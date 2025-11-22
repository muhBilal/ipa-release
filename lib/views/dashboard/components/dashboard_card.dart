import 'dart:ui';
import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:Ngoerahsun/views/examination_order/labolatory/order_labolatory_view.dart';
import 'package:Ngoerahsun/views/examination_order/radiology/order_radiology_view.dart';
import 'package:Ngoerahsun/views/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:Ngoerahsun/model/user_model.dart';

class GlassMorphDashboardCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Widget? destination;
  final String keyName;
  final bool requiresLogin;
  final UserModel? user;
  final Color? backgroundColor;

  const GlassMorphDashboardCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.keyName,
    this.destination,
    this.requiresLogin = false,
    this.user,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackground =
        backgroundColor ?? AppColors.primary.withOpacity(0.5);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            offset: const Offset(6, 6),
            blurRadius: 12,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.15),
            offset: const Offset(-4, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            if (keyName == 'dashboardCardExaminationOrder') {
              _showExaminationOrderModal(context);
            } else if (requiresLogin && user == null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignInView()),
              );
            } else if (destination != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => destination!),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 90,
                    maxWidth: 90,
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        constraints: const BoxConstraints(
                          maxHeight: 90,
                          maxWidth: 90,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white.withOpacity(0.7),
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExaminationOrderModal(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            children: [
              Text(
                l10n.dashboardChooseExaminationType,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildModalCard(
                      title: l10n.examLaboratory,
                      imagePath: 'assets/images/laboratory.png',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LabOrderPageView(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModalCard(
                      title: l10n.examRadiology,
                      imagePath: 'assets/images/radiology.png',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RadiologyOrderPageView(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    elevation: 6,
                    shadowColor: Colors.black45,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.commonClose,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary1,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(4, 6),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            offset: const Offset(-3, -3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 60,
                  height: 60,
                  color: Colors.white,
                  colorBlendMode: BlendMode.srcIn,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                    letterSpacing: -0.2,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 3,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
