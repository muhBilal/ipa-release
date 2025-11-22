import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreferences {
  static const _languageKey = 'en';

  static Future<void> saveLanguageCode(String code) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, code);
      log('Language saved: $code');
    } catch (e) {
      log('Error saving language: $e');
    }
  }

  static Future<String?> getLanguageCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_languageKey);
    } catch (e) {
      log('Error getting language: $e');
      return null;
    }
  }

  static Future<void> clearLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_languageKey);
      log('Language preference cleared');
    } catch (e) {
      log('Error clearing language: $e');
    }
  }
}
