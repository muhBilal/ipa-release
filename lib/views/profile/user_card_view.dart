import 'dart:convert';
import 'dart:developer';
import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:Ngoerahsun/model/user_model.dart';
import 'package:Ngoerahsun/services/preferences/user_preferences.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PatientCardFinal extends StatefulWidget {
  const PatientCardFinal({super.key});

  @override
  State<PatientCardFinal> createState() => _PatientCardFinalState();
}

class _PatientCardFinalState extends State<PatientCardFinal> {
  bool showCardInfo = false;
  bool showFullCode = false;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserPreferences.getUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildCardSection(),
              const SizedBox(height: 25),
              _buildCardInfoSection(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // ========== HEADER ==========
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.my_card,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
              letterSpacing: 0.2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.arrow_back_rounded,
                      size: 22, color: Colors.black87),
                ),
              ),
              GestureDetector(
                onTap: () => _showInfoBottomSheet(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.info_outline_rounded,
                      size: 22, color: Colors.black87),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: Colors.grey[800], size: 26),
                const SizedBox(width: 10),
                Text(
                  AppLocalizations.of(context)!.card_information,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.digitalCardInfo,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context)!.got_it,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AspectRatio(
        aspectRatio: 1.586,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppColors.primary,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/images/supergraphic.png",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo_white.png",
                      width: 150,
                    ),
                  ],
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final formattedDate = _user!.tanggalLahir != null
                      ? DateFormat('yyyy-MM-dd').format(_user!.tanggalLahir!)
                      : "-";

                  return Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          BarcodeWidget(
                            barcode: Barcode.code128(),
                            data:
                                _user!.noRm.isNotEmpty ? _user!.noRm : "000000",
                            width: constraints.maxWidth * 0.3,
                            height: constraints.maxHeight * 0.10,
                            drawText: false,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: constraints.maxWidth * 0.40,
                            child: Text(
                              _user!.nama.isNotEmpty ? _user!.nama : "Unknown",
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: constraints.maxWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "MR. No.${_user!.noRm} / $formattedDate",
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.03,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== INFO SECTION ==========
  Widget _buildCardInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => setState(() => showCardInfo = !showCardInfo),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.personal_information,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          showCardInfo
                              ? AppLocalizations.of(context)!.hide_info
                              : AppLocalizations.of(context)!.show_info,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          showCardInfo
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (showCardInfo) ...[
              Divider(height: 1, color: Colors.grey[200]),
              _buildInfoItem(
                icon: Icons.credit_card_rounded,
                label: AppLocalizations.of(context)!.medical_record_no,
                value: showFullCode ? _user!.noRm : _maskNoRm(_user!.noRm),
                trailing: IconButton(
                  icon: Icon(
                    showFullCode
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  onPressed: () => setState(() => showFullCode = !showFullCode),
                ),
              ),
              Divider(height: 1, color: Colors.grey[200], indent: 68),
              _buildInfoItem(
                icon: Icons.email_rounded,
                label: AppLocalizations.of(context)!.email,
                value: _user!.email.isNotEmpty ? _user!.email : '-',
              ),
              Divider(height: 1, color: Colors.grey[200], indent: 68),
              _buildInfoItem(
                icon: Icons.badge_rounded,
                label: 'NIK',
                value: _user!.nik.isNotEmpty ? _user!.nik : '-',
              ),
              Divider(height: 1, color: Colors.grey[200], indent: 68),
              _buildInfoItem(
                icon: Icons.calendar_today_rounded,
                label: AppLocalizations.of(context)!.date_of_birth,
                value: _user!.tanggalLahir != null
                    ? DateFormat('dd/MM/yyyy').format(_user!.tanggalLahir!)
                    : '-',
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper untuk masking NoRM
  String _maskNoRm(String norm) {
    if (norm.isEmpty) return '-';
    if (norm.length <= 4) return '••$norm';
    if (norm.length <= 2) return '••••$norm';

    final lastDigits = norm.substring(norm.length - 2);
    return '••••$lastDigits';
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[900],
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
