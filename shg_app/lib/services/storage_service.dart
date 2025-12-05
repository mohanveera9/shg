import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final _secureStorage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_preferred_language', language);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_preferred_language') ?? 'te';
  }

  Future<void> saveOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
