import 'package:ngoerahsun/l10n/app_localizations.dart';
import 'package:ngoerahsun/views/doctor_list__all/all_doctor_list_view.dart';
import 'package:flutter/material.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:ngoerahsun/utils/app_images/app_images.dart';
import 'package:ngoerahsun/views/booking_view/my_booking_view.dart';
import 'package:ngoerahsun/views/dashboard/dashboard_view.dart';
import 'package:ngoerahsun/views/profile/profile_edit_page/profile_edit_view.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future<void> openWhatsApp(BuildContext context) async {
  const phoneE164 = '628889990922';
  const message = 'Halo, saya ingin bertanya tentang layanan.';

  final native = Uri.parse(
    'whatsapp://send?phone=$phoneE164&text=${Uri.encodeComponent(message)}',
  );
  final web = Uri.parse(
    'https://wa.me/$phoneE164?text=${Uri.encodeComponent(message)}',
  );

  final okNative =
      await launchUrl(native, mode: LaunchMode.externalApplication);
  if (okNative) return;

  final okWeb = await launchUrl(web, mode: LaunchMode.externalApplication);
  if (okWeb) return;

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(AppLocalizations.of(context)!.sorry_we_cannot_open_whatsapp_on_this_device),
      ),
    );
  }
}

class BottomNavigationBarView extends StatefulWidget {
  final int initialIndex;
  const BottomNavigationBarView({super.key, this.initialIndex = 0});

  @override
  State<BottomNavigationBarView> createState() =>
      _BottomNavigationBarViewState();
}

class _BottomNavigationBarViewState extends State<BottomNavigationBarView> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardView(),
    AllDoctorListView(),
    MyBookingView(),
    ProfileEditView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          color: Colors.white,
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'waFab',
        onPressed: () => openWhatsApp(context),
        backgroundColor: Colors.green,
        child: const FaIcon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
          size: 28,
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          color: Colors.white,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: NavigationBar(
              indicatorColor: AppColors.athensGrayColor,
              backgroundColor: Colors.white,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              destinations: [
                NavigationDestination(
                  icon: Image.asset(
                    LocalImages.icHomeOutlinedIcon,
                    height: 24,
                    width: 24,
                    color: AppColors.paleSkyColor,
                  ),
                  selectedIcon: Image.asset(
                    LocalImages.icHomeOnIcon,
                    height: 24,
                    width: 24,
                    color: AppColors.riverBedColor,
                  ),
                  label: "",
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.local_hospital,
                    size: 24,
                    color: AppColors.paleSkyColor,
                  ),
                  selectedIcon: Icon(
                    Icons.local_hospital,
                    size: 24,
                    color: AppColors.riverBedColor,
                  ),
                  label: "",
                ),
                NavigationDestination(
                  icon: Image.asset(
                    LocalImages.icCalendarOnOutlinedIcon,
                    height: 24,
                    width: 24,
                    color: AppColors.paleSkyColor,
                  ),
                  selectedIcon: Image.asset(
                    LocalImages.icCalendarOnIcon,
                    height: 24,
                    width: 24,
                    color: AppColors.riverBedColor,
                  ),
                  label: "",
                ),
                NavigationDestination(
                  icon: Image.asset(
                    LocalImages.icPersonOnOutlinedIcon,
                    height: 24,
                    width: 24,
                    color: AppColors.paleSkyColor,
                  ),
                  selectedIcon: Image.asset(
                    LocalImages.icPersonOnIcon,
                    height: 24,
                    width: 24,
                    color: AppColors.riverBedColor,
                  ),
                  label: "",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
