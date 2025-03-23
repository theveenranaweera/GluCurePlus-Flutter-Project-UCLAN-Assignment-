import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:glucure_plus/screens/credential_screens/welcome_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:typeset/typeset.dart';
import 'package:glucure_plus/screens/credential_screens/constants_for_credential_screens.dart';
import 'package:glucure_plus/screens/credential_screens/login_screen.dart';
import 'package:glucure_plus/screens/main_screens/dashboard_screen.dart';
import 'package:glucure_plus/widgets/credential_input_field_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:glucure_plus/services/user_auth_service.dart';

class SignUpPage extends StatefulWidget {
  static const String navID = 'signup_screen';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool showLoadingSpinner = false;

  // Controllers to capture the user's input.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showLoadingSpinner,
      child: Scaffold(
        backgroundColor: kDarkBgColor,
        appBar: AppBar(
          backgroundColor: kDarkBgColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                WelcomePage.navID,
                    (Route<dynamic> route) => false,
              );
            },
            icon: getGoBackIcon(),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Heading
                  FadeInUp(
                    duration: const Duration(milliseconds: 300),
                    child: Center(
                      child: TypeSet(
                        "#Join# the World \nof GluCure+",
                        style: kCredentialScreenHeadingText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: CredentialInputField(
                      label: "Email Address",
                      hintText: "name@email.com",
                      prefixIcon: Iconsax.sms,
                      // Pass the controller to capture user input.
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  // Password
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: CredentialInputField(
                      label: "Password",
                      obscureText: true,
                      hintText: "Enter Password",
                      prefixIcon: Iconsax.lock_14,
                      controller: _passwordController,
                    ),
                  ),
                  // Confirm Password
                  FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    child: CredentialInputField(
                      label: "Confirm Password",
                      obscureText: true,
                      hintText: "Enter Password Again",
                      prefixIcon: Iconsax.lock_14,
                      controller: _confirmPasswordController,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sign Up button with Firebase integration
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: Center(
                      child: SizedBox(
                        width: kButtonWidth,
                        height: kButtonHeight,
                        child: ElevatedButton(
                          style: kCredentialButtonStyle,
                          onPressed: () async {
                            setState(() {
                              showLoadingSpinner = true;
                            });

                            // Ensure the password fields match before proceeding.
                            if (_passwordController.text != _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Passwords do not match")),
                              );
                              setState(() {
                                showLoadingSpinner = false;
                              });
                              return;
                            }

                            final authService = AuthService();
                            try {
                              final newUser = await authService.signUpWithEmail(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );
                              if (newUser != null) {
                                // Inform the user to verify their email before accessing the app.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Verification email sent. Please check your inbox.")),
                                );
                                Navigator.pushNamed(context, LoginPage.navID);
                              }
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Sign Up Failed: ${error.toString()}")),
                              );
                            }
                            setState(() {
                              showLoadingSpinner = false;
                            });
                          },
                          child: const Text(
                            "Sign Up",
                            style: kCredentialButtonText,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Google Sign Up button
                  FadeInUp(
                    duration: const Duration(milliseconds: 900),
                    child: Center(
                      child: SizedBox(
                        width: kButtonWidth,
                        height: kButtonHeight,
                        child: OutlinedButton.icon(
                          style: kCredentialOutlinedButtonStyle,
                          icon: const Icon(Icons.login, color: kButtonFillColor),
                          label: Text(
                            "Sign up with Google",
                            style: kCredentialButtonText.copyWith(
                              color: kButtonFillColor, // dark text on gold
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              showLoadingSpinner = true;
                            });

                            // Create an instance of AuthService.
                            final AuthService _authService = AuthService();
                            final userCredential = await _authService.signInWithGoogle();
                            if (userCredential != null) {
                              Navigator.pushNamed(context, DashboardScreen.navID);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Google Sign In Failed")),
                              );
                            }
                            setState(() {
                              showLoadingSpinner = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Center(
                      child: Container(
                        width: 290,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),

                  // "Already have an account? Log in"
                  FadeInUp(
                    duration: const Duration(milliseconds: 1100),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginPage.navID);
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
        ),
      ),
    );
  }
}