import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();
  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF000000);
  static const silverColor = Color(0xFFCBCBCB);
  static const athensGrayColor = Color(0xFFF3F4F6);
  static const loganColor = Color(0xFFACA1CD);
  static const petiteOrchidColor = Color(0xFFDC9497);
  static const jacartaColor = Color(0xFF352261);
  static const cameoColor = Color(0xFFD7A99C);
  static const breakerBayColor = Color(0xFF4D9B91);
  static const mirageColor = Color(0xFF1C2A3A);
  static const paleSkyColor = Color(0xFF6B7280);
  static const riverBedColor = Color(0xFF4B5563);
  static const grannyAppleColor = Color(0xFFDEF7E5);
  static const cinderellaColor = Color(0xFFFDE8E8);
  static const oxfordBlueColor = Color(0xFF374151);
  static const ebonyClayColor = Color(0xFF1F2A37);
  // Primary Colors
  static const Color primary = Color(0xFF4E98D3);
  static const Color primary1 = Color(0xFF4E98D3);
  static const Color primary1Active = Color(0xFF3A7BB0);
  static const Color primaryLight = Color(0xFFE8E7FF);
  static const Color primaryLight1 = Color(0xFF74A9DA);
  static const Color primaryLight2 = Color(0xFF94BAE3);
  static const Color primaryLight3 = Color(0xFFBBCFEC);
  static const Color primaryLight4 = Color(0xFFD9E5F5);
  static const Color primaryDark = Color(0xFF3A76C9);

  // Secondary Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF231F20);
  static const Color greyLight1 = Color(0xFFD9D9D9);
  static const Color greyLight2 = Color(0xFFB2B2B2);
  static const Color greyLight3 = Color(0xFF808080);
  static const Color greyDark1 = Color(0xFF4D4D4D);
  static const Color greyDark2 = Color(0xFF58595B);

  // Tertiary Colors
  static const Color teal = Color(0xFF61BAC1);
  static const Color blue = Color(0xFF5473B8);
  static const Color orange = Color(0xFFF26B24);

  //  static const Color oxfordBlueColor = Color(0xFF022B42); // Deep blue for primary elements
  // static const Color ebonyClayColor = Color(0xFF1A2E35); // Darker shade for text and headings
  static const Color backgroundLight = Color(0xFFF9FAFB); // Light background for scaffold

  // Secondary colors
  static const Color accentBlue = Color(0xFF1976D2); // Vibrant blue for buttons and highlights
  static const Color accentGreen = Color(0xFF10B981); // Green for certifications and success states
  static const Color accentAmber = Color(0xFFFFB300); // Amber for ratings and warnings

  // Neutral colors
  static const Color greyLight = Color(0xFFE5E7EB); // Light grey for borders and dividers
  static const Color greyMedium = Color(0xFF6B7280); // Medium grey for secondary text
  static const Color greyDark = Color(0xFF374151); // Dark grey for subtle text

  // Background and surface colors
  static const Color cardBackground = Color(0xFFFFFFFF); // White for cards and containers
  static const Color shadowColor = Color(0x1A000000); // Subtle shadow color with opacity

  // Semantic colors
  static const Color errorRed = Color(0xFFE53935); // Red for error states
  static const Color successGreen = Color(0xFF2ECC71); // Green for success states
  static const Color infoBlue = Color(0xFF0288D1); // Blue for informational elements

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [oxfordBlueColor, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [cardBackground, Color(0xFFF1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color tealish = Color(0xFF61BAC1); 
  static const Color blueSlate = Color(0xFF5473B8); 
  static const Color orangePop = Color(0xFFF26B24);
}