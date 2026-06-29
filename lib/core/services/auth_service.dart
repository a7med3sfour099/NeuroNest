import 'package:neuronest/core/constants/app_constants.dart';
import 'package:neuronest/core/network/api_error.dart';
import 'package:neuronest/core/network/api_service.dart';
import 'package:neuronest/core/utils/pref_helpers.dart';
import 'package:neuronest/features/auth/data/user_model.dart';
import 'package:flutter/foundation.dart';
// Firebase Auth is optional in this project; keep imports guarded
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final ApiService _api = ApiService();

  // Login with email and password
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _api.post('/auth/login', {
        'email': email.trim(),
        'password': password,
      });
      // print('======================');
      // print('RESPONSE TYPE => ${response.runtimeType}');
      // print('RESPONSE DATA => $response');
      // print('======================');

      debugPrint('LOGIN RESPONSE: $response');

      if (response is Map<String, dynamic>) {
        final token = response['token'];

        if (token != null) {
          await PrefHelper.saveToken(token.toString());
          debugPrint('TOKEN SAVED');
        }

        final user = UserModel(
          name: response['fullName'] ?? '',
          email: response['email'] ?? email,
          token: token?.toString(),
        );

        debugPrint('USER CREATED: ${user.name}');

        // print('USER CREATED => ${user.name}');
        return user;
      }

      debugPrint('Response is not Map<String,dynamic>');
      return null;
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }

  /// Sign up new user
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final body = {
        'fullName': name.trim(),
        'email': email.trim(),
        'password': password,
      };

      // print('======================');
      // print(body.runtimeType);
      // print(body);
      // print('======================');

      final response = await _api.post('/auth/register', body);

      debugPrint('SIGNUP RESPONSE: $response');

      return response is Map<String, dynamic>;

      // return null;
    } catch (e) {
      debugPrint('Signup error: $e');
      return false;
    }
  }

  Future<bool> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _api.post('/auth/verify-email', {
        'email': email,
        'code': code,
      });

      return response is! ApiError;
    } catch (e) {
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _api.post('/auth/forgot-password', {
        'email': email.trim(),
      });

      debugPrint('FORGOT PASSWORD RESPONSE: $response');

      return response is! ApiError;
    } catch (e) {
      debugPrint('Forgot password error: $e');
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await _api.post('/auth/reset-password', {
        'email': email,
        'code': code,
        'newPassword': newPassword,
      });

      print('RESET RESPONSE => $response');

      return response is! ApiError;
    } catch (e) {
      print('RESET ERROR => $e');
      return false;
    }
  }

  // Resend verification
  Future<bool> resendVerification(String email) async {
    try {
      final response = await _api.post('/auth/resend-verification', {
        'email': email,
      });

      return response != null;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // Google Sign-In

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Future<UserModel?> signInWithGoogle() async {
    // Use backend Google sign-in with Google ID token only.
    try {
      await _googleSignIn.initialize(
        serverClientId: AppConstants.googleWebClientId,
      );

      debugPrint("GOOGLE INITIALIZED");

      GoogleSignInAccount? googleUser;

      try {
        googleUser = await _googleSignIn.attemptLightweightAuthentication();
      } catch (lightweightError) {
        debugPrint("Lightweight auth failed: $lightweightError");
      }

      // ignore: prefer_conditional_assignment
      if (googleUser == null) {
        googleUser = await _googleSignIn.authenticate();
      }

      // ignore: unnecessary_null_comparison, dead_code
      if (googleUser == null) return null;

      debugPrint("ACCOUNT => ${googleUser.email}");

      // Backend needs Google ID token.
      // FirebaseAuth integration is currently disabled in this project.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        debugPrint('GoogleSignInAuthentication.idToken is null/empty');
        return null;
      }

      final response = await _api.post('/auth/google-signin', {
        'idToken': idToken,
      });

      debugPrint('GOOGLE API RESPONSE: $response');

      if (response is Map<String, dynamic>) {
        final token = response['token'];

        if (token != null) {
          await PrefHelper.saveToken(token.toString());
          debugPrint('GOOGLE AUTH TOKEN SAVED');
        }

        return UserModel(
          name: response['fullName'] ?? googleUser.displayName ?? '',
          email: response['email'] ?? googleUser.email ?? '',
          token: token?.toString(),
        );
      }

      return null;
    } catch (e, s) {
      debugPrint("GOOGLE LOGIN CRITICAL ERROR => $e");
      debugPrint("STACK => $s");
      return null;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _api.post('/auth/logout', {});
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      await PrefHelper.clearToken();
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await PrefHelper.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _api.get('/auth/me');

      if (response is Map<String, dynamic>) {
        return UserModel(
          name: response['fullName'] ?? '',
          email: response['email'] ?? '',
          token: response['token'],
        );
      }

      return null;
    } catch (e) {
      debugPrint('Get current user error: $e');
      return null;
    }
  }
}
