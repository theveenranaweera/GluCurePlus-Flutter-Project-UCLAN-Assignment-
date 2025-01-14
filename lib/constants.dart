import 'package:flutter/material.dart';

const Color kDarkBgColor = Color(0xFF13101F);
const Color kButtonFillColor = Color(0xFFE4B875);
const Color kQuickAccessCredentialTextColor = Color(0xFF0066FF);

const TextStyle kWelcomeScreenHeadingText = TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontWeight: FontWeight.bold,
    fontFamily: 'Sans',
);

const TextStyle kCredentialScreenHeadingText = TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontFamily: 'Sans',
);

const TextStyle kCredentialButtonText = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'Sans',
);

// Credential Button Dimensions
const double kButtonWidth = 277.0;
const double kButtonHeight = 69.0;

final kCredentialButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: kButtonFillColor,
    foregroundColor: kDarkBgColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
    ),
);

// Outlined Button Style
final ButtonStyle kCredentialOutlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: kButtonFillColor,
    side: BorderSide(color: kButtonFillColor),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
    ),
);
