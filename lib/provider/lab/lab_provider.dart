import 'dart:developer';

import 'package:ngoerahsun/services/preferences/language_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:ngoerahsun/model/lab_menu.dart';
import 'package:ngoerahsun/services/lab/lab_service.dart';

class LabProvider with ChangeNotifier {
  final LabService _service = LabService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<LabMenu> _menus = [];
  List<LabMenu> get menus => _menus;

  Future<void> fetchMenus({bool forceRefresh = false}) async {
    // if (_isLoading) return;
    // if (_menus.isNotEmpty && !forceRefresh) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _service.fetchLabMenu();
      _menus = result;
    } catch (e) {
      _error = e.toString();
      _menus = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _menus = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
