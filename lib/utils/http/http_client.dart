import 'dart:async';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/utils/local_storage/storage_utility.dart';

class MBGHttpHelper extends GetConnect {
  static String? _baseUrl = dotenv.env['API_BASE_URL'];
  static String _sessionToken = '';
  static final _localStorage = MBGLocalStorage();
  static Future<void> Function({String? message})? _unauthorizedHandler;
  static bool _isHandlingUnauthorized = false;

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

  // Method to get base URL
  static String? getBaseUrl() {
    return _baseUrl;
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
    try {
      final response = await get(
        '$_baseUrl/$endpoint',
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on SocketException {
      throw Exception('No internet connection.');
    }
  }

  // Helper method to make a POST request
  Future<Response> postRequest(
    String endpoint,
    dynamic data, {
    bool handleUnauthorized = true,
  }) async {
    try {
      final response = await post(
        '$_baseUrl/$endpoint',
        data,
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response, handleUnauthorized: handleUnauthorized);
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on SocketException {
      throw Exception('No internet connection.');
    }
  }

  // Helper method to make a PUT request
  Future<Response> putRequest(String endpoint, dynamic data) async {
    try {
      final response = await put(
        '$_baseUrl/$endpoint',
        data,
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on SocketException {
      throw Exception('No internet connection.');
    }
  }

  // Helper method to make a PATCH request
  Future<Response> patchRequest(String endpoint, dynamic data) async {
    try {
      final response = await patch(
        '$_baseUrl/$endpoint',
        data,
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on SocketException {
      throw Exception('No internet connection.');
    }
  }

  // Helper method to make a DELETE request
  Future<Response> deleteRequest(String endpoint) async {
    try {
      final response = await delete(
        '$_baseUrl/$endpoint',
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on SocketException {
      throw Exception('No internet connection.');
    }
  }

  Response _handleResponse(
    Response response, {
    bool handleUnauthorized = true,
  }) {
    final body = response.body;
    String? message;
    if (body is Map<String, dynamic>) {
      message = body['message'] as String?;
    }

    if (handleUnauthorized && response.statusCode == 401) {
      _triggerUnauthorized(message: message);
      throw Exception(message ?? 'Unauthorized');
    }

    return response;
  }

  static void registerUnauthorizedHandler(
    Future<void> Function({String? message}) handler,
  ) {
    _unauthorizedHandler = handler;
  }

  static void unregisterUnauthorizedHandler(
    Future<void> Function({String? message}) handler,
  ) {
    _unauthorizedHandler = null;
  }

  static Future<void> _triggerUnauthorized({String? message}) async {
    if (_isHandlingUnauthorized) return;
    _isHandlingUnauthorized = true;

    await clearSessionToken();

    if (_unauthorizedHandler != null) {
      await _unauthorizedHandler!(message: message);
    }

    _isHandlingUnauthorized = false;
  }
}
