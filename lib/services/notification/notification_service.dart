import 'dart:convert';
import 'dart:developer';
import 'package:Ngoerahsun/model/notification/notification_group_model.dart';
import 'package:Ngoerahsun/services/preferences/user_preferences.dart';
import 'package:Ngoerahsun/utils/repository.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  ResourceRepository repo = ResourceRepository();

  Future<List<NotificationGroup>> fetchNotifications() async {
    try {
      final String url = repo.getNotificationUrl;
      final user = await UserPreferences.getUser();
      final uid = user?.muid;
      final response = await http.get(Uri.parse("$url/$uid"));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == true && decoded['data'] != null) {
          Map<String, dynamic> groupedData = decoded['data'];
          List<NotificationGroup> result = [];
          groupedData.forEach((key, value) {
            if (value is List) {
              result.add(NotificationGroup.fromJson(key, value));
            }
          });
          return result;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
