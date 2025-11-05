class GoogleLoginResponse {
  final bool success;
  final String? token;           // Your app's JWT token
  final String? refreshToken;    // If you use refresh tokens
  final UserData? user;          // Optional, if backend returns it
  final String? message;

  GoogleLoginResponse({
    required this.success,
    this.token,
    this.refreshToken,
    this.user,
    this.message,
  });

  factory GoogleLoginResponse.fromJson(Map<String, dynamic> json) {
    return GoogleLoginResponse(
      success: json['success'] ?? false,
      token: json['token'],
      refreshToken: json['refresh_token'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      message: json['message'],
    );
  }
}

class UserData {
  final int id;
  final String? email;
  final String? name;
  final String? firstName;
  final String? lastName;

  UserData({
    required this.id,
    this.email,
    this.name,
    this.firstName,
    this.lastName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: int.parse(json['id'].toString()),
      email: json['email'],
      name: json['name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}