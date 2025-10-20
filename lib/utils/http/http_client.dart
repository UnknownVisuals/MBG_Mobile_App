import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/utils/local_storage/storage_utility.dart';

class MBGHttpHelper extends GetConnect {
  static String? _baseUrl = dotenv.env['API_BASE_URL'];
  static String _sessionToken = '';
  static final _localStorage = MBGLocalStorage();

  // Setter method to change the base URL
  static void setBaseUrl(String url) {
    _baseUrl = url;
  }

  // Setter method to set session token
  static Future<void> setSessionToken(
    String token, {
    bool persist = true,
  }) async {
    _sessionToken = token;
    if (persist) {
      await _localStorage.saveData('session_token', _sessionToken);
    }
  }

  // Method to load session token from storage
  static void loadSessionToken() {
    final token = _localStorage.readData<String>('session_token');
    if (token != null) {
      _sessionToken = token;
    }
  }

  // Method to clear session token
  static Future<void> clearSessionToken() async {
    _sessionToken = '';
    await _localStorage.removeData('session_token');
  }

  // Method to check if session token exists
  static bool hasSessionToken() {
    return _sessionToken.isNotEmpty;
  }

  // Method to get current session token
  static String getSessionToken() {
    return _sessionToken;
  }

  // Setter headers for HTTP requests
  static Map<String, String> _getHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_sessionToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_sessionToken';
    }
    return headers;
  }

  // Helper method to make a GET request
  Future<Response> getRequest(String endpoint) async {
    return await get(
      '$_baseUrl/$endpoint',
      headers: _getHeaders(),
    ).timeout(const Duration(seconds: 10));
  }

  // Helper method to make a POST request
  Future<Response> postRequest(String endpoint, dynamic data) async {
    return await post(
      '$_baseUrl/$endpoint',
      data,
      headers: _getHeaders(),
    ).timeout(const Duration(seconds: 10));
  }

  // Helper method to make a PUT request
  Future<Response> putRequest(String endpoint, dynamic data) async {
    return await put(
      '$_baseUrl/$endpoint',
      data,
      headers: _getHeaders(),
    ).timeout(const Duration(seconds: 10));
  }

  // Helper method to make a PATCH request
  Future<Response> patchRequest(String endpoint, dynamic data) async {
    return await patch(
      '$_baseUrl/$endpoint',
      data,
      headers: _getHeaders(),
    ).timeout(const Duration(seconds: 10));
  }

  // Helper method to make a DELETE request
  Future<Response> deleteRequest(String endpoint) async {
    return await delete(
      '$_baseUrl/$endpoint',
      headers: _getHeaders(),
    ).timeout(const Duration(seconds: 10));
  }
}
