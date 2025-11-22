import 'dart:developer';
import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:Ngoerahsun/views/profile/user_card_view.dart';
import 'package:Ngoerahsun/views/term_conditions/term_conditions_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Ngoerahsun/model/user_model.dart';
import 'package:Ngoerahsun/provider/language/locale_provider.dart';
import 'package:Ngoerahsun/services/preferences/user_preferences.dart';
import 'package:Ngoerahsun/core/navigation/navigator.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:Ngoerahsun/utils/app_images/app_images.dart';
import 'package:Ngoerahsun/views/favorites_view/my_favorite_view.dart';
import 'package:Ngoerahsun/views/login/login_view.dart';
import 'package:Ngoerahsun/views/notifications/my_notifications_view.dart';
import 'package:Ngoerahsun/views/profile/profile_edit_page/profile_menu_item/profile_menu_item_view.dart';
import 'package:Ngoerahsun/views/profile/profile_view.dart';
import 'package:Ngoerahsun/widgets/app_button/app_button.dart';
import 'package:Ngoerahsun/widgets/gradient_background/gradient_background.dart';

const kDeeplinkEditProfile = 'editProfile';
const kDeeplinkClientCard = 'clientCard';
const kDeeplinkFavorite = 'favorite';
const kDeeplinkNotifications = 'notifications';
const kDeeplinkSettings = 'settings';
const kDeeplinkChangeLanguage = 'changeLanguage';
const kDeeplinkHelpSupport = 'helpSupport';
const kDeeplinkTerms = 'terms';
const kDeeplinkLogout = 'logout';

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final List<Map<String, dynamic>> _menuItems = [
    {
      "image": LocalImages.icEditProfileIcon,
      "icon": LocalImages.icProfileEditArrowIcon,
      "deeplink": kDeeplinkEditProfile,
      "requiresLogin": true,
    },
    {
      "image": LocalImages.icCardIcon,
      "icon": LocalImages.icProfileEditArrowIcon,
      "deeplink": kDeeplinkClientCard,
      "requiresLogin": true,
    },
    {
      "image": LocalImages.icFavoriteIcon,
      "icon": LocalImages.icProfileEditArrowIcon,
      "deeplink": kDeeplinkFavorite,
      "requiresLogin": true,
    },
    {
      "image": LocalImages.icNotificationIcon,
      "icon": LocalImages.icProfileEditArrowIcon,
      "deeplink": kDeeplinkNotifications,
      "requiresLogin": true,
    },
    // {
    //   "image": LocalImages.icSettingIcon,
    //   "icon": LocalImages.icProfileEditArrowIcon,
    //   "deeplink": kDeeplinkSettings,
    //   "requiresLogin": false,
    // },
    {
      "image": LocalImages.icHelpAndSupportIcon,
      "icon": LocalImages.icProfileEditArrowIcon,
      "deeplink": kDeeplinkChangeLanguage,
      "requiresLogin": false,
    },
    // {
    //   "image": LocalImages.icHelpAndSupportIcon,
    //   "icon": LocalImages.icProfileEditArrowIcon,
    //   "deeplink": kDeeplinkHelpSupport,
    // },
    {
      "image": LocalImages.icTermsAndConditionsIcon,
      "icon": LocalImages.icProfileEditArrowIcon,
      "deeplink": kDeeplinkTerms,
      "requiresLogin": false,
    },
    {
      "image": LocalImages.icLogoutIcon,
      "deeplink": kDeeplinkLogout,
      "requiresLogin": true,
    },
  ];

  UserModel? _user;
  bool _isLoading = true;

  String _labelForMenu(String deeplink, AppLocalizations l10n) {
    switch (deeplink) {
      case kDeeplinkEditProfile:
        return l10n.profileMenuEditProfile;
      case kDeeplinkClientCard:
        return l10n.profileMenuCard;
      case kDeeplinkFavorite:
        return l10n.profileMenuFavorite;
      case kDeeplinkNotifications:
        return l10n.profileMenuNotifications;
      // case kDeeplinkSettings:
      //   return l10n.profileMenuSettings;
      case kDeeplinkChangeLanguage:
        return l10n.profileMenuChangeLanguage;
      // case kDeeplinkHelpSupport:
      //   return l10n.profileMenuHelpSupport;
      case kDeeplinkTerms:
        return l10n.profileMenuTerms;
      case kDeeplinkLogout:
        return l10n.profileMenuLogout;
      default:
        return '';
    }
  }

  void _onNavigationItemClick(String deeplink, BuildContext context) {
    switch (deeplink) {
      case kDeeplinkEditProfile:
        Navigation.push(context, const ProfileView());
        break;
      case kDeeplinkClientCard:
        Navigation.push(context, const PatientCardFinal());
        break;
      case kDeeplinkFavorite:
        Navigation.push(context, const MyFavoriteDoctorListView());
        break;
      case kDeeplinkNotifications:
        Navigation.push(context, const MyNotificationsView());
        break;
      case kDeeplinkTerms:
        Navigation.push(context, const TermsConditionsView());
        break;
      case kDeeplinkChangeLanguage:
        _showChangeLanguageBottomSheet(context);
        break;
      case kDeeplinkLogout:
        _showLogoutBottomSheet(context);
        break;
    }
  }

  Future<void> _loadUser() async {
    final user = await UserPreferences.getUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String userName =
        _user?.nama?.isNotEmpty == true ? _user!.nama! : l10n.profileGuest;
    final String phoneCountry =
        _user?.phoneCountry?.isNotEmpty == true ? _user!.phoneCountry! : '+62';
    final String phoneNumber =
        _user?.noTelp != null ? '$phoneCountry ${_user!.noTelp}' : '';

    final filteredMenu = _menuItems.where((item) {
      if (item["requiresLogin"] == true && _user == null) {
        return false;
      }
      return true;
    }).toList();

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
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
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(
                  l10n.profileTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0) +
                    const EdgeInsets.only(top: 25),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        maxRadius: 60,
                        child: ClipOval(
                          child: (_user?.image != null &&
                                  _user!.image!.isNotEmpty)
                              ? CachedNetworkImage(
                                  imageUrl: _user!.image!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Icon(
                                    Icons.person_4_outlined,
                                    color: Colors.grey.shade400,
                                    size: 80,
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.person_4_outlined,
                                    color: Colors.grey.shade500,
                                    size: 80,
                                  ),
                                )
                              : Icon(
                                  Icons.person_4_outlined,
                                  color: Colors.grey.shade500,
                                  size: 80,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 121,
                      child: Image.asset(
                        LocalImages.icProfileEditLogo,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              Text(
                phoneNumber,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.paleSkyColor,
                ),
              ),
              Expanded(
                child: Builder(builder: (context) {
                  final int extraLogin = _user == null ? 1 : 0;
                  final int totalItems = filteredMenu.length + extraLogin + 1; // +1 for footer
                  return ListView.builder(
                    itemCount: totalItems,
                    itemBuilder: (context, index) {
                      // menu items
                      if (index < filteredMenu.length) {
                        final menuItem = filteredMenu[index];
                        final deeplink = menuItem["deeplink"] as String;
                        final label = _labelForMenu(deeplink, l10n);
                        return InkWell(
                          splashColor: Colors.transparent,
                          onTap: () => _onNavigationItemClick(deeplink, context),
                          child: Column(
                            children: [
                              ProfileMenuItemView(
                                image: menuItem["image"],
                                text: label,
                                icon: menuItem["icon"],
                                height: 24,
                                width: 24,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(),
                              ),
                            ],
                          ),
                        );
                      }

                      // optional login button when user is null
                      if (_user == null &&
                          index == filteredMenu.length &&
                          filteredMenu.any((item) =>
                              item["deeplink"] == kDeeplinkTerms)) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              onPressed: () {
                                Navigation.push(context, const SignInView());
                              },
                              child: Text(
                                // l10n.profileMenuLogin,
                                "Login",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      // footer: powered by text (last item)
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'powered by: simrs.id',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.paleSkyColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showLogoutBottomSheet(BuildContext rootContext) {
  final l10n = AppLocalizations.of(rootContext)!;
  showModalBottomSheet(
    context: rootContext,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext sheetContext) {
      return Container(
        height: 199,
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.profileLogoutTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mirageColor,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              l10n.profileLogoutMessage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.paleSkyColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: AppButtonView(
                    color: AppColors.athensGrayColor,
                    textColor: AppColors.mirageColor,
                    border: Border.all(color: AppColors.mirageColor),
                    text: l10n.profileLogoutCancel,
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButtonView(
                    color: AppColors.primary,
                    textColor: AppColors.athensGrayColor,
                    border: Border.all(color: AppColors.primary),
                    text: l10n.profileLogoutConfirm,
                    onTap: () async {
                      Navigator.of(sheetContext).pop();
                      await UserPreferences.clearUser();
                      Navigation.removeAllPreviousAndPush(
                        rootContext,
                        const SignInView(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void _showChangeLanguageBottomSheet(BuildContext rootContext) {
  final l10n = AppLocalizations.of(rootContext)!;
  showModalBottomSheet(
    context: rootContext,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext sheetContext) {
      String selectedLang =
          rootContext.read<LocaleProvider>().locale?.languageCode ?? 'id';
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.langChangeTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mirageColor,
                  ),
                ),
                const SizedBox(height: 12),
                RadioListTile<String>(
                  value: 'id',
                  groupValue: selectedLang,
                  title: Text(l10n.langIndonesian),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => selectedLang = val);
                  },
                ),
                RadioListTile<String>(
                  value: 'eng',
                  groupValue: selectedLang,
                  title: Text(l10n.langEnglish),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => selectedLang = val);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppButtonView(
                        color: AppColors.athensGrayColor,
                        textColor: AppColors.mirageColor,
                        border: Border.all(color: AppColors.mirageColor),
                        text: l10n.profileLogoutCancel,
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButtonView(
                        color: AppColors.mirageColor,
                        textColor: AppColors.athensGrayColor,
                        border: Border.all(color: AppColors.mirageColor),
                        text: l10n.commonSave,
                        onTap: () async {
                          final messenger = ScaffoldMessenger.of(rootContext);
                          Navigator.of(sheetContext).pop();
                          await rootContext
                              .read<LocaleProvider>()
                              .setLocale(Locale(selectedLang));
                          final newL10n = AppLocalizations.of(rootContext)!;
                          final langName = selectedLang == 'id'
                              ? newL10n.langIndonesian
                              : newL10n.langEnglish;
                          messenger
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                content: Text(newL10n.langSavedToast(langName))));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
