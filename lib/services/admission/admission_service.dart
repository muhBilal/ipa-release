import 'dart:developer';
import 'package:ngoerahsun/model/booking/booking_detail_model.dart';
import 'package:ngoerahsun/model/booking_result_model.dart';
import 'package:ngoerahsun/model/doctor_model.dart';
import 'package:ngoerahsun/model/poli_model.dart';
import 'package:ngoerahsun/model/myBooking_model.dart';
import 'package:ngoerahsun/model/schedule_model.dart';
import 'package:ngoerahsun/services/preferences/user_preferences.dart';
import 'package:ngoerahsun/utils/repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AdmissionService {
  ResourceRepository repo = ResourceRepository();
  Future<List<DoctorModel>> fetchDoctors({
    int? poliId,
    String? search,
    int? uid,
    int? onlyFav,
    bool examinationDoctor = false,
  }) async {
    final String baseUrl = repo.getDoctorsUrl;
    final queryParams = <String, String>{};

    if (poliId != null) {
      queryParams['poli'] = poliId.toString();
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (uid != null) {
      queryParams['uid'] = uid.toString();
    }
    if (onlyFav != null) {
      queryParams['onlyFav'] = onlyFav.toString();
    }
    if (examinationDoctor) {
      queryParams['examination_doctor'] = '1';
    }
    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    try {
      final response = await http.get(uri);
      log("debug Fetching doctors from: $uri");
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List doctorsJson = decoded['data']?['doctors'] ?? [];
        return doctorsJson.map((e) => DoctorModel.fromJson(e)).toList();
      } else {
        log("Failed to fetch doctors: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      log("error fetching doctors: $e");
      return [];
    }
  }

  Future<List<PoliModel>> fetchPoli(
      {Duration timeout = const Duration(seconds: 20)}) async {
    final String url = repo.getPoliUrl;

    try {
      final resp = await http.get(Uri.parse(url)).timeout(timeout);

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final decoded = jsonDecode(resp.body);
        final List<dynamic> list = (decoded is Map<String, dynamic>)
            ? (decoded['data'] as List<dynamic>? ?? const [])
            : const [];

        return list
            .map((e) => PoliModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        log('fetchPoli failed: HTTP ${resp.statusCode}');
        return [];
      }
    } catch (e) {
      log('fetchPoli error: $e');
      return [];
    }
  }

  Future<List<ScheduleModel>> fetchScheduleTime(
      int poliId, int doctorId, String date) async {
    final String url = repo.getScheduleUrl;
    try {
      final response =
          await http.get(Uri.parse('$url/$poliId/$doctorId/$date'));
      log("debug Fetching schedule from: $url/$poliId/$doctorId/$date");
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List scheduleJson = decoded['response'];
        log("debug scheduleJson: $scheduleJson");
        final List<ScheduleModel> schedules =
            scheduleJson.map((e) => ScheduleModel.fromJson(e)).toList();

        final now = DateTime.now();
        final requestDate = DateTime.parse(date);

        final filteredAndSorted = schedules.where((s) {
          final parts = s.scheduleName.split(':');
          if (parts.length < 2) return false;
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          final scheduleDate = DateTime(
            requestDate.year,
            requestDate.month,
            requestDate.day,
            hour,
            minute,
          );

          if (requestDate.day == now.day &&
              requestDate.month == now.month &&
              requestDate.year == now.year) {
            return scheduleDate.isAfter(now);
          }
          return true;
        }).toList()
          ..sort((a, b) {
            final aParts = a.scheduleName.split(':');
            final bParts = b.scheduleName.split(':');
            final aHour = int.parse(aParts[0]);
            final aMinute = int.parse(aParts[1]);
            final bHour = int.parse(bParts[0]);
            final bMinute = int.parse(bParts[1]);
            return aHour != bHour
                ? aHour.compareTo(bHour)
                : aMinute.compareTo(bMinute);
          });

        return filteredAndSorted;
      } else {
        return [];
      }
    } catch (e) {
      log("error fetching schedule: $e");
      return [];
    }
  }

  Future<BookingResult> createBooking({
    required int idJadwal,
    required int idDokter,
    required int idPoli,
    int? idPaket,
    required String email,
    required String tanggalJadwal,
    String? authToken,
    List<int>? itemIds,
    String? category,
    bool examinationDoctor = false,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final String url = repo.getBookAppointmentUrl;
    final user = await UserPreferences.getUser();
    final muid = user?.muid ?? '';
    try {
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      };

      final body = {
        'id_jadwal': idJadwal.toString(),
        'id_dokter': idDokter.toString(),
        'id_poli': idPoli.toString(),
        'id_paket': (idPaket ?? 0).toString(),
        'txt_email': email,
        'tanggal_jadwal': tanggalJadwal,
        'm_uid': muid.toString(),
        if (itemIds != null && itemIds.isNotEmpty)
          'item_ids': itemIds.join(','),
        if (category != null && category.isNotEmpty) 'category': category,
        if (examinationDoctor) 'examination_doctor': 'true',
      };

      final resp = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(timeout);

      log("🔗 PackageService: Requesting URL -> $url");
      log("🔗 PackageService: Requesting body -> $body");
      log("response code -> ${resp.statusCode}");
      log("response body -> ${resp.body}");
      Map<String, dynamic> jsonMap;
      try {
        final decoded = jsonDecode(resp.body);
        jsonMap =
            decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
      } catch (_) {
        jsonMap = <String, dynamic>{};
      }

      final result =
          BookingResult.fromJson(jsonMap, statusCode: resp.statusCode);

      if (result.status.isEmpty) {
        return BookingResult.error(
          'Booking gagal (HTTP ${resp.statusCode}).',
          statusCode: resp.statusCode,
        );
      }
      return result;
    } catch (e) {
      log('createBooking error: $e');
      return BookingResult.error('Network error: $e');
    }
  }

  Future<List<MyBooking>> getMyBooking({
    String? nik,
    String? passport,
    required String type,
  }) async {
    if ((nik == null || nik.isEmpty) &&
        (passport == null || passport.isEmpty)) {
      log("getMyBooking aborted: both nik & passport empty");
      return [];
    }
    final String url = repo.getMyBookingUrl;
    try {
      final qp = <String, String>{
        'type': type,
        if (nik != null && nik.isNotEmpty) 'nik': nik,
        if ((nik == null || nik.isEmpty) &&
            passport != null &&
            passport.isNotEmpty)
          'passport': passport,
      };
      final uri = Uri.parse(url).replace(queryParameters: qp);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decoded = await compute(jsonDecode, response.body);
        final bookingData = decoded['data'];
        if (bookingData == null) return [];
        if (bookingData is List) {
          return bookingData.map((e) => MyBooking.fromJson(e)).toList();
        } else if (bookingData is Map<String, dynamic>) {
          return [MyBooking.fromJson(bookingData)];
        } else {
          return [];
        }
      } else {
        log("Failed getMyBooking: ${response.body}");
        return [];
      }
    } catch (e, st) {
      log("Error getMyBooking: $e\n$st");
      return [];
    }
  }

  Future<bool> rescheduleBooking({
    required int id,
    required String tanggal,
    required String jam,
  }) async {
    final String url = "${repo.getRescheduleBookingUrl}";
    try {
      final body = {
        'id': id,
        'tanggal': tanggal,
        'jam': jam,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['status'] == true;
      } else if (response.statusCode == 400) {
        final decoded = jsonDecode(response.body);
        log("Validation errors: ${decoded['errors']}");
        return false;
      } else {
        throw Exception('Failed to reschedule booking: ${response.statusCode}');
      }
    } catch (e, st) {
      log('rescheduleBooking error: $e\n$st');
      rethrow;
    }
  }

  Future<bool> cancelBooking(int bookingId) async {
    final String url = repo.getCancelBookingUrl;
    try {
      final uri = Uri.parse("$url/$bookingId");
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> handleFavDoctor(int idDokter) async {
    final String url = repo.postFavDoctorUrl;

    try {
      final user = await UserPreferences.getUser();
      if (user == null) {
        log("User not found in preferences");
        return false;
      }
      final uid = user.muid;
      final uri = Uri.parse(url);
      log("message Handling favorite doctor at: $uri for user ID: $uid and doctor ID: $idDokter");
      final response = await http.post(
        uri,
        body: {
          'id_dokter': idDokter.toString(),
          'm_uid': uid.toString(),
        },
      );

      log("debug handleFavDoctor response status: ${response.statusCode}");
      log("debug handleFavDoctor response body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Error handleFavDoctor: $e");
      return false;
    }
  }

  Future<BookingDetailModel?> fetchBookingDetail(int bookingCode) async {
    final uri = Uri.parse(repo.getDetailBookUrl + "/" + bookingCode.toString());
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          return BookingDetailModel.fromJson(decoded['data']);
        } else {
          log("⚠️ Booking data null");
          return null;
        }
      } else {
        log("❌ Failed fetch booking detail: ${response.statusCode} with id: $bookingCode");
        return null;
      }
    } catch (e) {
      log("🔥 Error fetch booking detail: $e");
      return null;
    }
  }
}
