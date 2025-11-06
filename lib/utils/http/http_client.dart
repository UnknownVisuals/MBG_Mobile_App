import 'dart:async';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/utils/helpers/file_helper.dart';
import 'package:mbg_mobile_app/utils/local_storage/storage_utility.dart';

class MBGHttpHelper extends GetConnect {
  // Dependencies
  static final _localStorage = MBGLocalStorage();

  // Default Configurations
  static String? _baseUrl = dotenv.env['API_BASE_URL'];
  static String _sessionToken = '';

  // Constructor to set timeout
  MBGHttpHelper() {
    timeout = const Duration(seconds: 60);
    httpClient.timeout = const Duration(seconds: 60);
  }

  // ====================
  // ===== BASE URL =====
  // ====================

  // Setter method to change the base URL
  static void setBaseUrl(String url) {
    _baseUrl = url;
  }

  // Method to get base URL
  static String? getBaseUrl() {
    return _baseUrl;
  }

  // =========================
  // ===== SESSION TOKEN =====
  // =========================

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

  // =================================
  // ===== HTTP REQUESTS HELPERS =====
  // =================================

  // Setter headers for HTTP requests
  static Map<String, String> _getHeaders() {
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    if (_sessionToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_sessionToken';
    }
    return headers;
  }

  // Private method to handle responses
  Response _handleResponse(Response response) {
    final body = response.body;
    String? message;

    if (body is Map<String, dynamic>) {
      message = body['message'] as String?;
    }

    final statusCode = response.statusCode ?? 0;

    // Log for debugging
    if (statusCode == 0 || statusCode < 200 || statusCode >= 300) {
      print('HTTP Error Debug:');
      print('Status Code: $statusCode');
      print('Status Text: ${response.statusText}');
      print('Body: ${response.bodyString}');
    }

    if (statusCode == 401) {
      throw Exception(message ?? 'Unauthorized request.');
    } else if (statusCode < 200 || statusCode >= 300) {
      throw Exception(message ?? 'Error: $statusCode');
    }

    return response;
  }

  // ========================
  // ===== HTTP METHODS =====
  // ========================

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
  Future<Response> postRequest(String endpoint, dynamic data) async {
    try {
      final response = await post(
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

  // Helper method to make a multipart/form-data POST request
  Future<Response> postMultipartRequest(
    String endpoint, {
    Map<String, dynamic>? fields,
    File? file,
    String fileFieldName = 'file',
    String? fileName,
    String? contentType,
    bool isPutMethod = false,
  }) async {
    try {
      final Map<String, dynamic> formMap = <String, dynamic>{
        if (fields != null) ...fields,
      };

      if (file != null) {
        final resolvedName =
            fileName ?? file.path.split(Platform.pathSeparator).last;
        final resolvedContentType =
            contentType ?? MBGFileHelper.inferImageContentType(file);

        formMap[fileFieldName] = MultipartFile(
          file,
          filename: resolvedName,
          contentType: resolvedContentType,
        );
      }

      final headers = <String, String>{};
      if (_sessionToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $_sessionToken';
      }

      final url = '$_baseUrl/$endpoint';
      final formData = FormData(formMap);

      final response =
          await (isPutMethod
                  ? put(url, formData, headers: headers)
                  : post(url, formData, headers: headers))
              .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
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
}
