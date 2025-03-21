import 'package:flutter/material.dart';
import 'package:glucure_plus/screens/credential_screens/forgot_password_screen.dart';
import 'screens/main_screens/add_sugar_screen.dart';
import 'screens/main_screens/dashboard_screen.dart';
import 'screens/credential_screens/signup_screen.dart';
import 'screens/credential_screens/login_screen.dart';
import 'screens/credential_screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:glucure_plus/firebase_options.dart';
import 'package:glucure_plus/screens/main_screens/profile_settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GluCurePlus());
}

class GluCurePlus extends StatelessWidget {
  const GluCurePlus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Turn off debug banner
      debugShowCheckedModeBanner: false,

      // Material 3 (optional) and a basic dark theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),

      initialRoute: WelcomePage.navID,
      routes: {
        WelcomePage.navID: (context) => WelcomePage(),
        LoginPage.navID: (context) => LoginPage(),
        ForgotPasswordPage.navID: (context) => ForgotPasswordPage(),
        SignUpPage.navID: (context) => SignUpPage(),
        DashboardScreen.navID: (context) => DashboardScreen(),
        AddSugarScreen.navID: (context) => AddSugarScreen(),
        ProfileSettingsScreen.navID: (context) => ProfileSettingsScreen(),
      },
    );
  }
}