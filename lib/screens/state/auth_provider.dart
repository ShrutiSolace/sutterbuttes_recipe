import 'package:flutter/material.dart';
import 'package:sutterbuttes_recipe/modal/profile_model.dart';
import '../../modal/login_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/profile_repository.dart';
import '../../services/facebook_signin_service.dart';
import '../../services/google_signin_service.dart';
import '../../services/notification_service.dart';
import '../../services/secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  LoginResponse? _userData;
  SignUpResponse? _signUpData;
  String? _token;

  Profile? _me;
  Profile? get me => _me;
  final UserRepository _userRepo = UserRepository();



  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginResponse? get userData => _userData;
  String? get token => _token;
  bool get isLoggedIn => _token != null;


  Future<bool> login({required String username, required String password,})
  async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.login(username: username, password: password);
      _userData = response;
      _token = response.token;
      // Fetch profile data after successful login
      if (_token != null) {
        await fetchCurrentUser();
      }


      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiError) {
        _errorMessage = e.message;
      } else {
        _errorMessage = e.toString();
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout method
 /* void logout() {
    _userData = null;
    _token = null;
    _errorMessage = null;
    notifyListeners();
  }*/
  Future<void> logout() async {
    _userData = null;
    _token = null;
    _errorMessage = null;
    _me = null;
    // Clear FCM token and unregister device
    await NotificationService.clearToken();

    // Clear token from secure storage
    await SecureStorage.deleteToken();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }


  Future<bool> signUp({required String username, required String email, required String password, required String firstName, required String lastName,
  })
  async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.signUp(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      _signUpData = response;
      _isLoading = false;

      notifyListeners();
      return response.success; // Return success status from API
    } catch (e) {
      if (e is ApiError) {
        _errorMessage = e.message;
      } else {
        _errorMessage = e.toString();
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Google Sign-In method
  Future<bool> signInWithGoogle() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
  final result = await GoogleSignInService.signInWithGoogle();

  if (result.success && result.user != null) {
  _isLoading = false;
  notifyListeners();
  return true;
  } else {
  _errorMessage = result.message;
  _isLoading = false;
  notifyListeners();
  return false;
  }
  } catch (e) {
  _errorMessage = 'Google sign-in failed: ${e.toString()}';
  _isLoading = false;
  notifyListeners();
  return false;
  }
  }



//facebook sign-in method can be added here similarly

  Future<bool> signInWithFacebook() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print("====Starting Facebook sign-in in AuthProvider...");

      final result = await FacebookSignInService.signInWithFacebook();

      if (result.success && result.user != null) {
        print("Facebook sign-in successful: ${result.user}");

        // Save user data and token
        _token = result.user!.id; // Use Firebase UID as token

        // Register device for notifications
        await NotificationService.registerDeviceWithBackend();

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        print("Facebook sign-in failed: ${result.message}");
        _errorMessage = result.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Facebook sign-in error in AuthProvider: $e");
      _errorMessage = 'Facebook sign-in failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }




  Future<bool> fetchCurrentUser() async {
    if (_token == null) return false;
    try {
      _me = await _userRepo.getCurrentUser();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Add this method to AuthProvider class
  Future<void> restoreAuthState() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get saved token from secure storage
      final savedToken = await SecureStorage.getLoginToken();

      if (savedToken != null && savedToken.isNotEmpty) {
        _token = savedToken;
        // Try to fetch user profile to validate token
        final profileFetched = await fetchCurrentUser();

        if (profileFetched) {
          print("Auth state restored successfully");
        } else {
          // Token is invalid, clear it
          _token = null;
          await SecureStorage.deleteToken();
          print("Invalid token, cleared auth state");
        }
      } else {
        print("No saved token found");
      }
    } catch (e) {
      print("Error restoring auth state: $e");
      _token = null;
      await SecureStorage.deleteToken();
    }

    _isLoading = false;
    notifyListeners();
  }





/*
// Google Sign-In method
Future<bool> signInWithGoogle() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    print("=== Starting Google Sign-In ===");
    final result = await GoogleSignInService.signInWithGoogle();

    if (result.success && result.user != null) {
      print("=== Google Sign-In successful ===");
      print("User email: ${result.user!.email}");
      print("User name: ${result.user!.name}");

      // Extract first and last name from Google display name
      final nameParts = result.user!.name.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Use email prefix as username
      final username = result.user!.email.split('@')[0];
      final password = 'google_signin_${result.user!.id}';

      print("=== Attempting backend authentication ===");

      try {
        // Try LOGIN first (for existing users)
        print("Trying to login existing user...");
        final loginResponse = await AuthService.login(
          username: username,
          password: password,
        );

        if (loginResponse.token != null && loginResponse.token!.isNotEmpty) {
          print("=== Login successful ===");
          _token = loginResponse.token;
          _userData = loginResponse;

          print("=== JWT token stored successfully ===");
          await fetchCurrentUser();

          _isLoading = false;
          notifyListeners();
          return true;
        }
      } catch (e) {
        print("Login failed: $e");
        print("User might not exist, trying to create new user...");

        // If login fails, try to create new user
        try {
          print("Trying to create new user...");
          final response = await AuthService.signUp(
            username: username,
            email: result.user!.email,
            password: password,
            firstName: firstName,
            lastName: lastName,
          );

          if (response.success) {
            print("New user created successfully");

            // Now try to login with the new account
            final loginResponse = await AuthService.login(
              username: username,
              password: password,
            );

            if (loginResponse.token != null && loginResponse.token!.isNotEmpty) {
              _token = loginResponse.token;
              _userData = loginResponse;

              print("=== JWT token stored successfully ===");
              await fetchCurrentUser();

              _isLoading = false;
              notifyListeners();
              return true;
            }
          }
        } catch (e) {
          print("Sign-up also failed: $e");
          throw e;
        }
      }

      _errorMessage = 'Failed to authenticate with backend';
      _isLoading = false;
      notifyListeners();
      return false;
    } else {
      print("=== Google Sign-In failed: ${result.message} ===");
      _errorMessage = result.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    print("=== Google Sign-In error: $e ===");
    _errorMessage = 'Google sign-in failed: ${e.toString()}';
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
 */




}