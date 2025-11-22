class DoctorModel {
  final int id;
  final String? nama;
  final String? gambar;
  final String? poli;
  final String? spesialis;
  final int? poliId;
  bool isFav;

  DoctorModel({
    required this.id,
    required this.nama,
    this.gambar,
    this.poli,
    this.spesialis,
    this.poliId,
    this.isFav = false,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int,
      nama: json['nama'] as String?,
      gambar: json['gambar'] as String?,
      poli: json['poli'] as String?,
      spesialis: json['spesialis'] as String?,
      isFav: (json['isfav'] as bool?) ?? false,
      poliId: json['poli_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'gambar': gambar,
      'poli': poli,
      'spesialis': spesialis,
      'isFav': isFav,
      'poliId': poliId
    };
  }
}
