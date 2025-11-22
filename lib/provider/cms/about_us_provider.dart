import 'package:flutter/material.dart';
import 'package:Ngoerahsun/model/cms/about_us_model.dart';
import 'package:Ngoerahsun/services/cms/about_us_service.dart';

class AboutUsProvider extends ChangeNotifier {
  final AboutUsService _service = AboutUsService();

  bool _isLoading = false;
  List<AboutUsModel> _aboutUs = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<AboutUsModel> get aboutUs => _aboutUs;
  String? get errorMessage => _errorMessage;

  String? _error;
  String? get error => _error;

  Future<void> loadAboutUsData(String lang) async {
  _isLoading = true;
  notifyListeners();
  try {
    final result = await _service.getAboutUs(lang);
    _aboutUs = result;
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

}

