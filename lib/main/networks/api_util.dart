import 'dart:convert';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  final int statusCode;
  final dynamic body;

  ApiResponse(this.statusCode, this.body);
}

class ApiUtil {
  static Future<ApiResponse> _handleResponse(http.Response response) async {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? json.decode(response.body) : null;
    return ApiResponse(statusCode, body);
  }

  static Future<dynamic> get(String url) async {
    try {
      final uri = Uri.parse(url);
      final token = await AppStorage.getToken();
      final response = await http.get(
        uri,
        headers: {
          "Authorization": 'Bearer $token',
          "Content-Type": 'application/json',
        },
      );
      return await _handleResponse(response);
    } catch (e) {
      debugPrint('GET error: $e');
      rethrow;
    }
  }

  static Future<dynamic> post({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    try {
      final uri = Uri.parse(url);
      final token = await AppStorage.getToken();

      // 🔹 Log thông tin request
      debugPrint('====================================');
      debugPrint('📤 POST REQUEST');
      debugPrint('URL: $url');
      // debugPrint('Headers: {');
      // debugPrint('  Authorization: Bearer ${token ?? "null"}');
      // debugPrint('  Content-Type: application/json');
      debugPrint('}');
      debugPrint('Body: ${jsonEncode(data ?? {})}');
      debugPrint('====================================');

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": 'application/json',
        },
        body: data != null ? json.encode(data) : null,
      );

      // 🔹 Log thông tin response
      debugPrint('📥 RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('====================================');

      return await _handleResponse(response);
    } catch (e) {
      debugPrint('❌ POST error: $e');
      rethrow;
    }
  }

  static Future<dynamic> put(String url, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse(url);
      final token = await AppStorage.getToken();
      final response = await http.put(
        uri,
        headers: {
          "Authorization": 'Bearer $token',
          "Content-Type": 'application/json',
        },
        body: json.encode(data),
      );
      return await _handleResponse(response);
    } catch (e) {
      debugPrint('PUT error: $e');
      rethrow;
    }
  }

  static Future<dynamic> delete(String url) async {
    try {
      final uri = Uri.parse(url);
      final token = await AppStorage.getToken();
      final response = await http.delete(
        uri,
        headers: {
          "Authorization": 'Bearer $token',
          "Content-Type": 'application/json',
        },
      );
      return await _handleResponse(response);
    } catch (e) {
      debugPrint('DELETE error: $e');
      rethrow;
    }
  }
}
