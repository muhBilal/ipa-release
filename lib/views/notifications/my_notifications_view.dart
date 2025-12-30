import 'package:ngoerahsun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:ngoerahsun/views/notifications/widget/notification_list_view.dart';
import 'package:ngoerahsun/provider/notification/notification_provider.dart';

class MyNotificationsView extends StatefulWidget {
  const MyNotificationsView({super.key});

  @override
  State<MyNotificationsView> createState() => _MyNotificationsViewState();
}

class _MyNotificationsViewState extends State<MyNotificationsView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<NotificationProvider>(context, listen: false)
            .loadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.riverBedColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.riverBedColor,
          ),
        ),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
                child: Text(
                    AppLocalizations.of(context)!.error(provider.error ?? '')));
          }
          if (provider.notifications.isEmpty) {
            return Center(
                child: Text(
                    AppLocalizations.of(context)!.no_notifications_yet));
          }
          return ListView.builder(
            itemCount: provider.notifications.length,
            itemBuilder: (context, index) {
              final group = provider.notifications[index];
              return NotificationsListView(
                dayName: group.group,
                // title: "Mark All As Read",
                notifications: group.notifications,
              );
            },
          );
        },
      ),
    );
  }
}
