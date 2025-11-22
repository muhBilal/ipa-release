import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:Ngoerahsun/utils/repository.dart';
import 'package:Ngoerahsun/model/doctor_detail_model.dart';

class DoctorDetailService {
  final ResourceRepository _repo = ResourceRepository();

  Future<Doctor?> fetchDoctorDetail(int id,
      {Duration timeout = const Duration(seconds: 20)}) async {
    final base = _repo.getDetailDoctorUrl;
    final uri = Uri.parse('$base/$id');
    try {
      const token =
          '1c5144f6be97655d7076b25791a21224c437ac09662dc9231871a01da271a0c913281a060c26207ecf8db301ddab0a2c3f4848ce9d4154cce88071256f7baa0bdb459cdbe9aad8d2cd91a2233802fb074cc103565879b9cd56afc9a9a49a580e24e73312435d77808022fa7fc1f3ce92e6c5faed99c8be4ff28141c26b5b3cce';
      final resp = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(timeout);
      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);
        try {
          final response = DoctorResponse.fromJson(decoded);
          return response.data;
        } catch (e) {
          log('Doctor detail parse error: $e');
          return null;
        }
      } else {
        if (resp.statusCode == 401) {
          log('Doctor detail unauthorized: ensure token validity');
        }
        log('Doctor detail http error ${resp.statusCode}: ${resp.body}');
        return null;
      }
    } catch (e) {
      log('Doctor detail network error: $e');
      return null;
    }
  }
}
