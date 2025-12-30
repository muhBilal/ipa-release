import 'dart:developer';

import 'package:ngoerahsun/model/booking/booking_detail_model.dart';
import 'package:ngoerahsun/provider/admission/admission_provider.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ngoerahsun/l10n/app_localizations.dart';

class BookingDetailScreen extends StatefulWidget {
  final int? bookingCode;
  const BookingDetailScreen({Key? key, this.bookingCode}) : super(key: key);

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
    Future.microtask(() {
      if (widget.bookingCode != null) {
        context.read<AdmissionProvider>().getBookingDetail(widget.bookingCode!);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _canModifyBooking(String tanggal, bool isDeleted) {
    if (isDeleted) return false;
    try {
      DateTime bookingDate;
      if (tanggal.contains("-")) {
        bookingDate = DateTime.parse(tanggal);
      } else {
        bookingDate =
            DateFormat("dd MMMM yyyy", "id_ID").parse(tanggal, true).toLocal();
      }
      final today = DateTime.now();
      final onlyDateNow = DateTime(today.year, today.month, today.day);
      final onlyDateBooking =
          DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
      return onlyDateNow.isBefore(onlyDateBooking) ||
          onlyDateNow.isAtSameMomentAs(onlyDateBooking);
    } catch (_) {
      return false;
    }
  }

  bool _canShowQRAndCode(BookingDetailModel booking) {
    try {
      log("debug can booking is delete : ${booking.isDeleted} and booking date : ${booking.tanggal}");
      if (booking.isDeleted) {
        return false;
      }
      ;
      DateTime bookingDate;
      if (booking.tanggal.contains("-")) {
        bookingDate = DateTime.parse(booking.tanggal);
      } else {
        bookingDate = DateFormat("dd MMMM yyyy", "id_ID")
            .parse(booking.tanggal, true)
            .toLocal();
      }
      final today = DateTime.now();
      final onlyDateNow = DateTime(today.year, today.month, today.day);
      final onlyDateBooking =
          DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
      bool status = onlyDateBooking.isAtSameMomentAs(onlyDateNow) ||
          onlyDateBooking.isAfter(onlyDateNow);
      return status;
    } catch (_) {
      log("debug false");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final admissionProvider = context.watch<AdmissionProvider>();
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (admissionProvider.isLoadingBookingDetail) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final booking = admissionProvider.bookingDetail;
                      if (booking == null) {
                        return Center(
                          child: Text(l10n.bookingNotFound),
                        );
                      }
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            _buildMainCard(booking),
                            if (_canModifyBooking(
                                    booking.tanggal, booking.isDeleted) &&
                                _canShowQRAndCode(booking))
                              _buildActionButtons(booking),
                            const SizedBox(height: 32),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              AppLocalizations.of(context)!.bookingDetails,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(BookingDetailModel booking) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCardHeader(),
          _canShowQRAndCode(booking)
              ? _buildQRSection(booking.kodeBooking)
              : const SizedBox(height: 32),
          _buildDetailsGrid(booking),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF00D4AA),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'ngoerahsun',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQRSection(String bookingCode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
      child: Column(
        children: [
          Container(
            width: 240,
            height: 240,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFFE5E5E5),
                width: 1,
              ),
            ),
            child: QrImageView(
              data: bookingCode,
              version: QrVersions.auto,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              bookingCode,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(BookingDetailModel booking) {
  final details = [
    {
      'label': 'Patient',
      'value': booking.nama,
      'icon': Icons.person_outline_rounded,
    },
    {
      'label': 'Service',
      'value': booking.namaPoli,
      'icon': Icons.medical_services_outlined,
    },
    {
      'label': booking.kodePoli == 'MCU' ? 'Package' : 'Doctor',
      'value': booking.kodePoli == 'MCU' ? '' : booking.namaDokter,
      'icon': booking.kodePoli == 'MCU'
          ? Icons.inventory_2_outlined
          : Icons.local_hospital_outlined,
    },
    {
      'label': 'Date',
      'value': booking.tanggal,
      'icon': Icons.calendar_today_outlined,
    },
  ];

  final filteredDetails = details.where((d) {
    final value = d['value'];
    return value != null && value.toString().trim().isNotEmpty;
  }).toList();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: Column(
      children: filteredDetails
          .map((detail) => _buildDetailRow(
                detail['label'] as String,
                detail['value'] as String,
                detail['icon'] as IconData,
              ))
          .toList(),
    ),
  );
}


  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BookingDetailModel booking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (widget.bookingCode == null) return;
                context
                    .read<AdmissionProvider>()
                    .cancelBooking(widget.bookingCode!);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                AppLocalizations.of(context)!.bookingBtnCancel,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _openRescheduleSheet(booking);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                AppLocalizations.of(context)!.bookingBtnReschedule,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openRescheduleSheet(BookingDetailModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
              child: Text(AppLocalizations.of(context)!.bookingRescheduleFlow(booking.kodeBooking)),
          ));
      },
    );
  }
}
