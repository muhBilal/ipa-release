class LabMenu {
  final String? title;
  final int? kodeJasa;
  final int? permintaan;
  final int? pemeriksaan;
  final List<LabContent>? content;

  LabMenu({
    this.title,
    this.kodeJasa,
    this.permintaan,
    this.pemeriksaan,
    this.content,
  });

  factory LabMenu.fromJson(Map<String, dynamic> json) {
    return LabMenu(
      title: json['title'],
      kodeJasa: json['kode_jasa'],
      permintaan: json['permintaan'],
      pemeriksaan: json['pemeriksaan'],
      content: json['content'] != null
          ? List<LabContent>.from(
              json['content'].map((e) => LabContent.fromJson(e)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'kode_jasa': kodeJasa,
      'permintaan': permintaan,
      'pemeriksaan': pemeriksaan,
      'content': content?.map((e) => e.toJson()).toList(),
    };
  }
}

class LabContent {
  final int? kodeJasa;
  final int? urutan;
  final int? cetak;
  final int? tipeCetakan;
  final int? groupJasa;
  final String? namaJasa;
  final String? kodeTarif;
  final String? tipePeriksa;
  final int? permintaan;
  final int? pemeriksaan;
  final String? tabView;
  final String? nilaiNormal;
  final String? unit;
  final String? ket;
  final String? nilaiNormalPrBayi;
  final String? nilaiNormalPrBalita;
  final String? nilaiNormalPrAnak;
  final String? nilaiNormalPrDewasa;
  final String? nilaiNormalLkBayi;
  final String? nilaiNormalLkBalita;
  final String? nilaiNormalLkAnak;
  final String? nilaiNormalLkDewasa;
  final String? hargaBPJS;
  final String? hargaUmum;
  final String? tarifTindakan;
  final String? kodeRef1;
  final String? kodeRef2;
  final String? keteranganNormal;
  final String? keteranganUmum;
  final String? kodeSs;
  final String? namaSs;
  final String? kodeAlias;
  final String? namaJasaEn;
  final String? createdAt;
  final String? createdBy;
  final String? updatedAt;
  final String? updatedBy;
  final String? deletedAt;
  final String? deletedBy;
  final int? isDeleted;

  LabContent({
    this.kodeJasa,
    this.urutan,
    this.cetak,
    this.tipeCetakan,
    this.groupJasa,
    this.namaJasa,
    this.kodeTarif,
    this.tipePeriksa,
    this.permintaan,
    this.pemeriksaan,
    this.tabView,
    this.nilaiNormal,
    this.unit,
    this.ket,
    this.nilaiNormalPrBayi,
    this.nilaiNormalPrBalita,
    this.nilaiNormalPrAnak,
    this.nilaiNormalPrDewasa,
    this.nilaiNormalLkBayi,
    this.nilaiNormalLkBalita,
    this.nilaiNormalLkAnak,
    this.nilaiNormalLkDewasa,
    this.hargaBPJS,
    this.hargaUmum,
    this.tarifTindakan,
    this.kodeRef1,
    this.kodeRef2,
    this.keteranganNormal,
    this.keteranganUmum,
    this.kodeSs,
    this.namaSs,
    this.kodeAlias,
    this.namaJasaEn,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    this.isDeleted,
  });

  factory LabContent.fromJson(Map<String, dynamic> json) {
    String? _s(dynamic v) => v == null ? null : v.toString();
    return LabContent(
      kodeJasa: json['kode_jasa'],
      urutan: json['urutan'],
      cetak: json['cetak'],
      tipeCetakan: json['tipe_cetakan'],
      groupJasa: json['group_jasa'],
      namaJasa: _s(json['nama_jasa']),
      kodeTarif: _s(json['kode_tarif']),
      tipePeriksa: _s(json['tipe_periksa']),
      permintaan: json['permintaan'],
      pemeriksaan: json['pemeriksaan'],
      tabView: _s(json['tab_view']),
      nilaiNormal: _s(json['nilai_normal']),
      unit: _s(json['unit']),
      ket: _s(json['ket']),
      nilaiNormalPrBayi: _s(json['nilai_normal_pr_bayi']),
      nilaiNormalPrBalita: _s(json['nilai_normal_pr_balita']),
      nilaiNormalPrAnak: _s(json['nilai_normal_pr_anak']),
      nilaiNormalPrDewasa: _s(json['nilai_normal_pr_dewasa']),
      nilaiNormalLkBayi: _s(json['nilai_normal_lk_bayi']),
      nilaiNormalLkBalita: _s(json['nilai_normal_lk_balita']),
      nilaiNormalLkAnak: _s(json['nilai_normal_lk_anak']),
      nilaiNormalLkDewasa: _s(json['nilai_normal_lk_dewasa']),
      hargaBPJS: _s(json['HargaBPJS']),
      hargaUmum: _s(json['HargaUmum']),
      tarifTindakan: _s(json['tarif']),
      kodeRef1: _s(json['kode_ref1']),
      kodeRef2: _s(json['kode_ref2']),
      keteranganNormal: _s(json['keterangan_normal']),
      keteranganUmum: _s(json['keterangan_umum']),
      kodeSs: _s(json['kode_ss']),
      namaSs: _s(json['nama_ss']),
      kodeAlias: _s(json['kode_alias']),
      namaJasaEn: _s(json['nama_jasa_en']),
      createdAt: _s(json['created_at']),
      createdBy: _s(json['created_by']),
      updatedAt: _s(json['updated_at']),
      updatedBy: _s(json['updated_by']),
      deletedAt: _s(json['deleted_at']),
      deletedBy: _s(json['deleted_by']),
      isDeleted: json['is_deleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_jasa': kodeJasa,
      'urutan': urutan,
      'cetak': cetak,
      'tipe_cetakan': tipeCetakan,
      'group_jasa': groupJasa,
      'nama_jasa': namaJasa,
      'kode_tarif': kodeTarif,
      'tipe_periksa': tipePeriksa,
      'permintaan': permintaan,
      'pemeriksaan': pemeriksaan,
      'tab_view': tabView,
      'nilai_normal': nilaiNormal,
      'unit': unit,
      'ket': ket,
      'nilai_normal_pr_bayi': nilaiNormalPrBayi,
      'nilai_normal_pr_balita': nilaiNormalPrBalita,
      'nilai_normal_pr_anak': nilaiNormalPrAnak,
      'nilai_normal_pr_dewasa': nilaiNormalPrDewasa,
      'nilai_normal_lk_bayi': nilaiNormalLkBayi,
      'nilai_normal_lk_balita': nilaiNormalLkBalita,
      'nilai_normal_lk_anak': nilaiNormalLkAnak,
      'nilai_normal_lk_dewasa': nilaiNormalLkDewasa,
      'HargaBPJS': hargaBPJS,
      'HargaUmum': hargaUmum,
      'tarifTindakan' : tarifTindakan,
      'kode_ref1': kodeRef1,
      'kode_ref2': kodeRef2,
      'keterangan_normal': keteranganNormal,
      'keterangan_umum': keteranganUmum,
      'kode_ss': kodeSs,
      'nama_ss': namaSs,
      'kode_alias': kodeAlias,
      'nama_jasa_en': namaJasaEn,
      'created_at': createdAt,
      'created_by': createdBy,
      'updated_at': updatedAt,
      'updated_by': updatedBy,
      'deleted_at': deletedAt,
      'deleted_by': deletedBy,
      'is_deleted': isDeleted,
    };
  }
}
