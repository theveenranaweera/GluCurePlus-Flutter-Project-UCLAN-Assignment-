import 'package:flutter/material.dart';
import 'package:glucure_plus/services/off_api_service.dart';

class FoodSearchScreen extends StatefulWidget {
  static const String navID = 'food_search_screen';

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
      appBar: AppBar(
        title: const Text("Search Database"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Enter Item Name or Barcode Value",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Search Button
            ElevatedButton(
              onPressed: _handleSearch,
              child: const Text("SEARCH"),
            ),
            const SizedBox(height: 12),

            // Loading indicator
            if (_isLoading) const CircularProgressIndicator(),

            // Error message (if any)
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Expanded area to show results
            Expanded(
              child: _barcodeResult != null
                  ? _buildBarcodeResult(_barcodeResult!)
                  : _buildNameSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcodeResult(Map<String, dynamic> product) {
    final productName = product["product_name"] ?? "Unknown Product";
    final nutriments = product["nutriments"] ?? {};
    final sugar100g = nutriments["sugars_100g"]?.toString() ?? "N/A";

    return Card(
      child: ListTile(
        title: Text(productName),
        subtitle: Text("Sugar Level: $sugar100g"),
      ),
    );
  }

  Widget _buildNameSearchResults() {
    if (_searchResults.isEmpty) {
      return const SizedBox(); // or a placeholder widget
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        final productName = product["product_name"] ?? "Unknown Product";
        final nutriments = product["nutriments"] ?? {};
        final sugars = nutriments["sugars"]?.toString() ?? "N/A";

        return Card(
          child: ListTile(
            title: Text(productName),
            subtitle: Text("Sugar Level: $sugars"),
          ),
        );
      },
    );
  }
}