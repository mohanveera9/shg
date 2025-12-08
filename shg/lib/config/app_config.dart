class AppConfig {
  static const String apiBaseUrl = 'https://shg-server.onrender.com/api';
  static const String defaultLanguage = 'te';
  static const String appName = 'SHG Management';
  static const String appVersion = '1.0.0';
  
  static const int otpLength = 6;
  static const int otpResendTime = 60;
  
  static const List<String> supportedLanguages = ['te', 'en'];
  static const Map<String, String> languageNames = {
    'te': 'తెలుగు',
    'en': 'English'
  };
}
