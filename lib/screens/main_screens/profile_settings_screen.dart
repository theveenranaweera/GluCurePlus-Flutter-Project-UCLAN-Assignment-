import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glucure_plus/screens/main_screens/constants_for_main_screens.dart';
import 'package:glucure_plus/screens/credential_screens/welcome_screen.dart'; // For navigation after sign-out
import 'package:typeset/typeset.dart'; // If you're using the TypeSet widget

// If you have a local storage or Firestore service for daily target, import it here:
// import 'package:glucure_plus/services/local_storage_service.dart';
// import 'package:glucure_plus/services/firestore_service.dart';

class ProfileSettingsScreen extends StatefulWidget {
  static const String navID = 'profile_settings_screen';

  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _auth = FirebaseAuth.instance;
  User? _currentUser;

  // Controller for the daily target field
  final TextEditingController _dailyTargetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;

    // Example: Load daily target from local storage or Firestore
    // _loadDailyTarget();
  }

  // Example function to load daily target (if you're using local storage or Firestore).
  // Future<void> _loadDailyTarget() async {
  //   final double goal = await LocalStorageService().getDailySugarGoal();
  //   setState(() {
  //     _dailyTargetController.text = goal.toString();
  //   });
  // }

  // Example sign-out function
  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, WelcomePage.navID);
  }

  @override
  void dispose() {
    _dailyTargetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhiteBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Settings heading
              TypeSet(
                "Profile *Settings*",
                style: kMainScreenHeadingText,
              ),
              const SizedBox(height: 25),

              // Centered avatar + user email
              Center(
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[300],
                      // Replace with your own asset path or network image
                      backgroundImage: const AssetImage("assets/images/default_profile_image.png"),
                    ),
                    const SizedBox(height: 12),

                    // User email
                    Text(
                      _currentUser?.email ?? "No Email Found",
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontFamily: 'Sans'
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // Daily target label
              const Text(
                "DAILY TARGET",
                style: kMainScreenSubHeadingText,
              ),
              const SizedBox(height: 8),

              // Daily target input
              Container(
                decoration: BoxDecoration(
                  color: kLightGreyButtonBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _dailyTargetController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Color(0x9B000000), fontWeight: FontWeight.bold, fontFamily: 'Sans'),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    // If you want to save the new daily target when the user presses "Enter":
                    // final newGoal = double.tryParse(value) ?? 35.0;
                    // LocalStorageService().setDailySugarGoal(newGoal);
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Sign Out button
              Center(
                child: SizedBox(
                  width: 125,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0x6EC6C6C6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _signOut,
                    child: const Text(
                      "SIGN OUT",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Sans',
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
