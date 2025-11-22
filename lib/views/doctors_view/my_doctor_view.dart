import 'dart:developer';
import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:Ngoerahsun/model/user_model.dart';
import 'package:Ngoerahsun/services/preferences/user_preferences.dart';
import 'package:Ngoerahsun/views/doctor_booking/doctor_booking_screen.dart';
import 'package:Ngoerahsun/views/doctor_details/doctor_details_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Ngoerahsun/core/navigation/navigator.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:Ngoerahsun/utils/app_images/app_images.dart';
import 'package:Ngoerahsun/provider/admission/admission_provider.dart';
import 'package:Ngoerahsun/model/doctor_model.dart';
import 'package:Ngoerahsun/views/login/login_view.dart';

class MyDoctorView extends StatefulWidget {
  final int poliId;
  const MyDoctorView({super.key, this.poliId = 0});

  @override
  State<MyDoctorView> createState() => _MyDoctorViewState();
}

class _MyDoctorViewState extends State<MyDoctorView>
    with AutomaticKeepAliveClientMixin {
  UserModel? _user;

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadUser() async {
    final user = await UserPreferences.getUser();
    log("user id loaded in MyDoctorView: ${user?.muid}");
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdmissionProvider>().getDoctors(
            poliId: widget.poliId == 0 ? null : widget.poliId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<AdmissionProvider>(
      builder: (context, provider, _) {
        if (provider.doctorLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.doctors.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.no_doctors_available));
        }

        return ListView.builder(
          key: const PageStorageKey('doctorList'),
          itemCount: provider.doctors.length,
          itemBuilder: (context, index) {
            final DoctorModel doctor = provider.doctors[index];

            return GestureDetector(
              onTap: () {
                log('debug doctor id ${doctor.id} with poli id ${doctor.poliId}');
                Navigation.push(
                  context,
                  DoctorDetailsView(doctorId: doctor.id, poliId: doctor.poliId),
                );
              },
              onLongPress: () {
                if (_user == null) {
                  Navigation.push(context, const SignInView());
                  return;
                }
                Navigation.push(
                  context,
                  DoctorBookingFlow(
                    doctor.poliId ?? 0,
                    initialDoctorId: doctor.id,
                    initialDoctorName: doctor.nama ?? "",
                  ),
                );
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: 140),
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: doctor.gambar ?? "",
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          maxHeightDiskCache: 400,
                          maxWidthDiskCache: 400,
                          fadeInDuration: const Duration(milliseconds: 200),
                          fadeOutDuration: const Duration(milliseconds: 200),
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
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
                              Selector<AdmissionProvider, bool>(
                                selector: (_, p) => p.isLoading(doctor.id),
                                builder: (context, isLoading, _) {
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
                                            if (_user == null) {
                                              Navigation.push(
                                                  context, const SignInView());
                                              return;
                                            }
                                            final success = await context
                                                .read<AdmissionProvider>()
                                                .toggleFavorite(doctor.id);
                                            log(
                                                "debug toggleFavorite result: $success for doctor ID: ${doctor.id}");
                                            if (success) {
                                              final updatedStatus = context
                                                  .read<AdmissionProvider>()
                                                  .isFavorite(
                                                    doctor.id,
                                                    defaultValue: doctor.isFav,
                                                  );
                                              final msg = updatedStatus
                                                  ? "Dokter ditambahkan ke favorit"
                                                  : "Dokter dihapus dari favorit";
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(msg),
                                                  duration: const Duration(
                                                      seconds: 2),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(AppLocalizations.of(context)!.failed_to_update_favorite_status),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                          },
                                  );
                                },
                              )
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
    );
  }
}
