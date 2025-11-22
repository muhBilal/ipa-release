import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:Ngoerahsun/utils/app_images/app_images.dart';
import 'package:Ngoerahsun/views/book_appointment/widget/time_picker_view.dart';
import 'package:Ngoerahsun/widgets/app_button/app_button.dart';
import 'package:intl/intl.dart';

class MyBookAppointmentWidgetView extends StatefulWidget {
  const MyBookAppointmentWidgetView({super.key});

  @override
  State<MyBookAppointmentWidgetView> createState() =>
      _MyBookAppointmentWidgetViewState();
}

class _MyBookAppointmentWidgetViewState
    extends State<MyBookAppointmentWidgetView> {
  DateTime? selectedDate;
  List<DateTime?> selectedDates = [];
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title:  Text(
          AppLocalizations.of(context)!.book_appointment,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.oxfordBlueColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppLocalizations.of(context)!.select_date,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mirageColor,
              ),
            ),
          ),
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(),
            value: selectedDates,
            onValueChanged: (date) {
              setState(() {
                selectedDates = date.cast<DateTime?>();
                selectedDate = selectedDates.first;
              });
            },
          ),
          const SizedBox(height: 1),
           Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              AppLocalizations.of(context)!.select_time,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mirageColor,
              ),
            ),
          ),
          Expanded(
            child: TimePickerView(
              onTimeSelected: (time) {
                selectedTime = time;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: AppButtonView(
              text: AppLocalizations.of(context)!.confirm,
              onTap: () {
                if (selectedDate != null && selectedTime != null) {
                  _dialogBuilder(context, selectedDate!, selectedTime!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _dialogBuilder(
    BuildContext context, DateTime selectedDate, TimeOfDay selectedTime) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              child: Image.asset(
                LocalImages.icCongratulationsLogo,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.congratulations,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.your_appointment_is_booked_for,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${selectedDate.toLocal().toString().split(' ')[0]} at ${selectedTime.format(context)}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            AppButtonView(
              text: "Done",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.thank_you_for_using_our_service,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    },
  );
}
