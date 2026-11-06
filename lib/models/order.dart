class Order {
  final String orderId;
  final String userId;
  final String? prescriptionId;
  final DateTime orderDate;
  final String status;
  final double totalAmount;

  Order({
    required this.orderId,
    required this.userId,
    this.prescriptionId,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['order_id'] ?? map['orderId'] ?? '',
      userId: map['user_id'] ?? map['userId'] ?? '',
      prescriptionId: map['prescription_id'] ?? map['prescriptionId'],
      orderDate: map['order_date'] != null 
          ? DateTime.parse(map['order_date']!) 
          : (map['orderDate'] as DateTime?) ?? DateTime.now(),
      status: map['status'] ?? 'pending',
      totalAmount: (map['total_amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'prescription_id': prescriptionId,
      'order_date': orderDate.toIso8601String(),
      'status': status,
      'total_amount': totalAmount,
    };
  }

  // Alias for Firestore compatibility
  Map<String, dynamic> toJson() => toMap();

  // Alias for Firestore compatibility
  factory Order.fromJson(Map<String, dynamic> json) => Order.fromMap(json);
}
