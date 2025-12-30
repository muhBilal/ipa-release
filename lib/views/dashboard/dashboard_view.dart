import 'dart:ui';

import 'package:ngoerahsun/l10n/app_localizations.dart';
import 'package:ngoerahsun/model/user_model.dart';
import 'package:ngoerahsun/services/preferences/user_preferences.dart';
import 'package:ngoerahsun/views/about_us/about_us_screen.dart';
import 'package:ngoerahsun/views/articles/articles_list.dart';
import 'package:ngoerahsun/views/dashboard/components/dashboard_card.dart';
import 'package:ngoerahsun/views/doctor_booking/doctor_booking_screen.dart';
import 'package:ngoerahsun/views/examination_result/examination_result_screen.dart';
import 'package:ngoerahsun/views/login/login_view.dart';
import 'package:ngoerahsun/views/our_facility/our_facility_screen.dart';
import 'package:ngoerahsun/views/wellness/wellness_submenu_screen.dart';
import 'package:ngoerahsun/widgets/gradient_background/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:ngoerahsun/core/navigation/navigator.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:ngoerahsun/utils/app_images/app_images.dart';
import 'package:ngoerahsun/views/notifications/my_notifications_view.dart';
import 'package:ngoerahsun/widgets/app_banner/app_banner_view.dart';
import 'package:provider/provider.dart';
import 'package:ngoerahsun/provider/article/article_provider.dart';
import 'package:ngoerahsun/views/articles/article_detail_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final TextEditingController addSearchController = TextEditingController();
  UserModel? _user;
  final List<Map<String, dynamic>> cards = [
    {
      'titleKey': 'dashboardCardWellness',
      'image': 'assets/images/icon_wellness.png',
      'destination': WellnessSubmenuScreen(),
      'requiresLogin': true,
      'color' : AppColors.primary1
    },
    {
      'titleKey': 'dashboardCardPlasticSurgery',
      'image': 'assets/images/icon_plastic_surgery.png',
      'destination': DoctorBookingFlow(52),
      'requiresLogin': true,
      'color' : AppColors.primary1
    },
    {
      'titleKey': 'dashboardCardDermaesthetic',
      'image': 'assets/images/icon_dermaesthetic.png',
      'destination': DoctorBookingFlow(51),
      'requiresLogin': true,
      'color' : AppColors.primary1
    },
    {
      'titleKey': 'dashboardCardAestheticDentistry',
      'image': 'assets/images/icon_aesthetic_dentistry.png',
      'destination': DoctorBookingFlow(50),
      'requiresLogin': true,
      'color' : AppColors.primary1
    },
    {
      'titleKey': 'dashboardCardExaminationOrder',
      'image': 'assets/images/examination_order.png',
      'destination': null,
      'requiresLogin': false,
      'color' : AppColors.tealish
    },
    {
      'titleKey': 'dashboardCardExaminationResult',
      'image': 'assets/images/mcu_for_umrah_and_hajj.png',
      'destination': ExaminationResultPage(),
      'requiresLogin': false,
      'color' : AppColors.tealish
    },
    {
      'titleKey': 'dashboardCardAboutUs',
      'image': 'assets/images/about_us.png',
      'destination': AboutUsScreenView(),
      'requiresLogin': false,
      'color' : AppColors.orangePop
    },
    {
      'titleKey': 'dashboardCardOurFacilities',
      'image': 'assets/images/our_facilities.png',
      'destination': OurFacilityView(),
      'requiresLogin': false,
      'color' : AppColors.orangePop
    },
  ];

  Future<void> loadUser() async {
    final user = await UserPreferences.getUser();
    final playerId = await UserPreferences.getPlayerId();
    setState(() {
      _user = user;
    });
    if (!mounted) return;
  }

  void onCardTap(BuildContext context, Map<String, dynamic> card) {
    final requiresLogin = card['requiresLogin'] as bool? ?? false;
    final destination = card['destination'];

    if (requiresLogin && _user == null) {
      Navigation.push(context, const SignInView());
      return;
    }

    if (destination != null) {
      Navigation.push(context, destination);
    }
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArticleProvider>(context, listen: false).fetchAllArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.dashboardLocationLabel,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.silverColor,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  Text(
                                    l10n.dashboardLocationDefault,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.black),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications,
                                color: Colors.black, size: 30),
                            onPressed: () {
                              Navigation.push(
                                context,
                                const MyNotificationsView(),
                              );
                            },
                          ),
                          // Positioned(
                          //   right: 14,
                          //   top: 14,
                          //   child: Container(
                          //     padding: const EdgeInsets.all(2),
                          //     decoration: BoxDecoration(
                          //       color: const Color(0xFFEA4C4C),
                          //       borderRadius: BorderRadius.circular(6),
                          //     ),
                          //     constraints: const BoxConstraints(
                          //       minWidth: 8,
                          //       minHeight: 8,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // TextFormFieldCustom(
                  //   controller: addSearchController,
                  //   hintText: l10n.dashboardSearchDoctorHint,
                  //   prefixIcon: const Padding(
                  //     padding: EdgeInsets.all(12.5),
                  //     child: Icon(
                  //       Icons.search,
                  //       color: AppColors.silverColor,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  const AppBannerView(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.dashboardCategories,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 0,
    mainAxisSpacing: 0,
    childAspectRatio: 0.88,
  ),
  padding: EdgeInsets.zero,
  itemCount: cards.length,
  itemBuilder: (context, index) {
    final c = cards[index];
    final key = c['titleKey'] as String;
    final title = {
      'dashboardCardWellness': l10n.dashboardCardWellness,
      'dashboardCardPlasticSurgery':
          l10n.dashboardCardPlasticSurgery,
      'dashboardCardDermaesthetic':
          l10n.dashboardCardDermaesthetic,
      'dashboardCardAestheticDentistry':
          l10n.dashboardCardAestheticDentistry,
      'dashboardCardExaminationOrder':
          l10n.dashboardCardExaminationOrder,
      'dashboardCardExaminationResult':
          l10n.dashboardCardExaminationResult,
      'dashboardCardAboutUs': l10n.dashboardCardAboutUs,
      'dashboardCardOurFacilities':
          l10n.dashboardCardOurFacilities,
    }[key]!;

    return GlassMorphDashboardCard(
      title: title,
      imagePath: c['image'] as String,
      keyName: key,
      destination: c['destination'] as Widget?,
      requiresLogin: c['requiresLogin'] as bool? ?? false,
      user: _user,
      backgroundColor: c['color'] as Color, 
    );
  },
),
const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.dashboardArticleUpdates,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigation.push(
                            context,
                            const ArticlesList(),
                          );
                        },
                        child: Text(
                          l10n.commonSeeAll,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.silverColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 180,
                    child: Consumer<ArticleProvider>(
                      builder: (context, articleProvider, _) {
                        if (articleProvider.isLoadingArticles) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final articles = articleProvider.articles;

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: articles.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            final thumbUrl =
                                "https://cms.ngoerahsunwac.co.id${article.attributes.thumbnail?.data?.attributes?.url ?? ''}";

                            final title = article.attributes.title;

                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigation.push(
                                    context,
                                    ArticleDetailView(article: article),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 260,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey.shade100,
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: thumbUrl != null &&
                                              thumbUrl.isNotEmpty
                                          ? (thumbUrl.startsWith('http')
                                              ? Image.network(
                                                  thumbUrl,
                                                  width: 260,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  LocalImages.icNearMedicalLogo,
                                                  fit: BoxFit.cover,
                                                ))
                                          : Image.asset(
                                              LocalImages.icNearMedicalLogo,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 260,
                                      child: Text(
                                        title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.blackColor,
                                        ),
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
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
