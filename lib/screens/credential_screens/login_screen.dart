import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:typeset/typeset.dart';
import 'package:glucure_plus/screens/credential_screens/constants_for_credential_screens.dart';
import 'package:glucure_plus/screens/credential_screens/signup_screen.dart';
import 'package:glucure_plus/screens/credential_screens/forgot_password_screen.dart';
import 'package:glucure_plus/screens/main_screens/dashboard_screen.dart';
import 'package:glucure_plus/widgets/credential_input_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  static const String navID = 'login_screen';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showLoadingSpinner = false;

  // Controllers for email and password.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources.
    _emailController.dispose();
    _passwordController.dispose();
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
            onPressed: () => Navigator.pop(context),
            icon: kGoBackIconStyle,
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
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
                    child: CredentialInputField(
                      label: "Email Address",
                      hintText: "name@email.com",
                      prefixIcon: Iconsax.sms,
                      // Pass the controller to capture the email.
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  // Password
                  FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    child: CredentialInputField(
                      label: "Password",
                      obscureText: true,
                      hintText: "Enter Password",
                      prefixIcon: Iconsax.lock_14,
                      controller: _passwordController,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Sign In button with Firebase integration
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
          
                            try {
                              // Sign in the user using Firebase Authentication.
                              final newUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );
                              // If sign in is successful, navigate to the Dashboard.
                              Navigator.pushNamed(context, DashboardPage.navID);
          
                              setState(() {
                                showLoadingSpinner = false;
                              });
          
                            } catch (error) {
                              // Show an error message if sign in fails.
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Sign In Failed: ${error.toString()}")),
                              );
          
                              setState(() {
                                showLoadingSpinner = false;
                              });
                            }
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
                          Navigator.pushNamed(context, ForgotPasswordPage.navID);
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
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  // "New to our World? Sign Up"
                  FadeInUp(
                    duration: const Duration(milliseconds: 1100),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpPage.navID);
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
        ),
      ),
    );
  }
}