import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
      backgroundColor: const Color(0xFFE4E5E0),

      body: SafeArea(
        child: Stack(
          children: [
            // Close (X) button in the top-right corner
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Or however you want to close
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black12,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black87,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Main content
            Padding(
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
                        Text(
                          "Add Sugar Data",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        // Barcode icon
                        IconButton(
                          onPressed: () {
                            // Navigate to your barcode scanner screen
                          },
                          icon: const Icon(Iconsax.scan),
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
                        color: const Color(0xFFCABBD1), // a light purple
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Product Name field
                          TextField(
                            controller: _productNameController,
                            decoration: const InputDecoration(
                              labelText: "Product Name",
                              labelStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Sugar Amount field
                          TextField(
                            controller: _sugarAmountController,
                            decoration: const InputDecoration(
                              labelText: "Sugar Amount (g)",
                              labelStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // Time row
                          GestureDetector(
                            onTap: () async {
                              // Open a time picker if you like:
                              // final newTime = await showTimePicker(...);
                              // if (newTime != null) {
                              //   setState(() => _timeString = _formatTimeOfDay(newTime));
                              // }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _timeString,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
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
                                backgroundColor: const Color(0xFF7E6680), // darker purple
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
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Iconsax.search_normal_1, color: Colors.black54),
                            SizedBox(width: 8),
                            Text(
                              "Search Food Database",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
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
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Add Favorites button
                    GestureDetector(
                      onTap: () {
                        // e.g. open favorites screen or show a modal
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
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
          ],
        ),
      ),
    );
  }

  /// Example function to format time as e.g. "9:41 AM"
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final hour12 = (hour % 12) == 0 ? 12 : (hour % 12);
    final minuteStr = minute < 10 ? '0$minute' : '$minute';
    return "$hour12:$minuteStr $ampm";
  }
}
