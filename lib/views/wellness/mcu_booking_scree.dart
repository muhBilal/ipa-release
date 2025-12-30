import 'package:ngoerahsun/l10n/app_localizations.dart';
import 'package:ngoerahsun/provider/admission/admission_provider.dart';
import 'package:ngoerahsun/provider/package/package_provider.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:ngoerahsun/views/bottom_navigation_bar/bottom_navigation_bar_view.dart';
import 'package:ngoerahsun/views/dashboard/dashboard_view.dart';
import 'package:ngoerahsun/widgets/gradient_background/gradient_background.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ngoerahsun/model/mcu_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ngoerahsun/services/admission/admission_service.dart';
import 'package:ngoerahsun/services/preferences/user_preferences.dart';
import 'package:ngoerahsun/model/user_model.dart';
import 'package:ngoerahsun/model/booking_result_model.dart';
import 'package:ngoerahsun/views/webview/mcu_questionnaire_webview.dart';

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
      home: MCUBookingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MCUBookingScreen extends StatefulWidget {
  @override
  _MCUBookingScreenState createState() => _MCUBookingScreenState();
}

class _MCUBookingScreenState extends State<MCUBookingScreen>
    with SingleTickerProviderStateMixin {
  MCUPackage? selectedPackage;
  int currentStep = 0;
  String selectedDoctor = '';
  String selectedDate = '';
  DateTime? selectedDateObj;
  String selectedTime = '';
  int? selectedScheduleId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  static const int _mcuTypeId = 45;
  bool _bookingLoading = false;
  UserModel? _currentUser;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WellnessPackageProvider>().fetchAllMCUPackages();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _fetchScheduleTime() {
    if (selectedPackage == null || selectedDateObj == null) return;
    context.read<AdmissionProvider>().getScheduleTime(
          _mcuTypeId,
          selectedPackage!.id,
          formatter.format(selectedDateObj!),
        );
  }

  void nextStep() {
    if (currentStep == 0) {
      selectedDateObj ??= DateTime.now();
      if (selectedDate.isEmpty) {
        final now = DateTime.now();
        selectedDate = '${now.day}/${now.month}';
      }
      _fetchScheduleTime();
    }
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
      _animationController.reset();
      _animationController.forward();
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

  void _onChangeDate(DateTime newDate) {
    setState(() {
      selectedDateObj = newDate;
      selectedDate = '${newDate.day}/${newDate.month}';
      selectedTime = '';
      selectedScheduleId = null;
    });
    _fetchScheduleTime();
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
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GlassMorphismButton(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios,
                color: Colors.black87, size: 18),
          ),
          const SizedBox(width: 15),
          Text(
            _getStepTitle(),
            style: const TextStyle(
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
        return _buildServiceSelection();
      case 1:
        return _buildDateTimeSelection();
      case 2:
        return _buildReviewConfirmation();
      default:
        return Container();
    }
  }

  Widget _buildDoctorSelection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.select_doctor,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.choose_your_preferred_doctor,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 20),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: doctors.length,
          //     itemBuilder: (context, index) {
          //       return GlassMorphismCard(
          //         margin: EdgeInsets.only(bottom: 12),
          //         isSelected: selectedDoctor == doctors[index].name,
          //         onTap: () {
          //           setState(() {
          //             selectedDoctor = doctors[index].name;
          //           });
          //         },
          //         child: _buildDoctorCard(doctors[index]),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  void _showServiceDetailsModal(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "service.name",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormatter.format(10000),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Divider(height: 32),
              Text(
                "service.description",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // setState(() {
                  //   selectedService = service;
                  // });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  backgroundColor: Colors.white,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    // gradient: const LinearGradient(
                    //   colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
                    // ),
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4FC3F7).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    child:  Text(
                      AppLocalizations.of(context)!.select,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceSelection() {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Consumer<WellnessPackageProvider>(
      builder: (context, prov, _) {
        if (prov.isLoadingPackages) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = prov.packagesMcu;
        if (data.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.no_packages_available,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final MCUModel category = data[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((category.categoryName ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        category.categoryName ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ...category.packages.map((pkg) {
                    final isSelected = selectedPackage?.id == pkg.id;
                    final priceVal = int.tryParse(
                          (pkg.price ?? '').replaceAll(RegExp(r'[^0-9]'), ''),
                        ) ??
                        0;
                    return GlassMorphismCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          selectedPackage = pkg;
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        title: Text(
                          pkg.packageName ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          priceVal > 0
                              ? currencyFormatter.format(priceVal)
                              : (pkg.price ?? '-'),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => _showMCUPackageDetails(pkg),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(Icons.info_outline),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // void _showMCUPackageDetails(MCUPackage pkg) {
  //   final currencyFormatter = NumberFormat.currency(
  //     locale: 'id_ID',
  //     symbol: 'Rp ',
  //     decimalDigits: 0,
  //   );
  //   final priceVal =
  //       int.tryParse((pkg.price ?? '').replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(24),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               pkg.packageName ?? '-',
  //               style:
  //                   const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 8),
  //             Text(
  //               priceVal > 0
  //                   ? currencyFormatter.format(priceVal)
  //                   : (pkg.price ?? '-'),
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w600,
  //                 color: Theme.of(context).primaryColor,
  //               ),
  //             ),
  //             const Divider(height: 32),
  //             Text(
  //               _truncate(pkg.packageDesc, 200),
  //               style: const TextStyle(
  //                 fontSize: 15,
  //                 color: Colors.black54,
  //                 height: 1.5,
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             ElevatedButton(
  //               onPressed: () {
  //                 setState(() {
  //                   selectedPackage = pkg;
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 padding: EdgeInsets.zero,
  //                 backgroundColor: Colors.white,
  //                 elevation: 0,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(14),
  //                 ),
  //               ),
  //               child: Ink(
  //                 decoration: BoxDecoration(
  //                   gradient: const LinearGradient(
  //                     colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
  //                   ),
  //                   borderRadius: BorderRadius.circular(14),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: const Color(0xFF4FC3F7).withOpacity(0.3),
  //                       blurRadius: 20,
  //                       offset: const Offset(0, 8),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Container(
  //                   height: 48,
  //                   alignment: Alignment.center,
  //                   child: const Text(
  //                     "Continue",
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showMCUPackageDetails(MCUPackage pkg) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final priceVal =
        int.tryParse((pkg.price ?? '').replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5, // fix 50% layar
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pkg.packageName ?? '-',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  priceVal > 0
                      ? currencyFormatter.format(priceVal)
                      : (pkg.price ?? '-'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Divider(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      pkg.packageDesc ?? '-', // scroll hanya untuk deskripsi
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedPackage = pkg;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      // gradient: const LinearGradient(
                      //   colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
                      // ),
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4FC3F7).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            // gradient: LinearGradient(
            //   colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
            // ),
            color: AppColors.primary,
          ),
          child: Center(
            child: Text(
              doctor.initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                doctor.specialty,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(
                    doctor.rating,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '(127 reviews)',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSelection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.select_date_time,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.choose_your_preferred_appointment_slot,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.available_dates,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          _buildDateSelector(),
          SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.available_times,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          _buildTimeSlots(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    const Color selectedColor = Color(0xFF4FC3F7);
    const Color unselectedTextColor = Color(0xFF37474F);

    return Container(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        itemBuilder: (context, index) {
          DateTime date = DateTime.now().add(Duration(days: index));
          String dateStr = '${date.day}/${date.month}';
          String dayName = (index == 0) ? 'Today' : _getDayName(date.weekday);
          bool isSelected = selectedDateObj != null &&
              date.year == selectedDateObj!.year &&
              date.month == selectedDateObj!.month &&
              date.day == selectedDateObj!.day;

          return GestureDetector(
            onTap: () {
              _onChangeDate(date);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 70,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color:
                    isSelected ? selectedColor : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: selectedColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ]
                    : [],
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white.withOpacity(0.9)
                          : unselectedTextColor.withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : unselectedTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Expanded(
      child: Consumer<AdmissionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingSchedule) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.schedules.isEmpty) {
            const String phoneE164 = '628889990922';
            // final String message =
            //     'Halo, saya ingin bertanya tentang jadwal MCU.';
            final String message = AppLocalizations.of(context)!.halo_saya_ingin_bertanya_tentang_jadwal_mcu;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.no_available_time_slots,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
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
                    label:  Text(
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.schedules.length,
            itemBuilder: (context, index) {
              final schedule = provider.schedules[index];
              return GlassMorphismCard(
                isSelected: selectedTime == schedule.scheduleName,
                onTap: () {
                  setState(() {
                    selectedTime = schedule.scheduleName;
                    selectedScheduleId = schedule.id;
                  });
                },
                child: Center(
                  child: Text(
                    schedule.scheduleName,
                    style: TextStyle(
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

  String _truncate(String? text, int max) {
    if (text == null) return '-';
    return text.length <= max ? text : '${text.substring(0, max)}...';
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
                _buildSummaryRow(
                    'Package', selectedPackage?.packageName ?? '-'),
                _buildSummaryRow(
                    'Desc', _truncate(selectedPackage?.packageDesc, 40)),
                _buildSummaryRow('Doctor', selectedDoctor),
                _buildSummaryRow(
                  'Date',
                  selectedDateObj != null
                      ? DateFormat('dd MMMM yyyy').format(selectedDateObj!)
                      : '-',
                ),
                _buildSummaryRow('Time', selectedTime),
                _buildSummaryRow('Fee', selectedPackage?.price ?? '-'),
              ],
            ),
          ),
          SizedBox(height: 20),
          // GlassMorphismCard(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'Notes',
          //         style: TextStyle(
          //           color: Colors.black87,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //       SizedBox(height: 10),
          //       Container(
          //         width: double.infinity,
          //         height: 80,
          //         decoration: BoxDecoration(
          //           color: Colors.white.withOpacity(0.7),
          //           borderRadius: BorderRadius.circular(12),
          //           border: Border.all(
          //             color: Colors.grey.withOpacity(0.3),
          //           ),
          //         ),
          //         child: TextField(
          //           maxLines: 3,
          //           style: TextStyle(color: Colors.black87),
          //           decoration: InputDecoration(
          //             hintText: 'Add any additional notes...',
          //             hintStyle: TextStyle(
          //               color: Colors.black38,
          //             ),
          //             border: InputBorder.none,
          //             contentPadding: EdgeInsets.all(12),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
    final bool canProceed = _canProceed();
    return Padding(
      padding: EdgeInsets.all(20),
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
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.blueGrey.withOpacity(0.5),
                        width: 1,
                      ),
                      color: Colors.white.withOpacity(0.4),
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.back,
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
            SizedBox(width: 12),
          ],
          Expanded(
            flex: currentStep > 0 ? 1 : 1,
            child: Opacity(
              opacity: canProceed ? 1.0 : 0.45,
              child: IgnorePointer(
                ignoring: !canProceed,
                child: Container(
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
                    // ),
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      if (canProceed)
                        BoxShadow(
                          color: Color(0xFF4FC3F7).withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: currentStep == 2 ? _confirmBooking : nextStep,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.primary.withOpacity(0.0),
                        ),
                        child: Center(
                          child: Text(
                            currentStep == 2 ? AppLocalizations.of(context)!.confirm_booking : AppLocalizations.of(context)!.next,
                            style: TextStyle(
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
        return selectedPackage != null;
      case 1:
        return selectedDateObj != null &&
            selectedTime.isNotEmpty &&
            selectedScheduleId != null;
      case 2:
        return true;
      default:
        return false;
    }
  }

  // Future<void> _confirmBooking() async {
  //   if (selectedPackage == null ||
  //       selectedDateObj == null ||
  //       selectedScheduleId == null) return;

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
  //       idDokter: selectedPackage!.id,
  //       idPoli: 45,
  //       idPaket: selectedPackage!.id,
  //       email: _currentUser!.email,
  //       tanggalJadwal: formatter.format(selectedDateObj!),
  //       muid: _currentUser!.muid,
  //     );
  //   } catch (e) {
  //     result = BookingResult.error('Terjadi kesalahan: $e');
  //   }

  //   if (!mounted) return;
  //   Navigator.of(context).pop();

  //   final bool success =
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
    if (selectedPackage == null ||
        selectedDateObj == null ||
        selectedScheduleId == null) return;

    _currentUser ??= await UserPreferences.getUser();
    if (_currentUser == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User belum login')),
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
        idDokter: selectedPackage!.id,
        idPoli: 45,
        idPaket: selectedPackage!.id,
        email: _currentUser!.email,
        tanggalJadwal: formatter.format(selectedDateObj!),
        // muid: _currentUser!.muid,
      );
    } catch (e) {
      result = BookingResult.error('Terjadi kesalahan: $e');
    }

    if (!mounted) return;
    Navigator.of(context).pop();

    final bool success =
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
        backgroundColor: Colors.white,
        child: GlassMorphismCard(
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
                  success ? AppLocalizations.of(context)!.booking_confirmed : AppLocalizations.of(context)!.booking_failed,
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
                          ? AppLocalizations.of(context)!.booking_successfully_but_code_is_not_available
                          : AppLocalizations.of(context)!.failed_to_book),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigation.removeAllPreviousAndPush(
                      //   context,
                      //   const BottomNavigationBarView(initialIndex: 2),
                      // );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BottomNavigationBarView(
                            initialIndex: 2,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          success ? const Color(0xFF4CAF50) : Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    setState(() => _bookingLoading = false);
  }

  String _getStepTitle() {
    switch (currentStep) {
      case 0:
        return 'Choose MCU Package';
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
