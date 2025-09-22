import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/profile_model.dart';
import '../services/secure_storage.dart';

class UserRepository {
  Future<Profile> getCurrentUser() async {

    String? token = await SecureStorage.getLoginToken();
    print("Fetching current user with token: $token");
    final uri = Uri.parse(ApiConstants.ProfileUrl);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    print("Fetching current user from: $uri");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Profile.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to fetch current user: ${response.statusCode}');
    }
  }
}