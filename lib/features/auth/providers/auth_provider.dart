import 'package:neuronest/features/auth/data/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:neuronest/core/services/auth_service.dart';
import 'package:neuronest/features/auth/data/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository(AuthService());

  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isGoogleLoading => _isGoogleLoading;
  String? get errorMessage => _errorMessage;

  bool get isLoggedIn => _currentUser != null;

  // Login method
  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.login(email: email, password: password);

      // print('======================');
      // print('USER FROM REPOSITORY: $user');
      // print('======================');

      if (user != null) {
        _currentUser = user;

        // print('LOGIN SUCCESS');
        // print('USER NAME: ${user.name}');
        // print('TOKEN: ${user.token}');

        return true;
      }

      // print('USER IS NULL');

      _errorMessage = 'Login failed, Invalid email or password.';
      return false;
    } catch (e) {
      // print('AUTH PROVIDER ERROR: $e');
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Signup method
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.signup(
        name: name,
        email: email,
        password: password,
      );
      // if (user != null && user.name != null) {
      //   _currentUser = user;
      //   return true;
      // }

      _errorMessage = 'Signup failed, Invalid email or password.';
      return user;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyEmail({
    required String email,
    required String code,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      return await _repository.verifyEmail(email: email, code: code);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Forgot password method
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _repository.forgotPassword(email);
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _repository.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resendVerification(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      return await _repository.resendVerification(email);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    _isGoogleLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.signInWithGoogle();

      if (user != null) {
        _currentUser = user;
        return true;
      }

      _errorMessage = 'Google Sign In Failed';

      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isGoogleLoading = false;
      notifyListeners();
    }
  }

  // Logout method
  Future<void> logout() async {
    await _repository.logout();

    _currentUser = null;
    _errorMessage = null;

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
