import 'package:ngoerahsun/l10n/app_localizations.dart';
import 'package:ngoerahsun/model/myBooking_model.dart';
import 'package:ngoerahsun/provider/admission/admission_provider.dart';
import 'package:ngoerahsun/views/booking_view/detail/book_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:ngoerahsun/widgets/app_AppointmentCard/app_appointment_card_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class mybookCard extends StatefulWidget {
  final String type;
  final String? nik;
  final String? passport;

  const mybookCard({super.key, required this.type, this.nik, this.passport});

  @override
  State<mybookCard> createState() => _mybookCardState();
}

class _mybookCardState extends State<mybookCard> {
  int? _loadingBookingId;

  void handleCancel(int bookingId) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _loadingBookingId = bookingId;
    });
    try {
      final admissionProvider =
          Provider.of<AdmissionProvider>(context, listen: false);
      await admissionProvider.cancelBooking(bookingId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.bookingCancelled),
            duration: Duration(seconds: 2),
          ),
        );
        admissionProvider.getMyBooking(
          nik: (widget.nik != null && widget.nik!.isNotEmpty)
              ? widget.nik
              : null,
          passport: (widget.nik == null || widget.nik!.isEmpty)
              ? widget.passport
              : null,
          type: widget.type,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n
                .bookingCancelError(e.toString())),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingBookingId = null;
        });
      }
    }
  }

  void _openRescheduleSheet(MyBooking booking) {
    if (booking.idDokter == null || booking.idPoli == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incomplete booking data. Cannot reschedule."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => _RescheduleSheet(
        booking: booking,
        type: widget.type,
        nik: widget.nik,
        passport: widget.passport,
        onSuccess: () {
          if (mounted) {
            Provider.of<AdmissionProvider>(context, listen: false).getMyBooking(
              nik: (widget.nik != null && widget.nik!.isNotEmpty)
                  ? widget.nik
                  : null,
              passport: (widget.nik == null || widget.nik!.isEmpty)
                  ? widget.passport
                  : null,
              type: widget.type,
            );
          }
        },
      ),
    );
  }

  void _openDetail(MyBooking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingDetailScreen(
          bookingCode: booking.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdmissionProvider>(
      builder: (context, bookingProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        if (bookingProvider.isLoadingMyBooking) {
          return const Center(child: CircularProgressIndicator());
        }

        if (bookingProvider.myBookings.isEmpty) {
          return Center(
            child: Text(
              l10n.bookingNoType(widget.type),
            ),
          );
        }

        return ListView.builder(
          itemCount: bookingProvider.myBookings.length,
          itemBuilder: (context, index) {
            final booking = bookingProvider.myBookings[index];

            return Column(
              children: [
                AppAppointmentCardView(
                  date: booking.tanggal ?? "N/A",
                  doctorName: booking.dokter ?? "Unknown Doctor",
                  specialty: booking.poli ?? "Unknown Specialty",
                  icon: Icons.location_on,
                  clinic: booking.lokasi ?? "Unknown Location",
                  image: booking.gambar,
                  onTap: () => _openDetail(booking),
                  actions: widget.type == "upcoming"
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.5),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _loadingBookingId == booking.id
                                        ? null
                                        : () => handleCancel(booking.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      minimumSize: const Size(0, 40),
                                      elevation: 0,
                                    ),
                                    child: _loadingBookingId == booking.id
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            l10n
                                                .bookingBtnCancel,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _openRescheduleSheet(booking),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      l10n
                                          .bookingBtnReschedule,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        );
      },
    );
  }
}

class _RescheduleSheet extends StatefulWidget {
  final MyBooking booking;
  final String type;
  final VoidCallback onSuccess;
  final String? nik;
  final String? passport;

  const _RescheduleSheet({
    required this.booking,
    required this.type,
    required this.onSuccess,
    this.nik,
    this.passport,
  });

  @override
  State<_RescheduleSheet> createState() => _RescheduleSheetState();
}

class _RescheduleSheetState extends State<_RescheduleSheet> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  bool _loadingTimes = false;
  bool _submitting = false;
  

  AdmissionProvider get provider =>
      Provider.of<AdmissionProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchTimes();
      }
    });
  }

  Future<void> _pickDate() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 60)),
      );

      if (picked != null && mounted) {
        setState(() {
          _selectedDate = picked;
          _selectedTime = null;
        });
        await _fetchTimes();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n
                .bookingSelectDateError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _fetchTimes() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final int? doctorId = widget.booking.idDokter;
      final int? poliId = widget.booking.idPoli;

      if (doctorId == null || poliId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Incomplete booking data. Cannot fetch schedule."),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (mounted) {
        setState(() => _loadingTimes = true);
      }

      final dateStr =
          "${_selectedDate.year.toString().padLeft(4, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

      await provider.getScheduleTime(poliId, doctorId, dateStr);

      if (mounted) {
        setState(() => _loadingTimes = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingTimes = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n
                .bookingFetchScheduleError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedTime == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                l10n.bookingSelectTimeFirst),
          ),
        );
      }
      return;
    }

    try {
      if (mounted) {
        setState(() => _submitting = true);
      }

      final tanggal =
          "${_selectedDate.year.toString().padLeft(4, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

      final ok = await provider.rescheduleBooking(
        id: widget.booking.id,
        tanggal: tanggal,
        jam: _selectedTime!,
      );

      if (mounted) {
        setState(() => _submitting = false);

        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Reschedule successful"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          widget.onSuccess();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Reschedule failed"),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.bookingError(e.toString())),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.rescheduleTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const Icon(Icons.edit_calendar,
                            size: 18, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Consumer<AdmissionProvider>(
                builder: (context, provider, child) {
                  if (_loadingTimes) {
                    return const Padding(
                      padding: EdgeInsets.all(28),
                      child: CircularProgressIndicator(),
                    );
                  }

                  final schedules = provider.schedules ?? [];

                  final times = schedules
                      .map((s) {
                        try {
                          if (s == null) return "";
                          final item = (s as dynamic);
                          return item.scheduleName?.toString() ?? "";
                        } catch (_) {
                          return "";
                        }
                      })
                      .where((t) => t.toString().isNotEmpty)
                      .cast<String>()
                      .toList();

                  if (times.isEmpty) {
                    const phoneE164 = '628889990922';
                    const message = 'Halo, saya ingin bertanya tentang jadwal.';
                    return Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n
                                .bookingNoAvailableSchedule,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final url =
                                  'https://wa.me/$phoneE164?text=${Uri.encodeComponent(message)}';
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(l10n
                                          .cannotOpenWhatsApp),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.phone,
                                color: Colors.white, size: 20),
                            label: Text(
                              l10n
                                  .contactViaWhatsApp,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: times.map((t) {
                        final selected = _selectedTime == t;
                        return ChoiceChip(
                          label: Text(
                            t,
                            style: TextStyle(
                              fontWeight:
                                  selected ? FontWeight.w600 : FontWeight.w400,
                              color: selected
                                  ? Colors.white
                                  : Colors.grey.shade800,
                            ),
                          ),
                          selected: selected,
                          selectedColor: AppColors.primary,
                          backgroundColor: Colors.grey.shade100,
                          onSelected: (_) {
                            if (mounted) {
                              setState(() => _selectedTime = t);
                            }
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            l10n.bookingConfirm,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
