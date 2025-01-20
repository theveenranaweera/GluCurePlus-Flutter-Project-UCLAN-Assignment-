import 'package:flutter/material.dart';
import '../screens/credential_screens/constants_for_credential_screens.dart';

// A reusable TextField input widget for both Login & Signup pages.
Widget credentialInputField({
  required String label,
  bool obscureText = false,
  String hintText = "",
  IconData? prefixIcon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // Field label
      Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Sans',
        ),
      ),

      // TextField
      TextField(
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[700],
            fontFamily: 'Sans',
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.grey[500])
              : null,
          filled: true,
          fillColor: kDarkBgColor,  // or another fill color if you prefer
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
        ),
      ),

      const SizedBox(height: 25),
    ],
  );
}
