import 'package:neuronest/core/services/auth_service.dart';
import 'package:neuronest/features/auth/data/auth_repo.dart' as _authService;
import 'package:neuronest/features/auth/data/user_model.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    return await _authService.login(email, password);
  }

  Future<UserModel?> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authService.signup(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<bool> verifyEmail({
  required String email,
  required String code,
}) {
  return _authService.verifyEmail(
    email: email,
    code: code,
  );
}

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  Future<bool> forgotPassword(String email) async {
    return await _authService.forgotPassword(email);
  }

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    return await _authService.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
  }

  Future<UserModel?> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }

  Future<UserModel?> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  Future<bool> resendVerification(String email) {
    return _authService.resendVerification(email);
  }
}
