import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/profile_model.dart';
import '../modal/update_profile_model.dart';
import '../services/secure_storage.dart';

class UserRepository {
  Future<Profile> getCurrentUser() async {
    String? token = await SecureStorage.getLoginToken();
    print("Fetching current user with token: $token");
    final uri = Uri.parse(ApiConstants.profileUrl);
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

  Future<UserData> getUserProfileData() async {
    String? token = await SecureStorage.getLoginToken();
    print("Fetching user profile data with token: $token");
    final uri = Uri.parse(ApiConstants.profileUrl);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    print("Fetching user profile data from: $uri");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final data = jsonMap['data'];
      return UserData.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to fetch profile data: ${response.statusCode}');
    }
  }

  Future<UpdateProfileModel> updateUserProfile({
    required UserData userData,
  }) async {
    String? token = await SecureStorage.getLoginToken();
    print("Updating user profile with token: $token");

    final uri = Uri.parse(ApiConstants.updateProfileUrl);
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(userData.toJson()),
    );

    print("Updating user profile at: $uri");
    print("Request Body: ${json.encode(userData.toJson())}");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UpdateProfileModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    String? token = await SecureStorage.getLoginToken();
    print("Changing password with token: $token");

    final uri = Uri.parse(ApiConstants.changePasswordUrl);
    final body = json.encode({
      'current_password': currentPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    });

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print("Change password at: $uri");
    print("Request Body: $body");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return data['message'] ?? 'Password changed successfully.';
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception(data['message'] ?? 'Failed to change password: ${response.statusCode}');
    }
  }
}
