import 'package:flutter/material.dart';
import 'package:glucure_plus/services/off_api_service.dart';
import 'package:glucure_plus/screens/main_screens/constants_for_main_screens.dart';
import 'package:glucure_plus/screens/credential_screens/constants_for_credential_screens.dart';
import 'package:typeset/typeset.dart';
import 'package:glucure_plus/screens/main_screens/add_sugar_screen.dart';

class FoodSearchScreen extends StatefulWidget {
  static const String navID = 'food_search_screen';

  const FoodSearchScreen({Key? key}) : super(key: key);

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final OpenFoodFactsApiService _openFoodFactsApiService = OpenFoodFactsApiService();

  bool _isLoading = false;
  String _errorMessage = "";

  // For name search results
  List<Map<String, dynamic>> _searchResults = [];

  // For barcode result
  Map<String, dynamic>? _barcodeResult;

  /// Handles the actual search logic: either by name or by barcode.
  Future<void> _handleSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() => _errorMessage = "Please enter a product name or barcode.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
      _searchResults.clear();
      _barcodeResult = null;
    });

    try {
      // If query is purely numeric, treat it as a barcode
      if (RegExp(r'^[0-9]+$').hasMatch(query)) {
        final product = await _openFoodFactsApiService.searchByBarcode(query);
        if (product == null) {
          setState(() => _errorMessage = "No product found for barcode: $query");
        } else {
          setState(() => _barcodeResult = product);
        }
      } else {
        // Otherwise, treat as a product name search
        final results = await _openFoodFactsApiService.searchByName(query);
        if (results.isEmpty) {
          setState(() => _errorMessage = "No products found for '$query'");
        } else {
          setState(() => _searchResults = results);
        }
      }
    } catch (e) {
      setState(() => _errorMessage = "Error searching products: $e");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1) Match the off-white background
      backgroundColor: kOffWhiteBgColor,
      appBar: AppBar(
        backgroundColor: kOffWhiteBgColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: getGoBackIcon(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2) Heading with TypeSet, matching style from ProfileSettingsScreen
              TypeSet(
                "*Search* Database",
                style: kMainScreenHeadingText,
              ),
              const SizedBox(height: 15),

              // 3) Container for the search field, styled similarly to the text fields
              Container(
                decoration: BoxDecoration(
                  color: kLightGreyButtonBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Sans',
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Item Name or Barcode Value",
                    hintStyle: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Sans',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4) "Search" Button, styled like the "SAVE" button in ProfileSettingsScreen
              Center(
                child: SizedBox(
                  width: 120,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDarkPurpleBgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _handleSearch,
                    child: const Text(
                      "SEARCH",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 5) Loading indicator or error message
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // 6) Results
              // Wrap results in a container with a subtle background, like kLightPurpleBgColor
              if (_barcodeResult != null)
                Container(
                  decoration: BoxDecoration(
                    color: kLightPurpleBgColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(13),
                  child: _buildBarcodeResult(_barcodeResult!),
                )
              else if (_searchResults.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: kLightPurpleBgColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(13),
                  child: _buildNameSearchResults(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarcodeResult(Map<String, dynamic> product) {
    final productName = product["product_name"] ?? "Unknown Product";
    final nutriments = product["nutriments"] ?? {};
    final sugars = nutriments["sugars_100g"]?.toString() ?? "N/A";

    return Card(
      color: kLightPurpleBgColor,
      child: ListTile(
        title: Text(productName),
        subtitle: Text("Sugar Level: $sugars g"),
      ),
    );
  }

  Widget _buildNameSearchResults() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        final productName = product["product_name"] ?? "Unknown Product";
        final nutriments = product["nutriments"] ?? {};
        final sugars = nutriments["sugars"]?.toString() ?? "N/A";

        return Card(
          color: const Color(0xFF9E91AA),
          child: ListTile(
            title: Text(
              productName,
              style: const TextStyle(color: Color(0xFF272033)),
            ),
            subtitle: Text(
              "Sugar Level: $sugars g",
              style: const TextStyle(color: Color(0xFF272033)),
            ),
          ),
        );

      },
    );
  }
}
