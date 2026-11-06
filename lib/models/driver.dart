class Driver {
  final String driverId;
  final String name;
  final String phone;
  final String vehicleDetails;
  final bool availability;

  Driver({
    required this.driverId,
    required this.name,
    required this.phone,
    required this.vehicleDetails,
    required this.availability,
  });

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      driverId: map['driver_id'] ?? map['driverId'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      vehicleDetails: map['vehicle_details'] ?? map['vehicleDetails'] ?? '',
      availability: map['availability'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driver_id': driverId,
      'name': name,
      'phone': phone,
      'vehicle_details': vehicleDetails,
      'availability': availability,
    };
  }

  // Alias for Firestore compatibility
  Map<String, dynamic> toJson() => toMap();

  // Alias for Firestore compatibility
  factory Driver.fromJson(Map<String, dynamic> json) => Driver.fromMap(json);
}
