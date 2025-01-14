import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'constants_for_credential_screens.dart';

class SignupPage extends StatelessWidget {

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
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // helps when content might overflow
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: const Text(
                    "Join the World\nof GluCure+",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Full Name
                FadeInUp(
                  duration: const Duration(milliseconds: 1200),
                  child: _makeInput(label: "Full Name"),
                ),
                // Email
                FadeInUp(
                  duration: const Duration(milliseconds: 1300),
                  child: _makeInput(label: "Email Address"),
                ),
                // Password
                FadeInUp(
                  duration: const Duration(milliseconds: 1400),
                  child: _makeInput(label: "Password", obscureText: true),
                ),
                // Confirm Password
                FadeInUp(
                  duration: const Duration(milliseconds: 1500),
                  child: _makeInput(
                      label: "Confirm Password", obscureText: true),
                ),
                const SizedBox(height: 10),

                // Sign Up button
                FadeInUp(
                  duration: const Duration(milliseconds: 1600),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kButtonFillColor,
                        foregroundColor: kDarkBgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Sign up functionality (placeholder)
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Already have an account? Log In
                FadeInUp(
                  duration: const Duration(milliseconds: 1700),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        // Possibly navigate to login
                      },
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.grey[400]),
                          children: <InlineSpan>[
                            TextSpan(
                              text: "Log In",
                              style: TextStyle(
                                color: kButtonFillColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _makeInput({
    required String label,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          style: const TextStyle(color: Colors.white),
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
