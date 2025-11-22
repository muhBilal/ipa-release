import 'notification_model.dart';

class NotificationGroup {
  final String group;
  final List<NotificationModel> notifications;

  NotificationGroup({
    required this.group,
    required this.notifications,
  });

  factory NotificationGroup.fromJson(String key, List<dynamic> jsonList) {
    return NotificationGroup(
      group: key,
      notifications:
          jsonList.map((e) => NotificationModel.fromJson(e)).toList(),
    );
  }
}
