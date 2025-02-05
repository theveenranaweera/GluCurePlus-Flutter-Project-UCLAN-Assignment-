import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:glucure_plus/screens/main_screens/constants_for_main_screens.dart';
import 'package:typeset/typeset.dart';

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

  /// Holds the selected time as a string. By default, we use current time.
  late String _timeString;

  /// Example function to format time as e.g. "9:41 AM"
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final hour12 = (hour % 12) == 0 ? 12 : (hour % 12);
    final minuteStr = minute < 10 ? '0$minute' : '$minute';
    return "$hour12:$minuteStr $amPm";
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Example: Format as 9:41 AM
    _timeString = _formatTime(now);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _sugarAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Light background from your wireframe
      backgroundColor: kOffWhiteBgColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row for the heading and the barcode icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // "Add Sugar Data"
                    TypeSet(
                      "*Add* Sugar Data",
                      style: kMainScreenHeadingText,
                    ),

                    // Barcode icon
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

                // Big container for Product Name, Sugar Amount, Time, ADD button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBBB2CC), // a light purple
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Product Name field
                      TextField(
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

                      // Time row
                      GestureDetector( // CONVERT THIS TO A DROP DOWN LIST
                        onTap: () async {
                          // Open a time picker if you like:
                          // final newTime = await showTimePicker(...);
                          // if (newTime != null) {
                          //   setState(() => _timeString = _formatTimeOfDay(newTime));
                          // }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0x32787880),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _timeString,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontFamily: 'Sans'
                            ),
                          ),
                        ),
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
                            // Validate & Save
                            // e.g.:
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
                              fontFamily: 'Sans'
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
                    // e.g. open a screen or show a list
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
                            color: Colors.black54
                        ),

                        SizedBox(width: 10),

                        Text(
                          "Search Food Database",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Sans'
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // "FAVOURITES" label
                const Text(
                  "FAVOURITES",
                  style: kMainScreenSubHeadingText,
                ),

                const SizedBox(height: 10),

                // Add Favorites button
                GestureDetector(
                  onTap: () {
                    // e.g. open favorites screen or show a modal
                  },
                  child: Container(
                    height: 65,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kLightGreyButtonBgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Iconsax.add_circle, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(
                          "ADD FAVORITES",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Sans'
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // You can add more spacing or additional sections
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
