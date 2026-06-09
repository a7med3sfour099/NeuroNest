String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[a-zA-Z]{2,}$').hasMatch(value.trim())) {
    return 'Invalid email';
  }
  return null;
}

String? validateStrongPassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Password is required';
  }

  final password = value.trim();

  if (password.length < 8) {
    return 'Password must be at least 8 characters';
  }
  if (!RegExp(r'[a-zA-Z]').hasMatch(password)) {
    return 'Add at least one letter';
  }
  if ((!RegExp(r'\d').hasMatch(password))) {
    return 'Add at least one number';
  }

  return null;
}
