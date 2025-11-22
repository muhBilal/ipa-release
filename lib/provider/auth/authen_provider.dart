import 'dart:developer';
import 'dart:io';

import 'package:Ngoerahsun/model/user_model.dart';
import 'package:Ngoerahsun/services/auth/auth_service.dart';
import 'package:Ngoerahsun/services/preferences/user_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthenProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;
  UserModel? get user => _userModel;

  bool _isLoadingSavePlayerId = false;
  bool get isLoadingSavePlayerId => _isLoadingSavePlayerId;

  Future<bool> sendOtp(String phoneNumber, String countryCode) async {
    try {
      await _authService.sendOtp(phoneNumber, countryCode);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error sending OTP: $e");
      }
      return false;
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    String? email,
    String? countryCode,
    required String phoneNumber,
    String? gender,
    String? dateOfBirth,
    bool? isWni,
    String? nik,
  }) async {
    _isRegistering = true;
    notifyListeners();
    try {
      final result = await _authService.register(
        name: name,
        email: email,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        gender: gender,
        dateOfBirth: dateOfBirth,
        isWni: isWni,
        nik: nik,
      );

      if (result['ok'] == true) {
        try {
          _userModel = await _authService.getUser(null, phoneNumber);
          if (_userModel != null) {
            await UserPreferences.saveUser(_userModel!);
            log('User saved after register');
          }
        } catch (e) {
          log('getUser after register failed: $e');
        }
      }

      return result;
    } catch (e) {
      log('register wrapper error: $e');
      return {'ok': false, 'message': 'Terjadi kesalahan: $e'};
    } finally {
      _isRegistering = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(
      String countryCode, String phoneNumber, String otp) async {
    try {
      var fullNumber = countryCode + phoneNumber;
      bool isVerified = await _authService.verifyOtp(fullNumber, otp);
      if (isVerified) {
        _userModel = await _authService.getUser(null, phoneNumber);
        if (_userModel != null) {
          await UserPreferences.saveUser(_userModel!);
          print("User saved to preferences");
          final savedUser = await UserPreferences.getUser();
          print("Verification - saved user: ${savedUser?.toJson()}");
          return true;
        } else {
          print("User model is null, cannot save");
        }
      }
      return false;
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }

  Future<bool> updateUser({
    required int id,
    required String nama,
    required String email,
    required String noTelp,
    required String jkel,
    required bool isWni,
    String? noKtp,
    String? noPassport,
    String? countryCode,
    String? dateOfBirth,
    File? photoFile,
  }) async {
    final ok = await _authService.updateUser(
      id: id,
      nama: nama,
      email: email,
      noTelp: noTelp,
      jkel: jkel,
      isWni: isWni,
      noKtp: noKtp,
      noPassport: noPassport,
      countryCode: countryCode,
      dateOfBirth: dateOfBirth,
      photoFile: photoFile,
    );
    if (ok) {
      try {
        final refreshed = await _authService.getUser(email, noTelp);
        if (refreshed != null) {
          _userModel = refreshed;
          await UserPreferences.saveUser(refreshed);
          notifyListeners();
        }
      } catch (_) {}
    }
    return ok;
  }

  Future<void> savePlayerId({
    required String playerId,
  }) async {
    _isLoadingSavePlayerId = true;
    notifyListeners();
    final success = await _authService.savePlayerId(
      playerId: playerId,
    );
    _isLoadingSavePlayerId = false;
    notifyListeners();
    if (!success) {
    }
  }
}
