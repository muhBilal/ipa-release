import 'package:flutter/material.dart';
import 'package:ngoerahsun/model/doctor_detail_model.dart';
import 'package:ngoerahsun/services/doctor/doctor_detail_service.dart';

class DoctorDetailProvider with ChangeNotifier {
  final DoctorDetailService _service = DoctorDetailService();

  bool _isLoading = false;
  Doctor? _doctor;
  String? _error;

  bool get isLoading => _isLoading;
  Doctor? get doctor => _doctor;
  String? get error => _error;

  Future<void> fetchDoctorDetail(int id) async {
    if (_isLoading) return; // prevent duplicate
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _service.fetchDoctorDetail(id);
    if (result != null) {
      _doctor = result;
    } else {
      _error = 'Failed to load doctor detail';
    }
    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _doctor = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
