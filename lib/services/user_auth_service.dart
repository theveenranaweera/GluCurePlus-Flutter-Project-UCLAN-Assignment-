/// Provides methods for authenticating via Firebase (email/pass, Google).
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Sign in and sign up using google authentication.
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

  // Sign in using Firebase Authentication.
  Future<UserCredential?> signInWithEmail({required String email, required String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Reload user to fetch the latest data (including emailVerified status)
      await userCredential.user?.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        // If not verified, sign out and throw an error
        await FirebaseAuth.instance.signOut();
        throw Exception("Email not verified. Please verify your email before logging in.");
      }
      return userCredential;
    } catch (e) {
      print("Error in Email Sign-In: $e");
      rethrow;
    }
  }

  // Sign up using Firebase Authentication.
  Future<UserCredential?> signUpWithEmail({required String email, required String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Send verification email.
      await userCredential.user?.sendEmailVerification();
      return userCredential;
    } catch (e) {
      print("Error in Email Sign-Up: $e");
      rethrow;
    }
  }

  // Send a password reset email.
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error sending password reset email: $e");
      rethrow;
    }
  }

  // Sign out from app
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error signing out: $e");
      rethrow;
    }
  }
}
