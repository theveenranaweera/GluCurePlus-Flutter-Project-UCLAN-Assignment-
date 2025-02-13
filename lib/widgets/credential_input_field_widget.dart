import 'package:flutter/material.dart';
import 'package:glucure_plus/screens/credential_screens/constants_for_credential_screens.dart';

class CredentialInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CredentialInputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          controller: controller,
          keyboardType: keyboardType,
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
            fillColor: kDarkBgColor,
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
}
