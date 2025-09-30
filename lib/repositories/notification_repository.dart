import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/notification_pref_model.dart';
import '../services/secure_storage.dart';

class NotificationRepository {
  Future<NotificationPrefModel> getPreferences() async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.notificationsUrl);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return NotificationPrefModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to fetch notifications: ${response.statusCode}');
    }
  }

  Future<String> updatePreferences({required Map<String, dynamic> payload}) async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.notificationsUpdateUrl);

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      return data['message']?.toString() ?? 'Preferences updated successfully';
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception(data['message']?.toString() ?? 'Failed to update preferences: ${response.statusCode}');
    }
  }

  Future<String> resetPreferences() async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.notificationsResetUrl);

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      return data['message']?.toString() ?? 'Preferences reset successfully';
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception(data['message']?.toString() ?? 'Failed to reset preferences: ${response.statusCode}');
    }
  }
}


