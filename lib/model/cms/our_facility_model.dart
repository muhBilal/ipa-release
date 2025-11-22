class OurFacilityModel {
  final int id;
  final String title;
  final String description;
  final String? image;

  OurFacilityModel({
    required this.id,
    required this.title,
    required this.description,
    this.image,
  });

  factory OurFacilityModel.fromJson(Map<String, dynamic> json) {
    return OurFacilityModel(
      id: (json['id'] is int)
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }

  static List<OurFacilityModel> listFromJson(dynamic jsonData) {
    if (jsonData == null) return [];
    if (jsonData is List) {
      return jsonData.map((e) => OurFacilityModel.fromJson(e)).toList();
    }
    return [];
  }
}
