import 'package:shared_preferences/shared_preferences.dart';
import 'package:neuronest/features/auth/data/user_model.dart';
import 'dart:convert';

class ProfileStorageService {
  static final ProfileStorageService _instance =
      ProfileStorageService._internal();

  factory ProfileStorageService() {
    return _instance;
  }

  ProfileStorageService._internal();

  static const String _userKey = 'user_profile_data';

  /// Save user profile to SharedPreferences
  Future<bool> saveUserProfile(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      return await prefs.setString(_userKey, userJson);
    } catch (e) {
      print('Error saving user profile: $e');
      return false;
    }
  }

  /// Load user profile from SharedPreferences
  Future<UserModel?> loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        final Map<String, dynamic> jsonData = jsonDecode(userJson);
        return UserModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      print('Error loading user profile: $e');
      return null;
    }
  }

  /// Clear user profile
  Future<bool> clearUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_userKey);
    } catch (e) {
      print('Error clearing user profile: $e');
      return false;
    }
  }

  /// Check if user profile exists
  Future<bool> hasUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_userKey);
    } catch (e) {
      print('Error checking user profile: $e');
      return false;
    }
  }
}
