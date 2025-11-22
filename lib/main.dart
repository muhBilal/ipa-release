import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:Ngoerahsun/services/preferences/user_preferences.dart';
import 'package:Ngoerahsun/views/booking_view/detail/book_detail_view.dart';
import 'package:Ngoerahsun/views/splash/splash_view.dart';
import 'package:Ngoerahsun/widgets/app_button/app_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:Ngoerahsun/provider/language/locale_provider.dart';
import 'package:Ngoerahsun/provider/promo/promo_provider.dart';
import 'package:Ngoerahsun/provider/article/article_provider.dart';
import 'package:Ngoerahsun/provider/admission/admission_provider.dart';
import 'package:Ngoerahsun/provider/auth/authen_provider.dart';
import 'package:Ngoerahsun/provider/examination/examination_provider.dart';
import 'package:Ngoerahsun/provider/doctor/doctor_detail_provider.dart';
import 'package:Ngoerahsun/provider/cms/about_us_provider.dart';
import 'package:Ngoerahsun/provider/cms/our_facility_provider.dart';
import 'package:Ngoerahsun/provider/lab/lab_provider.dart';
import 'package:Ngoerahsun/provider/notification/notification_provider.dart';
import 'package:Ngoerahsun/provider/package/package_provider.dart';
import 'package:Ngoerahsun/provider/radiology/radiology_provider.dart';
import 'package:Ngoerahsun/services/auth/auth_service.dart';
import 'package:Ngoerahsun/utils/app_strings/app_strings.dart';
import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:Ngoerahsun/views/bottom_navigation_bar/bottom_navigation_bar_view.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
// import 'package:Ngoerahsun/widgets/app_button/app_button_view.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> initOneSignal() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("3c4853d1-9a6d-4b27-b24b-c5f80af3a3cd");
  await OneSignal.Notifications.requestPermission(true);
  OneSignal.User.pushSubscription.addObserver((state) async {
    final playerId = state.current.id;
    if (playerId != null) {
      await UserPreferences.savePlayerId(playerId);
    }
  });
  for (int i = 0; i < 10; i++) {
    log("Checking for OneSignal Player ID, attempt ${i + 1}/10");
    await Future.delayed(const Duration(seconds: 1));
    final playerId = OneSignal.User.pushSubscription.id;
    if (playerId != null && playerId.isNotEmpty) {
      log("Found OneSignal Player ID: $playerId");
      await UserPreferences.savePlayerId(playerId);
      break;
    }
  }
  final saved = await UserPreferences.getPlayerId();
  log("OneSignal Player ID: $saved");
  OneSignal.Notifications.addClickListener((event) {
    try {
      final data = event.notification.additionalData;
      if (data != null && data['route'] != null) {
        final route = data['route'];
        final params = data['params'] ?? {};
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.toNamed('/$route', arguments: params);
        });
      }
    } catch (e) {
      log("Error handling OneSignal click: $e");
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initOneSignal();
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        Provider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => AuthenProvider()),
        ChangeNotifierProvider(create: (_) => AdmissionProvider()),
        ChangeNotifierProvider(create: (_) => WellnessPackageProvider()),
        ChangeNotifierProvider(create: (_) => ArticleProvider()),
        ChangeNotifierProvider(create: (_) => ExaminationProvider()),
        ChangeNotifierProvider(create: (_) => PromoProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => AboutUsProvider()),
        ChangeNotifierProvider(create: (_) => DoctorDetailProvider()),
        ChangeNotifierProvider(create: (_) => RadiologyProvider()),
        ChangeNotifierProvider(create: (_) => LabProvider()),
        ChangeNotifierProvider(create: (_) => OurFacilityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    const key = "isFirstLaunch";
    final first = prefs.getBool(key) ?? true;
    if (first) await prefs.setBool(key, false);
    return first;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _savePlayerIdToServer(context);
    });
  }

  Future<void> _savePlayerIdToServer(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    final playerId = await UserPreferences.getPlayerId();
    if (playerId == null || playerId.isEmpty) return;
    final authProvider = Provider.of<AuthenProvider>(context, listen: false);
    await authProvider.savePlayerId(playerId: playerId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProv, _) {
        return GetMaterialApp(
          key: ValueKey(localeProv.locale?.languageCode ?? 'id'),
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          theme:
              ThemeData(fontFamily: 'Montserrat', primarySwatch: Colors.blue),
          locale: localeProv.locale ?? const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const SplashView()),
            GetPage(name: '/home', page: () => const BottomNavigationBarView()),
            GetPage(name: '/booking-detail', page: () => const BookingDetailScreen()),
          ],
          home: FutureBuilder<bool>(
            future: isFirstLaunch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.data == true) {
                return const SplashView();
              }
              return const BottomNavigationBarView();
            },
          ),
        );
      },
    );
  }
}

