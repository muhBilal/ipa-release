import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:Ngoerahsun/widgets/gradient_background/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:Ngoerahsun/views/booking_view/widget/my_book_card/my_book_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Ngoerahsun/services/preferences/user_preferences.dart';
import 'package:Ngoerahsun/provider/admission/admission_provider.dart';

class MyBookingView extends StatefulWidget {
  const MyBookingView({super.key});

  @override
  State<MyBookingView> createState() => _MyBookingViewState();
}

class _MyBookingViewState extends State<MyBookingView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _nik;
  String? _passport;
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _initLoad();
  }

  Future<void> _initLoad() async {
    final user = await UserPreferences.getUser();
    _nik = user?.nik;
    _passport = (user?.passport?.isNotEmpty ?? false) ? user!.passport : null;
    if (mounted) {
      setState(() => _initialLoading = false);
      if (_hasIdentifier) {
        _fetchForIndex(_tabController.index);
      }
    }
  }

  bool get _hasIdentifier =>
      (_nik != null && _nik!.isNotEmpty) ||
      (_passport != null && _passport!.isNotEmpty);

  void _handleTabChange() {
    if (_tabController.index != _tabController.previousIndex) {
      if (_hasIdentifier) {
        _fetchForIndex(_tabController.index);
      }
    }
  }

  void _fetchForIndex(int index) {
    final provider = context.read<AdmissionProvider>();
    provider.clearMyBookings(); // tambahkan fungsi ini di provider
    final type = switch (index) {
      0 => 'upcoming',
      1 => 'completed',
      _ => 'cancelled',
    };
    provider.getMyBooking(
      nik: _nik,
      passport: _nik == null || _nik!.isEmpty ? _passport : null,
      type: type,
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_initialLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_hasIdentifier) {
      return Scaffold(
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.identity_not_found_nik_passport,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return GradientBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Text(
                    l10n.myBookingTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TabBar(
                splashFactory: NoSplash.splashFactory,
                controller: _tabController,
                indicatorColor: Colors.black,
                indicatorWeight: 2.0,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: l10n.bookingTabUpcoming),
                  Tab(text: l10n.bookingTabCompleted),
                  Tab(text: l10n.bookingTabCancelled),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      mybookCard(
                        type: "upcoming",
                        nik: _nik,
                        passport: _passport,
                      ),
                      mybookCard(
                        type: "completed",
                        nik: _nik,
                        passport: _passport,
                      ),
                      mybookCard(
                        type: "cancelled",
                        nik: _nik,
                        passport: _passport,
                      ),
                    ],
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
