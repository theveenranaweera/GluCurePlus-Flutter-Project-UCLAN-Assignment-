import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glucure_plus/screens/main_screens/constants_for_main_screens.dart';
import 'package:glucure_plus/screens/credential_screens/welcome_screen.dart';
import 'package:typeset/typeset.dart';
import 'package:glucure_plus/services/firestore_service.dart';

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
    _loadDailyTarget();
  }

  // Load daily target from Firestore
  Future<void> _loadDailyTarget() async {
    try {
      final double goal = await FirestoreService().getDailySugarGoal();
      setState(() {
        _dailyTargetController.text = goal.toString();
      });
    } catch (e) {
      print("Error loading daily target: $e");
    }
  }

  // Save daily target to Firestore with input validations.
  Future<void> _saveDailyTarget() async {
    // 1. Retrieve the text from the daily target field.
    final targetText = _dailyTargetController.text.trim();

    // 2. Check if the daily target field is empty.
    if (targetText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your daily target.")),
      );
      return; // Exit if no target is provided.
    }

    // 3. Try to convert the daily target text into a number.
    final dailyTarget = double.tryParse(targetText);
    if (dailyTarget == null || dailyTarget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid daily target.")),
      );
      return; // Exit if the target is invalid.
    }

    // 4. Save the daily target to Firestore.
    try {
      await FirestoreService().setDailySugarGoal(dailyTarget);
      // 5. Show a success message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Daily target updated to ${dailyTarget.toStringAsFixed(1)} g")),
      );
    } catch (e) {
      // 6. If there is an error, display it.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating daily target: $e")),
      );
    }
  }

  // Sign-out function
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
                        fontFamily: 'Sans',
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
                  style: const TextStyle(
                    color: Color(0x9B000000),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sans',
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _saveDailyTarget(),
                ),
              ),
              const SizedBox(height: 30),

              // Save button
              Center(
                child: SizedBox(
                  width: 125,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x6EC6C6C6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _saveDailyTarget,
                    child: const Text(
                      "SAVE",
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
              const SizedBox(height: 20),

              // Sign Out button
              Center(
                child: SizedBox(
                  width: 125,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x6EC6C6C6),
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
