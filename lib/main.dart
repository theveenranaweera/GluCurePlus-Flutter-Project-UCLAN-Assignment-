/// The entry point of the GluCure Plus application.
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:glucure_plus/firebase_options.dart';
import 'package:glucure_plus/auth_wrapper.dart';
import 'package:glucure_plus/screens/credential_screens/forgot_password_screen.dart';
import 'package:glucure_plus/screens/credential_screens/login_screen.dart';
import 'package:glucure_plus/screens/credential_screens/signup_screen.dart';
import 'package:glucure_plus/screens/credential_screens/welcome_screen.dart';
import 'package:glucure_plus/screens/main_screens/add_sugar_screen.dart';
import 'package:glucure_plus/screens/main_screens/dashboard_screen.dart';
import 'package:glucure_plus/screens/main_screens/profile_settings_screen.dart';
import 'package:glucure_plus/screens/main_screens/food_search_screen.dart';
import 'connectivity_wrapper.dart';

// Initializes Firebase and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GluCurePlus());
}

// Main App Widget
class GluCurePlus extends StatelessWidget {
  const GluCurePlus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Use Material 3 theme with a dark baseline
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const ConnectivityWrapper(
        child: AuthWrapper(),
      ),

      routes: {
        WelcomePage.navID: (context) {
          return WelcomePage();
        },
        LoginPage.navID: (context) {
          return LoginPage();
        },
        ForgotPasswordPage.navID: (context) {
          return ForgotPasswordPage();
        },
        SignUpPage.navID: (context) {
          return SignUpPage();
        },
        DashboardScreen.navID: (context) {
          return DashboardScreen();
        },
        AddSugarScreen.navID: (context) {
          return AddSugarScreen();
        },
        ProfileSettingsScreen.navID: (context) {
          return ProfileSettingsScreen();
        },
        FoodSearchScreen.navID: (context) {
          return FoodSearchScreen();
        },
      },
    );
  }
}
