import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'constants_for_credential_screens.dart';
import 'package:typeset/typeset.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBgColor,
      body: SafeArea(
        child: Padding(
          // Reduced vertical padding so content sits higher
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Text
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Center(
                  child: TypeSet(
                    "Track #Sweet#.\n  Live Smart.",
                    style: kWelcomeScreenHeadingText,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // GIF
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: SizedBox(
                  height: 290,
                  child: Image.asset(
                    "assets/images/glucure_plus_logo.gif",
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              // A little vertical space before the buttons
              const SizedBox(height: 30),

              // Get Started Button
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: SizedBox(
                  width: kButtonWidth,
                  height: kButtonHeight,
                  child: ElevatedButton(
                    style: kCredentialButtonStyle, // Use the constant style
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: const Text(
                      "Get Started",
                      style: kCredentialButtonText,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Sign In Button
              FadeInUp(
                duration: const Duration(milliseconds: 1600),
                child: SizedBox(
                  width: kButtonWidth,
                  height: kButtonHeight,
                  child: OutlinedButton(
                    style: kCredentialOutlinedButtonStyle, // Use the constant style
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Sign In",
                      style: kCredentialButtonText.copyWith(
                        color: kButtonFillColor, // dark text on gold
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
