import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserPreferences {
  static const String _userDataKey = 'user_data';
  // static const String _isFirstLaunchKey = 'is_first_launch';
  // static const String _themeKey = 'theme_mode';
  // static const String _languageKey = 'language_code';
  // static const String _notificationKey = 'notifications_enabled';
  
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveUserData(User user) async {
    await init();
    
    final userData = {
      'uid': user.uid,
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'phoneNumber': user.phoneNumber,
      // 'isEmailVerified': user.isEmailVerified,
      'isAnonymous': user.isAnonymous,
      'providerId': user.providerData.isNotEmpty ? user.providerData.first.providerId : null,
      'creationTime': user.metadata.creationTime?.millisecondsSinceEpoch,
      'lastSignInTime': user.metadata.lastSignInTime?.millisecondsSinceEpoch,
      'tenantId': user.tenantId,
      'providerData': user.providerData.map((info) => {
        'uid': info.uid,
        'displayName': info.displayName,
        'email': info.email,
        'phoneNumber': info.phoneNumber,
        'photoURL': info.photoURL,
        'providerId': info.providerId,
      }).toList(),
    };
    
    final userDataJson = jsonEncode(userData);
    await _prefs!.setString(_userDataKey, userDataJson);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    await init();
    final userDataJson = _prefs!.getString(_userDataKey);
    if (userDataJson != null) {
      return jsonDecode(userDataJson) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<void> clearUserData() async {
    await init();
    await _prefs!.remove(_userDataKey);
  }

  static Future<void> clearAllPreferences() async {
    await init();
    await _prefs!.clear();
  }

  static String? getUserUid() {
    final userDataJson = _prefs?.getString(_userDataKey);
    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
      return userData['uid'] as String?;
    }
    return null;
  }

  static String? getUserEmail() {
    final userDataJson = _prefs?.getString(_userDataKey);
    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
      return userData['email'] as String?;
    }
    return null;
  }

  static String? getUserDisplayName() {
    final userDataJson = _prefs?.getString(_userDataKey);
    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
      return userData['displayName'] as String?;
    }
    return null;
  }

  static String? getUserPhotoURL() {
    final userDataJson = _prefs?.getString(_userDataKey);
    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
      return userData['photoURL'] as String?;
    }
    return null;
  }

  static bool isUserEmailVerified() {
    final userDataJson = _prefs?.getString(_userDataKey);
    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
      return userData['isEmailVerified'] as bool? ?? false;
    }
    return false;
  }

  static DateTime? getUserCreationTime() {
    final userDataJson = _prefs?.getString(_userDataKey);
    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
      final timestamp = userData['creationTime'] as int?;
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    }
    return null;
  }

  static DateTime? getUserLastSignInTime() {
    final userDataJson = _prefs?.getString(_userDataKey);
    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
      final timestamp = userData['lastSignInTime'] as int?;
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    }
    return null;
  }
}