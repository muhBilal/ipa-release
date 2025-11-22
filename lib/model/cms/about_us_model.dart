class AboutUsModel {
  final int id;
  final String title;
  final String description;
  final String? image;

  AboutUsModel({
    required this.id,
    required this.title,
    required this.description,
    this.image,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      id: (json['id'] is int)
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }

  static List<AboutUsModel> listFromJson(dynamic jsonData) {
    if (jsonData == null) return [];
    if (jsonData is List) {
      return jsonData.map((e) => AboutUsModel.fromJson(e)).toList();
    }
    return [];
  }
}
