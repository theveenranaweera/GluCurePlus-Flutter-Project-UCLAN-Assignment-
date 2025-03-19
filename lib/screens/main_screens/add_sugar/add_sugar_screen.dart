import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:typeset/typeset.dart';
import 'package:glucure_plus/screens/main_screens/constants_for_main_screens.dart';

class AddSugarScreen extends StatefulWidget {
  static const String navID = 'add_sugar_screen';

  @override
  State<AddSugarScreen> createState() => _AddSugarScreenState();
}

class _AddSugarScreenState extends State<AddSugarScreen> {
  /// Track user inputs if you like (e.g., with Controllers).
  /// For now, we just show placeholders:
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _sugarAmountController = TextEditingController();

  @override
  void dispose() {
    _productNameController.dispose();
    _sugarAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhiteBgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row for the heading and barcode icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // "Add Sugar Data" heading
                    TypeSet(
                      "*Add* Sugar Data",
                      style: kMainScreenHeadingText,
                    ),
                    // Barcode icon (placeholder for future scan screen)
                    IconButton(
                      onPressed: () {
                        // Navigate to your barcode scanner screen
                      },
                      icon: Icon(Iconsax.scan),
                      color: Colors.black,
                      iconSize: 28,
                      tooltip: "Scan Barcode",
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Container for input fields and ADD button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kLightPurpleBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Product Name field
                      TextField(
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Sans',
                        ),
                        controller: _productNameController,
                        decoration: const InputDecoration(
                          hintText: "Product Name",
                          hintStyle: TextStyle(
                            color: Color(0xBE373737),
                            fontFamily: 'Sans',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Sugar Amount field
                      TextField(
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Sans',
                        ),
                        controller: _sugarAmountController,
                        decoration: const InputDecoration(
                          hintText: "Sugar Amount (g)",
                          hintStyle: TextStyle(
                            color: Color(0xBE373737),
                            fontFamily: 'Sans',
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      // ADD button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDarkPurpleBgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Validate & Save your sugar data here.
                            // For example:
                            // final product = _productNameController.text;
                            // final sugarVal = double.tryParse(_sugarAmountController.text) ?? 0;
                            // if (sugarVal > 0) { ... } else { ... }
                          },
                          child: const Text(
                            "ADD",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Sans',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Search Food Database button
                GestureDetector(
                  onTap: () {
                    // Navigate to your food database search screen.
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kLightGreyButtonBgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Iconsax.search_normal_1,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Search Food Database",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Sans',
                          ),
                        ),
                      ],
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
