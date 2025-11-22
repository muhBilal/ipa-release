import 'dart:developer';

import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:Ngoerahsun/views/doctor_booking/doctor_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:Ngoerahsun/core/navigation/navigator.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:Ngoerahsun/utils/app_images/app_images.dart';
import 'package:Ngoerahsun/provider/admission/admission_provider.dart';
import 'package:Ngoerahsun/model/doctor_model.dart';

class MyFavoriteDoctorListView extends StatefulWidget {
  const MyFavoriteDoctorListView({super.key});

  @override
  State<MyFavoriteDoctorListView> createState() =>
      _MyFavoriteDoctorListViewState();
}

class _MyFavoriteDoctorListViewState extends State<MyFavoriteDoctorListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdmissionProvider>().getDoctors(
            onlyFav: 1,
          );
    });
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return 'DR';
    final initials = parts.map((p) => p.isNotEmpty ? p[0] : '').take(2).join();
    return initials.isEmpty ? 'DR' : initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.my_favorite_doctors),
        backgroundColor: AppColors.whiteColor,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Consumer<AdmissionProvider>(
        builder: (context, provider, _) {
          if (provider.doctorLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.doctors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.no_favorite_doctors_yet,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.browse_and_add_doctors_to_your_favorites,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: provider.doctors.length,
            itemBuilder: (context, index) {
              final DoctorModel doctor = provider.doctors[index];

              return GestureDetector(
                onTap: () {
                  Navigation.push(
                    context,
                    DoctorBookingFlow(
                      0,
                      initialDoctorId: doctor.id,
                      initialDoctorName: doctor.nama ?? "",
                    ),
                  );
                },
                child: Container(
                  constraints: const BoxConstraints(minHeight: 140),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: (doctor.gambar != null &&
                                doctor.gambar!.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: doctor.gambar!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey.shade200,
                                  child: Center(
                                    child: Text(
                                      _getInitials(doctor.nama ?? ""),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Image.asset(
                                LocalImages.icIntroImgFirst,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    doctor.nama ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Consumer<AdmissionProvider>(
                                  builder: (context, provider, _) {
                                    final isLoading =
                                        provider.isLoading(doctor.id);
                                    final isFav = provider.isFavorite(
                                      doctor.id,
                                      defaultValue: doctor.isFav,
                                    );

                                    return IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            )
                                          : Icon(
                                              isFav
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFav
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                      onPressed: isLoading
                                          ? null
                                          : () async {
                                              log('doctor.id: ${doctor.id}');
                                              final success = await context
                                                  .read<AdmissionProvider>()
                                                  .toggleFavorite(doctor.id);

                                              if (success) {
                                                final updatedStatus = context
                                                    .read<AdmissionProvider>()
                                                    .isFavorite(doctor.id,
                                                        defaultValue:
                                                            doctor.isFav);

                                                final msg = updatedStatus
                                                    ? AppLocalizations.of(context)!.doctor_added_to_favorites
                                                    : AppLocalizations.of(context)!.doctor_removed_from_favorites;

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(msg),
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  ),
                                                );

                                                if (!updatedStatus) {
                                                  await context
                                                      .read<AdmissionProvider>()
                                                      .getDoctors(
                                                        onlyFav: 1,
                                                      );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      AppLocalizations.of(context)!.failed_to_update_favorite_status,
                                                    ),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            },
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            if ((doctor.poli ?? '').isNotEmpty) ...[
                              Text(
                                doctor.poli!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                            const Divider(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
