import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:ngoerahsun/model/user_model.dart';
import 'package:ngoerahsun/provider/auth/authen_provider.dart';
import 'package:ngoerahsun/services/preferences/user_preferences.dart';
import 'package:ngoerahsun/utils/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:ngoerahsun/services/preferences/firebase_user_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;
  UserModel? _lastUserModel;
  UserModel? get lastUserModel => _lastUserModel;
  GoogleSignInAccount? _currentGoogleUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  GoogleSignInAccount? get currentGoogleUser => _currentGoogleUser;
  ResourceRepository repo = ResourceRepository();

  Future<void> _initializeGoogleSignIn() async {
    if (_isGoogleSignInInitialized) return;

    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
      log('Google Sign-In initialized successfully');
    } catch (e) {
      log('Failed to initialize Google Sign-In: $e');
      rethrow;
    }
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      if (!_googleSignIn.supportsAuthenticate()) {
        log("❌ Platform does not support Google Sign-In authentication");
        throw UnsupportedError(
            'Platform does not support Google Sign-In authentication');
      }
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate(scopeHint: ['email']);
      _currentGoogleUser = googleUser;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);
      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      log("✅ Firebase sign-in success");
      final u = userCredential.user;
      final email = u?.email ?? '';
      final name = u?.displayName ?? '';
      final phone = u?.phoneNumber ?? '';
      final photoUrl = u?.photoURL ?? '';

      if (email.isEmpty) {
        log("❌ Google email unavailable");
        throw Exception('Google email unavailable');
      }
      UserModel? userModel = await getUser(email, null);

      if (userModel == null) {
        log("ℹ️ User belum ada, coba register via backend");
        final result = await register(
          name: name.isNotEmpty ? name : email.split('@').first,
          email: email,
          phoneNumber: phone.isNotEmpty ? phone : "-",
          photoUrl: photoUrl,
        );

        if (result['ok'] != true) {
          final msg = result['message'] ?? 'Register failed';
          log("❌ Register gagal: $msg");
          throw Exception(msg);
        }

        userModel = await getUser(email, null);
        if (userModel == null) {
          log("❌ User not found after successful register");
          throw Exception('User not found after register');
        }
      }

      _lastUserModel = userModel;
      return userCredential;
    } catch (error, st) {
      log("❌ Unknown error in signInWithGoogle: $error\n$st");
      _currentGoogleUser = null;
      rethrow;
    }
  }

  Future<UserCredential?> signInSilently() async {
    try {
      await _ensureGoogleSignInInitialized();

      final result = _googleSignIn.attemptLightweightAuthentication();

      GoogleSignInAccount? googleUser;

      if (result is Future<GoogleSignInAccount?>) {
        googleUser = await result;
      } else {
        googleUser = result as GoogleSignInAccount?;
      }

      if (googleUser == null) {
        return null;
      }

      _currentGoogleUser = googleUser;

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await FirebaseUserPreferences.saveUserData(userCredential.user!);
        log('Silent Google Sign-In successful: ${userCredential.user?.email}');
        log('User data saved to preferences');
      }

      return userCredential;
    } catch (error) {
      log('Silent Google Sign-In failed: $error');
      _currentGoogleUser = null;
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);

      _currentGoogleUser = null;
      await FirebaseUserPreferences.clearUserData();
      debugPrint('User signed out successfully');
    } catch (error) {
      debugPrint('Sign out error: $error');
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user signed in');
      }

      if (user.providerData.any((info) => info.providerId == 'google.com')) {
        await _reauthenticateWithGoogle();
      }

      await user.delete();
      await _googleSignIn.signOut();

      _currentGoogleUser = null;
      await FirebaseUserPreferences.clearUserData();
      debugPrint('Account deleted successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        debugPrint('Re-authentication required for account deletion');
        throw Exception('Please sign in again to delete your account');
      }
      debugPrint('Delete account Firebase error: ${e.code} - ${e.message}');
      rethrow;
    } catch (error) {
      debugPrint('Delete account error: $error');
      rethrow;
    }
  }

  Future<void> _reauthenticateWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();

      final user = _auth.currentUser;
      if (user == null) throw Exception('No user signed in');

      GoogleSignInAccount? googleUser;
      final result = _googleSignIn.attemptLightweightAuthentication();

      if (result is Future<GoogleSignInAccount?>) {
        googleUser = await result;
      } else {
        googleUser = result as GoogleSignInAccount?;
      }

      if (googleUser == null) {
        googleUser = await _googleSignIn.authenticate(scopeHint: ['email']);
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleAuth.idToken,
      );

      await user.reauthenticateWithCredential(credential);
      debugPrint('Re-authentication successful');
    } catch (error) {
      debugPrint('Re-authentication error: $error');
      rethrow;
    }
  }

  String getGoogleSignInErrorMessage(dynamic exception) {
    if (exception is GoogleSignInException) {
      switch (exception.code.name) {
        case 'canceled':
          return 'Sign-in was cancelled. Please try again if you want to continue.';
        case 'interrupted':
          return 'Sign-in was interrupted. Please try again.';
        case 'clientConfigurationError':
          return 'There is a configuration issue with Google Sign-In. Please contact support.';
        case 'providerConfigurationError':
          return 'Google Sign-In is currently unavailable. Please try again later.';
        case 'uiUnavailable':
          return 'Google Sign-In UI is currently unavailable. Please try again later.';
        case 'userMismatch':
          return 'There was an issue with your account. Please sign out and try again.';
        case 'unknownError':
        default:
          return 'An unexpected error occurred during Google Sign-In. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }

  Future<bool> sendOtp(String phoneNumber, String countryCode) async {
    final String url = repo.getSendOtpUrl;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'phone_number': phoneNumber, 'country_code': countryCode}),
      );
      log("sendOtp response: ${response.body} phone number: $phoneNumber");
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to send OTP');
      }
    } catch (error) {
      debugPrint('Error sending OTP: $error');
      rethrow;
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String otpCode) async {
    final String url = repo.getVerifyOtpUrl;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'phone_number': phoneNumber, 'otp_code': otpCode}),
      );

      log("verifyOtp response: ${response.body} phone number: $phoneNumber, otp: $otpCode");
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (error) {
      debugPrint('Error verifying OTP: $error');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String? email, String? phone) async {
    try {
      final String url = repo.getUserUrl;
      final uri = Uri.parse(url).replace(queryParameters: {
        'email': email,
        'phone': phone,
      });
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];
        final muid = data['muid'];
        final playerId = await UserPreferences.getPlayerId();
        if (playerId != null && playerId.isNotEmpty) {
          log("debug store user player id from preferences: $playerId");
          unawaited(savePlayerId(playerId: playerId, uid: muid));
        }
        return UserModel.fromJson(data);
      }
      if (response.statusCode == 404) {
        return null;
      }

      throw Exception('Failed to load user: ${response.statusCode}');
    } catch (e) {
      rethrow;
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
    String? photoUrl,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final String url = repo.getRegisterUrl;
    try {
      final body = {
        'name': name,
        'email': email,
        'country_code': countryCode,
        'phone_number': phoneNumber,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'isWni': isWni == true ? '1' : '0',
        'nik': nik,
        'photo_url': photoUrl,
      }..removeWhere((k, v) => v == null || v == '');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeout);

      log("debug response register ${response.statusCode} and body ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final ok = decoded['status'] == true || decoded['status'] == 'true';
        return {
          'ok': ok,
          'message': decoded['message'] ?? '',
        };
      } else {
        return {
          'ok': false,
          'message': decoded['message'] ?? 'Register gagal',
        };
      }
    } catch (e, st) {
      log('register error: $e\n$st');
      return {
        'ok': false,
        'message': 'Terjadi kesalahan: $e',
      };
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
    final String url = repo.getUpdateUserUrl;
    try {
      final Map<String, String> fields = {
        'id': id.toString(),
        'Nama': nama,
        'email': email,
        'NoTelp': noTelp,
        'Jkel': jkel,
        'isWni': isWni ? '1' : '0',
        if (noKtp != null && noKtp.isNotEmpty) 'NoKTP': noKtp,
        if (noPassport != null && noPassport.isNotEmpty)
          'NoPassport': noPassport,
        if (countryCode != null && countryCode.isNotEmpty)
          'country_code': countryCode,
        if (dateOfBirth != null && dateOfBirth.isNotEmpty)
          'date_of_birth': dateOfBirth,
      };

      http.Response response;

      if (photoFile != null) {
        final req = http.MultipartRequest('POST', Uri.parse(url));
        fields.forEach((k, v) => req.fields[k] = v);

        final fileName = photoFile.path.split('/').last;
        req.files.add(
          await http.MultipartFile.fromPath(
            'photo_url',
            photoFile.path,
            filename: fileName,
          ),
        );
        req.headers.addAll({
          'Accept': 'application/json',
        });

        final streamed = await req.send();
        response = await http.Response.fromStream(streamed);
      } else {
        final body = {...fields};
        response = await http.post(
          Uri.parse(url),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        );
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['status'] == true;
      } else {
        debugPrint('Update user failed: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Update user error: $e');
      return false;
    }
  }

  Future<bool> savePlayerId({
    required String playerId,
    int? uid,
  }) async {
    final String url = repo.getStorePlayerIdUrl;
    try {
      final UserModel? user = await UserPreferences.getUser();
      final userId = uid ?? user?.muid;
      if (userId == null) {
        log("No user found to associate player ID");
        return false;
      }
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'user_id': userId,
          'player_id': playerId,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
