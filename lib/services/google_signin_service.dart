import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sutterbuttes_recipe/services/secure_storage.dart';

import '../api_constant.dart';
import '../modal/google_signin_modal.dart';


class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static final FirebaseAuth _auth = FirebaseAuth.instance;


  // Sign in with Google
  static Future<GoogleSignInResult> signInWithGoogle() async{
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return GoogleSignInResult(
          success: false,
          message: 'Sign-in cancelled by user',
        );
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print("ggl sign method called");


      final response = await http.post(
        Uri.parse(ApiConstants.googleLoginUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': googleAuth.idToken}),
      );
      print("Google login request sent.");
      print("uri: ${Uri.parse(ApiConstants.googleLoginUrl)}");
      print("response body: ${response.body}");
      print("response status: ${response.statusCode}");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final GoogleLoginResponse loginResult = GoogleLoginResponse.fromJson(data);
        if (loginResult.success && loginResult.token != null) {
          await SecureStorage.saveToken(loginResult.token!);

          print("App token saved!");
        } else {
          print("Backend Google login failed: ${loginResult.message}");

        }
      } else {
        // Handle HTTP/server error
        print("HTTP error: ${response.statusCode} - ${response.reasonPhrase}");
      }


     /* final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );*/
      print("accessToken: ${googleAuth.accessToken}");
      print("idToken: ${googleAuth.idToken}");
      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        return GoogleSignInResult(
          success: true,
          message: 'Sign-in successful',
          user: GoogleUser(
            id: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? '',
            photoUrl: user.photoURL ?? '',
          ),
        );
      } else {
        return GoogleSignInResult(
          success: false,
          message: 'Failed to get user information',
        );
      }
    } catch (e) {
      return GoogleSignInResult(
        success: false,
        message: 'Sign-in failed: ${e.toString()}',
      );
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Check if user is signed in
  static Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}

// Result class
class GoogleSignInResult {
  final bool success;
  final String message;
  final GoogleUser? user;

  GoogleSignInResult({
    required this.success,
    required this.message,
    this.user,
  });
}

// User data class
class GoogleUser {
  final String id;
  final String email;
  final String name;
  final String photoUrl;

  GoogleUser({
    required this.id,
    required this.email,
    required this.name,
    required this.photoUrl,
  });
}