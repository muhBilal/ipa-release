import 'package:flutter/material.dart';
import 'package:Ngoerahsun/services/preferences/language_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;
  bool _isLoaded = false;

  LocaleProvider() {
    _init();
  }

  Future<void> _init() async {
    if (_isLoaded) return;
    final code = await LanguagePreferences.getLanguageCode();
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await LanguagePreferences.saveLanguageCode(locale.languageCode);
    notifyListeners();
  }

  Future<void> clearLocale() async {
    _locale = null;
    await LanguagePreferences.clearLanguage();
    notifyListeners();
  }
}
