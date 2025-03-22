import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  /// Initiates the Google sign-in flow and returns a [UserCredential].
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google authentication flow.
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If the user cancels the sign-in, return null.
      if (googleUser == null) {
        return null;
      }

      // Obtain the authentication details from the request.
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential].
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Error in Google Sign-In: $e");
      return null;
    }
  }
}
