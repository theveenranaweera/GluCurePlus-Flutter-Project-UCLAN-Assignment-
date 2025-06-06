/// Screen for adding sugar data (product name & sugar amount) to Firestore.
import 'package:flutter/material.dart';
import 'package:glucure_plus/screens/main_screens/food_search_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:typeset/typeset.dart';
import 'package:glucure_plus/screens/main_screens/constants_for_main_screens.dart';
import 'package:glucure_plus/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddSugarScreen extends StatefulWidget {
  static const String navID = 'add_sugar_screen';

  const AddSugarScreen({Key? key}) : super(key: key);

  @override
  State<AddSugarScreen> createState() => _AddSugarScreenState();
}

class _AddSugarScreenState extends State<AddSugarScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _sugarAmountController = TextEditingController();

  // Controls whether the ModalProgressHUD shows a loading spinner.
  bool _showLoadingSpinner = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _sugarAmountController.dispose();
    super.dispose();
  }

  // Saves sugar data to Firestore with basic validations.
  Future<void> _handleAddSugar() async {
    final String productName = _productNameController.text.trim();
    final String sugarText = _sugarAmountController.text.trim();
    final double? sugarAmount = double.tryParse(sugarText);

    // Validate decimal places
    if (sugarText.contains('.')) {
      final parts = sugarText.split('.');
      if (parts.length > 1 && parts[1].length > 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter a sugar value with at most 2 decimal places."),
          ),
        );
        return;
      }
    }

    if (productName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a product name.")),
      );
      return;
    }

    if (sugarAmount == null || sugarAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid sugar amount.")),
      );
      return;
    }

    setState(() {
      _showLoadingSpinner = true;
    });

    final dateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      await FirestoreService().saveSugarLogForDay(
        productName: productName,
        sugarAmount: sugarAmount,
        dateString: dateString,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sugar log saved for $productName!")),
      );
      _productNameController.clear();
      _sugarAmountController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving sugar log: $e")),
      );
    } finally {
      setState(() {
        _showLoadingSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.black,
      inAsyncCall: _showLoadingSpinner,
      child: Scaffold(
        backgroundColor: kOffWhiteBgColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row for the heading
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TypeSet(
                        "*Add* Sugar Data",
                        style: kMainScreenHeadingText,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Container for input fields + "ADD" button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kLightPurpleBgColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kDarkPurpleBgColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _handleAddSugar,
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
                  const SizedBox(height: 25),

                  // Search Food Database button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, FoodSearchScreen.navID);
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
                              fontSize: 15,
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
      ),
    );
  }
}
