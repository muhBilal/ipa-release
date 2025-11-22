import 'package:Ngoerahsun/core/navigation/navigator.dart';
import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:Ngoerahsun/views/bottom_navigation_bar/bottom_navigation_bar_view.dart';
import 'package:Ngoerahsun/views/wellness/components/wellness_package_card.dart';
import 'package:Ngoerahsun/widgets/gradient_background/gradient_background.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:provider/provider.dart';
import 'package:Ngoerahsun/provider/admission/admission_provider.dart';
import 'package:Ngoerahsun/model/wellnessModel.dart';
import 'package:Ngoerahsun/provider/package/package_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Ngoerahsun/services/admission/admission_service.dart';
import 'package:Ngoerahsun/model/booking_result_model.dart';
import 'package:Ngoerahsun/services/preferences/user_preferences.dart';
import 'package:Ngoerahsun/model/user_model.dart';
import 'package:Ngoerahsun/views/webview/mcu_questionnaire_webview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: WellnessBookingFlow(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WellnessBookingFlow extends StatefulWidget {
  @override
  _WellnessBookingFlowState createState() => _WellnessBookingFlowState();
}

class _WellnessBookingFlowState extends State<WellnessBookingFlow>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;

  WellnessPackage? selectedPackage;
  int selectedPackageId = 0;
  String selectedTime = '';
  DateTime? selectedDate;
  List<DateTime?> selectedDates = [];
  int? selectedScheduleId;
  bool _bookingLoading = false;
  UserModel? _currentUser;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  late AdmissionProvider admissionProvider;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    admissionProvider = Provider.of<AdmissionProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WellnessPackageProvider>().fetchAllWellnessPackages();
    });
  }

  void nextStep() {
    if (currentStep == 0) {
      selectedDate ??= DateTime.now();
      _fetchSchedule();
    }
    if (currentStep < 2) {
      setState(() => currentStep++);
      _animationController
        ..reset()
        ..forward();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _onChangeDate() {
    setState(() {
      selectedTime = '';
      selectedScheduleId = null;
    });
    _fetchSchedule();
  }

  void _fetchSchedule() {
    if (selectedPackageId == 0 || selectedDate == null) return;
    admissionProvider.getScheduleTime(
      69,
      selectedPackageId,
      formatter.format(selectedDate!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProgressBar(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildCurrentStep(),
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          GlassMorphismButton(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
          ),
          SizedBox(width: 15),
          Text(
            _getStepTitle(),
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 10 : 0),
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: index <= currentStep
                    ? Colors.blue.withOpacity(0.8)
                    : Colors.grey.withOpacity(0.3),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        // return _buildDoctorSelection();
        return _buildWellnessPackageSelection();
      case 1:
        return _buildDateTimeSelection();
      case 2:
        return _buildReviewConfirmation();
      default:
        return Container();
    }
  }

  Widget _buildWellnessPackageSelection() {
    final provider = context.watch<WellnessPackageProvider>();
    final isLoading = provider.isLoadingPackages;
    final packages = provider.packages;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.choose_your_wellness_package,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isLoading
                ? AppLocalizations.of(context)!.loading_packages
                : (packages.isEmpty
                    ? AppLocalizations.of(context)!.no_packages_found
                    : AppLocalizations.of(context)!.choose_your_wellness_package_1),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : packages.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.no_packages_found,
                            style: TextStyle(color: Colors.black45),
                          ),
                        )
                      : ListView.builder(
                          itemCount: packages.length,
                          itemBuilder: (context, index) {
                            final pkg = packages[index];
                            final selected = selectedPackageId == pkg.id;

                            return WellnessPackageCard(
                              pkg: pkg,
                              isSelected: selected,
                              onTap: () {
                                setState(() {
                                  selectedPackage = pkg;
                                  selectedPackageId = pkg.id;
                                });
                              },
                            );
                          },
                        ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.select_date,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              selectedDayHighlightColor: AppColors.primary,
              weekdayLabelTextStyle: const TextStyle(color: Colors.black87),
              controlsTextStyle: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.w600),
              dayTextStyle: const TextStyle(color: Colors.black87),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030, 12, 31),
            ),
            value: selectedDates,
            onValueChanged: (date) {
              setState(() {
                selectedDates = date;
                selectedDate =
                    selectedDates.isNotEmpty ? selectedDates.first : null;
              });
              _onChangeDate();
            },
          ),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.select_time,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          _buildTimeSlots(),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Expanded(
      child: Consumer<AdmissionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingSchedule) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.schedules.isEmpty) {
            const String phoneE164 = '628889990922';
            final String message = AppLocalizations.of(context)!.halo_saya_ingin_bertanya_tentang_jadwal_wellness;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.no_available_time_slots,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final url =
                          'https://wa.me/$phoneE164?text=${Uri.encodeComponent(message)}';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.phone, color: Colors.white),
                    label: Text(
                      // "Contact via WhatsApp",
                      AppLocalizations.of(context)!.contactViaWhatsApp,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.schedules.length,
            itemBuilder: (context, index) {
              final schedule = provider.schedules[index];
              final isSel = selectedTime == schedule.scheduleName;
              return GlassMorphismCard(
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    selectedTime = schedule.scheduleName;
                    selectedScheduleId = schedule.id;
                  });
                },
                child: Center(
                  child: Text(
                    schedule.scheduleName,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildReviewConfirmation() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.review_confirm,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.please_review_your_appointment_details,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 30),
          GlassMorphismCard(
            child: Column(
              children: [
                _buildSummaryRow('Package', selectedPackage?.name ?? '-'),
                _buildSummaryRow(
                  'Date',
                  selectedDate != null
                      ? DateFormat('dd MMMM yyyy').format(selectedDate!)
                      : '-',
                ),
                _buildSummaryRow('Time', selectedTime),
                _buildSummaryRow('Duration', selectedPackage?.duration ?? '-'),
                _buildSummaryRow('Price', selectedPackage?.price ?? '-'),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final canProceed = _canProceed();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (currentStep > 0) ...[
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: previousStep,
                  borderRadius: BorderRadius.circular(14),
                  splashColor: Colors.blueGrey.withOpacity(0.2),
                  highlightColor: Colors.blueGrey.withOpacity(0.1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.blueGrey.withOpacity(0.5),
                        width: 1,
                      ),
                      color: Colors.white.withOpacity(0.4),
                    ),
                    child: const Center(
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: Color(0xFF37474F),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Opacity(
              opacity: canProceed ? 1 : 0.45,
              child: IgnorePointer(
                ignoring: !canProceed,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      if (canProceed)
                        BoxShadow(
                          color: const Color(0xFF4FC3F7).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: currentStep == 2 ? _confirmBooking : nextStep,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.primary,
                        ),
                        child: Center(
                          child: Text(
                            currentStep == 2 ? 'Confirm Booking' : 'Continue',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (currentStep) {
      case 0:
        return selectedPackageId != 0;
      case 1:
        return selectedDate != null &&
            selectedTime.isNotEmpty &&
            selectedScheduleId != null;
      case 2:
        return true;
      default:
        return false;
    }
  }

  // Future<void> _confirmBooking() async {
  //   if (selectedPackageId == 0 ||
  //       selectedDate == null ||
  //       selectedScheduleId == null ||
  //       selectedTime.isEmpty) return;

  //   _currentUser ??= await UserPreferences.getUser();
  //   if (_currentUser == null) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('User belum login')),
  //     );
  //     return;
  //   }

  //   setState(() => _bookingLoading = true);
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => const Center(child: CircularProgressIndicator()),
  //   );

  //   BookingResult result;
  //   try {
  //     result = await AdmissionService().createBooking(
  //       idJadwal: selectedScheduleId!,
  //       idDokter: selectedPackageId,
  //       idPoli: 69,
  //       idPaket: selectedPackageId,
  //       email: _currentUser!.email,
  //       tanggalJadwal: formatter.format(selectedDate!),
  //       muid: _currentUser!.muid,
  //     );
  //   } catch (e) {
  //     result = BookingResult.error('Terjadi kesalahan: $e');
  //   }

  //   if (!mounted) return;
  //   Navigator.of(context).pop();

  //   final success =
  //       (result.status.toLowerCase() == 'success') || (result.success == true);

  //   if (success && (result.bookingCode?.isNotEmpty ?? false)) {
  //     setState(() => _bookingLoading = false);
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) =>
  //             MCUQuestionnaireWebView(bookingCode: result.bookingCode!),
  //       ),
  //     );
  //     return;
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (_) => Dialog(
  //       backgroundColor: Colors.white,
  //       child: GlassMorphismCard(
  //         child: Padding(
  //           padding: const EdgeInsets.all(20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Icon(
  //                 success ? Icons.check_circle : Icons.error,
  //                 color: success ? const Color(0xFF4CAF50) : Colors.redAccent,
  //                 size: 64,
  //               ),
  //               const SizedBox(height: 16),
  //               Text(
  //                 success ? 'Booking Confirmed!' : 'Booking Failed',
  //                 style: const TextStyle(
  //                   color: Colors.black87,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 result.message?.isNotEmpty == true
  //                     ? result.message!
  //                     : (success
  //                         ? 'Booking berhasil tetapi kode tidak tersedia'
  //                         : 'Gagal melakukan booking'),
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(
  //                   color: Colors.black54,
  //                   fontSize: 14,
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () => Navigator.of(context).pop(),
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor:
  //                         success ? const Color(0xFF4CAF50) : Colors.redAccent,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     padding: const EdgeInsets.symmetric(vertical: 12),
  //                   ),
  //                   child: const Text(
  //                     'Done',
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   setState(() => _bookingLoading = false);
  // }

  Future<void> _confirmBooking() async {
    if (selectedPackageId == 0 ||
        selectedDate == null ||
        selectedScheduleId == null ||
        selectedTime.isEmpty) return;

    _currentUser ??= await UserPreferences.getUser();
    if (_currentUser == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.please_sign_in_first)),
      );
      return;
    }

    setState(() => _bookingLoading = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    BookingResult result;
    try {
      result = await AdmissionService().createBooking(
        idJadwal: selectedScheduleId!,
        idDokter: selectedPackageId,
        idPoli: 69,
        idPaket: selectedPackageId,
        email: _currentUser!.email,
        tanggalJadwal: formatter.format(selectedDate!),
        // muid: _currentUser!.muid,
      );
    } catch (e) {
      result = BookingResult.error(AppLocalizations.of(context)!.something_went_wrong_e(e.toString()));
    }

    if (!mounted) return;
    Navigator.of(context).pop();

    final success =
        (result.status.toLowerCase() == 'success') || (result.success == true);

    if (success && (result.bookingCode?.isNotEmpty ?? false)) {
      setState(() => _bookingLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              MCUQuestionnaireWebView(bookingCode: result.bookingCode!),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? const Color(0xFF4CAF50) : Colors.redAccent,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                success
                    ? AppLocalizations.of(context)!.booking_confirmed
                    : AppLocalizations.of(context)!.booking_failed,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result.message?.isNotEmpty == true
                    ? result.message!
                    : (success
                        ? AppLocalizations.of(context)!.booking_successfully_confirmed
                        : AppLocalizations.of(context)!.failed_to_confirm_booking),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigation.removeAllPreviousAndPush(
                    //   context,
                    //   const BottomNavigationBarView(initialIndex: 2),
                    // );
                    Navigation.removeAllPreviousAndPush(
                      context,
                      const BottomNavigationBarView(initialIndex: 2),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        success ? const Color(0xFF4CAF50) : Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    setState(() => _bookingLoading = false);
  }

  String _getStepTitle() {
    switch (currentStep) {
      case 0:
        return 'Choose Package';
      case 1:
        return 'Select Date & Time';
      case 2:
        return 'Review & Confirm';
      default:
        return '';
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}

class GlassMorphismCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final bool isSelected;
  final VoidCallback? onTap;

  const GlassMorphismCard({
    Key? key,
    required this.child,
    this.margin,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? Color(0xFF0288D1).withOpacity(0.4)
              : Colors.white.withOpacity(0.25),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(0xFF0288D1).withOpacity(0.08)
                  : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onTap,
                splashColor: Color(0xFF4FC3F7).withOpacity(0.15),
                highlightColor: Color(0xFF4FC3F7).withOpacity(0.08),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassMorphismButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const GlassMorphismButton({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: Center(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Doctor {
  final String name;
  final String specialty;
  final String rating;
  final String initials;

  Doctor(this.name, this.specialty, this.rating, this.initials);
}
