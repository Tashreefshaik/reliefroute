import 'package:flutter/foundation.dart';
import '../models/medication.dart';

class FavoriteService extends ChangeNotifier {
  final Set<String> _favoriteMedicationIds = {};

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteMedicationIds);

  bool isFavorite(String medicationId) {
    return _favoriteMedicationIds.contains(medicationId);
  }

  void toggleFavorite(String medicationId) {
    if (_favoriteMedicationIds.contains(medicationId)) {
      _favoriteMedicationIds.remove(medicationId);
    } else {
      _favoriteMedicationIds.add(medicationId);
    }
    notifyListeners();
  }

  void removeFavorite(String medicationId) {
    _favoriteMedicationIds.remove(medicationId);
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteMedicationIds.clear();
    notifyListeners();
  }

  int get favoriteCount => _favoriteMedicationIds.length;
}
