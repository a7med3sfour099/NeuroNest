import 'package:flutter/material.dart';
import 'package:neuronest/features/auth/data/user_model.dart';
import 'package:neuronest/core/services/profile_storage_service.dart';
import 'package:neuronest/core/services/image_service.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  final ProfileStorageService _storageService = ProfileStorageService();
  final ImageService _imageService = ImageService();

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize by loading user profile from storage
  Future<void> initializeProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedUser = await _storageService.loadUserProfile();
      if (savedUser != null) {
        _user = savedUser;
        _errorMessage = null;
      } else {
        // Create default user if none exists
        _user = UserModel(
          name: 'Guest User',
          email: 'guest@example.com',
          address: 'Your Address',
        );
      }
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile(UserModel updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _storageService.saveUserProfile(updatedUser);
      if (success) {
        _user = updatedUser;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to save profile';
      }
      return success;
    } catch (e) {
      _errorMessage = 'Error updating profile: $e';
      print(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Pick image from camera
  Future<String?> pickImageFromCamera() async {
    try {
      return await _imageService.pickFromCamera();
    } catch (e) {
      _errorMessage = 'Error picking image from camera: $e';
      notifyListeners();
      return null;
    }
  }

  /// Pick image from gallery
  Future<String?> pickImageFromGallery() async {
    try {
      return await _imageService.pickFromGallery();
    } catch (e) {
      _errorMessage = 'Error picking image from gallery: $e';
      notifyListeners();
      return null;
    }
  }

  /// Update only the user name
  Future<bool> updateUserName(String newName) async {
    if (_user == null) return false;
    final updatedUser = _user!.copyWith(name: newName);
    return await updateUserProfile(updatedUser);
  }

  /// Update only the user email
  Future<bool> updateUserEmail(String newEmail) async {
    if (_user == null) return false;
    final updatedUser = _user!.copyWith(email: newEmail);
    return await updateUserProfile(updatedUser);
  }

  /// Update only the user address
  Future<bool> updateUserAddress(String newAddress) async {
    if (_user == null) return false;
    final updatedUser = _user!.copyWith(address: newAddress);
    return await updateUserProfile(updatedUser);
  }

  /// Update only the user image
  Future<bool> updateUserImage(String newImagePath) async {
    if (_user == null) return false;

    // Delete old image if it exists
    if (_user!.image != null && _imageService.isLocalImage(_user!.image)) {
      await _imageService.deleteImage(_user!.image);
    }

    final updatedUser = _user!.copyWith(image: newImagePath);
    return await updateUserProfile(updatedUser);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Refresh user profile from storage
  Future<void> refreshProfile() async {
    await initializeProfile();
  }
}
