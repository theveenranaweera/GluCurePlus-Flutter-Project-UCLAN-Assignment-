import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:typeset/typeset.dart';
import 'package:iconsax/iconsax.dart';
import 'constants_for_credential_screens.dart';
import 'credential_input_field_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Heading
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Center(
                  child: TypeSet(
                    "#Join# the World \nof GluCure+",
                    style: kCredentialScreenHeadingText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Full Name
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: credentialInputField(
                  label: "Name",
                  hintText: "Enter Full Name",
                  prefixIcon: Iconsax.user,
                ),
              ),

              // Email
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: credentialInputField(
                  label: "Email Address",
                  hintText: "name@email.com",
                  prefixIcon: Iconsax.sms,
                ),
              ),

              // Password
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: credentialInputField(
                  label: "Password",
                  obscureText: true,
                  hintText: "Enter Password",
                  prefixIcon: Iconsax.lock_14,
                ),
              ),

              // Confirm Password
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                child: credentialInputField(
                  label: "Confirm Password",
                  obscureText: true,
                  hintText: "Enter Password Again",
                  prefixIcon: Iconsax.lock_14,
                ),
              ),

              const SizedBox(height: 30),

              // Sign Up button
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Center(
                  child: SizedBox(
                    width: kButtonWidth,
                    height: kButtonHeight,
                    child: ElevatedButton(
                      style: kCredentialButtonStyle,
                      onPressed: () {
                        // Sign Up functionality
                      },
                      child: Text(
                        "Sign Up",
                        style: kCredentialButtonText.copyWith(
                          color: kDarkBgColor, // Dark text on gold button
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // "Already have an account? Log in"
              FadeInUp(
                duration: const Duration(milliseconds: 1100),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Possibly go to login
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: kCredentialCaptionText,
                        children: <InlineSpan>[
                          TextSpan(
                            text: "Log in",
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
