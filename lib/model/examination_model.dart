class Examination {
  final String name;
  final String category;
  final String date;
  final String url;

  Examination({
    required this.name,
    required this.category,
    required this.date,
    required this.url,
  });

  factory Examination.fromJson(Map<String, dynamic> json) {
    return Examination(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'date': date,
      'url': url,
    };
  }
}
