// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get wellnessServicesTitle => 'Wellness Services';

  @override
  String get wellnessChooseServiceTitle => 'Choose Your Wellness Service';

  @override
  String get wellnessChooseServiceSubtitle => 'Select the type of wellness service you need';

  @override
  String get wellnessCardMcuTitle => 'Medical Checkup';

  @override
  String get wellnessCardMcuSubtitle => 'Complete medical examination';

  @override
  String get wellnessCardWellnessTitle => 'Wellness';

  @override
  String get wellnessCardWellnessSubtitle => 'Comprehensive health assessment';

  @override
  String get wellnessCardHealthScreeningTitle => 'Health Screening';

  @override
  String get wellnessCardHealthScreeningSubtitle => 'Preventive health tests';

  @override
  String get wellnessCardNutritionTitle => 'Nutrition Consultation';

  @override
  String get wellnessCardNutritionSubtitle => 'Dietary guidance and planning';

  @override
  String get bookingStepChooseDoctor => 'Choose Doctor';

  @override
  String get bookingStepChoosePoli => 'Choose Poli';

  @override
  String get bookingStepSelectDateTime => 'Select Date & Time';

  @override
  String get bookingStepReviewConfirm => 'Review & Confirm';

  @override
  String get bookingChooseDoctorTitle => 'Choose Your Doctor';

  @override
  String get bookingChooseDoctorSubtitle => 'Select from our top specialist doctors';

  @override
  String get bookingChoosePoliTitle => 'Choose Poli';

  @override
  String get bookingChoosePoliSubtitle => 'Select your preferred poli';

  @override
  String bookingSelectedDoctor(String name) {
    return 'Selected doctor: $name';
  }

  @override
  String get bookingAvailableDates => 'Available Dates';

  @override
  String get bookingAvailableTimes => 'Available Times';

  @override
  String get bookingNoTimeSlots => 'No available time slots';

  @override
  String get bookingNoPoliAvailable => 'No poli available';

  @override
  String get bookingReviewConfirmTitle => 'Review & Confirm';

  @override
  String get bookingReviewConfirmSubtitle => 'Please review your appointment details';

  @override
  String get bookingSummaryDoctor => 'Doctor';

  @override
  String get bookingSummaryPoli => 'Poli';

  @override
  String get bookingSummaryDate => 'Date';

  @override
  String get bookingSummaryTime => 'Time';

  @override
  String get bookingNotSelected => 'Not selected';

  @override
  String get bookingBtnBack => 'Back';

  @override
  String get bookingBtnContinue => 'Continue';

  @override
  String get bookingBtnConfirmBooking => 'Confirm Booking';

  @override
  String get bookingBtnDone => 'Done';

  @override
  String get bookingResultSuccessTitle => 'Booking Confirmed!';

  @override
  String get bookingResultFailureTitle => 'Booking Failed';

  @override
  String get bookingResultSuccessDefaultMessage => 'Your appointment has been successfully booked.';

  @override
  String bookingResultSuccessWithCode(String code) {
    return 'Your appointment has been successfully booked.\nCode: $code';
  }

  @override
  String get bookingResultGenericError => 'Something went wrong. Please try again.';

  @override
  String bookingNetworkError(String error) {
    return 'Network error: $error';
  }

  @override
  String get dashboardLocationLabel => 'Location';

  @override
  String get dashboardLocationDefault => 'Denpasar, Bali, Indonesia';

  @override
  String get dashboardSearchDoctorHint => 'Search Doctor';

  @override
  String get dashboardCategories => 'Categories';

  @override
  String get commonSeeAll => 'See All';

  @override
  String get dashboardArticleUpdates => 'Articles & Updates';

  @override
  String get dashboardChooseExaminationType => 'Choose Examination Type';

  @override
  String get examLaboratory => 'Laboratory';

  @override
  String get examRadiology => 'Radiology';

  @override
  String get commonClose => 'Close';

  @override
  String get dashboardCardWellness => 'Wellness';

  @override
  String get dashboardCardPlasticSurgery => 'Plastic Surgery';

  @override
  String get dashboardCardDermaesthetic => 'Dermaesthetic';

  @override
  String get dashboardCardAestheticDentistry => 'Aesthetic Dentistry';

  @override
  String get dashboardCardExaminationOrder => 'Examination Order';

  @override
  String get dashboardCardExaminationResult => 'Examination Result';

  @override
  String get dashboardCardAboutUs => 'About Us';

  @override
  String get dashboardCardOurFacilities => 'Our Facilities';

  @override
  String get profileTitle => 'User Profile';

  @override
  String get profileMenuEditProfile => 'Edit Profile';

  @override
  String get profileMenuCard => 'Patient Card';

  @override
  String get profileMenuFavorite => 'Favorite';

  @override
  String get profileMenuNotifications => 'Notifications';

  @override
  String get profileMenuSettings => 'Settings';

  @override
  String get profileMenuChangeLanguage => 'Change Language';

  @override
  String get profileMenuHelpSupport => 'Help & Support';

  @override
  String get profileMenuTerms => 'Terms & Conditions';

  @override
  String get profileMenuLogout => 'Log Out';

  @override
  String get profileGuest => 'Guest';

  @override
  String get profileLogoutTitle => 'Log Out';

  @override
  String get profileLogoutMessage => 'Are you sure you want to log out?';

  @override
  String get profileLogoutCancel => 'Cancel';

  @override
  String get profileLogoutConfirm => 'Yes, Logout';

  @override
  String get langChangeTitle => 'Change Language';

  @override
  String get langIndonesian => 'Indonesian';

  @override
  String get langEnglish => 'English';

  @override
  String langSavedToast(String lang) {
    return 'Language changed to $lang';
  }

  @override
  String get doctorsAllTitle => 'All Doctors';

  @override
  String doctorsFoundCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doctors found',
      one: '1 doctor found',
      zero: 'No doctors found',
    );
    return '$_temp0';
  }

  @override
  String get commonDefault => 'Default';

  @override
  String get myBookingTitle => 'My Bookings';

  @override
  String get bookingTabUpcoming => 'Upcoming';

  @override
  String get bookingTabCompleted => 'Completed';

  @override
  String get bookingTabCancelled => 'Cancelled';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profileSectionPersonalInfo => 'Personal Information';

  @override
  String get profileSectionIdentity => 'Identity';

  @override
  String get profileSectionAdditionalInfo => 'Additional Information';

  @override
  String get profileHintFullName => 'Full Name';

  @override
  String get profileHintEmail => 'Email';

  @override
  String get profileHintPhoneNumber => 'Phone Number';

  @override
  String get profileHintNikNumber => 'NIK Number';

  @override
  String get profileHintPassportNumber => 'Passport Number';

  @override
  String get profileHintDateOfBirth => 'Date of Birth';

  @override
  String get profileHintGender => 'Gender';

  @override
  String get profileLabelNationality => 'Nationality';

  @override
  String get profileNationalityWni => 'Indonesian';

  @override
  String get profileNationalityWna => 'Foreign Citizen';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get profileBtnSaveChanges => 'Save Changes';

  @override
  String get profileBtnSaving => 'Saving...';

  @override
  String get profileErrorUserNotFound => 'User data not found';

  @override
  String get profileErrorInvalidPatientId => 'Invalid patient ID';

  @override
  String get profileErrorNameRequired => 'Name is required';

  @override
  String get profileErrorEmailRequired => 'Email is required';

  @override
  String get profileErrorEmailInvalid => 'Invalid email format';

  @override
  String get profileErrorPhoneRequired => 'Phone number is required';

  @override
  String get profileErrorGenderRequired => 'Gender is required';

  @override
  String get profileErrorGenderInvalid => 'Invalid gender';

  @override
  String get profileSnackbarUpdateSuccess => 'Profile updated successfully';

  @override
  String get profileSnackbarUpdateFailure => 'Failed to update profile';

  @override
  String get profileDialogCongratsTitle => 'Congratulations!';

  @override
  String get profileDialogCongratsBody => 'Your account is ready to use. You will be redirected to the homepage shortly...';

  @override
  String get commonSave => 'Save';

  @override
  String get loginRequiredTitle => 'Login Required';

  @override
  String get loginRequiredMessage => 'Please login first to continue your transaction';

  @override
  String get bookingNotFound => 'Booking not found';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get bookingBtnCancel => 'Cancel Booking';

  @override
  String get bookingBtnReschedule => 'Reschedule';

  @override
  String bookingRescheduleFlow(String code) {
    return 'Reschedule flow for $code';
  }

  @override
  String get bookingCancelled => 'Booking cancelled';

  @override
  String bookingCancelError(String error) {
    return 'Failed to cancel booking: $error';
  }

  @override
  String bookingNoType(String type) {
    return 'No $type bookings';
  }

  @override
  String bookingSelectDateError(String error) {
    return 'Error selecting date: $error';
  }

  @override
  String bookingFetchScheduleError(String error) {
    return 'Error fetching schedule: $error';
  }

  @override
  String get bookingSelectTimeFirst => 'Please select a time first';

  @override
  String get rescheduleTitle => 'Reschedule Booking';

  @override
  String get bookingNoAvailableSchedule => 'No available schedule';

  @override
  String get cannotOpenWhatsApp => 'Cannot open WhatsApp';

  @override
  String get contactViaWhatsApp => 'Contact via WhatsApp';

  @override
  String get bookingConfirm => 'Confirm';

  @override
  String bookingError(String error) {
    return 'Error: $error';
  }

  @override
  String get storagePermissionDenied => 'Storage permission denied';

  @override
  String fileSavedToDownload(String file) {
    return 'File saved to Download/$file';
  }

  @override
  String get failedToDownloadFile => 'Failed to download file';

  @override
  String get failedToLoadPage => 'Failed to load page';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get home => 'Home';

  @override
  String get aboutUs => 'About Us';

  @override
  String get ngoerahsunHospital => 'Ngoerahsun Hospital';

  @override
  String get excellenceInHealthcare => 'Excellence in Healthcare';

  @override
  String get aboutDescription => 'Ngoerahsun Hospital is a leading healthcare institution in Indonesia, providing international standard medical services backed by advanced technology and experienced medical professionals.';

  @override
  String get aboutLabel => 'About';

  @override
  String get ourVisionTitle => 'Our Vision';

  @override
  String get ourVisionDescription => 'To become the leading hospital of choice providing comprehensive, safe, and high-quality healthcare services to all segments of society.';

  @override
  String get ourMissionTitle => 'Our Mission';

  @override
  String get ourMissionDescription => 'To deliver excellent medical services with a holistic approach, prioritizing patient safety and continuous innovation.';

  @override
  String get ourExcellenceTitle => 'Our Excellence';

  @override
  String get ourExcellenceDescription => 'Equipped with modern facilities, experienced specialists, 24/7 services, and international accreditation standards.';

  @override
  String get ourCommitmentTitle => 'Our Commitment';

  @override
  String get ourCommitmentDescription => 'Committed to patient satisfaction through friendly, professional, and empathetic service.';

  @override
  String get yourHealthOurPriority => 'Your Health, Our Priority';

  @override
  String get trustedByThousands => 'Trusted by thousands of patients across Indonesia';

  @override
  String get article => 'Article';

  @override
  String get publishedToday => 'Published today';

  @override
  String noArticlesFound(String query) {
    return 'No articles found for \"$query\".';
  }

  @override
  String get noArticlesAvailable => 'No articles available at the moment';

  @override
  String get all_articles => 'All Articles';

  @override
  String get mcu_questionnaire => 'MCU Questionnaire';

  @override
  String get my_favorite_doctors => 'My Favorite Doctors';

  @override
  String get no_favorite_doctors_yet => 'No favorite doctors yet';

  @override
  String get browse_and_add_doctors_to_your_favorites => 'Browse and add doctors to your favorites';

  @override
  String get doctor_added_to_favorites => 'Doctor added to favorites';

  @override
  String get doctor_removed_from_favorites => 'Doctor removed from favorites';

  @override
  String get failed_to_update_favorite_status => 'Failed to update favorite status';

  @override
  String get notifications => 'Notifications';

  @override
  String error(String provider_error) {
    return '❌ Error: $provider_error';
  }

  @override
  String get no_notifications_yet => 'No notifications yet';

  @override
  String get sign_in_successful_welcome => 'Sign-in successful. Welcome!';

  @override
  String sign_in_failed_error(String error) {
    return 'Sign-in failed: $error';
  }

  @override
  String get name_is_required => 'Name is required';

  @override
  String get phone_number_is_required => 'Phone number is required';

  @override
  String get invalid_email_format => 'Invalid email format';

  @override
  String get registration_successful => 'Registration successful';

  @override
  String get registration_failed_please_try_again => 'Registration failed. Please try again.';

  @override
  String an_error_occurred_e(String e) {
    return 'An error occurred: $e';
  }

  @override
  String get search_country_or_code => 'Search country or code...';

  @override
  String get phone_number => 'Phone Number';

  @override
  String get gender => 'Gender';

  @override
  String get nationality => 'Nationality';

  @override
  String get create_your_account => 'Create Your Account';

  @override
  String get please_fill_in_the_details_below_to_create_your_account => 'Please fill in the details below to create your account.';

  @override
  String get full_name => 'Full Name';

  @override
  String get email_address => 'Email Address';

  @override
  String get nik_number => 'NIK Number';

  @override
  String get passport_number => 'Passport Number';

  @override
  String get sign_up => 'Sign Up';

  @override
  String get by_signing_up_you_agree_to_our_terms_of_service_and_privacy_policy => 'By signing up, you agree to our Terms of Service and Privacy Policy.';

  @override
  String get already_have_an_account => 'Already have an account? ';

  @override
  String get sign_in => 'Sign In';

  @override
  String get retry => 'Retry';

  @override
  String get education_details_are_not_available_right_now => 'Education details are not available right now.';

  @override
  String get certifications => 'Certifications';

  @override
  String get certification_details_are_not_available_right_now => 'Certification details are not available right now.';

  @override
  String get general_schedule => 'General Schedule';

  @override
  String get schedule_details_are_not_available_right_now => 'Schedule details are not available right now.';

  @override
  String get professional_info => 'Professional Info';

  @override
  String get specialist => 'Specialist';

  @override
  String get department => 'Department';

  @override
  String get doctor_id => 'Doctor ID';

  @override
  String get internal_id => 'Internal ID';

  @override
  String get department_id => 'Department ID';

  @override
  String get select_doctor => 'Select Doctor';

  @override
  String get hello_i_would_like_to_inquire_about_the_services => 'Hello, I would like to inquire about the services.';

  @override
  String get contact_via_whatsapp => 'Contact via WhatsApp';

  @override
  String get identity_not_found_nik_passport => 'Identity not found (NIK / Passport)';

  @override
  String get no_doctors_available => 'No doctors available';

  @override
  String get sign_in_cancelled_or_failed => 'Sign-in cancelled or failed';

  @override
  String get account_not_found_please_sign_up_first => 'Account not found. Please sign up first.';

  @override
  String welcome(String name) {
    return 'Welcome $name!';
  }

  @override
  String sign_in_failed(String error) {
    return 'Sign-in failed: $error';
  }

  @override
  String get sign_in_failed_1 => 'Sign-in failed';

  @override
  String otp_sent_to_phonenumber(String phoneNumber) {
    return 'OTP sent to $phoneNumber';
  }

  @override
  String get failed_to_send_otp_phone_not_registered => 'Failed to send OTP. Phone number not registered';

  @override
  String get success => 'Success';

  @override
  String get otp_verified_successfully => 'OTP verified successfully!';

  @override
  String get failed => 'Failed';

  @override
  String get invalid_otp_please_try_again => 'Invalid OTP. Please try again.';

  @override
  String get verification_failed => 'Verification failed';

  @override
  String get enter_verification_code => 'Enter Verification Code';

  @override
  String get we_sent_a_verification_code_to => 'We sent a verification code to';

  @override
  String get didn_t_receive_the_code => 'Didn\'t receive the code? ';

  @override
  String get resend => 'Resend';

  @override
  String get select_country => 'Select Country';

  @override
  String get welcome_back => 'Welcome Back';

  @override
  String get please_enter_your_phone_number_to_continue => 'Please enter your phone number to continue';

  @override
  String get enter_phone_number => 'Enter phone number';

  @override
  String get continue_label => 'Continue';

  @override
  String get continue_as_guest => 'Continue as Guest';

  @override
  String get or => 'OR';

  @override
  String get signing_in => 'Signing in...';

  @override
  String get continue_with_google => 'Continue with Google';

  @override
  String get need_help_signing_in => 'Need help signing in?';

  @override
  String get don_t_have_an_account => 'Don\'t have an account? ';

  @override
  String get choose_your_wellness_package => 'Choose Your Wellness Package';

  @override
  String get loading_packages => 'Loading packages...';

  @override
  String get no_packages_found => 'No packages found';

  @override
  String get choose_your_wellness_package_1 => 'Choose your wellness package';

  @override
  String get select_date => 'Select Date';

  @override
  String get select_time => 'Select Time';

  @override
  String get halo_saya_ingin_bertanya_tentang_jadwal_wellness => 'Hello, I want to ask about the Wellness schedule.';

  @override
  String get no_available_time_slots => 'No available time slots';

  @override
  String get review_confirm => 'Review & Confirm';

  @override
  String get please_review_your_appointment_details => 'Please review your appointment details';

  @override
  String get please_sign_in_first => 'Please sign in first';

  @override
  String something_went_wrong_e(String e) {
    return 'Something went wrong: $e';
  }

  @override
  String get booking_confirmed => 'Booking Confirmed!';

  @override
  String get booking_failed => 'Booking Failed';

  @override
  String get booking_successfully_confirmed => 'Booking successfully confirmed';

  @override
  String get failed_to_confirm_booking => 'Failed to confirm booking';

  @override
  String get choose_your_preferred_doctor => 'Choose your preferred doctor';

  @override
  String get select => 'Select';

  @override
  String get no_packages_available => 'No packages available';

  @override
  String get select_date_time => 'Select Date & Time';

  @override
  String get choose_your_preferred_appointment_slot => 'Choose your preferred appointment slot';

  @override
  String get available_dates => 'Available Dates';

  @override
  String get available_times => 'Available Times';

  @override
  String get halo_saya_ingin_bertanya_tentang_jadwal_mcu => 'Hello, I want to ask about the MCU schedule.';

  @override
  String get back => 'Back';

  @override
  String get confirm_booking => 'Confirm Booking';

  @override
  String get next => 'Next';

  @override
  String get booking_successfully_but_code_is_not_available => 'Booking successful but code is not available';

  @override
  String get failed_to_book => 'Failed to book';

  @override
  String get book_appointment => 'Book Appointment';

  @override
  String get confirm => 'Confirm';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get your_appointment_is_booked_for => 'Your appointment is booked for:';

  @override
  String get thank_you_for_using_our_service => 'Thank you for using our service!';

  @override
  String get permission_denied_to_access_storage => 'Permission denied to access storage';

  @override
  String file_saved_to_download_pdf(String fileName) {
    return 'File saved to Download/$fileName.pdf';
  }

  @override
  String get failed_to_download_file => 'Failed to download file';

  @override
  String get no_pdf_available_for_this_result => 'No PDF available for this result';

  @override
  String error_1(String provider_errorMenu) {
    return 'Error: $provider_errorMenu';
  }

  @override
  String get examination_results => 'Examination Results';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get failed_to_pick_image => 'Failed to pick image';

  @override
  String get my_card => 'My Card';

  @override
  String get card_information => 'Card Information';

  @override
  String get got_it => 'Got it';

  @override
  String get personal_information => 'Personal Information';

  @override
  String get hide_info => 'Hide Info';

  @override
  String get show_info => 'Show Info';

  @override
  String get medical_record_no => 'Medical Record No.';

  @override
  String get email => 'Email';

  @override
  String get date_of_birth => 'Date of Birth';

  @override
  String get doctor_details => 'Doctor Details';

  @override
  String get doctor_detail_is_empty => 'Doctor detail is empty';

  @override
  String get doctor_attributes_are_unavailable => 'Doctor attributes are unavailable';

  @override
  String get name_not_available => 'Name not available';

  @override
  String get specialization_not_available => 'Specialization not available';

  @override
  String get about => 'About';

  @override
  String get no_description_available_for_this_doctor => 'No description available for this doctor.';

  @override
  String get show_more => 'Show more';

  @override
  String get show_less => 'Show less';

  @override
  String get education => 'Education';

  @override
  String get no_education_data_available => 'No education data available';

  @override
  String get no_certification_data_available => 'No certification data available';

  @override
  String get unknown => 'Unknown';

  @override
  String get terms_conditions => 'Terms & Conditions';

  @override
  String error_2(String provider_errorMessage) {
    return 'Error: $provider_errorMessage';
  }

  @override
  String get no_facilities_found => 'No facilities found';

  @override
  String get sorry_we_cannot_open_whatsapp_on_this_device => 'Sorry, WhatsApp cannot be opened on this device.';

  @override
  String get active => 'ACTIVE';

  @override
  String get inactive => 'INACTIVE';

  @override
  String get validity_period => 'Validity Period';

  @override
  String get use_promo_now => 'USE PROMO NOW';

  @override
  String get promo_unavailable => 'PROMO UNAVAILABLE';

  @override
  String promo_successfully_used(String widget_promo_title) {
    return '🎉 Promo $widget_promo_title successfully used!';
  }

  @override
  String get sharing_promo => '📤 Sharing promo...';

  @override
  String get promo_saved_to_favorites => '💾 Promo saved to favorites!';

  @override
  String get digitalCardInfo => 'This digital card represents your patient identity. Scan the barcode for registration or identification at the hospital.';

  @override
  String get showingBasicProfile => 'Showing basic profile. You can continue with this doctor or reload for full details.';

  @override
  String orderConfirmationBody(int count, String total) {
    return 'You selected $count items.\nTotal: $total\n\nProceed with the order?';
  }

  @override
  String get laboratory_order => 'Laboratory Order';

  @override
  String get search_laboratory => 'Search laboratory...';

  @override
  String get error_3 => 'Error: ';

  @override
  String get no_laboratory_data => 'No laboratory data';

  @override
  String get selected => 'Selected: ';

  @override
  String get total => 'Total: ';

  @override
  String get order_confirmation => 'Order Confirmation';

  @override
  String get cancel => 'Cancel';

  @override
  String get order_submitted_proceed_to_booking => 'Order submitted! Proceed to booking.';

  @override
  String get place_order => 'Place Order';

  @override
  String get order_radiology => 'Radiology Order';

  @override
  String get search_radiology => 'Search radiology...';

  @override
  String get no_radiology_items => 'No radiology items';

  @override
  String get no_matching_results => 'No matching results';

  @override
  String selected_1(int count) {
    return 'Selected: $count';
  }

  @override
  String total_1(String total) {
    return 'Total: $total';
  }
}
