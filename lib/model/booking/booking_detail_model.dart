class BookingDetailModel {
  final String kodeBooking;
  final String nama;
  final String namaPoli;
  final String kodePoli;
  // final String namaTreatment;
  final String namaDokter;
  final String tanggal;
  final bool isDeleted;

  BookingDetailModel({
    required this.kodeBooking,
    required this.nama,
    required this.namaPoli,
    required this.kodePoli,
    // required this.namaTreatment,
    required this.namaDokter,
    required this.tanggal,
    this.isDeleted = false,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailModel(
      kodeBooking: json['kode_booking']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      namaPoli: json['nama_poli']?.toString() ?? '',
      kodePoli: json['id_poli']?.toString() ?? '',
      namaDokter: json['nama_dokter']?.toString() ?? '',
      tanggal: json['tanggal']?.toString() ?? '',
      isDeleted: (json['is_deleted'] == 1 ||
            json['is_deleted'] == "1" ||
            json['is_deleted'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kodeBooking': kodeBooking,
      'nama': nama,
      'namaPoli': namaPoli,
      'kodePoli': kodePoli,
      // 'namaTreatment': namaTreatment,
      'namaDokter': namaDokter,
      'tanggal': tanggal,
      'isDeleted': isDeleted,
    };
  }
}
