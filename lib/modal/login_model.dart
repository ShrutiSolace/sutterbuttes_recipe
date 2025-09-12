import 'dart:convert';

// Login Request Model
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

// Login Response Model
class LoginResponse {
  final String token;
  final String userEmail;
  final String userNicename;
  final String userDisplayName;
  final String refreshToken;
  final int refreshExp;

  LoginResponse({
    required this.token,
    required this.userEmail,
    required this.userNicename,
    required this.userDisplayName,
    required this.refreshToken,
    required this.refreshExp,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      userEmail: json['user_email'] ?? '',
      userNicename: json['user_nicename'] ?? '',
      userDisplayName: json['user_display_name'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      refreshExp: json['refresh_exp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_email': userEmail,
      'user_nicename': userNicename,
      'user_display_name': userDisplayName,
      'refresh_token': refreshToken,
      'refresh_exp': refreshExp,
    };
  }
}

// API Error Model
class ApiError {
  final String message;
  final int? statusCode;

  ApiError({
    required this.message,
    this.statusCode,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] ?? 'An error occurred',
      statusCode: json['statusCode'],
    );
  }
}

class SignUpRequest {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  SignUpRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
class SignUpResponse {
  final bool success;
  final int userId;
  final String message;

  SignUpResponse({
    required this.success,
    required this.userId,
    required this.message,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      success: json['success'] ?? false,
      userId: json['user_id'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'user_id': userId,
      'message': message,
    };
  }
}
