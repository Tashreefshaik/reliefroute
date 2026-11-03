class Delivery {
  final String deliveryId;
  final String orderId;
  final String? driverId;
  final String address;
  final String status;
  final DateTime? trackingTime;

  Delivery({
    required this.deliveryId,
    required this.orderId,
    this.driverId,
    required this.address,
    required this.status,
    this.trackingTime,
  });

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      deliveryId: map['delivery_id'] ?? map['deliveryId'] ?? '',
      orderId: map['order_id'] ?? map['orderId'] ?? '',
      driverId: map['driver_id'] ?? map['driverId'],
      address: map['address'] ?? '',
      status: map['status'] ?? 'pending',
      trackingTime: map['tracking_time'] != null 
          ? DateTime.parse(map['tracking_time']) 
          : (map['trackingTime'] as DateTime?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'delivery_id': deliveryId,
      'order_id': orderId,
      'driver_id': driverId,
      'address': address,
      'status': status,
      'tracking_time': trackingTime?.toIso8601String(),
    };
  }
}
