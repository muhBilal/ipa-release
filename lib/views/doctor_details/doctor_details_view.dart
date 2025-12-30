import 'dart:developer';

import 'package:ngoerahsun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:ngoerahsun/utils/app_images/app_images.dart';
import 'package:ngoerahsun/widgets/app_button/app_button.dart';
import 'package:ngoerahsun/provider/doctor/doctor_detail_provider.dart';
import 'package:ngoerahsun/views/doctor_booking/doctor_booking_screen.dart';
import 'package:ngoerahsun/provider/admission/admission_provider.dart';
import 'package:ngoerahsun/core/navigation/navigator.dart';

class DoctorDetailsView extends StatefulWidget {
  final int doctorId;
  final int? poliId;
  const DoctorDetailsView({super.key, required this.doctorId, this.poliId});

  @override
  State<DoctorDetailsView> createState() => _DoctorDetailsViewState();
}

class _DoctorDetailsViewState extends State<DoctorDetailsView> {
  String? _resolveImageUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http')) return raw;
    const base = 'https://cms-staging.ngoerahsunwac.co.id';
    return '$base${raw.startsWith('/') ? '' : '/'}$raw';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorDetailProvider>().fetchDoctorDetail(widget.doctorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.doctor_details,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.oxfordBlueColor,
            letterSpacing: 0.5,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<DoctorDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.error!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButtonView(
                    text: 'Retry',
                    onTap: () => provider.fetchDoctorDetail(widget.doctorId),
                  ),
                ],
              ),
            );
          }
          final doctor = provider.doctor;
          if (doctor == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.doctor_detail_is_empty,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  AppButtonView(
                    text: AppLocalizations.of(context)!.retry,
                    onTap: () => provider.fetchDoctorDetail(widget.doctorId),
                  ),
                ],
              ),
            );
          }
          final attr = doctor.attributes;
          if (attr == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.doctor_attributes_are_unavailable,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  AppButtonView(
                    text: 'Retry',
                    onTap: () => provider.fetchDoctorDetail(widget.doctorId),
                  ),
                ],
              ),
            );
          }
          final imageUrl = attr.image?.attributes?.url ?? attr.imageUrl;
          final fullImageUrl = _resolveImageUrl(imageUrl);
          return SingleChildScrollView(
            // padding: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Profile Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor Image
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: DoctorImage(
                            imageUrl: fullImageUrl,
                            width: 100,
                            height: 120,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attr.name?.isNotEmpty == true
                                  ? attr.name!
                                  : AppLocalizations.of(context)!.name_not_available,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                                color: AppColors.oxfordBlueColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Specialization Badge
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: double.infinity,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                (attr.specialization ?? '').isNotEmpty
                                    ? attr.specialization!
                                    : AppLocalizations.of(context)!.specialization_not_available,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Rating
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.amber.shade100,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber.shade600,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    attr.order != null
                                        ? attr.order.toString()
                                        : '5.0',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.oxfordBlueColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // About Section
                _buildSectionHeader(
                  title: AppLocalizations.of(context)!.about,
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ReadMoreText(
                    (attr.prefixTitle != null && attr.prefixTitle!.isNotEmpty) ||
                            (attr.suffixTitle != null && attr.suffixTitle!.isNotEmpty)
                        ? '${attr.prefixTitle ?? ''} ${attr.suffixTitle ?? ''}'
                            .trim()
                        : AppLocalizations.of(context)!.no_description_available_for_this_doctor,
                    trimMode: TrimMode.Line,
                    trimLines: 3,
                    colorClickableText: AppColors.primary,
                    trimCollapsedText: AppLocalizations.of(context)!.show_more,
                    trimExpandedText: AppLocalizations.of(context)!.show_less,
                    moreStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    lessStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Education Section
                _buildSectionHeader(
                  title: AppLocalizations.of(context)!.education,
                  icon: Icons.school_rounded,
                ),
                const SizedBox(height: 12),
                if (attr.education != null && attr.education!.isNotEmpty) 
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: attr.education!
                          .asMap()
                          .entries
                          .map((entry) => _buildEducationItem(entry.value, entry.key))
                          .toList(),
                    ),
                  )
                else
                  _buildEmptyState(AppLocalizations.of(context)!.no_education_data_available),
                const SizedBox(height: 24),

                // Certifications Section
                _buildSectionHeader(
                  title: AppLocalizations.of(context)!.certifications,
                  icon: Icons.verified_rounded,
                ),

                const SizedBox(height: 12),
                
                if (attr.certification != null && attr.certification!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: attr.certification!
                          .map((c) => _buildCertificationChip(c))
                          .toList(),
                    ),
                  )
                else
                  _buildEmptyState(
                    AppLocalizations.of(context)!.no_certification_data_available,
                  ),
                const SizedBox(height: 24),

                // Book Appointment Button
                Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        final admission = context.read<AdmissionProvider>();
                        int? poliId;
                        for (final d in admission.doctors) {
                          if (d.id == doctor.id) {
                            poliId = d.poliId;
                            break;
                          }
                        }
                        log("debug doctor id ${widget.doctorId} with poli id ${widget.poliId} with name ${attr.name}");
                        // return;
                        Navigation.push(
                          context,
                          DoctorBookingFlow(
                            widget.poliId ?? 0,
                            initialDoctorId: widget.doctorId ?? 0,
                            initialDoctorName: attr.name ?? '-',
                          ),
                        );
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.book_appointment,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.oxfordBlueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEducationItem(education, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  education.title ?? AppLocalizations.of(context)!.unknown,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ebonyClayColor,
                  ),
                ),
                if (education.year != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      education.year!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationChip(certification) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.shade100,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            color: Colors.green.shade600,
            size: 14,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              certification.title ?? AppLocalizations.of(context)!.unknown,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.green.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

class DoctorImage extends StatefulWidget {
  final String? imageUrl;
  final double width;
  final double height;
  const DoctorImage(
      {super.key, this.imageUrl, required this.width, required this.height});

  @override
  State<DoctorImage> createState() => _DoctorImageState();
}

class _DoctorImageState extends State<DoctorImage> {
  late String? _finalUrl;

  @override
  void initState() {
    super.initState();
    _finalUrl = _selectUrl(widget.imageUrl);
  }

  String? _selectUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http')) return raw;
    const base = 'https://cms-staging.ngoerahsunwac.co.id';
    return '$base${raw.startsWith('/') ? '' : '/'}$raw';
  }

  @override
  Widget build(BuildContext context) {
    final url = _finalUrl;
    if (url == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          LocalImages.icIntroImgFirst,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        url,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
        loadingBuilder: (c, child, progress) {
          if (progress == null) return child;
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => Image.asset(
          LocalImages.icIntroImgFirst,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}