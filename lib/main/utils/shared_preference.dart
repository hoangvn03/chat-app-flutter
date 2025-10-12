import 'dart:convert';

import 'package:chat_app/main/networks/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static const String _tokenKey = "auth_token";
  static const String _keyUser = "auth_token";

  /// Lưu token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Lấy token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Xóa token (logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson()); // chuyển thành chuỗi JSON
    await prefs.setString(_keyUser, userJson);
  }

  /// Lấy UserModel từ SharedPreferences
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_keyUser);
    if (userString == null || userString.isEmpty) return null;
    final Map<String, dynamic> userMap = jsonDecode(userString);
    return UserModel.fromJson(userMap);
  }

  /// Xóa UserModel (đăng xuất)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }
}
