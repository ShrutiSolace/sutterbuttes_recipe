import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with Google
  static Future<GoogleSignInResult> signInWithGoogle() async {
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

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

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