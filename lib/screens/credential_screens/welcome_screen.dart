import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:glucure_plus/screens/credential_screens/constants_for_credential_screens.dart';
import 'package:glucure_plus/screens/credential_screens/login_screen.dart';
import 'package:glucure_plus/screens/credential_screens/signup_screen.dart';

class WelcomePage extends StatelessWidget {
  static const String navID = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            // Reduced vertical padding so content sits higher
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Text
                FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Track Sweet.\n  Live Smart.',
                          textStyle: kWelcomeScreenHeadingText,  // Keep the same style
                          speed: const Duration(milliseconds: 130),  // Adjust animation speed
                        ),
                      ],
                      repeatForever: true,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // GIF
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
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
                  duration: const Duration(milliseconds: 600),
                  child: SizedBox(
                    width: kButtonWidth,
                    height: kButtonHeight,
                    child: ElevatedButton(
                      style: kCredentialButtonStyle,
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpPage.navID);
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
                  duration: const Duration(milliseconds: 700),
                  child: SizedBox(
                    width: kButtonWidth,
                    height: kButtonHeight,
                    child: OutlinedButton(
                      style: kCredentialOutlinedButtonStyle, // Use the constant style
                      onPressed: () {
                        Navigator.pushNamed(context, LoginPage.navID);
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
      ),
    );
  }
}
