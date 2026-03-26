String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validateStrongPassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Password is required';
  }

  final password = value.trim();

  if (password.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
    return 'Must contain at least one uppercase letter';
  }
  if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
    return 'Must contain at least one lowercase letter';
  }
  if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
    return 'Must contain at least one number';
  }
  if (!RegExp(
    r'(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>/?])',
  ).hasMatch(password)) {
    return 'Must contain at least one special character';
  }

  return null;
}
