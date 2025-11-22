import 'dart:developer';
import 'package:Ngoerahsun/model/mcu_model.dart';
import 'package:Ngoerahsun/services/package/package_service.dart';
import 'package:flutter/foundation.dart';

import 'package:Ngoerahsun/model/wellnessModel.dart';

class WellnessPackageProvider with ChangeNotifier {
  final PackageService _packageService = PackageService();

  List<WellnessPackage> _packages = [];
  List<WellnessPackage> get packages => _packages;

  List<MCUModel> _packagesMcu = [];
  List<MCUModel> get packagesMcu => _packagesMcu;

  bool _isLoadingPackages = false;
  bool get isLoadingPackages => _isLoadingPackages;

  Future<void> fetchAllWellnessPackages() async {
    _isLoadingPackages = true;
    notifyListeners();

    try {
      final result = await _packageService.fetchWellnessPackage();
      _packages = result;
    } catch (e) {
      log('fetchAllWellnessPackages error: $e');
      _packages = [];
    } finally {
      _isLoadingPackages = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllMCUPackages() async {
    _isLoadingPackages = true;
    notifyListeners();

    try {
      final result = await _packageService.fetchMCUPackage();
      _packagesMcu = result;
    } catch (e) {
      log('fetchAllMCUPackages error: $e');
      _packagesMcu = [];
    } finally {
      _isLoadingPackages = false;
      notifyListeners();
    }
  }
}
