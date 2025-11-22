import 'dart:async';
import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:Ngoerahsun/model/user_model.dart';
import 'package:Ngoerahsun/services/preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Ngoerahsun/widgets/gradient_background/gradient_background.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:Ngoerahsun/widgets/app_text_from_field/app_text_from_field_view.dart';
import 'package:Ngoerahsun/views/doctors_view/my_doctor_view.dart';
import 'package:Ngoerahsun/views/doctor_list__all/horizontal_doctor_category_name_list_view/doctor_category_list_view.dart';
import 'package:Ngoerahsun/provider/admission/admission_provider.dart';

class AllDoctorListView extends StatefulWidget {
  const AllDoctorListView({super.key});

  @override
  State<AllDoctorListView> createState() => _AllDoctorListViewState();
}

class _AllDoctorListViewState extends State<AllDoctorListView> {
  final TextEditingController addSearchController = TextEditingController();
  Timer? _debounce;
  int? _selectedPoliId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ap = context.read<AdmissionProvider>();
      ap.getPoli();
      ap.getDoctors();
    });

    addSearchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final ap = context.read<AdmissionProvider>();
      ap.getDoctors(
        poliId: _selectedPoliId,
        search: _searchTextOrNull(),
      );
    });
  }

  String? _searchTextOrNull() {
    final s = addSearchController.text.trim();
    return s.isEmpty ? null : s;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    addSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ap = context.watch<AdmissionProvider>();
    final foundCount = ap.doctors.length;
    final polis = ap.polis;

    return GradientBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white, 
            title: Text(
              l10n.doctorsAllTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.oxfordBlueColor,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormFieldCustom(
                  controller: addSearchController,
                  hintText: l10n.dashboardSearchDoctorHint,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12.5),
                    child: Icon(
                      Icons.search,
                      color: AppColors.silverColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DoctorCategoryListView(
                  polis: polis,
                  selectedPoliId: _selectedPoliId,
                  onPoliSelected: (int? poliId) {
                    setState(() => _selectedPoliId = poliId);
                    context.read<AdmissionProvider>().getDoctors(
                          poliId: poliId,
                          search: _searchTextOrNull(),
                        );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.doctorsFoundCount(foundCount),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.commonDefault,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.silverColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: MyDoctorView(
                    poliId: _selectedPoliId ?? 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
