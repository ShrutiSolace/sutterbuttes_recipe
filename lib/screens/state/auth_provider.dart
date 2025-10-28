import 'package:flutter/material.dart';
import 'package:sutterbuttes_recipe/modal/profile_model.dart';
import '../../modal/login_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/profile_repository.dart';
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










}