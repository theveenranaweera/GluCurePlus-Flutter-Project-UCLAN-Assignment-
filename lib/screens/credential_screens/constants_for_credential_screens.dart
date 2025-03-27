/// A collection of constants (colors, text styles, button styles, etc.)
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

const Color kDarkBgColor = Color(0xFF13101F);
const Color kButtonFillColor = Color(0xFFE4B875);

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
    fontSize: 21,
    fontWeight: FontWeight.bold,
    fontFamily: 'Sans',
    color: kDarkBgColor,
);

const TextStyle kCredentialCaptionText = TextStyle(
    color: Color(0xFF9E9E9E),
    fontSize: 14,
    fontFamily: 'Sans',
);

const TextStyle kCredentialLinkText = TextStyle(
    color: Color(0xFF0066FF),
    fontWeight: FontWeight.bold,
    fontSize: 14,
    fontFamily: 'Sans',
);

// Credential Button Dimensions
const double kButtonWidth = 280.0;
const double kButtonHeight = 65.0;

final ButtonStyle kCredentialButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: kButtonFillColor,
    foregroundColor: kDarkBgColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
    ),
);

final ButtonStyle kCredentialOutlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: kButtonFillColor,
    side: BorderSide(color: kButtonFillColor),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
    ),
);

Icon getGoBackIcon({Color color = Colors.white}) {
    return Icon(
        Iconsax.arrow_left_2,
        size: 20,
        color: color,
    );
}