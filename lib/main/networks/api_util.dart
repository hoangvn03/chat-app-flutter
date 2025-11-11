import 'dart:convert';
import 'dart:io';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

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

  static Future<dynamic> get(String url, {Map<String, dynamic>? params}) async {
    try {
      final uri = Uri.parse(url).replace(queryParameters: params);
      final token = await AppStorage.getToken();

      debugPrint('🔹 [GET] Request URL: $uri');
      debugPrint('🔹 [GET] Token: $token');

      final response = await http.get(
        uri,
        headers: {
          "Authorization": 'Bearer $token',
          "Content-Type": 'application/json',
        },
      );

      debugPrint('✅ [GET] Status code: ${response.statusCode}');
      debugPrint('📦 [GET] Response body: ${response.body}');

      return await _handleResponse(response);
    } catch (e, stackTrace) {
      debugPrint('❌ [GET] error: $e');
      debugPrintStack(stackTrace: stackTrace);
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

  static Future<dynamic> postFileV2({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    try {
      final uri = Uri.parse(url);

      debugPrint('====================================');
      debugPrint('📤 POST REQUEST (FormData)');
      debugPrint('URL: $url');
      debugPrint('Body: $data');
      debugPrint('====================================');

      var request = http.MultipartRequest('POST', uri);

      // 🟢 Thêm các trường text
      data?.forEach((key, value) async {
        if (value == null) return;
        if (value is String || value is num) {
          request.fields[key] = value.toString();
        } else if (value is List<int>) {
          // Nếu bạn gửi file dạng bytes
          request.files.add(http.MultipartFile.fromBytes(key, value));
        } else if (value is String && value.startsWith("/")) {
          // Nếu value là đường dẫn tới file trong local
          request.files.add(await http.MultipartFile.fromPath(key, value));
        }
      });

      // ❌ Không cần Authorization hoặc Content-Type JSON
      // request.headers["Authorization"] = "Bearer $token"; // bỏ

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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

  static Future<ApiResponse> postFiles({
    required String url,
    required List<File> files,
    String? key
  }) async {
    try {
      final token = await AppStorage.getToken();
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      debugPrint('🔹 [GET] Request URL: $url');
      debugPrint('🔹 [GET] Token: $token');
      for (var file in files) {
        final mimeType = lookupMimeType(file.path) ?? 'image/jpeg'; // fallback
        final mimeSplit = mimeType.split('/');
        print('Uploading ${file.path} with MIME type $mimeType');
        request.files.add(
          await http.MultipartFile.fromPath(
            key ?? 'files',
            file.path,
            contentType: MediaType(mimeSplit[0], mimeSplit[1]),
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('📥 RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('====================================');

      return await _handleResponse(response); // Trả về ApiResponse
    } catch (e) {
      debugPrint('❌ Upload error: $e');
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
