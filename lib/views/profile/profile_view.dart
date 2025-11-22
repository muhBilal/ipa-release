import 'dart:developer';

import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:Ngoerahsun/utils/app_images/app_images.dart';
import 'package:Ngoerahsun/widgets/app_button/app_button.dart';
import 'package:Ngoerahsun/widgets/app_text_from_field/app_text_from_field_view.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:Ngoerahsun/services/preferences/user_preferences.dart';
import 'package:Ngoerahsun/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:Ngoerahsun/provider/auth/authen_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:Ngoerahsun/model/country_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController editNameController = TextEditingController();
  final TextEditingController editEmailController = TextEditingController();
  final TextEditingController editPhoneController = TextEditingController();
  final TextEditingController editNikController = TextEditingController();
  final TextEditingController editPassportController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  static const List<String> genderCodes = ['M', 'F'];
  String? selectedGenderCode;

  DateTime? selectedDate;
  bool isWni = true;
  bool _isSaving = false;
  File? _pickedImageFile;
  bool _uploadingImage = false;
  final ImagePicker _imagePicker = ImagePicker();

  Country selectedCountry = Country(
    name: 'Indonesia',
    code: 'ID',
    dialCode: '+62',
    flag: '🇮🇩',
  );
  List<Country> countries = [
    Country(name: 'Indonesia', code: 'ID', dialCode: '+62', flag: '🇮🇩'),
    Country(name: 'United States', code: 'US', dialCode: '+1', flag: '🇺🇸'),
    Country(name: 'United Kingdom', code: 'GB', dialCode: '+44', flag: '🇬🇧'),
    Country(name: 'Australia', code: 'AU', dialCode: '+61', flag: '🇦🇺'),
    Country(name: 'Canada', code: 'CA', dialCode: '+1', flag: '🇨🇦'),
    Country(name: 'Germany', code: 'DE', dialCode: '+49', flag: '🇩🇪'),
    Country(name: 'France', code: 'FR', dialCode: '+33', flag: '🇫🇷'),
    Country(name: 'Italy', code: 'IT', dialCode: '+39', flag: '🇮🇹'),
    Country(name: 'Spain', code: 'ES', dialCode: '+34', flag: '🇪🇸'),
    Country(name: 'Japan', code: 'JP', dialCode: '+81', flag: '🇯🇵'),
    Country(name: 'South Korea', code: 'KR', dialCode: '+82', flag: '🇰🇷'),
    Country(name: 'China', code: 'CN', dialCode: '+86', flag: '🇨🇳'),
    Country(name: 'India', code: 'IN', dialCode: '+91', flag: '🇮🇳'),
    Country(name: 'Singapore', code: 'SG', dialCode: '+65', flag: '🇸🇬'),
    Country(name: 'Malaysia', code: 'MY', dialCode: '+60', flag: '🇲🇾'),
    Country(name: 'Thailand', code: 'TH', dialCode: '+66', flag: '🇹🇭'),
    Country(name: 'Philippines', code: 'PH', dialCode: '+63', flag: '🇵🇭'),
    Country(name: 'Vietnam', code: 'VN', dialCode: '+84', flag: '🇻🇳'),
  ];
  List<Country> filteredCountries = [];
  final TextEditingController countrySearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCountries = countries;
    _loadUserIntoForm();
  }

  Future<void> _loadUserIntoForm() async {
    try {
      log("Loading user data into form...");
      final UserModel? user = await UserPreferences.getUser();
      if (user == null) return;
      if (!mounted) return;
      setState(() {
        editNameController.text = user.nama;
        editEmailController.text = user.email;
        editPhoneController.text = user.noTelp;
        editNikController.text = user.nik;
        editPassportController.text = user.passport ?? '';

        if (user.tanggalLahir != DateTime(1900)) {
          selectedDate = user.tanggalLahir;
          dateController.text =
              "${user.tanggalLahir.year.toString().padLeft(4, '0')}-${user.tanggalLahir.month.toString().padLeft(2, '0')}-${user.tanggalLahir.day.toString().padLeft(2, '0')}";
        } else {
          selectedDate = null;
          dateController.text = '';
        }

        selectedGenderCode = (user.jenkel.toLowerCase() == 'male') ? 'M' : 'F';
        isWni = user.warganegara == 'WNI';

        if (user.phoneCountry.isNotEmpty) {
          final dial = user.phoneCountry.startsWith('+')
              ? user.phoneCountry
              : '+${user.phoneCountry}';
          final found = countries.where((c) => c.dialCode == dial);
          if (found.isNotEmpty) selectedCountry = found.first;
        }
      });
    } catch (_) {}
  }

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(value);
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String? _validateRequiredFields({
    required UserModel user,
    required AppLocalizations l10n,
  }) {
    final id = user.muid;
    if (id <= 0) return l10n.profileErrorInvalidPatientId;

    final nama = editNameController.text.trim();
    if (nama.isEmpty) return l10n.profileErrorNameRequired;

    final email = editEmailController.text.trim();
    if (email.isEmpty) return l10n.profileErrorEmailRequired;
    if (!_isValidEmail(email)) return l10n.profileErrorEmailInvalid;

    final telp = editPhoneController.text.trim();
    if (telp.isEmpty) return l10n.profileErrorPhoneRequired;

    if (selectedGenderCode == null) return l10n.profileErrorGenderRequired;
    if (selectedGenderCode != 'M' && selectedGenderCode != 'F') {
      return l10n.profileErrorGenderInvalid;
    }
    if (selectedCountry.dialCode.isEmpty) return 'Country code required';
    return null;
  }

  @override
  void dispose() {
    editNameController.dispose();
    editEmailController.dispose();
    editPhoneController.dispose();
    editNikController.dispose();
    editPassportController.dispose();
    dateController.dispose();
    countrySearchController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(AppLocalizations.of(context)!.gallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(AppLocalizations.of(context)!.camera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 800,
      );
      if (picked == null) return;

      setState(() {
        _pickedImageFile = File(picked.path);
      });

      await _uploadSelectedImage();
    } catch (e) {
      _showError(AppLocalizations.of(context)!.failed_to_pick_image);
    }
  }

  Future<void> _uploadSelectedImage() async {
    if (_pickedImageFile == null) return;
  }

  void _filterCountries(String query) {
    setState(() {
      filteredCountries = countries.where((c) {
        return c.name.toLowerCase().contains(query.toLowerCase()) ||
            c.dialCode.contains(query) ||
            c.code.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _showCountryPicker() {
    countrySearchController.clear();
    filteredCountries = countries;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.public,
                                color: Colors.grey.shade600, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.select_country,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.pop(ctx),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.close,
                                    size: 18, color: Colors.grey.shade600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: TextField(
                            controller: countrySearchController,
                            onChanged: (val) {
                              setModal(() {
                                _filterCountries(val);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.search_country_or_code,
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(Icons.search,
                                  color: Colors.grey.shade400, size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (_, i) {
                        final c = filteredCountries[i];
                        final sel = selectedCountry.code == c.code;
                        return InkWell(
                          onTap: () {
                            setState(() => selectedCountry = c);
                            Navigator.pop(ctx);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: sel
                                  ? const Color(0xFF3699FF).withOpacity(0.08)
                                  : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade100,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(c.flag,
                                    style: const TextStyle(fontSize: 22)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.name,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: sel
                                              ? const Color(0xFF3699FF)
                                              : Colors.grey.shade800,
                                        ),
                                      ),
                                      Text(
                                        c.code,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  c.dialCode,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: sel
                                        ? const Color(0xFF3699FF)
                                        : Colors.grey.shade600,
                                  ),
                                ),
                                if (sel) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.check_circle,
                                      size: 18, color: Color(0xFF3699FF)),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.profileEditTitle,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryLight4,
                    maxRadius: 60,
                    backgroundImage: _pickedImageFile != null
                        ? FileImage(_pickedImageFile!)
                        : null,
                    child: _pickedImageFile == null
                        ? const Icon(
                            Icons.person_outline,
                            color: AppColors.primary,
                            size: 80,
                          )
                        : null,
                  ),
                  if (_uploadingImage)
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _uploadingImage ? null : _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          _uploadingImage
                              ? Icons.hourglass_bottom
                              : Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle(l10n.profileSectionPersonalInfo),
            const SizedBox(height: 16),
            TextFormFieldCustom(
              controller: editNameController,
              hintText: l10n.profileHintFullName,
              prefixIcon:
                  const Icon(Icons.person_outline, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            TextFormFieldCustom(
              controller: editEmailController,
              hintText: l10n.profileHintEmail,
              prefixIcon:
                  const Icon(Icons.email_outlined, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _showCountryPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(selectedCountry.flag,
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 6),
                          Text(
                            selectedCountry.dialCode,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down,
                              size: 18, color: Colors.grey.shade600),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: editPhoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.profileHintPhoneNumber,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(l10n.profileSectionIdentity),
            const SizedBox(height: 16),
            _buildNationalitySelector(l10n),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => SizeTransition(
                sizeFactor:
                    CurvedAnimation(parent: anim, curve: Curves.easeInOut),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: isWni
                  ? Column(
                      key: const ValueKey('nikField'),
                      children: [
                        TextFormFieldCustom(
                          controller: editNikController,
                          hintText: l10n.profileHintNikNumber,
                          prefixIcon: const Icon(Icons.badge_outlined,
                              color: AppColors.primary),
                        ),
                      ],
                    )
                  : Column(
                      key: const ValueKey('passportField'),
                      children: [
                        TextFormFieldCustom(
                          controller: editPassportController,
                          hintText: l10n.profileHintPassportNumber,
                          prefixIcon: const Icon(Icons.book_outlined,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(l10n.profileSectionAdditionalInfo),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormFieldCustom(
                  controller: dateController,
                  hintText: l10n.profileHintDateOfBirth,
                  prefixIcon: const Icon(Icons.calendar_today_outlined,
                      color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight4.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.person_outline,
                        color: AppColors.primary),
                    hintText: l10n.profileHintGender,
                  ),
                  value: selectedGenderCode,
                  items: [
                    DropdownMenuItem(
                      value: 'M',
                      child: Text(l10n.genderMale),
                    ),
                    DropdownMenuItem(
                      value: 'F',
                      child: Text(l10n.genderFemale),
                    ),
                  ],
                  onChanged: (val) => setState(() => selectedGenderCode = val),
                ),
              ),
            ),
            const SizedBox(height: 32),
            AppButtonView(
              onTap: _isSaving
                  ? () {}
                  : () async {
                      final user = await UserPreferences.getUser();
                      if (user == null) {
                        _showError(l10n.profileErrorUserNotFound);
                        return;
                      }
                      final err =
                          _validateRequiredFields(user: user, l10n: l10n);
                      if (err != null) {
                        _showError(err);
                        return;
                      }
                      if (_uploadingImage) {
                        _showError('Tunggu upload foto selesai');
                        return;
                      }
                      setState(() => _isSaving = true);
                      try {
                        final provider = context.read<AuthenProvider>();
                        final success = await provider.updateUser(
                          id: user.muid,
                          nama: editNameController.text.trim(),
                          email: editEmailController.text.trim(),
                          noTelp: editPhoneController.text.trim(),
                          jkel: selectedGenderCode ?? 'M',
                          isWni: isWni,
                          noKtp: isWni
                              ? (editNikController.text.trim().isEmpty
                                  ? null
                                  : editNikController.text.trim())
                              : null,
                          noPassport: !isWni
                              ? (editPassportController.text.trim().isEmpty
                                  ? null
                                  : editPassportController.text.trim())
                              : null,
                          countryCode: selectedCountry.dialCode,
                          dateOfBirth: selectedDate != null
                              ? "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                              : null,
                          photoFile: _pickedImageFile,
                        );
                        if (!mounted) return;                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? l10n.profileSnackbarUpdateSuccess
                                  : l10n.profileSnackbarUpdateFailure,
                            ),
                            backgroundColor:
                                success ? Colors.green : Colors.red,
                          ),
                        );
                      } finally {
                        if (mounted) setState(() => _isSaving = false);
                      }
                    },
              text: _isSaving
                  ? l10n.profileBtnSaving
                  : l10n.profileBtnSaveChanges,
              color: _isSaving ? AppColors.primaryLight2 : AppColors.primary,
              textColor: Colors.white,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildNationalitySelector(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.flag_outlined,
                        color: Colors.white, size: 20),
                  ),
                  Text(
                    l10n.profileLabelNationality,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isWni = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isWni
                              ? AppColors.primary.withOpacity(0.1)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isWni
                                ? AppColors.primary
                                : Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isWni
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isWni
                                  ? AppColors.primary
                                  : Colors.grey.shade400,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text('🇮🇩', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 4),
                            Text(
                              l10n.profileNationalityWni,
                              style: TextStyle(
                                color: isWni
                                    ? AppColors.primary
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isWni = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isWni
                              ? AppColors.primary.withOpacity(0.1)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: !isWni
                                ? AppColors.primary
                                : Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              !isWni
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: !isWni
                                  ? AppColors.primary
                                  : Colors.grey.shade400,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text('🌍', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 4),
                            Text(
                              l10n.profileNationalityWna,
                              style: TextStyle(
                                color: !isWni
                                    ? AppColors.primary
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _dialogBuilder(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                child: Image.asset(LocalImages.icCongratulationsLogo),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.profileDialogCongratsTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.profileDialogCongratsBody,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
            ],
          ),
          actions: const [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 50,
                width: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  colors: [Colors.black, Colors.white],
                  strokeWidth: 2,
                  backgroundColor: Colors.white,
                  pathBackgroundColor: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
