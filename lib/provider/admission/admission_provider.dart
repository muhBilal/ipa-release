import 'dart:developer';
import 'package:ngoerahsun/model/booking/booking_detail_model.dart';
import 'package:ngoerahsun/services/preferences/user_preferences.dart';
import 'package:flutter/foundation.dart';

import 'package:ngoerahsun/model/doctor_model.dart';
import 'package:ngoerahsun/model/poli_model.dart';
import 'package:ngoerahsun/model/schedule_model.dart';
import 'package:ngoerahsun/model/myBooking_model.dart';
import 'package:ngoerahsun/services/admission/admission_service.dart';

class AdmissionProvider with ChangeNotifier {
  final AdmissionService _admissionService = AdmissionService();

  List<DoctorModel> _doctors = [];
  bool _doctorLoading = false;
  List<DoctorModel> get doctors => _doctors;
  bool get doctorLoading => _doctorLoading;

  bool _isLoadingSchedule = false;
  List<ScheduleModel> _schedules = [];
  bool get isLoadingSchedule => _isLoadingSchedule;
  List<ScheduleModel> get schedules => _schedules;

  List<PoliModel> _polis = [];
  bool _isLoadingPoli = false;
  List<PoliModel> get polis => _polis;
  bool get isLoadingPoli => _isLoadingPoli;

  bool _isLoadingMyBooking = false;
  bool get isLoadingMyBooking => _isLoadingMyBooking;

  List<MyBooking> _myBookings = [];
  List<MyBooking> get myBookings => _myBookings;

  bool _rescheduling = false;
  bool get isRescheduling => _rescheduling;

  BookingDetailModel? _bookingDetail;
  BookingDetailModel? get bookingDetail => _bookingDetail;
  bool _isLoadingBookingDetail = false;
  bool get isLoadingBookingDetail => _isLoadingBookingDetail;

  Future<bool> rescheduleBooking({
    required int id,
    required String tanggal,
    required String jam,
  }) async {
    _rescheduling = true;
    notifyListeners();
    try {
      final ok = await _admissionService.rescheduleBooking(
        id: id,
        tanggal: tanggal,
        jam: jam,
      );
      return ok;
    } catch (e) {
      log("rescheduleBooking provider error: $e");
      return false;
    } finally {
      _rescheduling = false;
      notifyListeners();
    }
  }

  Future<void> getPoli() async {
    _isLoadingPoli = true;
    notifyListeners();
    try {
      final result = await _admissionService.fetchPoli();
      _polis = result;
    } catch (e) {
      log('getPoli error: $e');
      _polis = [];
    } finally {
      _isLoadingPoli = false;
      notifyListeners();
    }
  }

  void clearMyBookings() {
    _myBookings = [];
    notifyListeners();
  }

  Future<void> getScheduleTime(int poliId, int doctorId, String date) async {
    _isLoadingSchedule = true;
    notifyListeners();

    try {
      final result =
          await _admissionService.fetchScheduleTime(poliId, doctorId, date);

      // Pastikan hasilnya dalam bentuk list
      if (result is List) {
        _schedules = result;
      } else {
        _schedules = [];
        log("⚠️ fetchScheduleTime() tidak mengembalikan List: ${result.runtimeType}");
      }
    } catch (e) {
      log("❌ Error in getScheduleTime: $e");
      _schedules = [];
    } finally {
      _isLoadingSchedule = false;
      notifyListeners();
    }
  }

  Future<void> getMyBooking({
    String? nik,
    String? passport,
    required String type,
  }) async {
    _isLoadingMyBooking = true;
    notifyListeners();
    try {
      final result = await _admissionService.getMyBooking(
        nik: nik,
        passport: passport,
        type: type,
      );
      _myBookings = result;
    } catch (e) {
      log("Error in getMyBooking: $e");
      _myBookings = [];
    } finally {
      _isLoadingMyBooking = false;
      notifyListeners();
    }
  }

  Future<bool> cancelBooking(int idBooking) async {
    try {
      log("attempting to cancel booking with ID: $idBooking");
      final success = await _admissionService.cancelBooking(idBooking);
      if (success) {
        _myBookings.removeWhere((booking) => booking.id == idBooking);
        notifyListeners();
      }
      return success;
    } catch (e) {
      log("Error in cancelBooking: $e");
      return false;
    }
  }

  final Set<int> _loadingIds = {};
  final Map<int, bool> _favorites = {};

  Future<void> getDoctors(
      {int? poliId,
      String? search,
      int? onlyFav,
      bool examinationDoctor = false}) async {
    _doctorLoading = true;
    _loadingIds.clear();
    _favorites.clear();
    notifyListeners();

    try {
      final user = await UserPreferences.getUser();
      final userId = user?.muid;
      final result = await _admissionService.fetchDoctors(
        poliId: poliId,
        search: search,
        uid: userId,
        onlyFav: onlyFav,
        examinationDoctor: examinationDoctor,
      );

      _doctors = result;

      for (var doctor in _doctors) {
        _favorites[doctor.id] = doctor.isFav;
      }
    } catch (e) {
      log("getDoctors error: $e");
      _doctors = [];
    } finally {
      _doctorLoading = false;
      notifyListeners();
    }
  }

  bool isLoading(int doctorId) => _loadingIds.contains(doctorId);

  bool isFavorite(int doctorId, {bool? defaultValue}) {
    return _favorites[doctorId] ?? (defaultValue ?? false);
  }

  Future<bool> toggleFavorite(int doctorId) async {
    if (_loadingIds.contains(doctorId)) return false;

    _loadingIds.add(doctorId);
    notifyListeners();

    var result = false;

    try {
      final success = await _admissionService.handleFavDoctor(doctorId);
      if (success) {
        final current = _favorites[doctorId] ?? false;
        _favorites[doctorId] = !current;
        result = true;
      }
    } catch (e) {
      log("Error in toggleFavorite: $e");
    } finally {
      _loadingIds.remove(doctorId);
      notifyListeners();
    }

    return result;
  }

  Future<void> getBookingDetail(int bookingCode) async {
    _isLoadingBookingDetail = true;
    notifyListeners();

    try {
      final result = await _admissionService.fetchBookingDetail(bookingCode);
      _bookingDetail = result;
    } catch (e) {
      log("getBookingDetail error: $e");
      _bookingDetail = null;
    } finally {
      _isLoadingBookingDetail = false;
      notifyListeners();
    }
  }
}
