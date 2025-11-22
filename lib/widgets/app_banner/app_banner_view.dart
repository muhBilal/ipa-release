import 'dart:async';
import 'dart:developer';
import 'package:Ngoerahsun/provider/promo/promo_provider.dart';
import 'package:Ngoerahsun/views/promos/detail_promo_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';

class AppBannerView extends StatefulWidget {
  const AppBannerView({super.key});

  @override
  _AppBannerViewState createState() => _AppBannerViewState();
}

class _AppBannerViewState extends State<AppBannerView> {
  final PageController _controller = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        Provider.of<PromoProvider>(context, listen: false).loadPromos());

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      final provider = Provider.of<PromoProvider>(context, listen: false);
      if (provider.promos.isEmpty) return;
      if (!_controller.hasClients) return;

      int currentPage = _controller.page?.round() ?? 0;
      int nextPage = currentPage + 1;

      if (nextPage >= provider.promos.length) {
        nextPage = 0;
      }

      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PromoProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const SizedBox(
            height: 175,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (provider.error != null) {
          return SizedBox(
            height: 175,
            child: Center(child: Text("Error: ${provider.error}")),
          );
        }
        if (provider.promos.isEmpty) {
          return const SizedBox(
            height: 175,
            child: Center(child: Text("No promos available")),
          );
        }

        return Card(
          elevation: 5,
          child: Stack(
            children: [
              SizedBox(
                height: 175,
                width: double.infinity,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: provider.promos.length,
                  itemBuilder: (context, index) {
                    final promo = provider.promos[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PromoDetailPage(promo: promo),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(promo.image),
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2),
                              BlendMode.softLight,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          // children: [
                          //   Text(
                          //     promo.title,
                          //     style: const TextStyle(
                          //       fontSize: 18,
                          //       fontWeight: FontWeight.bold,
                          //       color: AppColors.whiteColor,
                          //     ),
                          //   ),
                          //   const SizedBox(height: 8),
                          //   Text(
                          //     promo.description,
                          //     style: const TextStyle(
                          //       fontSize: 14,
                          //       color: AppColors.whiteColor,
                          //     ),
                          //   ),
                          // ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: provider.promos.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 10,
                      expansionFactor: 2.5,
                      spacing: 8,
                      activeDotColor: AppColors.whiteColor,
                      dotColor: Color(0xFF9B9B9B),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
