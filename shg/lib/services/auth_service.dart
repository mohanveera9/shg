import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _api = ApiService();
  final _storage = StorageService();

  Future<Map<String, dynamic>> sendOTP(String phone) async {
    return await _api.post('/auth/send-otp', {'phone': phone});
  }

  Future<Map<String, dynamic>> verifyOTP(String phone, String otp) async {
    final response = await _api.post('/auth/verify-otp', {
      'phone': phone,
      'otp': otp,
    });

    if (response['success'] == true) {
      await _storage.saveToken(response['accessToken']);
      await _storage.saveRefreshToken(response['refreshToken']);
    }

    return response;
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    try {
      await _api.post('/auth/logout', {}, needsAuth: true);
    } catch (e) {
      // Continue with logout even if API call fails
    }
    await _storage.clearAll();
  }

  User? parseUser(Map<String, dynamic> response) {
    if (response['user'] != null) {
      return User.fromJson(response['user']);
    }
    return null;
  }
}