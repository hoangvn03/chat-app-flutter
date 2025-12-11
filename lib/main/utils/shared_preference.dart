import 'dart:convert';

import 'package:chat_app/main/networks/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static const String _tokenKey = "auth_token";
  static const String _keyUser = "auth_user";
  static const String _keyCheckLogin = "keyCheckLogin";

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
  /// Lưu đăng nhập
  static Future<void> saveIsLogin(bool token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCheckLogin, token);
  }

  /// Lấy đăng nhập
  static Future<bool> getIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCheckLogin) ?? false;
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

    // Lưu IP tùy chỉnh (set khi người dùng nhập)
  static Future<void> setCustomIp(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_ip', ip);
  }

  // Lấy IP đã lưu
  static Future<String?> getCustomIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('custom_ip');
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  static Future<void> clearExceptUser() async {
  final prefs = await SharedPreferences.getInstance();

  // 1. Lấy data user trước khi xóa
  final userJson = prefs.getString("USER_DATA");

  // 2. Xóa toàn bộ
  await prefs.clear();

  // 3. Lưu lại user (nếu có)
  if (userJson != null) {
    await prefs.setString("USER_DATA", userJson);
  }
}

}
