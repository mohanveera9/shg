import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final _storage = StorageService();
  final String baseUrl = AppConfig.apiBaseUrl;

  Future<Map<String, String>> _getHeaders({bool needsAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (needsAuth) {
      final token = await _storage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
      print('Headers: $headers');
    }

    return headers;
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body, {bool needsAuth = false}) async {
    try {
      final headers = await _getHeaders(needsAuth: needsAuth);
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, {bool needsAuth = false, Map<String, String>? queryParams}) async {
    try {
      final headers = await _getHeaders(needsAuth: needsAuth);
      var uri = Uri.parse('$baseUrl$endpoint');
      
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http.get(uri, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body, {bool needsAuth = false}) async {
    try {
      final headers = await _getHeaders(needsAuth: needsAuth);
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      try {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Request failed'};
      } catch (e) {
        return {'success': false, 'message': 'Request failed with status ${response.statusCode}'};
      }
    }
  }
}
