import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/login_model.dart';
import '../services/secure_storage.dart';

class AuthService {
  static const Duration _timeout = Duration(seconds: 30);

  static Future<LoginResponse> login({required String username, required String password})
  async {
    print("username: $username");
    print("password: $password");
    print("login api call");
    try {
      final loginRequest = LoginRequest(
        username: username,
        password: password,
      );

      final response = await http.post(Uri.parse(ApiConstants.loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(loginRequest.toJson()),
      )
          .timeout(_timeout);

      print("url: ${ApiConstants.loginUrl}");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");


     /* if (response.statusCode == 200) {

        final Map<String, dynamic> responseData = json.decode(response.body);
        return LoginResponse.fromJson(responseData);
      }*/
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final loginResponse = LoginResponse.fromJson(responseData);

        // Save the token to secure storage
        if (loginResponse.token != null) {
          await SecureStorage.saveToken(loginResponse.token!);
        }

        return loginResponse;
      }



      else if (response.statusCode == 401) {
        // Invalid credentials
        throw ApiError(
          message: 'Invalid username or password',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 400) {
        // Bad request
        throw ApiError(
          message: 'Invalid request. Please check your credentials.',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 403) {
        // Forbidden
        throw ApiError(
          message: 'Access denied. Please contact support.',
          statusCode: response.statusCode,
        );
      } else {
        // Other errors
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw ApiError(
          message: errorData['message'] ?? 'Login failed. Please try again.',
          statusCode: response.statusCode,
        );
      }

    } on http.ClientException {
      throw ApiError(message: 'Network error. Please check your connection.');
    } on FormatException {
      throw ApiError(message: 'Invalid response format from server.');
    } catch (e) {
      throw ApiError(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  //sign UP api
  static Future<SignUpResponse> signUp({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    print("username: $username");
    print("email: $email");
    print("password: $password");
    print("firstName: $firstName");
    print("lastName: $lastName");
    print("signup api call");

    try {
      final signUpRequest = SignUpRequest(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      final response = await http.post(
        Uri.parse(ApiConstants.signUpUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(signUpRequest.toJson()),
      ).timeout(_timeout);

      print("url: ${ApiConstants.signUpUrl}");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return SignUpResponse.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw ApiError(
          message: errorData['message'] ?? 'Sign up failed. Please try again.',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }


















}

