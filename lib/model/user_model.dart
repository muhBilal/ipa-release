class UserModel {
  final int id;
  final int muid;
  final String noRm;
  final String nik;
  final String nama;
  final String phoneCountry;
  final String noTelp;
  final String email;
  final String warganegara;
  final String? negara;
  final String? passport;
  final String jenkel;
  final DateTime tanggalLahir;
  final String tempatLahir;
  final String image;
  
  UserModel({
    required this.id,
    this.muid = 0,
    required this.noRm,
    required this.nik,
    required this.nama,
    required this.phoneCountry,
    required this.noTelp,
    required this.email,
    required this.warganegara,
    this.negara,
    this.passport,
    required this.jenkel,
    required this.tanggalLahir,
    required this.tempatLahir,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      muid: json['muid'] ?? 0,
      noRm: json['noRm'] ?? '',
      nik: json['nik'] ?? '',
      nama: json['nama'] ?? '',
      phoneCountry: json['phoneCountry'] ?? '',
      noTelp: json['noTelp'] ?? '',
      email: json['email'] ?? '',
      warganegara: json['warganegara'] ?? '',
      negara: json['negara'],
      passport: json['passport'],
      jenkel: json['jenkel'] ?? '',
      tanggalLahir:
          DateTime.tryParse(json['tanggalLahir'] ?? '') ?? DateTime(1900),
      tempatLahir: json['tempatLahir'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'muid': muid,
      'noRm': noRm,
      'nik': nik,
      'nama': nama,
      'phoneCountry': phoneCountry,
      'noTelp': noTelp,
      'email': email,
      'warganegara': warganegara,
      'negara': negara,
      'passport': passport,
      'jenkel': jenkel,
      'tanggalLahir': tanggalLahir.toIso8601String(),
      'tempatLahir': tempatLahir,
      'image': image,
    };
  }
}
