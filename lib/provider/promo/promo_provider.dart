import 'dart:developer';
import 'package:ngoerahsun/services/promo/promo_service.dart';
import 'package:flutter/material.dart';
import 'package:ngoerahsun/model/promo_model.dart';

class PromoProvider extends ChangeNotifier {
  final PromoService _promoService = PromoService();

  List<Promo> _promos = [];
  bool _isLoading = false;
  String? _error;

  List<Promo> get promos => _promos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPromos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetched = await _promoService.fetchPromos();
      _promos = fetched;
    } catch (e) {
      _error = e.toString();
      log("❌ PromoProvider: loadPromos caught error -> $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
