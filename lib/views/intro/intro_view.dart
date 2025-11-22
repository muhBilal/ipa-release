import 'package:flutter/material.dart';
import 'package:Ngoerahsun/core/navigation/navigator.dart';
import 'package:Ngoerahsun/utils/app_images/app_images.dart';
import 'package:Ngoerahsun/views/login/login_view.dart';
import 'package:Ngoerahsun/widgets/app_button/app_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  // final List<Map<String, dynamic>> introImgDetail = [
  //   {
  //     "image": LocalImages.icIntroImgFirst,
  //     "title": AppStrings.firstTitle,
  //     "description": AppStrings.firstDescription,
  //   },
  //   {
  //     "image": LocalImages.icIntroImgSecond,
  //     "title": AppStrings.secondTitle,
  //     "description": AppStrings.secondDescription,
  //   },
  //   {
  //     "image": LocalImages.icSBottomThird,
  //     "title": AppStrings.thirdTitle,
  //     "description": AppStrings.thirdDescription,
  //   },
  //   {
  //     "image": LocalImages.icSBottomThird,
  //     "title": AppStrings.thirdTitle,
  //     "description": AppStrings.thirdDescription,
  //   },
  // ];

final List<Map<String, dynamic>> introImgDetail = [
  {
    "image": LocalImages.icIntroImgFirst,
    "title": "WELLNESS",
    "description": "Focus on overall health and wellbeing, offering personalized treatments and services.",
  },
  {
    "image": LocalImages.icIntroImgSecond,
    "title": "DERMAESTHETIC",
    "description": "Explore innovative skin treatments and cosmetic dermatology for a rejuvenated look.",
  },
  {
    "image": LocalImages.icSBottomThird,
    "title": "PLASTIC SURGERY",
    "description": "Enhance your appearance with advanced surgical techniques for facial and body aesthetics.",
  },
  {
    "image": LocalImages.icSBottomFourth,
    "title": "AESTHETIC DENTISTRY",
    "description": "Achieve a perfect smile with state-of-the-art dental procedures for cosmetic enhancement.",
  },
];


  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_controller.page?.toInt() == introImgDetail.length - 1) {
      Navigation.push(
        context,
        const SignInView(),
      );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: introImgDetail.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.asset(introImgDetail[index]['image']),
                    // const SizedBox(height: 10),
                    // Text(
                    //   introImgDetail[index]['title']!,
                    //   style: const TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //     color: Color(0xFF374151),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //   child: Text(
                    //     introImgDetail[index]['description']!,
                    //     textAlign: TextAlign.center,
                    //     style: const TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.normal,
                    //       color: Color(0xFF6B7280),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // 🔹 Tengah vertikal
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            introImgDetail[index]['title']!,
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF26232F),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              introImgDetail[index]['description']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.5, // 🔹 lebih nyaman dibaca
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30) +
                const EdgeInsets.only(bottom: 14),
            child: AppButtonView(
              text: "Next",
              onTap: _onNextPressed,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SmoothPageIndicator(
              controller: _controller, // PageController
              count: introImgDetail.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 10,
                expansionFactor: 2.5,
                spacing: 8,
                activeDotColor: Color(0xFF26232F),
                dotColor: Color(0xFF9B9B9B),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: InkWell(
              onTap: () {
                Navigation.push(
                  context,
                  const SignInView(),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
