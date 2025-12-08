import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();
  final _storage = StorageService();
  
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    _isAuthenticated = await _authService.isAuthenticated();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> sendOTP(String phone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _authService.sendOTP(phone);
    
    _isLoading = false;
    if (response['success'] != true) {
      _errorMessage = response['message'] ?? 'Failed to send OTP';
    }
    notifyListeners();

    return response['success'] == true;
  }

  Future<bool> verifyOTP(String phone, String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _authService.verifyOTP(phone, otp);
    
    if (response['success'] == true) {
      _user = _authService.parseUser(response);
      _isAuthenticated = true;
      
      if (_user != null) {
        await _storage.saveLanguage(_user!.language);
      }
    } else {
      _errorMessage = response['message'] ?? 'Failed to verify OTP';
    }
    
    _isLoading = false;
    notifyListeners();

    return response['success'] == true;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    
    _user = null;
    _isAuthenticated = false;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}