import 'dart:convert';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiUtil {
  static Future<dynamic> _handleResponse(http.Response response) async {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? json.decode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      debugPrint('Success [$statusCode]: $body');
      return body;
    } else {
      debugPrint('Error [$statusCode]: $body');
      throw Exception('HTTP $statusCode: $body');
    }
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
      print("token:$token");
      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": 'application/json',
        },
        body: data != null ? json.encode(data) : null,
      );
      return await _handleResponse(response);
    } catch (e) {
      debugPrint('POST error: $e');
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
