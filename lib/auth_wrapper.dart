import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glucure_plus/screens/credential_screens/welcome_screen.dart';
import 'package:glucure_plus/screens/main_screens/dashboard_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // listens for auth changes
      builder: (context, snapshot) {
        // Check if the connection is active
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          // If user is null, not signed in – show the welcome/login screen.
          return user == null ? WelcomePage() : DashboardScreen();
        }
        // While waiting for authentication state, show a loading indicator.
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
