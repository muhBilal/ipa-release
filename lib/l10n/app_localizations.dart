import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @wellnessServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Wellness Services'**
  String get wellnessServicesTitle;

  /// No description provided for @wellnessChooseServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Wellness Service'**
  String get wellnessChooseServiceTitle;

  /// No description provided for @wellnessChooseServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the type of wellness service you need'**
  String get wellnessChooseServiceSubtitle;

  /// No description provided for @wellnessCardMcuTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical Checkup'**
  String get wellnessCardMcuTitle;

  /// No description provided for @wellnessCardMcuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete medical examination'**
  String get wellnessCardMcuSubtitle;

  /// No description provided for @wellnessCardWellnessTitle.
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get wellnessCardWellnessTitle;

  /// No description provided for @wellnessCardWellnessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive health assessment'**
  String get wellnessCardWellnessSubtitle;

  /// No description provided for @wellnessCardHealthScreeningTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Screening'**
  String get wellnessCardHealthScreeningTitle;

  /// No description provided for @wellnessCardHealthScreeningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preventive health tests'**
  String get wellnessCardHealthScreeningSubtitle;

  /// No description provided for @wellnessCardNutritionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Consultation'**
  String get wellnessCardNutritionTitle;

  /// No description provided for @wellnessCardNutritionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dietary guidance and planning'**
  String get wellnessCardNutritionSubtitle;

  /// No description provided for @bookingStepChooseDoctor.
  ///
  /// In en, this message translates to:
  /// **'Choose Doctor'**
  String get bookingStepChooseDoctor;

  /// No description provided for @bookingStepChoosePoli.
  ///
  /// In en, this message translates to:
  /// **'Choose Poli'**
  String get bookingStepChoosePoli;

  /// No description provided for @bookingStepSelectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time'**
  String get bookingStepSelectDateTime;

  /// No description provided for @bookingStepReviewConfirm.
  ///
  /// In en, this message translates to:
  /// **'Review & Confirm'**
  String get bookingStepReviewConfirm;

  /// No description provided for @bookingChooseDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Doctor'**
  String get bookingChooseDoctorTitle;

  /// No description provided for @bookingChooseDoctorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select from our top specialist doctors'**
  String get bookingChooseDoctorSubtitle;

  /// No description provided for @bookingChoosePoliTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Poli'**
  String get bookingChoosePoliTitle;

  /// No description provided for @bookingChoosePoliSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred poli'**
  String get bookingChoosePoliSubtitle;

  /// No description provided for @bookingSelectedDoctor.
  ///
  /// In en, this message translates to:
  /// **'Selected doctor: {name}'**
  String bookingSelectedDoctor(String name);

  /// No description provided for @bookingAvailableDates.
  ///
  /// In en, this message translates to:
  /// **'Available Dates'**
  String get bookingAvailableDates;

  /// No description provided for @bookingAvailableTimes.
  ///
  /// In en, this message translates to:
  /// **'Available Times'**
  String get bookingAvailableTimes;

  /// No description provided for @bookingNoTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'No available time slots'**
  String get bookingNoTimeSlots;

  /// No description provided for @bookingNoPoliAvailable.
  ///
  /// In en, this message translates to:
  /// **'No poli available'**
  String get bookingNoPoliAvailable;

  /// No description provided for @bookingReviewConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & Confirm'**
  String get bookingReviewConfirmTitle;

  /// No description provided for @bookingReviewConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please review your appointment details'**
  String get bookingReviewConfirmSubtitle;

  /// No description provided for @bookingSummaryDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get bookingSummaryDoctor;

  /// No description provided for @bookingSummaryPoli.
  ///
  /// In en, this message translates to:
  /// **'Poli'**
  String get bookingSummaryPoli;

  /// No description provided for @bookingSummaryDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get bookingSummaryDate;

  /// No description provided for @bookingSummaryTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get bookingSummaryTime;

  /// No description provided for @bookingNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get bookingNotSelected;

  /// No description provided for @bookingBtnBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get bookingBtnBack;

  /// No description provided for @bookingBtnContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get bookingBtnContinue;

  /// No description provided for @bookingBtnConfirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get bookingBtnConfirmBooking;

  /// No description provided for @bookingBtnDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get bookingBtnDone;

  /// No description provided for @bookingResultSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingResultSuccessTitle;

  /// No description provided for @bookingResultFailureTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Failed'**
  String get bookingResultFailureTitle;

  /// No description provided for @bookingResultSuccessDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'Your appointment has been successfully booked.'**
  String get bookingResultSuccessDefaultMessage;

  /// No description provided for @bookingResultSuccessWithCode.
  ///
  /// In en, this message translates to:
  /// **'Your appointment has been successfully booked.\nCode: {code}'**
  String bookingResultSuccessWithCode(String code);

  /// No description provided for @bookingResultGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get bookingResultGenericError;

  /// No description provided for @bookingNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error: {error}'**
  String bookingNetworkError(String error);

  /// No description provided for @dashboardLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get dashboardLocationLabel;

  /// No description provided for @dashboardLocationDefault.
  ///
  /// In en, this message translates to:
  /// **'Denpasar, Bali, Indonesia'**
  String get dashboardLocationDefault;

  /// No description provided for @dashboardSearchDoctorHint.
  ///
  /// In en, this message translates to:
  /// **'Search Doctor'**
  String get dashboardSearchDoctorHint;

  /// No description provided for @dashboardCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get dashboardCategories;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get commonSeeAll;

  /// No description provided for @dashboardArticleUpdates.
  ///
  /// In en, this message translates to:
  /// **'Articles & Updates'**
  String get dashboardArticleUpdates;

  /// No description provided for @dashboardChooseExaminationType.
  ///
  /// In en, this message translates to:
  /// **'Choose Examination Type'**
  String get dashboardChooseExaminationType;

  /// No description provided for @examLaboratory.
  ///
  /// In en, this message translates to:
  /// **'Laboratory'**
  String get examLaboratory;

  /// No description provided for @examRadiology.
  ///
  /// In en, this message translates to:
  /// **'Radiology'**
  String get examRadiology;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @dashboardCardWellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get dashboardCardWellness;

  /// No description provided for @dashboardCardPlasticSurgery.
  ///
  /// In en, this message translates to:
  /// **'Plastic Surgery'**
  String get dashboardCardPlasticSurgery;

  /// No description provided for @dashboardCardDermaesthetic.
  ///
  /// In en, this message translates to:
  /// **'Dermaesthetic'**
  String get dashboardCardDermaesthetic;

  /// No description provided for @dashboardCardAestheticDentistry.
  ///
  /// In en, this message translates to:
  /// **'Aesthetic Dentistry'**
  String get dashboardCardAestheticDentistry;

  /// No description provided for @dashboardCardExaminationOrder.
  ///
  /// In en, this message translates to:
  /// **'Examination Order'**
  String get dashboardCardExaminationOrder;

  /// No description provided for @dashboardCardExaminationResult.
  ///
  /// In en, this message translates to:
  /// **'Examination Result'**
  String get dashboardCardExaminationResult;

  /// No description provided for @dashboardCardAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get dashboardCardAboutUs;

  /// No description provided for @dashboardCardOurFacilities.
  ///
  /// In en, this message translates to:
  /// **'Our Facilities'**
  String get dashboardCardOurFacilities;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get profileTitle;

  /// No description provided for @profileMenuEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileMenuEditProfile;

  /// No description provided for @profileMenuCard.
  ///
  /// In en, this message translates to:
  /// **'Patient Card'**
  String get profileMenuCard;

  /// No description provided for @profileMenuFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get profileMenuFavorite;

  /// No description provided for @profileMenuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileMenuNotifications;

  /// No description provided for @profileMenuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileMenuSettings;

  /// No description provided for @profileMenuChangeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get profileMenuChangeLanguage;

  /// No description provided for @profileMenuHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get profileMenuHelpSupport;

  /// No description provided for @profileMenuTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get profileMenuTerms;

  /// No description provided for @profileMenuLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileMenuLogout;

  /// No description provided for @profileGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get profileGuest;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get profileLogoutMessage;

  /// No description provided for @profileLogoutCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileLogoutCancel;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Logout'**
  String get profileLogoutConfirm;

  /// No description provided for @langChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get langChangeTitle;

  /// No description provided for @langIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get langIndonesian;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {lang}'**
  String langSavedToast(String lang);

  /// No description provided for @doctorsAllTitle.
  ///
  /// In en, this message translates to:
  /// **'All Doctors'**
  String get doctorsAllTitle;

  /// No description provided for @doctorsFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No doctors found} one {1 doctor found} other {{count} doctors found}}'**
  String doctorsFoundCount(num count);

  /// No description provided for @commonDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get commonDefault;

  /// No description provided for @myBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookingTitle;

  /// No description provided for @bookingTabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get bookingTabUpcoming;

  /// No description provided for @bookingTabCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingTabCompleted;

  /// No description provided for @bookingTabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingTabCancelled;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditTitle;

  /// No description provided for @profileSectionPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profileSectionPersonalInfo;

  /// No description provided for @profileSectionIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get profileSectionIdentity;

  /// No description provided for @profileSectionAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get profileSectionAdditionalInfo;

  /// No description provided for @profileHintFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileHintFullName;

  /// No description provided for @profileHintEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileHintEmail;

  /// No description provided for @profileHintPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profileHintPhoneNumber;

  /// No description provided for @profileHintNikNumber.
  ///
  /// In en, this message translates to:
  /// **'NIK Number'**
  String get profileHintNikNumber;

  /// No description provided for @profileHintPassportNumber.
  ///
  /// In en, this message translates to:
  /// **'Passport Number'**
  String get profileHintPassportNumber;

  /// No description provided for @profileHintDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get profileHintDateOfBirth;

  /// No description provided for @profileHintGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileHintGender;

  /// No description provided for @profileLabelNationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get profileLabelNationality;

  /// No description provided for @profileNationalityWni.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get profileNationalityWni;

  /// No description provided for @profileNationalityWna.
  ///
  /// In en, this message translates to:
  /// **'Foreign Citizen'**
  String get profileNationalityWna;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @profileBtnSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profileBtnSaveChanges;

  /// No description provided for @profileBtnSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get profileBtnSaving;

  /// No description provided for @profileErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User data not found'**
  String get profileErrorUserNotFound;

  /// No description provided for @profileErrorInvalidPatientId.
  ///
  /// In en, this message translates to:
  /// **'Invalid patient ID'**
  String get profileErrorInvalidPatientId;

  /// No description provided for @profileErrorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get profileErrorNameRequired;

  /// No description provided for @profileErrorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get profileErrorEmailRequired;

  /// No description provided for @profileErrorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get profileErrorEmailInvalid;

  /// No description provided for @profileErrorPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get profileErrorPhoneRequired;

  /// No description provided for @profileErrorGenderRequired.
  ///
  /// In en, this message translates to:
  /// **'Gender is required'**
  String get profileErrorGenderRequired;

  /// No description provided for @profileErrorGenderInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid gender'**
  String get profileErrorGenderInvalid;

  /// No description provided for @profileSnackbarUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileSnackbarUpdateSuccess;

  /// No description provided for @profileSnackbarUpdateFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get profileSnackbarUpdateFailure;

  /// No description provided for @profileDialogCongratsTitle.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get profileDialogCongratsTitle;

  /// No description provided for @profileDialogCongratsBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready to use. You will be redirected to the homepage shortly...'**
  String get profileDialogCongratsBody;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @loginRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequiredTitle;

  /// No description provided for @loginRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Please login first to continue your transaction'**
  String get loginRequiredMessage;

  /// No description provided for @bookingNotFound.
  ///
  /// In en, this message translates to:
  /// **'Booking not found'**
  String get bookingNotFound;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @bookingBtnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get bookingBtnCancel;

  /// No description provided for @bookingBtnReschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get bookingBtnReschedule;

  /// No description provided for @bookingRescheduleFlow.
  ///
  /// In en, this message translates to:
  /// **'Reschedule flow for {code}'**
  String bookingRescheduleFlow(String code);

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get bookingCancelled;

  /// No description provided for @bookingCancelError.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel booking: {error}'**
  String bookingCancelError(String error);

  /// No description provided for @bookingNoType.
  ///
  /// In en, this message translates to:
  /// **'No {type} bookings'**
  String bookingNoType(String type);

  /// No description provided for @bookingSelectDateError.
  ///
  /// In en, this message translates to:
  /// **'Error selecting date: {error}'**
  String bookingSelectDateError(String error);

  /// No description provided for @bookingFetchScheduleError.
  ///
  /// In en, this message translates to:
  /// **'Error fetching schedule: {error}'**
  String bookingFetchScheduleError(String error);

  /// No description provided for @bookingSelectTimeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a time first'**
  String get bookingSelectTimeFirst;

  /// No description provided for @rescheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Booking'**
  String get rescheduleTitle;

  /// No description provided for @bookingNoAvailableSchedule.
  ///
  /// In en, this message translates to:
  /// **'No available schedule'**
  String get bookingNoAvailableSchedule;

  /// No description provided for @cannotOpenWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Cannot open WhatsApp'**
  String get cannotOpenWhatsApp;

  /// No description provided for @contactViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Contact via WhatsApp'**
  String get contactViaWhatsApp;

  /// No description provided for @bookingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get bookingConfirm;

  /// No description provided for @bookingError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String bookingError(String error);

  /// No description provided for @storagePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission denied'**
  String get storagePermissionDenied;

  /// No description provided for @fileSavedToDownload.
  ///
  /// In en, this message translates to:
  /// **'File saved to Download/{file}'**
  String fileSavedToDownload(String file);

  /// No description provided for @failedToDownloadFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to download file'**
  String get failedToDownloadFile;

  /// No description provided for @failedToLoadPage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load page'**
  String get failedToLoadPage;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @ngoerahsunHospital.
  ///
  /// In en, this message translates to:
  /// **'ngoerahsun Hospital'**
  String get ngoerahsunHospital;

  /// No description provided for @excellenceInHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Excellence in Healthcare'**
  String get excellenceInHealthcare;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'ngoerahsun Hospital is a leading healthcare institution in Indonesia, providing international standard medical services backed by advanced technology and experienced medical professionals.'**
  String get aboutDescription;

  /// No description provided for @aboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutLabel;

  /// No description provided for @ourVisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Vision'**
  String get ourVisionTitle;

  /// No description provided for @ourVisionDescription.
  ///
  /// In en, this message translates to:
  /// **'To become the leading hospital of choice providing comprehensive, safe, and high-quality healthcare services to all segments of society.'**
  String get ourVisionDescription;

  /// No description provided for @ourMissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMissionTitle;

  /// No description provided for @ourMissionDescription.
  ///
  /// In en, this message translates to:
  /// **'To deliver excellent medical services with a holistic approach, prioritizing patient safety and continuous innovation.'**
  String get ourMissionDescription;

  /// No description provided for @ourExcellenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Excellence'**
  String get ourExcellenceTitle;

  /// No description provided for @ourExcellenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Equipped with modern facilities, experienced specialists, 24/7 services, and international accreditation standards.'**
  String get ourExcellenceDescription;

  /// No description provided for @ourCommitmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Commitment'**
  String get ourCommitmentTitle;

  /// No description provided for @ourCommitmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Committed to patient satisfaction through friendly, professional, and empathetic service.'**
  String get ourCommitmentDescription;

  /// No description provided for @yourHealthOurPriority.
  ///
  /// In en, this message translates to:
  /// **'Your Health, Our Priority'**
  String get yourHealthOurPriority;

  /// No description provided for @trustedByThousands.
  ///
  /// In en, this message translates to:
  /// **'Trusted by thousands of patients across Indonesia'**
  String get trustedByThousands;

  /// No description provided for @article.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get article;

  /// No description provided for @publishedToday.
  ///
  /// In en, this message translates to:
  /// **'Published today'**
  String get publishedToday;

  /// No description provided for @noArticlesFound.
  ///
  /// In en, this message translates to:
  /// **'No articles found for \"{query}\".'**
  String noArticlesFound(String query);

  /// No description provided for @noArticlesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No articles available at the moment'**
  String get noArticlesAvailable;

  /// No description provided for @all_articles.
  ///
  /// In en, this message translates to:
  /// **'All Articles'**
  String get all_articles;

  /// No description provided for @mcu_questionnaire.
  ///
  /// In en, this message translates to:
  /// **'MCU Questionnaire'**
  String get mcu_questionnaire;

  /// No description provided for @my_favorite_doctors.
  ///
  /// In en, this message translates to:
  /// **'My Favorite Doctors'**
  String get my_favorite_doctors;

  /// No description provided for @no_favorite_doctors_yet.
  ///
  /// In en, this message translates to:
  /// **'No favorite doctors yet'**
  String get no_favorite_doctors_yet;

  /// No description provided for @browse_and_add_doctors_to_your_favorites.
  ///
  /// In en, this message translates to:
  /// **'Browse and add doctors to your favorites'**
  String get browse_and_add_doctors_to_your_favorites;

  /// No description provided for @doctor_added_to_favorites.
  ///
  /// In en, this message translates to:
  /// **'Doctor added to favorites'**
  String get doctor_added_to_favorites;

  /// No description provided for @doctor_removed_from_favorites.
  ///
  /// In en, this message translates to:
  /// **'Doctor removed from favorites'**
  String get doctor_removed_from_favorites;

  /// No description provided for @failed_to_update_favorite_status.
  ///
  /// In en, this message translates to:
  /// **'Failed to update favorite status'**
  String get failed_to_update_favorite_status;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'❌ Error: {provider_error}'**
  String error(String provider_error);

  /// No description provided for @no_notifications_yet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get no_notifications_yet;

  /// No description provided for @sign_in_successful_welcome.
  ///
  /// In en, this message translates to:
  /// **'Sign-in successful. Welcome!'**
  String get sign_in_successful_welcome;

  /// No description provided for @sign_in_failed_error.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed: {error}'**
  String sign_in_failed_error(String error);

  /// No description provided for @name_is_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get name_is_required;

  /// No description provided for @phone_number_is_required.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phone_number_is_required;

  /// No description provided for @invalid_email_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalid_email_format;

  /// No description provided for @registration_successful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registration_successful;

  /// No description provided for @registration_failed_please_try_again.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registration_failed_please_try_again;

  /// No description provided for @an_error_occurred_e.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {e}'**
  String an_error_occurred_e(String e);

  /// No description provided for @search_country_or_code.
  ///
  /// In en, this message translates to:
  /// **'Search country or code...'**
  String get search_country_or_code;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @create_your_account.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get create_your_account;

  /// No description provided for @please_fill_in_the_details_below_to_create_your_account.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the details below to create your account.'**
  String get please_fill_in_the_details_below_to_create_your_account;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address;

  /// No description provided for @nik_number.
  ///
  /// In en, this message translates to:
  /// **'NIK Number'**
  String get nik_number;

  /// No description provided for @passport_number.
  ///
  /// In en, this message translates to:
  /// **'Passport Number'**
  String get passport_number;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @by_signing_up_you_agree_to_our_terms_of_service_and_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to our Terms of Service and Privacy Policy.'**
  String get by_signing_up_you_agree_to_our_terms_of_service_and_privacy_policy;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get already_have_an_account;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @education_details_are_not_available_right_now.
  ///
  /// In en, this message translates to:
  /// **'Education details are not available right now.'**
  String get education_details_are_not_available_right_now;

  /// No description provided for @certifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get certifications;

  /// No description provided for @certification_details_are_not_available_right_now.
  ///
  /// In en, this message translates to:
  /// **'Certification details are not available right now.'**
  String get certification_details_are_not_available_right_now;

  /// No description provided for @general_schedule.
  ///
  /// In en, this message translates to:
  /// **'General Schedule'**
  String get general_schedule;

  /// No description provided for @schedule_details_are_not_available_right_now.
  ///
  /// In en, this message translates to:
  /// **'Schedule details are not available right now.'**
  String get schedule_details_are_not_available_right_now;

  /// No description provided for @professional_info.
  ///
  /// In en, this message translates to:
  /// **'Professional Info'**
  String get professional_info;

  /// No description provided for @specialist.
  ///
  /// In en, this message translates to:
  /// **'Specialist'**
  String get specialist;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @doctor_id.
  ///
  /// In en, this message translates to:
  /// **'Doctor ID'**
  String get doctor_id;

  /// No description provided for @internal_id.
  ///
  /// In en, this message translates to:
  /// **'Internal ID'**
  String get internal_id;

  /// No description provided for @department_id.
  ///
  /// In en, this message translates to:
  /// **'Department ID'**
  String get department_id;

  /// No description provided for @select_doctor.
  ///
  /// In en, this message translates to:
  /// **'Select Doctor'**
  String get select_doctor;

  /// No description provided for @hello_i_would_like_to_inquire_about_the_services.
  ///
  /// In en, this message translates to:
  /// **'Hello, I would like to inquire about the services.'**
  String get hello_i_would_like_to_inquire_about_the_services;

  /// No description provided for @contact_via_whatsapp.
  ///
  /// In en, this message translates to:
  /// **'Contact via WhatsApp'**
  String get contact_via_whatsapp;

  /// No description provided for @identity_not_found_nik_passport.
  ///
  /// In en, this message translates to:
  /// **'Identity not found (NIK / Passport)'**
  String get identity_not_found_nik_passport;

  /// No description provided for @no_doctors_available.
  ///
  /// In en, this message translates to:
  /// **'No doctors available'**
  String get no_doctors_available;

  /// No description provided for @sign_in_cancelled_or_failed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in cancelled or failed'**
  String get sign_in_cancelled_or_failed;

  /// No description provided for @account_not_found_please_sign_up_first.
  ///
  /// In en, this message translates to:
  /// **'Account not found. Please sign up first.'**
  String get account_not_found_please_sign_up_first;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome {name}!'**
  String welcome(String name);

  /// No description provided for @sign_in_failed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed: {error}'**
  String sign_in_failed(String error);

  /// No description provided for @sign_in_failed_1.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get sign_in_failed_1;

  /// No description provided for @otp_sent_to_phonenumber.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to {phoneNumber}'**
  String otp_sent_to_phonenumber(String phoneNumber);

  /// No description provided for @failed_to_send_otp_phone_not_registered.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP. Phone number not registered'**
  String get failed_to_send_otp_phone_not_registered;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @otp_verified_successfully.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully!'**
  String get otp_verified_successfully;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @invalid_otp_please_try_again.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalid_otp_please_try_again;

  /// No description provided for @verification_failed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verification_failed;

  /// No description provided for @enter_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enter_verification_code;

  /// No description provided for @we_sent_a_verification_code_to.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to'**
  String get we_sent_a_verification_code_to;

  /// No description provided for @didn_t_receive_the_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didn_t_receive_the_code;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @select_country.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get select_country;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome_back;

  /// No description provided for @please_enter_your_phone_number_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number to continue'**
  String get please_enter_your_phone_number_to_continue;

  /// No description provided for @enter_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enter_phone_number;

  /// No description provided for @continue_label.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_label;

  /// No description provided for @continue_as_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continue_as_guest;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @signing_in.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signing_in;

  /// No description provided for @continue_with_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continue_with_google;

  /// No description provided for @need_help_signing_in.
  ///
  /// In en, this message translates to:
  /// **'Need help signing in?'**
  String get need_help_signing_in;

  /// No description provided for @don_t_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get don_t_have_an_account;

  /// No description provided for @choose_your_wellness_package.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Wellness Package'**
  String get choose_your_wellness_package;

  /// No description provided for @loading_packages.
  ///
  /// In en, this message translates to:
  /// **'Loading packages...'**
  String get loading_packages;

  /// No description provided for @no_packages_found.
  ///
  /// In en, this message translates to:
  /// **'No packages found'**
  String get no_packages_found;

  /// No description provided for @choose_your_wellness_package_1.
  ///
  /// In en, this message translates to:
  /// **'Choose your wellness package'**
  String get choose_your_wellness_package_1;

  /// No description provided for @select_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get select_date;

  /// No description provided for @select_time.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get select_time;

  /// No description provided for @halo_saya_ingin_bertanya_tentang_jadwal_wellness.
  ///
  /// In en, this message translates to:
  /// **'Hello, I want to ask about the Wellness schedule.'**
  String get halo_saya_ingin_bertanya_tentang_jadwal_wellness;

  /// No description provided for @no_available_time_slots.
  ///
  /// In en, this message translates to:
  /// **'No available time slots'**
  String get no_available_time_slots;

  /// No description provided for @review_confirm.
  ///
  /// In en, this message translates to:
  /// **'Review & Confirm'**
  String get review_confirm;

  /// No description provided for @please_review_your_appointment_details.
  ///
  /// In en, this message translates to:
  /// **'Please review your appointment details'**
  String get please_review_your_appointment_details;

  /// No description provided for @please_sign_in_first.
  ///
  /// In en, this message translates to:
  /// **'Please sign in first'**
  String get please_sign_in_first;

  /// No description provided for @something_went_wrong_e.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {e}'**
  String something_went_wrong_e(String e);

  /// No description provided for @booking_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get booking_confirmed;

  /// No description provided for @booking_failed.
  ///
  /// In en, this message translates to:
  /// **'Booking Failed'**
  String get booking_failed;

  /// No description provided for @booking_successfully_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking successfully confirmed'**
  String get booking_successfully_confirmed;

  /// No description provided for @failed_to_confirm_booking.
  ///
  /// In en, this message translates to:
  /// **'Failed to confirm booking'**
  String get failed_to_confirm_booking;

  /// No description provided for @choose_your_preferred_doctor.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred doctor'**
  String get choose_your_preferred_doctor;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @no_packages_available.
  ///
  /// In en, this message translates to:
  /// **'No packages available'**
  String get no_packages_available;

  /// No description provided for @select_date_time.
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time'**
  String get select_date_time;

  /// No description provided for @choose_your_preferred_appointment_slot.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred appointment slot'**
  String get choose_your_preferred_appointment_slot;

  /// No description provided for @available_dates.
  ///
  /// In en, this message translates to:
  /// **'Available Dates'**
  String get available_dates;

  /// No description provided for @available_times.
  ///
  /// In en, this message translates to:
  /// **'Available Times'**
  String get available_times;

  /// No description provided for @halo_saya_ingin_bertanya_tentang_jadwal_mcu.
  ///
  /// In en, this message translates to:
  /// **'Hello, I want to ask about the MCU schedule.'**
  String get halo_saya_ingin_bertanya_tentang_jadwal_mcu;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @confirm_booking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirm_booking;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @booking_successfully_but_code_is_not_available.
  ///
  /// In en, this message translates to:
  /// **'Booking successful but code is not available'**
  String get booking_successfully_but_code_is_not_available;

  /// No description provided for @failed_to_book.
  ///
  /// In en, this message translates to:
  /// **'Failed to book'**
  String get failed_to_book;

  /// No description provided for @book_appointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get book_appointment;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @your_appointment_is_booked_for.
  ///
  /// In en, this message translates to:
  /// **'Your appointment is booked for:'**
  String get your_appointment_is_booked_for;

  /// No description provided for @thank_you_for_using_our_service.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using our service!'**
  String get thank_you_for_using_our_service;

  /// No description provided for @permission_denied_to_access_storage.
  ///
  /// In en, this message translates to:
  /// **'Permission denied to access storage'**
  String get permission_denied_to_access_storage;

  /// No description provided for @file_saved_to_download_pdf.
  ///
  /// In en, this message translates to:
  /// **'File saved to Download/{fileName}.pdf'**
  String file_saved_to_download_pdf(String fileName);

  /// No description provided for @failed_to_download_file.
  ///
  /// In en, this message translates to:
  /// **'Failed to download file'**
  String get failed_to_download_file;

  /// No description provided for @no_pdf_available_for_this_result.
  ///
  /// In en, this message translates to:
  /// **'No PDF available for this result'**
  String get no_pdf_available_for_this_result;

  /// No description provided for @error_1.
  ///
  /// In en, this message translates to:
  /// **'Error: {provider_errorMenu}'**
  String error_1(String provider_errorMenu);

  /// No description provided for @examination_results.
  ///
  /// In en, this message translates to:
  /// **'Examination Results'**
  String get examination_results;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @failed_to_pick_image.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failed_to_pick_image;

  /// No description provided for @my_card.
  ///
  /// In en, this message translates to:
  /// **'My Card'**
  String get my_card;

  /// No description provided for @card_information.
  ///
  /// In en, this message translates to:
  /// **'Card Information'**
  String get card_information;

  /// No description provided for @got_it.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get got_it;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @hide_info.
  ///
  /// In en, this message translates to:
  /// **'Hide Info'**
  String get hide_info;

  /// No description provided for @show_info.
  ///
  /// In en, this message translates to:
  /// **'Show Info'**
  String get show_info;

  /// No description provided for @medical_record_no.
  ///
  /// In en, this message translates to:
  /// **'Medical Record No.'**
  String get medical_record_no;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get date_of_birth;

  /// No description provided for @doctor_details.
  ///
  /// In en, this message translates to:
  /// **'Doctor Details'**
  String get doctor_details;

  /// No description provided for @doctor_detail_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Doctor detail is empty'**
  String get doctor_detail_is_empty;

  /// No description provided for @doctor_attributes_are_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Doctor attributes are unavailable'**
  String get doctor_attributes_are_unavailable;

  /// No description provided for @name_not_available.
  ///
  /// In en, this message translates to:
  /// **'Name not available'**
  String get name_not_available;

  /// No description provided for @specialization_not_available.
  ///
  /// In en, this message translates to:
  /// **'Specialization not available'**
  String get specialization_not_available;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @no_description_available_for_this_doctor.
  ///
  /// In en, this message translates to:
  /// **'No description available for this doctor.'**
  String get no_description_available_for_this_doctor;

  /// No description provided for @show_more.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get show_more;

  /// No description provided for @show_less.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get show_less;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @no_education_data_available.
  ///
  /// In en, this message translates to:
  /// **'No education data available'**
  String get no_education_data_available;

  /// No description provided for @no_certification_data_available.
  ///
  /// In en, this message translates to:
  /// **'No certification data available'**
  String get no_certification_data_available;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @terms_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_conditions;

  /// No description provided for @error_2.
  ///
  /// In en, this message translates to:
  /// **'Error: {provider_errorMessage}'**
  String error_2(String provider_errorMessage);

  /// No description provided for @no_facilities_found.
  ///
  /// In en, this message translates to:
  /// **'No facilities found'**
  String get no_facilities_found;

  /// No description provided for @sorry_we_cannot_open_whatsapp_on_this_device.
  ///
  /// In en, this message translates to:
  /// **'Sorry, WhatsApp cannot be opened on this device.'**
  String get sorry_we_cannot_open_whatsapp_on_this_device;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'INACTIVE'**
  String get inactive;

  /// No description provided for @validity_period.
  ///
  /// In en, this message translates to:
  /// **'Validity Period'**
  String get validity_period;

  /// No description provided for @use_promo_now.
  ///
  /// In en, this message translates to:
  /// **'USE PROMO NOW'**
  String get use_promo_now;

  /// No description provided for @promo_unavailable.
  ///
  /// In en, this message translates to:
  /// **'PROMO UNAVAILABLE'**
  String get promo_unavailable;

  /// No description provided for @promo_successfully_used.
  ///
  /// In en, this message translates to:
  /// **'🎉 Promo {widget_promo_title} successfully used!'**
  String promo_successfully_used(String widget_promo_title);

  /// No description provided for @sharing_promo.
  ///
  /// In en, this message translates to:
  /// **'📤 Sharing promo...'**
  String get sharing_promo;

  /// No description provided for @promo_saved_to_favorites.
  ///
  /// In en, this message translates to:
  /// **'💾 Promo saved to favorites!'**
  String get promo_saved_to_favorites;

  /// No description provided for @digitalCardInfo.
  ///
  /// In en, this message translates to:
  /// **'This digital card represents your patient identity. Scan the barcode for registration or identification at the hospital.'**
  String get digitalCardInfo;

  /// No description provided for @showingBasicProfile.
  ///
  /// In en, this message translates to:
  /// **'Showing basic profile. You can continue with this doctor or reload for full details.'**
  String get showingBasicProfile;

  /// No description provided for @orderConfirmationBody.
  ///
  /// In en, this message translates to:
  /// **'You selected {count} items.\nTotal: {total}\n\nProceed with the order?'**
  String orderConfirmationBody(int count, String total);

  /// No description provided for @laboratory_order.
  ///
  /// In en, this message translates to:
  /// **'Laboratory Order'**
  String get laboratory_order;

  /// No description provided for @search_laboratory.
  ///
  /// In en, this message translates to:
  /// **'Search laboratory...'**
  String get search_laboratory;

  /// No description provided for @error_3.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get error_3;

  /// No description provided for @no_laboratory_data.
  ///
  /// In en, this message translates to:
  /// **'No laboratory data'**
  String get no_laboratory_data;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected: '**
  String get selected;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total: '**
  String get total;

  /// No description provided for @order_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmation'**
  String get order_confirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @order_submitted_proceed_to_booking.
  ///
  /// In en, this message translates to:
  /// **'Order submitted! Proceed to booking.'**
  String get order_submitted_proceed_to_booking;

  /// No description provided for @place_order.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get place_order;

  /// No description provided for @order_radiology.
  ///
  /// In en, this message translates to:
  /// **'Radiology Order'**
  String get order_radiology;

  /// No description provided for @search_radiology.
  ///
  /// In en, this message translates to:
  /// **'Search radiology...'**
  String get search_radiology;

  /// No description provided for @no_radiology_items.
  ///
  /// In en, this message translates to:
  /// **'No radiology items'**
  String get no_radiology_items;

  /// No description provided for @no_matching_results.
  ///
  /// In en, this message translates to:
  /// **'No matching results'**
  String get no_matching_results;

  /// No description provided for @selected_1.
  ///
  /// In en, this message translates to:
  /// **'Selected: {count}'**
  String selected_1(int count);

  /// No description provided for @total_1.
  ///
  /// In en, this message translates to:
  /// **'Total: {total}'**
  String total_1(String total);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
