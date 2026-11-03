import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/medication.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addItem(Medication medication) {
    final existingIndex = _items.indexWhere(
      (item) => item.medication.medicationId == medication.medicationId,
    );

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(CartItem(
        cartItemId: DateTime.now().millisecondsSinceEpoch.toString(),
        medication: medication,
        quantity: 1,
      ));
    }
    notifyListeners();
  }

  void removeItem(String cartItemId) {
    _items.removeWhere((item) => item.cartItemId == cartItemId);
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(cartItemId);
      return;
    }

    final index = _items.indexWhere((item) => item.cartItemId == cartItemId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool hasPrescriptionRequiredItems() {
    return _items.any((item) => item.medication.prescriptionRequired);
  }
}
