/// A widget that decides whether to show the Welcome screen or the Dashboard
/// based on the user's authentication state.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glucure_plus/screens/credential_screens/welcome_screen.dart';
import 'package:glucure_plus/screens/main_screens/dashboard_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showLoadingSpinner = true;

  @override
  void initState() {
    super.initState();
    // Immediately listen for changes; once the first event arrives, remove spinner.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        setState(() {
          _showLoadingSpinner = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Use ModalProgressHUD for the loading indicator
        return ModalProgressHUD(
          color: Colors.black,
          inAsyncCall: _showLoadingSpinner,
          child: (snapshot.connectionState == ConnectionState.active)
              ? (snapshot.data == null ? WelcomePage() : DashboardScreen())
              : const SizedBox.shrink(), // empty container if still waiting
        );
      },
    );
  }
}
