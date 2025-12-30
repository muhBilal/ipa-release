import 'package:flutter/material.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:ngoerahsun/model/notification/notification_model.dart';

class NotificationsListView extends StatelessWidget {
  final String? dayName;
  final String? title;
  final List<NotificationModel> notifications;
  final void Function(int id)? onItemTap;

  const NotificationsListView({
    super.key,
    this.dayName,
    this.title,
    required this.notifications,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayName ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.silverColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                title ?? "",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final isRead = notification.isRead ?? false;
              return InkWell(
                onTap: () => onItemTap?.call(notification.id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: isRead
                              ? Colors.blueAccent.withOpacity(0.2)
                              : Colors.lightBlueAccent.withOpacity(0.7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isRead ? FontWeight.w400 : FontWeight.bold,
                                color: isRead
                                    ? AppColors.silverColor
                                    : AppColors.blackColor,
                              ),
                            ),
                            Text(
                              notification.message,
                              style: TextStyle(
                                fontSize: 14,
                                color: isRead
                                    ? AppColors.silverColor
                                    : AppColors.paleSkyColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        notification.sendAt ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.silverColor,
                          fontWeight: FontWeight.w400,
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
    );
  }
}
