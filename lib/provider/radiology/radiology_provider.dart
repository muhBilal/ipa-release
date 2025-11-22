import 'package:flutter/foundation.dart';
import 'package:Ngoerahsun/model/radiology_menu.dart';
import 'package:Ngoerahsun/services/radiology/radiology_service.dart';

class RadiologyProvider with ChangeNotifier {
  final RadiologyService _service = RadiologyService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<RadiologyMenu> _menus = [];
  List<RadiologyMenu> get menus => _menus;

  Future<void> fetchMenus({bool forceRefresh = false}) async {
    // if (_isLoading) return;
    // if (_menus.isNotEmpty && !forceRefresh) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _service.fetchRadiologyMenu();
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
