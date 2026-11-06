class Prescription {
  final String prescriptionId;
  final String userId;
  final String? imageUrl;
  final String status;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final String? medicationName;
  final String? dosage;
  final String? instructions;
  final DateTime? submittedAt;

  Prescription({
    required this.prescriptionId,
    required this.userId,
    this.imageUrl,
    required this.status,
    this.verifiedBy,
    this.verifiedAt,
    this.medicationName,
    this.dosage,
    this.instructions,
    this.submittedAt,
  });

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      prescriptionId: map['prescription_id'] ?? map['prescriptionId'] ?? '',
      userId: map['user_id'] ?? map['userId'] ?? '',
      imageUrl: map['image_url'] ?? map['imageUrl'],
      status: map['status'] ?? 'pending',
      verifiedBy: map['verified_by'] ?? map['verifiedBy'],
      verifiedAt: map['verified_at'] != null
          ? DateTime.parse(map['verified_at'])
          : (map['verifiedAt'] as DateTime?),
      medicationName: map['medication_name'] ?? map['medicationName'],
      dosage: map['dosage'],
      instructions: map['instructions'],
      submittedAt: map['submitted_at'] != null
          ? DateTime.parse(map['submitted_at'])
          : (map['submittedAt'] as DateTime?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prescription_id': prescriptionId,
      'user_id': userId,
      'image_url': imageUrl,
      'status': status,
      'verified_by': verifiedBy,
      'verified_at': verifiedAt?.toIso8601String(),
      'medication_name': medicationName,
      'dosage': dosage,
      'instructions': instructions,
      'submitted_at': submittedAt?.toIso8601String(),
    };
  }

  // Alias for Firestore compatibility
  Map<String, dynamic> toJson() => toMap();

  // Alias for Firestore compatibility
  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription.fromMap(json);
}
