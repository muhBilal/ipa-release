class ScheduleModel {
  final int id;
  final String scheduleName;

  ScheduleModel({
    required this.id,
    required this.scheduleName,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? 0,
      scheduleName: json['schedule_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schedule_name': scheduleName,
    };
  }
}
