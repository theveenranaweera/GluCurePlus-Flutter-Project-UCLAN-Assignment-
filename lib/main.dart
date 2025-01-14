import 'package:flutter/material.dart';
import 'screens/credential_screens/welcome_screen.dart';

void main() {
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

      home: const WelcomePage(),
    );
  }
}