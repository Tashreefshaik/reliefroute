class Medication {
  final String medicationId;
  final String name;
  final String description;
  final double price;
  final int stockQty;
  final bool prescriptionRequired;
  final String category;
  final String? imageUrl;

  Medication({
    required this.medicationId,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQty,
    required this.prescriptionRequired,
    this.category = 'General',
    this.imageUrl,
  });

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      medicationId: map['medication_id'] ?? map['medicationId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      stockQty: map['stock_qty'] ?? map['stockQty'] ?? 0,
      prescriptionRequired: map['prescription_required'] ?? map['prescriptionRequired'] ?? false,
      category: map['category'] ?? 'General',
      imageUrl: map['image_url'] ?? map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medication_id': medicationId,
      'name': name,
      'description': description,
      'price': price,
      'stock_qty': stockQty,
      'prescription_required': prescriptionRequired,
      'category': category,
      'image_url': imageUrl,
    };
  }

  // Alias for Firestore compatibility
  Map<String, dynamic> toJson() => toMap();

  // Alias for Firestore compatibility
  factory Medication.fromJson(Map<String, dynamic> json) => Medication.fromMap(json);
}
