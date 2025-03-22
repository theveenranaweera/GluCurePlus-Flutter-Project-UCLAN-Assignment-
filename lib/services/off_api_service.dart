import 'dart:convert';
import 'package:http/http.dart' as http;

/// A simple service class to fetch data from OpenFoodFacts using raw HTTP calls.
class OpenFoodFactsApiService {
  /// Search for products by a text query using the v2 search endpoint.
  /// Returns a list of product maps.
  Future<List<Map<String, dynamic>>> searchByName(String query) async {
    final url = Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&json=1'
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final products = data['products'] as List<dynamic>?;
      if (products != null) {
        return products.map((p) => p as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } else {
      throw Exception(
        "Error retrieving data from OpenFoodFacts (status: ${response.statusCode})",
      );
    }
  }

  /// Search for a product by barcode using the v2 product endpoint.
  /// Returns a product map or null if not found.
  Future<Map<String, dynamic>?> searchByBarcode(String barcode) async {
    // Example endpoint (GET):
    // https://world.openfoodfacts.org/api/v2/product/5410188032302.json
    final url = Uri.parse(
      "https://world.openfoodfacts.org/api/v2/product/$barcode.json",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // If "status" == 1, the product is found
      if (data['status'] == 1) {
        return data['product'] as Map<String, dynamic>;
      } else {
        return null;
      }
    } else {
      throw Exception(
        "Error retrieving product (status: ${response.statusCode})",
      );
    }
  }
}