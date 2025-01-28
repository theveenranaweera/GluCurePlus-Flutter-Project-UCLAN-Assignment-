import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:typeset/typeset.dart';
import 'constants_for_credential_screens.dart';
import '../../widgets/credential_input_field_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String navID = 'forgot_password_screen';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBgColor,
      appBar: AppBar(
        backgroundColor: kDarkBgColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: kGoBackIconStyle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              FadeInUp(
                duration: const Duration(milliseconds: 500),
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
                duration: const Duration(milliseconds: 600),
                child: CredentialInputField(
                  label: "Email Address",
                  hintText: "name@email.com",
                  prefixIcon: Iconsax.sms,
                ),
              ),

              const SizedBox(height: 30),

              // Send Link button
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Center(
                  child: SizedBox(
                    width: kButtonWidth,
                    height: kButtonHeight,
                    child: ElevatedButton(
                      style: kCredentialButtonStyle,
                      onPressed: () {
                        // Password reset functionality
                      },
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
    );
  }
}