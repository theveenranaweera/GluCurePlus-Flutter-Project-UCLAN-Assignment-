import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:glucure_plus/constants.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: darkBg,
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
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  "Let’s Continue\nto track your\nSugar Intake!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Email field
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: _makeInput(label: "Email Address"),
              ),

              // Password field
              FadeInUp(
                duration: const Duration(milliseconds: 1300),
                child: _makeInput(label: "Password", obscureText: true),
              ),
              const SizedBox(height: 20),

              // Sign In button
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonFill,
                      foregroundColor: darkBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Sign in functionality (placeholder)
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

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
                              color: buttonFill,
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
              borderSide: BorderSide(color: Colors.grey.shade700),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
