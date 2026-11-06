class OrderItem {
  final String orderItemId;
  final String orderId;
  final String medicationId;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.orderItemId,
    required this.orderId,
    required this.medicationId,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      orderItemId: map['order_item_id'] ?? map['orderItemId'] ?? '',
      orderId: map['order_id'] ?? map['orderId'] ?? '',
      medicationId: map['medication_id'] ?? map['medicationId'] ?? '',
      quantity: map['quantity'] ?? 0,
      unitPrice: (map['unit_price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order_item_id': orderItemId,
      'order_id': orderId,
      'medication_id': medicationId,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }

  // Alias for Firestore compatibility
  Map<String, dynamic> toJson() => toMap();

  // Alias for Firestore compatibility
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem.fromMap(json);
}
