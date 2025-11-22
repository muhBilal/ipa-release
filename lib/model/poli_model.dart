class PoliModel {
  final int id;
  final String nama;

  PoliModel({
    required this.id,
    required this.nama,
  });

  factory PoliModel.fromJson(Map<String, dynamic> json) {
    return PoliModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
    };
  }
}
