class DeviceRegistrationRequest {
  final String token;
  final String platform;

  DeviceRegistrationRequest({
    required this.token,
    required this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'platform': platform,
    };
  }
}

class DeviceRegistrationResponse {
  final String message;
  final bool success;

  DeviceRegistrationResponse({
    required this.message,
    required this.success,
  });

  factory DeviceRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return DeviceRegistrationResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}