// import 'package:shared_preferences/shared_preferences.dart';

// class PrefHelper {
//   static const String _tokenKey = 'auth_token';
//   static Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(PrefHelper._tokenKey, token);
//   }
//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_tokenKey);
//   }

//   static Future<void> clearToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove(_tokenKey);
//   }

// }

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static const String _tokenKey = 'auth_token';

  // Initialize FlutterSecureStorage with platform-specific options for maximum security
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Saves the authentication token securely.
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Retrieves the stored authentication token.
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Clears the token during logout.
  static Future<void> clearToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  static Future<void> migrateTokenToSecureStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final oldToken = prefs.getString(_tokenKey);

    if (oldToken != null && oldToken.isNotEmpty) {
      await saveToken(oldToken);
      await prefs.remove(_tokenKey);
    }
  }
}
