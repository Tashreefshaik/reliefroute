import 'medication.dart';

class CartItem {
  final String cartItemId;
  final Medication medication;
  int quantity;

  CartItem({
    required this.cartItemId,
    required this.medication,
    required this.quantity,
  });

  double get totalPrice => medication.price * quantity;

  CartItem copyWith({
    String? cartItemId,
    Medication? medication,
    int? quantity,
  }) {
    return CartItem(
      cartItemId: cartItemId ?? this.cartItemId,
      medication: medication ?? this.medication,
      quantity: quantity ?? this.quantity,
    );
  }
}
