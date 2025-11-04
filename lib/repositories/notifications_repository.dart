import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/device_register_model.dart';
import '../modal/notifications_list_model.dart';
import '../services/secure_storage.dart';



class DeviceRegistrationRepository {
  Future<DeviceRegistrationResponse> registerDevice({
    required String fcmToken,
    required String platform,
  }) async {
    final String? authToken = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.deviceRegisterUrl);

    final request = DeviceRegistrationRequest(
      token: fcmToken,
      platform: platform,
    );

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    print("====Registering device at: $uri");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("Request Body: ${json.encode(request.toJson())}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return DeviceRegistrationResponse.fromJson(data);
    }
    else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to register device: ${response.statusCode}');
    }
  }




  //listing notifications
  Future<NotificationsListModel> getNotifications() async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.notificationslistUrl);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    print("+++++++++++++++");
    print("URL: $uri");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return NotificationsListModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to fetch notifications: ${response.statusCode}');
    }
  }
}