import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:glucure_plus/screens/credential_screens/constants_for_credential_screens.dart';
import 'package:typeset/typeset.dart';
import 'package:iconsax/iconsax.dart';
import 'credential_input_field_widget.dart';
import 'forgot_password_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBgColor,
      appBar: AppBar(
        backgroundColor: kDarkBgColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: goBackIcon,
        ),
      ),
      body: SafeArea(
        child: Padding(
          // Moved to Padding for consistent spacing
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Heading
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Center(
                  child: TypeSet(
                    "Let’s #Continue# \nto track your \nSugar Intake!",
                    style: kCredentialScreenHeadingText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Email
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: credentialInputField(
                  label: "Email Address",
                  hintText: "name@email.com",
                  prefixIcon: Iconsax.sms,
                ),
              ),

              // Password
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: credentialInputField(
                  label: "Password",
                  obscureText: true,
                  hintText: "Enter Password",
                  prefixIcon: Iconsax.lock_14,
                ),
              ),

              const SizedBox(height: 30),

              // Sign In button (use constants for style and size)
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Center(
                  // Use SizedBox to set the button’s width/height from constants
                  child: SizedBox(
                    width: kButtonWidth,
                    height: kButtonHeight,
                    child: ElevatedButton(
                      style: kCredentialButtonStyle,
                      onPressed: () {
                        // Sign in functionality (placeholder)
                      },
                      child: Text(
                        "Sign In",
                        style: kCredentialButtonText,
                      ),
                    ),
                  ),
                ),
              ),

              // Forgot Password?
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: kCredentialLinkText,
                    ),
                  ),
                ),
              ),

              // Separator line
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Center(
                  child: Container(
                    width: 290,
                    height: 1.5,
                    color: Colors.grey.shade700, // Change to your preferred color
                  ),
                ),
              ),

              // "New to our World? Sign Up"
              FadeInUp(
                duration: const Duration(milliseconds: 1100),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Possibly go to signup
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "New to our World? ",
                        style: kCredentialCaptionText,
                        children: <InlineSpan>[
                          TextSpan(
                            text: "Sign Up",
                            style: kCredentialLinkText,
                          ),
                        ],
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
