import 'package:flutter/material.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:ngoerahsun/utils/app_images/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppAppointmentCardView extends StatelessWidget {
  final String? type;
  final String? date;
  final String? doctorName;
  final String? specialty;
  final String? clinic;
  final String? image;
  final Widget? actions;
  final IconData? icon;
  final VoidCallback? onTap;

  const AppAppointmentCardView({
    super.key,
    this.type,
    this.date,
    this.doctorName,
    this.specialty,
    this.clinic,
    this.image,
    this.actions,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: AppColors.primary.withOpacity(0.08),
      highlightColor: AppColors.primary.withOpacity(0.04),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(bottom: 10) +
            const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date ?? "",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: AppColors.silverColor),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: image != null
                          ? CachedNetworkImage(
                              imageUrl: image!,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              width: 90,
                              height: 90,
                              placeholder: (context, url) => Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.calendar_month_rounded,
                                    size: 36,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.calendar_month_rounded,
                                  size: 36,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                    )),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName ?? "",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        specialty ?? "",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(icon),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              clinic ?? "",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            type == "completed"
                ? const Divider(color: AppColors.silverColor)
                : const SizedBox.shrink(),
            if (actions != null) ...[
              const SizedBox(height: 10),
              actions!,
            ]
          ],
        ),
      ),
    );
  }
}
