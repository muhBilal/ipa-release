import 'package:Ngoerahsun/core/navigation/navigator.dart';
import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:Ngoerahsun/model/booking_result_model.dart';
import 'package:Ngoerahsun/model/doctor_model.dart';
import 'package:Ngoerahsun/model/user_model.dart';
import 'package:Ngoerahsun/provider/admission/admission_provider.dart';
import 'package:Ngoerahsun/services/admission/admission_service.dart';
import 'package:Ngoerahsun/services/preferences/user_preferences.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:Ngoerahsun/views/bottom_navigation_bar/bottom_navigation_bar_view.dart';
import 'package:Ngoerahsun/views/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:Ngoerahsun/widgets/gradient_background/gradient_background.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Ngoerahsun/provider/doctor/doctor_detail_provider.dart';
import 'package:Ngoerahsun/model/doctor_detail_model.dart';

class DoctorBookingFlow extends StatefulWidget {
  final int poliId;
  final int? initialDoctorId;
  final String? initialDoctorName;
  final bool fromExamination;
  final List<int>? itemIds;
  final String? category;

  const DoctorBookingFlow(
    this.poliId, {
    Key? key,
    this.initialDoctorId,
    this.initialDoctorName,
    this.fromExamination = false,
    this.itemIds,
    this.category,
  }) : super(key: key);

  @override
  _DoctorBookingFlowState createState() => _DoctorBookingFlowState();
}

class _DoctorBookingFlowState extends State<DoctorBookingFlow>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;
  String selectedDoctor = '';
  int selectedDoctorId = 0;
  int selectedPoliId = 0;
  String selectedTime = '';
  DateTime? selectedDate;
  List<DateTime?> selectedDates = [];
  int? selectedScheduleId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  late AdmissionProvider admissionProvider;
  UserModel? _user;
  static const int _totalSteps = 3;
  static const int _examinationPoliId = 74;
  bool get _skipDoctorStep => widget.initialDoctorId != null;

  int get _effectivePoliId {
    if (widget.fromExamination) return _examinationPoliId;
    return (selectedPoliId == 0) ? widget.poliId : selectedPoliId;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    admissionProvider = Provider.of<AdmissionProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_skipDoctorStep) {
        selectedDoctorId = widget.initialDoctorId!;
        selectedDoctor = widget.initialDoctorName ?? '';
        selectedDate = DateTime.now();
        admissionProvider.getScheduleTime(
          _effectivePoliId,
          selectedDoctorId,
          formatter.format(selectedDate!),
        );
        setState(() => currentStep = 1);
      } else {
        admissionProvider.getDoctors(
          poliId: widget.fromExamination ? _examinationPoliId : widget.poliId,
          examinationDoctor: widget.fromExamination,
        );
        setState(() => currentStep = 0);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void nextStep() {
    if (currentStep == 0) {
      selectedTime = '';
      selectedScheduleId = null;
      selectedDate ??= DateTime.now();
      if (selectedDoctorId != 0 && _effectivePoliId != 0) {
        admissionProvider.getScheduleTime(
          _effectivePoliId,
          selectedDoctorId,
          formatter.format(selectedDate!),
        );
      }
    }
    if (currentStep < _totalSteps - 1) {
      setState(() => currentStep++);
      _animationController
        ..reset()
        ..forward();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _animationController
        ..reset()
        ..forward();
    }
  }

  void _onChangeDate() {
    setState(() {
      selectedTime = '';
      selectedScheduleId = null;
    });
    if (selectedDate != null &&
        selectedDoctorId != 0 &&
        _effectivePoliId != 0) {
      admissionProvider.getScheduleTime(
        _effectivePoliId,
        selectedDoctorId,
        formatter.format(selectedDate!),
      );
    }
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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GlassMorphismButton(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black87,
                size: 18,
              ),
            ),
          ),
          Text(
            _getStepTitle(l10n),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < _totalSteps - 1 ? 10 : 0),
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: index <= currentStep
                    ? AppColors.primaryLight1
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
        return _buildDoctorSelection();
      case 1:
        return _buildDateTimeSelection();
      case 2:
        return _buildReviewConfirmation();
    }
    return const SizedBox();
  }

  Widget _buildDoctorSelection() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.bookingChooseDoctorTitle,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(l10n.bookingChooseDoctorSubtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(height: 20),
          Consumer<AdmissionProvider>(
            builder: (context, provider, _) {
              if (provider.doctorLoading) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: provider.doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = provider.doctors[index];
                    return GlassMorphismCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      isSelected: selectedDoctorId == doctor.id,
                      onTap: () {
                        setState(() {
                          selectedDoctor = doctor.nama ?? "";
                          selectedDoctorId = doctor.id;
                        });
                        nextStep();
                      },
                      child: _buildDoctorCard(doctor),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModel doctor) {
    final String doctorName = doctor.nama ?? "";
    final String initials = _getInitials(doctorName);
    final String? thumbImage = doctor.gambar;
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.primary,
          ),
          child: (thumbImage != null && thumbImage.isNotEmpty)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    thumbImage,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            doctorName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _showDoctorDetailsModal(doctor),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight4.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.info_outline,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  void _showDoctorDetailsModal(DoctorModel doctor) {
    final String doctorName = doctor.nama ?? "Unknown Doctor";
    final String? department = doctor.poli;
    final String? specialist = doctor.spesialis;
    final String? thumbImage = doctor.gambar;
    final String initials = _getInitials(doctorName);

    try {
      final detailProv = context.read<DoctorDetailProvider>();
      detailProv.clear();
      detailProv.fetchDoctorDetail(doctor.id);
    } catch (_) {}
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final size = MediaQuery.of(ctx).size;
        return SafeArea(
          child: SizedBox(
            height: size.height * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // Avatar
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: AppColors.primary,
                    ),
                    child: (thumbImage != null && thumbImage.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.network(
                              thumbImage,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text(
                                  initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    doctorName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ebonyClayColor,
                    ),
                  ),
                ),
                if (specialist != null && specialist.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight4,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        specialist,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const Divider(height: 1),

                // Scrollable Content (driven by DoctorDetailProvider)
                Expanded(
                  child: Consumer<DoctorDetailProvider>(
                    builder: (context, prov, _) {
                      if (prov.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (prov.error != null) {
                        // Fallback UI when fetching detailed info fails
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildModalSection(
                                icon: Icons.info_outline,
                                iconColor: Colors.redAccent,
                                title: 'Unable to load details',
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prov.error!,
                                      style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .showingBasicProfile,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          prov.fetchDoctorDetail(doctor.id);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        icon: const Icon(Icons.refresh),
                                        label: Text(
                                            AppLocalizations.of(context)!
                                                .retry),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Basic professional info using available list data
                              _buildModalSection(
                                icon: Icons.medical_services_outlined,
                                iconColor: AppColors.teal,
                                title: 'Professional Info',
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if ((specialist ?? '').isNotEmpty)
                                      _buildInfoRow('Specialist', specialist!),
                                    if ((department ?? '').isNotEmpty)
                                      _buildInfoRow('Department', department!),
                                    _buildInfoRow(
                                        'Internal ID', doctor.id.toString()),
                                    if (doctor.poliId != null)
                                      _buildInfoRow('Department ID',
                                          doctor.poliId.toString()),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Placeholder sections
                              _buildModalSection(
                                icon: Icons.school_outlined,
                                iconColor: AppColors.blue,
                                title: 'Education',
                                content: Text(
                                  AppLocalizations.of(context)!
                                      .education_details_are_not_available_right_now,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                              ),

                              const SizedBox(height: 20),

                              _buildModalSection(
                                icon: Icons.verified_outlined,
                                iconColor: AppColors.orange,
                                title: AppLocalizations.of(context)!
                                    .certifications,
                                content: Text(
                                  AppLocalizations.of(context)!
                                      .certification_details_are_not_available_right_now,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                              ),

                              const SizedBox(height: 20),

                              _buildModalSection(
                                icon: Icons.schedule_outlined,
                                iconColor: AppColors.teal,
                                title: AppLocalizations.of(context)!
                                    .general_schedule,
                                content: Text(
                                  AppLocalizations.of(context)!
                                      .schedule_details_are_not_available_right_now,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final Doctor? detail = prov.doctor;
                      final attr = detail?.attributes;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildModalSection(
                              icon: Icons.medical_services_outlined,
                              iconColor: AppColors.teal,
                              title: AppLocalizations.of(context)!
                                  .professional_info,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if ((attr?.specialization ?? '').isNotEmpty)
                                    _buildInfoRow(
                                      AppLocalizations.of(context)!.specialist,
                                      attr!.specialization!,
                                    ),
                                  if ((department ?? '').isNotEmpty)
                                    _buildInfoRow(
                                      AppLocalizations.of(context)!.department,
                                      department!,
                                    ),
                                  if ((attr?.idDoctor ?? '').isNotEmpty)
                                    _buildInfoRow(
                                      AppLocalizations.of(context)!.doctor_id,
                                      attr!.idDoctor!,
                                    ),
                                  _buildInfoRow(
                                    AppLocalizations.of(context)!.internal_id,
                                    doctor.id.toString(),
                                  ),
                                  if (doctor.poliId != null)
                                    _buildInfoRow(
                                      AppLocalizations.of(context)!
                                          .department_id,
                                      doctor.poliId.toString(),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildModalSection(
                              icon: Icons.school_outlined,
                              iconColor: AppColors.blue,
                              title: 'Education',
                              content: (attr?.education != null &&
                                      attr!.education!.isNotEmpty)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: attr.education!
                                          .map((e) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6),
                                                child: Text(
                                                  '• ${e.title ?? '-'}${e.year != null ? ' (${e.year})' : ''}${(e.description != null && e.description!.isNotEmpty) ? ' — ${e.description}' : ''}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ))
                                          .toList(),
                                    )
                                  : Text(
                                      AppLocalizations.of(context)!
                                          .education_details_are_not_available_right_now,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black54)),
                            ),
                            const SizedBox(height: 20),
                            _buildModalSection(
                              icon: Icons.verified_outlined,
                              iconColor: AppColors.orange,
                              title:
                                  AppLocalizations.of(context)!.certifications,
                              content: (attr?.certification != null &&
                                      attr!.certification!.isNotEmpty)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: attr.certification!
                                          .map((c) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6),
                                                child: Text(
                                                    '• ${c.title ?? '-'}',
                                                    style: const TextStyle(
                                                        fontSize: 14)),
                                              ))
                                          .toList(),
                                    )
                                  : Text(
                                      AppLocalizations.of(context)!
                                          .certification_details_are_not_available_right_now,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black54)),
                            ),
                            const SizedBox(height: 20),
                            _buildModalSection(
                              icon: Icons.schedule_outlined,
                              iconColor: AppColors.teal,
                              title:
                                  AppLocalizations.of(context)!.general_schedule,
                              content: (attr?.schedule != null &&
                                      attr!.schedule!.isNotEmpty)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: attr.schedule!
                                          .map((s) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6),
                                                child: Text(
                                                    '• ${s.day ?? '-'}: ${s.from ?? '-'} - ${s.to ?? '-'}',
                                                    style: const TextStyle(
                                                        fontSize: 14)),
                                              ))
                                          .toList(),
                                    )
                                  : Text(
                                      AppLocalizations.of(context)!
                                          .schedule_details_are_not_available_right_now,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                          height: 1.5),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom action
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() {
                          selectedDoctorId = doctor.id;
                          selectedDoctor = doctorName;
                          selectedPoliId = doctor.poliId ?? 0;
                        });
                        nextStep();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.select_doctor,
                        style: TextStyle(
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

  Widget _buildModalSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ebonyClayColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.ebonyClayColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    String initials = '';
    for (int i = 0; i < parts.length && i < 2; i++) {
      if (parts[i].isNotEmpty) initials += parts[i][0].toUpperCase();
    }
    return initials.isEmpty ? 'DR' : initials;
  }

  Widget _buildDateTimeSelection() {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            l10n.bookingAvailableDates,
            style: const TextStyle(
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
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
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
            l10n.bookingAvailableTimes,
            style: const TextStyle(
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
    const phoneE164 = '628889990922';
    final message =
        AppLocalizations.of(context)!.hello_i_would_like_to_inquire_about_the_services;
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AdmissionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingSchedule) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.schedules.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.bookingNoTimeSlots,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final url =
                        'https://wa.me/$phoneE164?text=${Uri.encodeComponent(message)}';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: Text(
                    AppLocalizations.of(context)!.contactViaWhatsApp,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }

  Widget _buildReviewConfirmation() {
    final l10n = AppLocalizations.of(context)!;
    final String dateText = selectedDate != null
        ? DateFormat('dd MMMM yyyy', l10n.localeName).format(selectedDate!)
        : l10n.bookingNotSelected;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.bookingReviewConfirmTitle,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(l10n.bookingReviewConfirmSubtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(height: 30),
          GlassMorphismCard(
            child: Column(
              children: [
                _buildSummaryRow(l10n.bookingSummaryDoctor, selectedDoctor),
                _buildSummaryRow(l10n.bookingSummaryDate, dateText),
                _buildSummaryRow(l10n.bookingSummaryTime, selectedTime),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Text(label,
                  style: const TextStyle(color: Colors.black54, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final l10n = AppLocalizations.of(context)!;
    final bool isLast = currentStep == _totalSteps - 1;
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
                          color: Colors.blueGrey.withOpacity(0.5), width: 1),
                      color: Colors.white.withOpacity(0.4),
                    ),
                    child: Center(
                      child: Text(l10n.bookingBtnBack,
                          style: const TextStyle(
                              color: Color(0xFF37474F),
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Container(
              // decoration: BoxDecoration(
              //   gradient: const LinearGradient(
              //       colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)]),
              //   borderRadius: BorderRadius.circular(14),
              // ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _canProceed()
                      ? (isLast ? _confirmBooking : nextStep)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: Text(
                          isLast
                              ? l10n.bookingBtnConfirmBooking
                              : l10n.bookingBtnContinue,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
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
    if (currentStep == 0) {
      return selectedDoctorId != 0;
    }
    if (currentStep == 1) {
      return selectedDate != null &&
          selectedTime.isNotEmpty &&
          selectedScheduleId != null;
    }
    if (currentStep == 2) return true;
    return false;
  }

  Future<void> _confirmBooking() async {
    final l10n = AppLocalizations.of(context)!;
    _user = await UserPreferences.getUser();

    if (!mounted) return;

    if (_user == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            titlePadding: const EdgeInsets.only(top: 20),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            title: Column(
              children: [
                const Icon(Icons.lock_outline,
                    size: 48, color: Color(0xFF4E98D3)),
                const SizedBox(height: 12),
                Text(
                  l10n.loginRequiredTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF4E98D3),
                  ),
                ),
              ],
            ),
            content: Text(
              l10n.loginRequiredMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding:
                const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            actions: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4E98D3),
                  side: const BorderSide(color: Color(0xFF4E98D3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4E98D3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigation.pushReplacement(context, SignInView());
                },
                icon: const Icon(Icons.login),
                label: const Text("Login"),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    BookingResult? result;
    try {
      final String tanggalJadwal =
          (selectedDate ?? DateTime.now()).toIso8601String().split('T').first;
      final int poliForBooking = _effectivePoliId;

      result = await AdmissionService().createBooking(
        idJadwal: selectedScheduleId ?? 0,
        idDokter: selectedDoctorId,
        idPoli: poliForBooking,
        idPaket: null,
        email: _user?.email ?? "",
        tanggalJadwal: tanggalJadwal,
        // muid: _user?.muid ?? 0,
        itemIds: widget.itemIds,
        category: widget.category,
        examinationDoctor: widget.fromExamination,
      );
    } catch (e) {
      result = BookingResult.error(l10n.bookingNetworkError(e.toString()));
    } finally {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }

    if (!mounted) return;

    final bool isSuccess = result.success;
    final Color accent = isSuccess ? const Color(0xFF4CAF50) : Colors.redAccent;
    final String title = isSuccess
        ? l10n.bookingResultSuccessTitle
        : l10n.bookingResultFailureTitle;

    final String message = isSuccess
        ? (result.message != null && result.message!.isNotEmpty
            ? result.message!
            : (result.bookingCode != null
                ? l10n.bookingResultSuccessWithCode(result.bookingCode!)
                : l10n.bookingResultSuccessDefaultMessage))
        : (result.message?.isNotEmpty == true
            ? result.message!
            : l10n.bookingResultGenericError);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10nDialog = AppLocalizations.of(context)!;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error_rounded,
                  color: accent,
                  size: 70,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, fontSize: 15),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigation.removeAllPreviousAndPush(
                        context,
                        const BottomNavigationBarView(initialIndex: 2),
                      );
                    },
                    child: Text(
                      l10nDialog.bookingBtnDone,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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

  String _getStepTitle(AppLocalizations l10n) {
    switch (currentStep) {
      case 0:
        return l10n.bookingStepChooseDoctor;
      case 1:
        return l10n.bookingStepSelectDateTime;
      case 2:
        return l10n.bookingStepReviewConfirm;
    }
    return '';
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
              ? const Color(0xFF0288D1).withOpacity(0.4)
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
                  ? const Color(0xFF0288D1).withOpacity(0.08)
                  : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onTap,
                splashColor: const Color(0xFF4FC3F7).withOpacity(0.15),
                highlightColor: const Color(0xFF4FC3F7).withOpacity(0.08),
                child: Padding(padding: const EdgeInsets.all(16), child: child),
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

  const GlassMorphismButton({Key? key, required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12)),
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
