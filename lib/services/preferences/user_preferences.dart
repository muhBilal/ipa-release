import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Ngoerahsun/model/user_model.dart';

class UserPreferences {
  static const _userKey = 'user_data';
  static const _isFirstLaunc = 'is_first_launch';
  static const _playerIdKey = 'onesignal_player_id';

  static Future<void> saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userKey, userJson);
    } catch (e) {
      log("Error saving user: $e");
    }
  }

  static Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_userKey);
      if (userString != null && userString.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        final user = UserModel.fromJson(userMap);
        return user;
      }
      return null;
    } catch (e) {
      log("Error getting user: $e");
      return null;
    }
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<bool> hasUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }

  // First Launch Methods
  static Future<void> setFirstLaunch(bool isFirstLaunch) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunc, isFirstLaunch);
  }

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstLaunc) ?? true;
  }

  static Future<void> savePlayerId(String playerId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_playerIdKey, playerId);

    } catch (e) {
    }
  }

  static Future<String?> getPlayerId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final playerId = prefs.getString(_playerIdKey);
      return playerId;
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearPlayerId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_playerIdKey);
    } catch (e) {
    }
  }

  static Future<bool> hasPlayerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_playerIdKey);
  }
}