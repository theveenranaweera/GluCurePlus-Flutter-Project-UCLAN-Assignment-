/// A service for persisting user preferences locally via SharedPreferences.
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glucure_plus/screens/main_screens/dashboard_body.dart';

class LocalStorageService {
  static const String _keySortPreference = 'sortPreference';

  // Save the sorting preference as a string.
  Future<void> setSortPreference(SortOption sortOption) async {
    final prefs = await SharedPreferences.getInstance();
    String sortString;
    switch (sortOption) {
      case SortOption.alphabetical:
        sortString = 'alphabetical';
        break;
      case SortOption.highestSugar:
        sortString = 'highestSugar';
        break;
      case SortOption.chronological:
      default:
        sortString = 'chronological';
        break;
    }
    await prefs.setString(_keySortPreference, sortString);
  }

  // Retrieve the saved sorting preference. Defaults to chronological.
  Future<SortOption> getSortPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final sortString = prefs.getString(_keySortPreference);
    switch (sortString) {
      case 'alphabetical':
        return SortOption.alphabetical;
      case 'highestSugar':
        return SortOption.highestSugar;
      case 'chronological':
      default:
        return SortOption.chronological;
    }
  }
}
