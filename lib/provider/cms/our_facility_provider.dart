import 'package:flutter/material.dart';
import 'package:ngoerahsun/model/cms/our_facility_model.dart';
import 'package:ngoerahsun/services/cms/our_facility_service.dart';

class OurFacilityProvider extends ChangeNotifier {
  final OurFacilityService _service = OurFacilityService();

  bool _isLoading = false;
  List<OurFacilityModel> _facilities = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<OurFacilityModel> get facilities => _facilities;
  String? get errorMessage => _errorMessage;

  Future<void> loadFacilities(String lang) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.getOurFacilities(lang);
      _facilities = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
