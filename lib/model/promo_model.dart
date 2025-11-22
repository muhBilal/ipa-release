class Promo {
  final int id;
  final String title;
  final String description;
  final String image;
  final String price;
  final String startDate;
  final String endDate;
  final bool isActive;

  Promo({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '0',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }
}
