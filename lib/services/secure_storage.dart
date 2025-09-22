import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;


  static const String _tokenKey = 'auth_token';


  SecureStorage._internal();


  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getLoginToken() async {
    return await _storage.read(key: _tokenKey);
  }



  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }


  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getLoginToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}