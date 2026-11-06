class RefillReminder {
  final String reminderId;
  final String userId;
  final String medicationId;
  final DateTime reminderDate;
  final String frequency;
  final bool active;

  RefillReminder({
    required this.reminderId,
    required this.userId,
    required this.medicationId,
    required this.reminderDate,
    required this.frequency,
    required this.active,
  });

  factory RefillReminder.fromMap(Map<String, dynamic> map) {
    return RefillReminder(
      reminderId: map['reminder_id'] ?? map['reminderId'] ?? '',
      userId: map['user_id'] ?? map['userId'] ?? '',
      medicationId: map['medication_id'] ?? map['medicationId'] ?? '',
      reminderDate: map['reminder_date'] != null 
          ? DateTime.parse(map['reminder_date']!) 
          : (map['reminderDate'] as DateTime?) ?? DateTime.now(),
      frequency: map['frequency'] ?? 'monthly',
      active: map['active'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reminder_id': reminderId,
      'user_id': userId,
      'medication_id': medicationId,
      'reminder_date': reminderDate.toIso8601String(),
      'frequency': frequency,
      'active': active,
    };
  }

  // Alias for Firestore compatibility
  Map<String, dynamic> toJson() => toMap();

  // Alias for Firestore compatibility
  factory RefillReminder.fromJson(Map<String, dynamic> json) => RefillReminder.fromMap(json);
}
