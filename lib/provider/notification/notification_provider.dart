import 'dart:developer';

import 'package:Ngoerahsun/model/notification/notification_group_model.dart';
import 'package:Ngoerahsun/services/notification/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<NotificationGroup> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<NotificationGroup> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNotifications() async {
    log("get notifications");
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await _notificationService.fetchNotifications();
    } catch (e) {
      _notifications = [];
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
