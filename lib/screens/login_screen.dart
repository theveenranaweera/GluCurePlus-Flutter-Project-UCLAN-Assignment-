import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:glucure_plus/constants.dart';
import 'package:typeset/typeset.dart';
import 'package:iconsax/iconsax.dart';
import 'credential_input_field_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDarkBgColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Iconsax.arrow_left_2,
            size: 20,
            color: Colors.white,
          ),
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
                duration: const Duration(milliseconds: 1000),
                child: Center(
                  child: TypeSet(
                    // Force each line to match your wireframe layout:
                    "Let’s #Continue#\n"
                        "  to track your\n"
                        " Sugar Intake!",
                    style: kCredentialScreenHeadingText.copyWith(
                      fontSize: 30,
                    ),
                    // Align text to the left
                    textAlign: TextAlign.left,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Email
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: credentialInputField(
                  label: "Email Address",
                  hintText: "name@email.com",
                  prefixIcon: Iconsax.sms,
                ),
              ),

              // Password
              FadeInUp(
                duration: const Duration(milliseconds: 1300),
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
                duration: const Duration(milliseconds: 1400),
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
                        style: kCredentialButtonText.copyWith(
                          color: kDarkBgColor, // Ensure text is dark on gold
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // "New to our World? Sign Up"
              FadeInUp(
                duration: const Duration(milliseconds: 1500),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Possibly go to signup
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "New to our World? ",
                        style: TextStyle(color: Colors.grey[400]),
                        children: <InlineSpan>[
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              color: kQuickAccessCredentialTextColor,
                              fontWeight: FontWeight.bold,
                            ),
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
