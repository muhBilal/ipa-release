class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String? userId;
  final String? sendAt;
  final String? type;
  final dynamic data;
  final bool? isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.userId,
    this.sendAt,
    this.type,
    this.data,
    this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      userId: json['user_id'],
      sendAt: json['send_at'],
      type: json['type'],
      data: json['data'],
      isRead: json['is_read'] == null ? null : json['is_read'] == 1,
    );
  }
}
