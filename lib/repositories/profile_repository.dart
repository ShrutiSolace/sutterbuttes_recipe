import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/profile_model.dart';
import '../modal/update_profile_model.dart';
import '../modal/upload_profile_image_model.dart';
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


/*

  Future<UpdateProfileModel> updateUserProfile({
    required UserData userData,
    required String? profileImagePath,
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

*/
  Future<UpdateProfileModel> updateUserProfile({
    required UserData userData,
    required String? profileImagePath,
  }) async {
    String? token = await SecureStorage.getLoginToken();
    print("Updating user profile with token: $token");

    final uri = Uri.parse(ApiConstants.updateProfileUrl);

    // Create a multipart request
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    // Add JSON fields as form fields
    request.fields.addAll(userData.toJson().map((key, value) => MapEntry(key, value.toString())));
    print("===UPdate profile api called===");
    print("Updating user profile at: $uri");

    print("=== Username Debug ===");
    print("Username from UserData: ${userData.username}");
    print("Username in toJson: ${userData.toJson()['username']}");
    print("All request fields: ${request.fields}");

    // Add profile image if available
    if (profileImagePath != null && profileImagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_image', // Make sure this matches the backend field name
        profileImagePath,
      ));
    }

    print("Request fields: ${request.fields}");
    print("Request files: ${request.files.map((f) => f.filename).toList()}");

    // Send the request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("Body contains '\"username\"': ${response.body.contains('"username"')}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UpdateProfileModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }

 //api for upload profile image
  Future<UploadProfileImageModel> uploadProfileImage({required String imagePath}) async {
    String? token = await SecureStorage.getLoginToken();
    print("Uploading profile image with token: $token");

    final uri = Uri.parse(ApiConstants.uploadProfileImageUrl);
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';
    request.files.add(await http.MultipartFile.fromPath(
      'profile_image', // Field name must match backend expectation
      imagePath,
    ));
    print("=====================");
    print("Uploading profile image to: $uri");
    print("Image path: $imagePath");
    print("Request files: ${request.files.map((f) => f.filename).toList()}");


    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UploadProfileImageModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to upload profile image: ${response.statusCode}');
    }
  }







  Future<String> changePassword({required String currentPassword, required String newPassword, required String confirmPassword,
  }) async {
    print("Initiating password change...");
    print("Current Password: $currentPassword");
    print("New Password: $newPassword");
    print("Confirm Password: $confirmPassword");

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

    print("URL: $uri");
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
