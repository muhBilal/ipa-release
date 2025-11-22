// const String _baseUrl = "http://10.100.10.3"; 
const String _baseUrl = "http://66.96.248.202"; 
// const String _baseUrl = "http://hp.local";
String get getBaseUrl => _baseUrl;

class ResourceRepository {
  String get baseUrl => getBaseUrl;

  final String _login = "$getBaseUrl/auth/login";
  String get getLoginUrl => _login;
  
  final String _register = "$getBaseUrl/api/register";
  String get getRegisterUrl => _register;

  final String _sendOtp = "$getBaseUrl/api/otp/send";
  String get getSendOtpUrl => _sendOtp;

  final String _verifyOtp = "$getBaseUrl/api/otp/verify";
  String get getVerifyOtpUrl => _verifyOtp;

  final String _getUser = "$getBaseUrl/api/admission/getUser";
  String get getUserUrl => _getUser;

  final String _getDoctors = "$getBaseUrl/api/get-doctor";
  String get getDoctorsUrl => _getDoctors;
  final String _getDetailDoctor =
      "https://cms-staging.ngoerahsunwac.co.id/api/doctor-simrs";
  String get getDetailDoctorUrl => _getDetailDoctor;

  final String _getPoli = "$getBaseUrl/api/get-poli";
  String get getPoliUrl => _getPoli;
  final String _getSchedule = "$getBaseUrl/admission/get_schedule_time";
  String get getScheduleUrl => _getSchedule;

  final String _getPackage = "$getBaseUrl/admission/get_doctor";
  String get getPackageUrl => _getPackage;

  final String _bookAppointment = "$getBaseUrl/api/admission/do_booking";
  String get getBookAppointmentUrl => _bookAppointment;

  final String _webViewBookCode = "$getBaseUrl/admission/mcu_quesioner";
  String get getWebViewBookCode => _webViewBookCode;

  final String _getMyBooking = "$getBaseUrl/api/get-patient-book";
  String get getMyBookingUrl => _getMyBooking;

  final String _getReschedule = "$getBaseUrl/api/reschedule-booking";
  String get getRescheduleBookingUrl => _getReschedule;

  final String _cancelBooking = "$getBaseUrl/api/cancel-booking";
  String get getCancelBookingUrl => _cancelBooking;

  final String _getExaminations = "$getBaseUrl/api/examination-result";
  String get getExaminationsUrl => _getExaminations;

  final String _getExaminationMenu = "$getBaseUrl/api/examination-result-menu";
  String get getExaminationMenuUrl => _getExaminationMenu;

  final String _getArticles = "https://cms.ngoerahsunwac.co.id/api/articles";
  String get getArticlesUrl => _getArticles;

  // final String _getAboutUs =
  //     "https://cms.ngoerahsunwac.co.id/api/about-us?populate[Section1][populate]=*&populate[Section2][populate]=*&populate[StorySection][populate]=StorySection.Banner,StorySection.BannerMobile&populate[Banner]=*&populate[BannerSection1]=*&populate[BannerSection2]=*&populate[BannerSection3]=*&populate[SEO]=metaTitle,metaDescription,keywords";
  final String _getAboutUs = "$getBaseUrl/api/cms/about-us";
  String get getAboutUsUrl => _getAboutUs;

  // final String _getOurFacility =
  //     "https://cms.ngoerahsunwac.co.id/api/about-us?populate[Section1][populate]=*&populate[Section2][populate]=*&populate[StorySection][populate]=StorySection.Banner,StorySection.BannerMobile&populate[Banner]=*&populate[BannerSection1]=*&populate[BannerSection2]=*&populate[BannerSection3]=";
  final String _getOurFacility = "$getBaseUrl/api/cms/facilities";
  String get getOurFacilityUrl => _getOurFacility;

  final String _updateUser = "$getBaseUrl/api/update-user";
  String get getUpdateUserUrl => _updateUser;

  final String _getPromos = "$getBaseUrl/api/promos";
  String get getPromosUrl => _getPromos;

  final String _getNotification = "$getBaseUrl/api/get-notif";
  String get getNotificationUrl => _getNotification;

  final String _handleFavDoctor = "$getBaseUrl/api/handle-fav-doctor";
  String get postFavDoctorUrl => _handleFavDoctor;

  final String _getDetailBook = "$getBaseUrl/api/admission/getBookDetail";
  String get getDetailBookUrl => _getDetailBook;

  final String _getRadiologyMenu = "$getBaseUrl/api/radiology";
  String get getRadiologyMenuUrl => _getRadiologyMenu;
  final String _getLabMenu = "$getBaseUrl/api/lab";
  String get getLabMenuUrl => _getLabMenu;

  final String _storePlayerId = "$getBaseUrl/api/save-player-id";
  String get getStorePlayerIdUrl => _storePlayerId;

}
