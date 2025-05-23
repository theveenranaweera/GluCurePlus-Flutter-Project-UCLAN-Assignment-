/// A screen that allows the user to reset their password via email link.
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:typeset/typeset.dart';
import 'package:glucure_plus/screens/credential_screens/constants_for_credential_screens.dart';
import 'package:glucure_plus/widgets/credential_input_field_widget.dart';
import 'package:glucure_plus/services/user_auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String navID = 'forgot_password_screen';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources.
    _emailController.dispose();
    super.dispose();
  }

  // Sends a reset link to the user's email using AuthService.
  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email.")),
      );
      return;
    }
    final authService = AuthService();
    try {
      await authService.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reset link sent to $email")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBgColor,
      appBar: AppBar(
        backgroundColor: kDarkBgColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
              children: [
                // Heading
                FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: TypeSet(
                      "We’ll send you \na link to #reset# \nyour password...",
                      style: kCredentialScreenHeadingText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        
                const SizedBox(height: 40),
        
                // Email Address
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: CredentialInputField(
                    label: "Email Address",
                    hintText: "name@email.com",
                    prefixIcon: Iconsax.sms,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                ),
        
                const SizedBox(height: 20),
        
                // Send Link button
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: Center(
                    child: SizedBox(
                      width: kButtonWidth,
                      height: kButtonHeight,
                      child: ElevatedButton(
                        style: kCredentialButtonStyle,
                        onPressed: _sendResetLink,
                        child: Text(
                          "Send Link",
                          style: kCredentialButtonText,
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