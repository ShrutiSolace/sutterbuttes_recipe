import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacebookSignInService {
  static final FacebookAuth _facebookAuth = FacebookAuth.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with Facebook
  static Future<FacebookSignInResult> signInWithFacebook() async {
    try {
      print("Starting Facebook sign-in...");

      // Trigger the sign-in flow
      final LoginResult result = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      print("Facebook login result: ${result.status}");

      if (result.status == LoginStatus.success) {
        print("Facebook login successful, getting access token...");

        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.tokenString);

        print("Signing in to Firebase with Facebook credential...");

        // Sign in to Firebase with the Facebook credential
        final UserCredential userCredential =
        await _auth.signInWithCredential(facebookAuthCredential);
        final User? user = userCredential.user;

        if (user != null) {
          print("Firebase sign-in successful: ${user.uid}");

          return FacebookSignInResult(
            success: true,
            message: 'Sign-in successful',
            user: FacebookUser(
              id: user.uid,
              email: user.email ?? '',
              name: user.displayName ?? '',
              photoUrl: user.photoURL ?? '',
            ),
          );
        } else {
          print("Failed to get user information from Firebase");
          return FacebookSignInResult(
            success: false,
            message: 'Failed to get user information',
          );
        }
      } else if (result.status == LoginStatus.cancelled) {
        print("Facebook login cancelled by user");
        return FacebookSignInResult(
          success: false,
          message: 'Sign-in cancelled by user',
        );
      } else {
        print("Facebook login failed: ${result.message}");
        return FacebookSignInResult(
          success: false,
          message: 'Sign-in failed: ${result.message}',
        );
      }
    } catch (e) {
      print("Facebook sign-in error: $e");
      return FacebookSignInResult(
        success: false,
        message: 'Sign-in failed: ${e.toString()}',
      );
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _facebookAuth.logOut();
      await _auth.signOut();
      print("Facebook sign-out successful");
    } catch (e) {
      print("Facebook sign-out error: $e");
    }
  }

  // Check if user is signed in
  static Future<bool> isSignedIn() async {
    try {
      final accessToken = await _facebookAuth.accessToken;
      print("====Facebook access token: $accessToken");
      return accessToken != null;
    } catch (e) {
      print("Error checking Facebook sign-in status: $e");
      return false;
    }
  }

  // Get current user data
  static Future<FacebookUser?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return FacebookUser(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          photoUrl: user.photoURL ?? '',
        );
      }
      return null;
    } catch (e) {
      print("Error getting current user: $e");
      return null;
    }
  }
}

// Result class
class FacebookSignInResult {
  final bool success;
  final String message;
  final FacebookUser? user;

  FacebookSignInResult({
    required this.success,
    required this.message,
    this.user,
  });
}

// User data class
class FacebookUser {
  final String id;
  final String email;
  final String name;
  final String photoUrl;

  FacebookUser({
    required this.id,
    required this.email,
    required this.name,
    required this.photoUrl,
  });

  @override
  String toString() {
    return 'FacebookUser{id: $id, email: $email, name: $name, photoUrl: $photoUrl}';
  }
}