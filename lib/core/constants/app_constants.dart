

class AppConstants {
  AppConstants._();

  // Android Client ID from Google Cloud Console
  static const String googleAndroidClientId = 
      '414461300173-06gaak4u9uhejrtfjlj7tp875m96b4b8.apps.googleusercontent.com';

  // Web Client ID from Google Cloud Console
  static const String googleWebClientId = 
      '414461300173-sf6kcc3mnpl7cet540mlh3p5g2v82565.apps.googleusercontent.com';

  // Backend API Base URL
  static const String baseUrl = 'http://austimaiapp.runasp.net/api';

  // Other constants...
  static const String appName = 'NeuroNest';
  static const Duration apiTimeout = Duration(seconds: 30);
}