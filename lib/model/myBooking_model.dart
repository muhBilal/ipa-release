class MyBooking {
  final int id;
  final String tanggal;
  final String dokter;
  final String poli;
  final String lokasi;
  final String gambar;
  final int? idDokter;
  final int? idPoli;

  MyBooking({
    required this.id,
    required this.tanggal,
    required this.dokter,
    required this.poli,
    required this.lokasi,
    required this.gambar,
    this.idDokter,
    this.idPoli,
  });

  factory MyBooking.fromJson(Map<String, dynamic> json) {
    return MyBooking(
      id: json['id'] ?? 0,
      tanggal: json['tanggal'] ?? '',
      dokter: json['dokter'] ?? '',
      poli: json['poli'] ?? '',
      lokasi: json['lokasi'] ?? '',
      gambar: json['gambar'] ?? '',
      idDokter: json['id_dokter'],
      idPoli: json['id_poli'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal,
      'dokter': dokter,
      'poli': poli,
      'lokasi': lokasi,
      'gambar': gambar,
      'id_dokter': idDokter,
      'id_poli': idPoli,
    };
  }
}
