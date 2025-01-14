import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'constants.dart';
import 'package:typeset/typeset.dart';

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

      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: Padding(
          // Reduced vertical padding so content sits higher
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            // Start or center so the GIF and buttons are pulled together
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Center(
                  child: TypeSet(
                    "Track #Sweet#.\n  Live Smart.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sans',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // GIF
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: SizedBox(
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/GluCure+Logo.GIF",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // A little vertical space before the buttons
              const SizedBox(height: 30),

              // Get Started Button
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonFill,
                      foregroundColor: darkBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sign In Button
              FadeInUp(
                duration: const Duration(milliseconds: 1600),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: buttonFill,
                      side: BorderSide(color: buttonFill),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
