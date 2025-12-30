// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get wellnessServicesTitle => 'Layanan Wellness';

  @override
  String get wellnessChooseServiceTitle => 'Pilih Layanan Wellness';

  @override
  String get wellnessChooseServiceSubtitle => 'Pilih jenis layanan wellness yang Anda butuhkan';

  @override
  String get wellnessCardMcuTitle => 'Medical Checkup';

  @override
  String get wellnessCardMcuSubtitle => 'Pemeriksaan kesehatan menyeluruh';

  @override
  String get wellnessCardWellnessTitle => 'Wellness';

  @override
  String get wellnessCardWellnessSubtitle => 'Penilaian kesehatan komprehensif';

  @override
  String get wellnessCardHealthScreeningTitle => 'Pemeriksaan Kesehatan';

  @override
  String get wellnessCardHealthScreeningSubtitle => 'Tes kesehatan preventif';

  @override
  String get wellnessCardNutritionTitle => 'Konsultasi Gizi';

  @override
  String get wellnessCardNutritionSubtitle => 'Panduan dan perencanaan diet';

  @override
  String get bookingStepChooseDoctor => 'Pilih Dokter';

  @override
  String get bookingStepChoosePoli => 'Pilih Poli';

  @override
  String get bookingStepSelectDateTime => 'Pilih Tanggal & Waktu';

  @override
  String get bookingStepReviewConfirm => 'Tinjau & Konfirmasi';

  @override
  String get bookingChooseDoctorTitle => 'Pilih Dokter Anda';

  @override
  String get bookingChooseDoctorSubtitle => 'Pilih dari dokter spesialis terbaik kami';

  @override
  String get bookingChoosePoliTitle => 'Pilih Poli';

  @override
  String get bookingChoosePoliSubtitle => 'Pilih poli yang Anda inginkan';

  @override
  String bookingSelectedDoctor(String name) {
    return 'Dokter yang dipilih: $name';
  }

  @override
  String get bookingAvailableDates => 'Tanggal Tersedia';

  @override
  String get bookingAvailableTimes => 'Waktu Tersedia';

  @override
  String get bookingNoTimeSlots => 'Tidak ada jadwal tersedia';

  @override
  String get bookingNoPoliAvailable => 'Poli tidak tersedia';

  @override
  String get bookingReviewConfirmTitle => 'Tinjau & Konfirmasi';

  @override
  String get bookingReviewConfirmSubtitle => 'Harap tinjau detail janji temu Anda';

  @override
  String get bookingSummaryDoctor => 'Dokter';

  @override
  String get bookingSummaryPoli => 'Poli';

  @override
  String get bookingSummaryDate => 'Tanggal';

  @override
  String get bookingSummaryTime => 'Waktu';

  @override
  String get bookingNotSelected => 'Belum dipilih';

  @override
  String get bookingBtnBack => 'Kembali';

  @override
  String get bookingBtnContinue => 'Lanjutkan';

  @override
  String get bookingBtnConfirmBooking => 'Konfirmasi Booking';

  @override
  String get bookingBtnDone => 'Selesai';

  @override
  String get bookingResultSuccessTitle => 'Booking Berhasil!';

  @override
  String get bookingResultFailureTitle => 'Booking Gagal';

  @override
  String get bookingResultSuccessDefaultMessage => 'Janji temu Anda berhasil dipesan.';

  @override
  String bookingResultSuccessWithCode(String code) {
    return 'Janji temu Anda berhasil dipesan.\nKode: $code';
  }

  @override
  String get bookingResultGenericError => 'Terjadi kesalahan. Silakan coba lagi.';

  @override
  String bookingNetworkError(String error) {
    return 'Kesalahan jaringan: $error';
  }

  @override
  String get dashboardLocationLabel => 'Lokasi';

  @override
  String get dashboardLocationDefault => 'Denpasar, Bali, Indonesia';

  @override
  String get dashboardSearchDoctorHint => 'Cari Dokter';

  @override
  String get dashboardCategories => 'Kategori';

  @override
  String get commonSeeAll => 'Lihat Semua';

  @override
  String get dashboardArticleUpdates => 'Artikel & Pembaruan';

  @override
  String get dashboardChooseExaminationType => 'Pilih Jenis Pemeriksaan';

  @override
  String get examLaboratory => 'Laboratorium';

  @override
  String get examRadiology => 'Radiologi';

  @override
  String get commonClose => 'Tutup';

  @override
  String get dashboardCardWellness => 'Wellness';

  @override
  String get dashboardCardPlasticSurgery => 'Bedah Plastik';

  @override
  String get dashboardCardDermaesthetic => 'Dermaestetik';

  @override
  String get dashboardCardAestheticDentistry => 'Kedokteran Gigi Estetik';

  @override
  String get dashboardCardExaminationOrder => 'Pesanan Pemeriksaan';

  @override
  String get dashboardCardExaminationResult => 'Hasil Pemeriksaan';

  @override
  String get dashboardCardAboutUs => 'Tentang Kami';

  @override
  String get dashboardCardOurFacilities => 'Fasilitas Kami';

  @override
  String get profileTitle => 'Profil Pengguna';

  @override
  String get profileMenuEditProfile => 'Ubah Profil';

  @override
  String get profileMenuCard => 'Kartu Pasien';

  @override
  String get profileMenuFavorite => 'Favorit';

  @override
  String get profileMenuNotifications => 'Notifikasi';

  @override
  String get profileMenuSettings => 'Pengaturan';

  @override
  String get profileMenuChangeLanguage => 'Ganti Bahasa';

  @override
  String get profileMenuHelpSupport => 'Bantuan & Dukungan';

  @override
  String get profileMenuTerms => 'Syarat & Ketentuan';

  @override
  String get profileMenuLogout => 'Keluar';

  @override
  String get profileGuest => 'Tamu';

  @override
  String get profileLogoutTitle => 'Keluar';

  @override
  String get profileLogoutMessage => 'Apakah Anda yakin ingin keluar?';

  @override
  String get profileLogoutCancel => 'Batal';

  @override
  String get profileLogoutConfirm => 'Ya, Keluar';

  @override
  String get langChangeTitle => 'Ganti Bahasa';

  @override
  String get langIndonesian => 'Bahasa Indonesia';

  @override
  String get langEnglish => 'Bahasa Inggris';

  @override
  String langSavedToast(String lang) {
    return 'Bahasa diubah ke $lang';
  }

  @override
  String get doctorsAllTitle => 'Semua Dokter';

  @override
  String doctorsFoundCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dokter ditemukan',
      one: '1 dokter ditemukan',
      zero: 'Tidak ada dokter ditemukan',
    );
    return '$_temp0';
  }

  @override
  String get commonDefault => 'Default';

  @override
  String get myBookingTitle => 'Booking Saya';

  @override
  String get bookingTabUpcoming => 'Mendatang';

  @override
  String get bookingTabCompleted => 'Selesai';

  @override
  String get bookingTabCancelled => 'Dibatalkan';

  @override
  String get profileEditTitle => 'Ubah Profil';

  @override
  String get profileSectionPersonalInfo => 'Informasi Pribadi';

  @override
  String get profileSectionIdentity => 'Identitas';

  @override
  String get profileSectionAdditionalInfo => 'Informasi Tambahan';

  @override
  String get profileHintFullName => 'Nama Lengkap';

  @override
  String get profileHintEmail => 'Email';

  @override
  String get profileHintPhoneNumber => 'Nomor Telepon';

  @override
  String get profileHintNikNumber => 'Nomor NIK';

  @override
  String get profileHintPassportNumber => 'Nomor Paspor';

  @override
  String get profileHintDateOfBirth => 'Tanggal Lahir';

  @override
  String get profileHintGender => 'Jenis Kelamin';

  @override
  String get profileLabelNationality => 'Kewarganegaraan';

  @override
  String get profileNationalityWni => 'Warga Negara Indonesia';

  @override
  String get profileNationalityWna => 'Warga Negara Asing';

  @override
  String get genderMale => 'Laki-laki';

  @override
  String get genderFemale => 'Perempuan';

  @override
  String get profileBtnSaveChanges => 'Simpan Perubahan';

  @override
  String get profileBtnSaving => 'Menyimpan...';

  @override
  String get profileErrorUserNotFound => 'Data pengguna tidak ditemukan';

  @override
  String get profileErrorInvalidPatientId => 'ID pasien tidak valid';

  @override
  String get profileErrorNameRequired => 'Nama wajib diisi';

  @override
  String get profileErrorEmailRequired => 'Email wajib diisi';

  @override
  String get profileErrorEmailInvalid => 'Format email tidak valid';

  @override
  String get profileErrorPhoneRequired => 'Nomor telepon wajib diisi';

  @override
  String get profileErrorGenderRequired => 'Jenis kelamin wajib dipilih';

  @override
  String get profileErrorGenderInvalid => 'Jenis kelamin tidak valid';

  @override
  String get profileSnackbarUpdateSuccess => 'Profil berhasil diperbarui';

  @override
  String get profileSnackbarUpdateFailure => 'Gagal memperbarui profil';

  @override
  String get profileDialogCongratsTitle => 'Selamat!';

  @override
  String get profileDialogCongratsBody => 'Akun Anda siap digunakan. Anda akan diarahkan ke halaman beranda dalam beberapa detik...';

  @override
  String get commonSave => 'Simpan';

  @override
  String get loginRequiredTitle => 'Perlu Login';

  @override
  String get loginRequiredMessage => 'Silakan login terlebih dahulu untuk melanjutkan transaksi';

  @override
  String get bookingNotFound => 'Booking tidak ditemukan';

  @override
  String get bookingDetails => 'Detail Booking';

  @override
  String get bookingBtnCancel => 'Batalkan Booking';

  @override
  String get bookingBtnReschedule => 'Jadwalkan Ulang';

  @override
  String bookingRescheduleFlow(String code) {
    return 'Alur penjadwalan ulang untuk $code';
  }

  @override
  String get bookingCancelled => 'Booking dibatalkan';

  @override
  String bookingCancelError(String error) {
    return 'Gagal membatalkan booking: $error';
  }

  @override
  String bookingNoType(String type) {
    return 'Tidak ada booking $type';
  }

  @override
  String bookingSelectDateError(String error) {
    return 'Gagal memilih tanggal: $error';
  }

  @override
  String bookingFetchScheduleError(String error) {
    return 'Gagal mengambil jadwal: $error';
  }

  @override
  String get bookingSelectTimeFirst => 'Silakan pilih waktu terlebih dahulu';

  @override
  String get rescheduleTitle => 'Jadwalkan Ulang';

  @override
  String get bookingNoAvailableSchedule => 'Tidak ada jadwal tersedia';

  @override
  String get cannotOpenWhatsApp => 'Tidak dapat membuka WhatsApp';

  @override
  String get contactViaWhatsApp => 'Hubungi via WhatsApp';

  @override
  String get bookingConfirm => 'Konfirmasi';

  @override
  String bookingError(String error) {
    return 'Kesalahan: $error';
  }

  @override
  String get storagePermissionDenied => 'Izin penyimpanan ditolak';

  @override
  String fileSavedToDownload(String file) {
    return 'File disimpan ke Download/$file';
  }

  @override
  String get failedToDownloadFile => 'Gagal mengunduh file';

  @override
  String get failedToLoadPage => 'Gagal memuat halaman';

  @override
  String get tryAgain => 'Coba Lagi';

  @override
  String get home => 'Beranda';

  @override
  String get aboutUs => 'Tentang Kami';

  @override
  String get ngoerahsunHospital => 'Rumah Sakit ngoerahsun';

  @override
  String get excellenceInHealthcare => 'Keunggulan Dalam Pelayanan Kesehatan';

  @override
  String get aboutDescription => 'ngoerahsun adalah institusi kesehatan terkemuka di Indonesia yang berkomitmen menyediakan layanan medis berstandar internasional dengan teknologi canggih dan tenaga medis berpengalaman.';

  @override
  String get aboutLabel => 'Tentang';

  @override
  String get ourVisionTitle => 'Visi Kami';

  @override
  String get ourVisionDescription => 'Menjadi rumah sakit pilihan utama yang memberikan layanan kesehatan menyeluruh, aman, dan berkualitas tinggi untuk seluruh masyarakat.';

  @override
  String get ourMissionTitle => 'Misi Kami';

  @override
  String get ourMissionDescription => 'Memberikan layanan medis terbaik dengan pendekatan holistik, mengutamakan keselamatan pasien, dan terus berinovasi dalam bidang kesehatan.';

  @override
  String get ourExcellenceTitle => 'Keunggulan Kami';

  @override
  String get ourExcellenceDescription => 'Dilengkapi dengan fasilitas medis modern, dokter spesialis berpengalaman, layanan 24 jam, dan standar akreditasi internasional.';

  @override
  String get ourCommitmentTitle => 'Komitmen Kami';

  @override
  String get ourCommitmentDescription => 'Mengutamakan kepuasan dan pemulihan pasien melalui layanan yang ramah, profesional, dan empatik.';

  @override
  String get yourHealthOurPriority => 'Kesehatan Anda Prioritas Kami';

  @override
  String get trustedByThousands => 'Dipercaya oleh ribuan pasien untuk layanan kesehatan terbaik di Indonesia';

  @override
  String get article => 'Artikel';

  @override
  String get publishedToday => 'Diterbitkan hari ini';

  @override
  String noArticlesFound(String query) {
    return 'Tidak ada artikel ditemukan untuk \"$query\".';
  }

  @override
  String get noArticlesAvailable => 'Tidak ada artikel tersedia saat ini';

  @override
  String get all_articles => 'Semua Artikel';

  @override
  String get mcu_questionnaire => 'Kuesioner MCU';

  @override
  String get my_favorite_doctors => 'Dokter Favorit Saya';

  @override
  String get no_favorite_doctors_yet => 'Belum ada dokter favorit';

  @override
  String get browse_and_add_doctors_to_your_favorites => 'Cari dan tambahkan dokter ke favorit Anda';

  @override
  String get doctor_added_to_favorites => 'Dokter ditambahkan ke favorit';

  @override
  String get doctor_removed_from_favorites => 'Dokter dihapus dari favorit';

  @override
  String get failed_to_update_favorite_status => 'Gagal memperbarui status favorit';

  @override
  String get notifications => 'Notifikasi';

  @override
  String error(String provider_error) {
    return '❌ Kesalahan: $provider_error';
  }

  @override
  String get no_notifications_yet => 'Belum ada notifikasi';

  @override
  String get sign_in_successful_welcome => 'Berhasil masuk. Selamat datang!';

  @override
  String sign_in_failed_error(String error) {
    return 'Gagal masuk: $error';
  }

  @override
  String get name_is_required => 'Nama wajib diisi';

  @override
  String get phone_number_is_required => 'Nomor telepon wajib diisi';

  @override
  String get invalid_email_format => 'Format email tidak valid';

  @override
  String get registration_successful => 'Registrasi berhasil';

  @override
  String get registration_failed_please_try_again => 'Registrasi gagal. Silakan coba lagi.';

  @override
  String an_error_occurred_e(String e) {
    return 'Terjadi kesalahan: $e';
  }

  @override
  String get search_country_or_code => 'Cari negara atau kode...';

  @override
  String get phone_number => 'Nomor Telepon';

  @override
  String get gender => 'Jenis Kelamin';

  @override
  String get nationality => 'Kewarganegaraan';

  @override
  String get create_your_account => 'Buat Akun';

  @override
  String get please_fill_in_the_details_below_to_create_your_account => 'Silakan isi detail di bawah untuk membuat akun Anda.';

  @override
  String get full_name => 'Nama Lengkap';

  @override
  String get email_address => 'Alamat Email';

  @override
  String get nik_number => 'Nomor NIK';

  @override
  String get passport_number => 'Nomor Paspor';

  @override
  String get sign_up => 'Daftar';

  @override
  String get by_signing_up_you_agree_to_our_terms_of_service_and_privacy_policy => 'Dengan mendaftar, Anda menyetujui Syarat Layanan dan Kebijakan Privasi kami.';

  @override
  String get already_have_an_account => 'Sudah punya akun? ';

  @override
  String get sign_in => 'Masuk';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get education_details_are_not_available_right_now => 'Detail pendidikan belum tersedia.';

  @override
  String get certifications => 'Sertifikasi';

  @override
  String get certification_details_are_not_available_right_now => 'Detail sertifikasi belum tersedia.';

  @override
  String get general_schedule => 'Jadwal Umum';

  @override
  String get schedule_details_are_not_available_right_now => 'Detail jadwal belum tersedia.';

  @override
  String get professional_info => 'Info Profesional';

  @override
  String get specialist => 'Spesialis';

  @override
  String get department => 'Departemen';

  @override
  String get doctor_id => 'ID Dokter';

  @override
  String get internal_id => 'ID Internal';

  @override
  String get department_id => 'ID Departemen';

  @override
  String get select_doctor => 'Pilih Dokter';

  @override
  String get hello_i_would_like_to_inquire_about_the_services => 'Halo, saya ingin bertanya tentang layanan.';

  @override
  String get contact_via_whatsapp => 'Hubungi via WhatsApp';

  @override
  String get identity_not_found_nik_passport => 'Identitas tidak ditemukan (NIK / Paspor)';

  @override
  String get no_doctors_available => 'Tidak ada dokter tersedia';

  @override
  String get sign_in_cancelled_or_failed => 'Login dibatalkan atau gagal';

  @override
  String get account_not_found_please_sign_up_first => 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';

  @override
  String welcome(String name) {
    return 'Selamat datang $name!';
  }

  @override
  String sign_in_failed(String error) {
    return 'Gagal masuk: $error';
  }

  @override
  String get sign_in_failed_1 => 'Gagal masuk';

  @override
  String otp_sent_to_phonenumber(String phoneNumber) {
    return 'OTP dikirim ke $phoneNumber';
  }

  @override
  String get failed_to_send_otp_phone_not_registered => 'Gagal mengirim OTP. Nomor tidak terdaftar';

  @override
  String get success => 'Berhasil';

  @override
  String get otp_verified_successfully => 'OTP berhasil diverifikasi!';

  @override
  String get failed => 'Gagal';

  @override
  String get invalid_otp_please_try_again => 'OTP tidak valid. Silakan coba lagi.';

  @override
  String get verification_failed => 'Verifikasi gagal';

  @override
  String get enter_verification_code => 'Masukkan Kode Verifikasi';

  @override
  String get we_sent_a_verification_code_to => 'Kami mengirimkan kode verifikasi ke';

  @override
  String get didn_t_receive_the_code => 'Tidak menerima kode? ';

  @override
  String get resend => 'Kirim Ulang';

  @override
  String get select_country => 'Pilih Negara';

  @override
  String get welcome_back => 'Selamat Datang Kembali';

  @override
  String get please_enter_your_phone_number_to_continue => 'Masukkan nomor telepon untuk melanjutkan';

  @override
  String get enter_phone_number => 'Masukkan nomor telepon';

  @override
  String get continue_label => 'Lanjutkan';

  @override
  String get continue_as_guest => 'Lanjutkan sebagai Tamu';

  @override
  String get or => 'ATAU';

  @override
  String get signing_in => 'Sedang masuk...';

  @override
  String get continue_with_google => 'Masuk dengan Google';

  @override
  String get need_help_signing_in => 'Butuh bantuan masuk?';

  @override
  String get don_t_have_an_account => 'Belum punya akun? ';

  @override
  String get choose_your_wellness_package => 'Pilih Paket Wellness Anda';

  @override
  String get loading_packages => 'Memuat paket...';

  @override
  String get no_packages_found => 'Tidak ada paket ditemukan';

  @override
  String get choose_your_wellness_package_1 => 'Pilih paket wellness Anda';

  @override
  String get select_date => 'Pilih Tanggal';

  @override
  String get select_time => 'Pilih Waktu';

  @override
  String get halo_saya_ingin_bertanya_tentang_jadwal_wellness => 'Halo, saya ingin bertanya tentang jadwal Wellness.';

  @override
  String get no_available_time_slots => 'Tidak ada waktu tersedia';

  @override
  String get review_confirm => 'Tinjau & Konfirmasi';

  @override
  String get please_review_your_appointment_details => 'Harap tinjau detail janji Anda';

  @override
  String get please_sign_in_first => 'Silakan masuk terlebih dahulu';

  @override
  String something_went_wrong_e(String e) {
    return 'Terjadi kesalahan: $e';
  }

  @override
  String get booking_confirmed => 'Booking Berhasil!';

  @override
  String get booking_failed => 'Booking Gagal';

  @override
  String get booking_successfully_confirmed => 'Booking berhasil dikonfirmasi';

  @override
  String get failed_to_confirm_booking => 'Gagal mengonfirmasi booking';

  @override
  String get choose_your_preferred_doctor => 'Pilih dokter pilihan Anda';

  @override
  String get select => 'Pilih';

  @override
  String get no_packages_available => 'Tidak ada paket tersedia';

  @override
  String get select_date_time => 'Pilih Tanggal & Waktu';

  @override
  String get choose_your_preferred_appointment_slot => 'Pilih slot janji yang Anda inginkan';

  @override
  String get available_dates => 'Tanggal Tersedia';

  @override
  String get available_times => 'Waktu Tersedia';

  @override
  String get halo_saya_ingin_bertanya_tentang_jadwal_mcu => 'Halo, saya ingin bertanya tentang jadwal MCU.';

  @override
  String get back => 'Kembali';

  @override
  String get confirm_booking => 'Konfirmasi Booking';

  @override
  String get next => 'Lanjut';

  @override
  String get booking_successfully_but_code_is_not_available => 'Booking berhasil tetapi kode tidak tersedia';

  @override
  String get failed_to_book => 'Gagal melakukan booking';

  @override
  String get book_appointment => 'Buat Janji';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get congratulations => 'Selamat!';

  @override
  String get your_appointment_is_booked_for => 'Janji Anda dijadwalkan pada:';

  @override
  String get thank_you_for_using_our_service => 'Terima kasih telah menggunakan layanan kami!';

  @override
  String get permission_denied_to_access_storage => 'Izin penyimpanan ditolak';

  @override
  String file_saved_to_download_pdf(String fileName) {
    return 'File disimpan ke Download/$fileName.pdf';
  }

  @override
  String get failed_to_download_file => 'Gagal mengunduh file';

  @override
  String get no_pdf_available_for_this_result => 'Tidak ada PDF untuk hasil ini';

  @override
  String error_1(String provider_errorMenu) {
    return 'Kesalahan: $provider_errorMenu';
  }

  @override
  String get examination_results => 'Hasil Pemeriksaan';

  @override
  String get gallery => 'Galeri';

  @override
  String get camera => 'Kamera';

  @override
  String get failed_to_pick_image => 'Gagal memilih gambar';

  @override
  String get my_card => 'Kartu Saya';

  @override
  String get card_information => 'Informasi Kartu';

  @override
  String get got_it => 'Mengerti';

  @override
  String get personal_information => 'Informasi Pribadi';

  @override
  String get hide_info => 'Sembunyikan Info';

  @override
  String get show_info => 'Tampilkan Info';

  @override
  String get medical_record_no => 'No. Rekam Medis';

  @override
  String get email => 'Email';

  @override
  String get date_of_birth => 'Tanggal Lahir';

  @override
  String get doctor_details => 'Detail Dokter';

  @override
  String get doctor_detail_is_empty => 'Detail dokter kosong';

  @override
  String get doctor_attributes_are_unavailable => 'Atribut dokter tidak tersedia';

  @override
  String get name_not_available => 'Nama tidak tersedia';

  @override
  String get specialization_not_available => 'Spesialisasi tidak tersedia';

  @override
  String get about => 'Tentang';

  @override
  String get no_description_available_for_this_doctor => 'Tidak ada deskripsi untuk dokter ini.';

  @override
  String get show_more => 'Tampilkan lebih banyak';

  @override
  String get show_less => 'Tampilkan lebih sedikit';

  @override
  String get education => 'Pendidikan';

  @override
  String get no_education_data_available => 'Data pendidikan tidak tersedia';

  @override
  String get no_certification_data_available => 'Data sertifikasi tidak tersedia';

  @override
  String get unknown => 'Tidak diketahui';

  @override
  String get terms_conditions => 'Syarat & Ketentuan';

  @override
  String error_2(String provider_errorMessage) {
    return 'Kesalahan: $provider_errorMessage';
  }

  @override
  String get no_facilities_found => 'Tidak ada fasilitas ditemukan';

  @override
  String get sorry_we_cannot_open_whatsapp_on_this_device => 'Maaf, WhatsApp tidak dapat dibuka di perangkat ini.';

  @override
  String get active => 'AKTIF';

  @override
  String get inactive => 'TIDAK AKTIF';

  @override
  String get validity_period => 'Masa Berlaku';

  @override
  String get use_promo_now => 'Gunakan Promo Sekarang';

  @override
  String get promo_unavailable => 'Promo Tidak Tersedia';

  @override
  String promo_successfully_used(String widget_promo_title) {
    return '🎉 Promo $widget_promo_title berhasil digunakan!';
  }

  @override
  String get sharing_promo => '📤 Membagikan promo...';

  @override
  String get promo_saved_to_favorites => '💾 Promo disimpan ke favorit!';

  @override
  String get digitalCardInfo => 'Kartu digital ini merepresentasikan identitas pasien Anda. Pindai barcode untuk registrasi atau identifikasi di rumah sakit.';

  @override
  String get showingBasicProfile => 'Menampilkan profil dasar. Anda dapat melanjutkan dengan dokter ini atau memuat ulang untuk detail lengkap.';

  @override
  String orderConfirmationBody(int count, String total) {
    return 'Anda memilih $count item.\nTotal: $total\n\nLanjutkan pesanan?';
  }

  @override
  String get laboratory_order => 'Pesanan Laboratorium';

  @override
  String get search_laboratory => 'Cari laboratorium...';

  @override
  String get error_3 => 'Kesalahan: ';

  @override
  String get no_laboratory_data => 'Tidak ada data laboratorium';

  @override
  String get selected => 'Dipilih: ';

  @override
  String get total => 'Total: ';

  @override
  String get order_confirmation => 'Konfirmasi Pesanan';

  @override
  String get cancel => 'Batal';

  @override
  String get order_submitted_proceed_to_booking => 'Pesanan dikirim! Lanjutkan ke booking.';

  @override
  String get place_order => 'Pesan';

  @override
  String get order_radiology => 'Pesanan Radiologi';

  @override
  String get search_radiology => 'Cari radiologi...';

  @override
  String get no_radiology_items => 'Tidak ada item radiologi';

  @override
  String get no_matching_results => 'Tidak ada hasil yang cocok';

  @override
  String selected_1(int count) {
    return 'Dipilih: $count';
  }

  @override
  String total_1(String total) {
    return 'Total: $total';
  }
}
