import 'dart:developer';

import 'package:Ngoerahsun/model/examination_model.dart';
import 'package:Ngoerahsun/services/examination/examination_service.dart';
import 'package:flutter/material.dart';

class ExaminationProvider with ChangeNotifier {
  final ExaminationService _service = ExaminationService();

  List<Examination> _examinations = [];
  bool _isLoading = false;
  String? _error;

  List<Examination> get examinations => _examinations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> _menus = [];
  bool _isLoadingMenu = false;
  String? _errorMenu;

  List<String> get menus => _menus;
  bool get isLoadingMenu => _isLoadingMenu;
  String? get errorMenu => _errorMenu;
  
  Future<void> loadExaminations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _examinations = await _service.fetchExaminations();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Examination> filterByType(String type) {
    if (type == 'all') return _examinations;
    return _examinations
        .where((exam) => exam.category.toLowerCase() == type.toLowerCase())
        .toList();
  }

  Future<void> loadMenus() async {
    _isLoadingMenu = true;
    _errorMenu = null;
    notifyListeners();

    try {
      final result = await _service.fetchMenus();
      _menus = result;
    } catch (e) {
      log("🔥 Error loadMenus: $e");
      _errorMenu = e.toString();
      _menus = [];
    } finally {
      _isLoadingMenu = false;
      notifyListeners();
    }
  }
}
