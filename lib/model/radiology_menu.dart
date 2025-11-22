class RadiologyMenu {
  final int? kdRad;
  final String? grRad;
  final String? namaRad;
  final String? kodeTarif;
  final String? tabView;
  final String? paket;
  final int? gr2Rad;
  final String? otherSpesialis;
  final String? modality;
  final String? namaRadEn;
  final String? createdAt;
  final String? createdBy;
  final String? updatedAt;
  final String? updatedBy;
  final String? deletedAt;
  final String? deletedBy;
  final int? isDeleted;
  final int? tarif;

  RadiologyMenu({
    this.kdRad,
    this.grRad,
    this.namaRad,
    this.kodeTarif,
    this.tabView,
    this.paket,
    this.gr2Rad,
    this.otherSpesialis,
    this.modality,
    this.namaRadEn,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    this.isDeleted,
    this.tarif,
  });

  factory RadiologyMenu.fromJson(Map<String, dynamic> json) {
    dynamic parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String && v.isNotEmpty) {
        return int.tryParse(v.replaceAll(RegExp(r'[^0-9]'), ''));
      }
      return null;
    }

    return RadiologyMenu(
      kdRad: parseInt(json['kd_rad']),
      grRad: json['gr_rad']?.toString(),
      namaRad: json['nama_rad']?.toString(),
      kodeTarif: json['kode_tarif']?.toString(),
      tabView: json['tab_view']?.toString(),
      paket: json['paket']?.toString(),
      gr2Rad: parseInt(json['gr2_rad']),
      otherSpesialis: json['other_spesialis']?.toString(),
      modality: json['modality']?.toString(),
      namaRadEn: json['nama_rad_en']?.toString(),
      createdAt: json['created_at']?.toString(),
      createdBy: json['created_by']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      updatedBy: json['updated_by']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      deletedBy: json['deleted_by']?.toString(),
      isDeleted: parseInt(json['is_deleted']),
      tarif: parseInt(json['tarif']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kd_rad': kdRad,
      'gr_rad': grRad,
      'nama_rad': namaRad,
      'kode_tarif': kodeTarif,
      'tab_view': tabView,
      'paket': paket,
      'gr2_rad': gr2Rad,
      'other_spesialis': otherSpesialis,
      'modality': modality,
      'nama_rad_en': namaRadEn,
      'created_at': createdAt,
      'created_by': createdBy,
      'updated_at': updatedAt,
      'updated_by': updatedBy,
      'deleted_at': deletedAt,
      'deleted_by': deletedBy,
      'is_deleted': isDeleted,
      'tarif': tarif,
    };
  }

  static List<RadiologyMenu> listFromJson(List<dynamic> data) {
    return data.map((e) => RadiologyMenu.fromJson(e)).toList();
  }
}
