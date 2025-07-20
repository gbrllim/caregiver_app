class MedicineReminder {
  final String id;
  final String profileId;
  final String medication;
  final String dosage;
  final DateTime startDate;
  final DateTime endDate;
  final String frequency; // e.g., "Daily", "Twice a day", "Weekly"
  final String? notes;
  final DateTime createdAt;

  MedicineReminder({
    required this.id,
    required this.profileId,
    required this.medication,
    required this.dosage,
    required this.startDate,
    required this.endDate,
    required this.frequency,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'medication': medication,
      'dosage': dosage,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'frequency': frequency,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MedicineReminder.fromJson(Map<String, dynamic> json) {
    return MedicineReminder(
      id: json['id'],
      profileId: json['profileId'],
      medication: json['medication'],
      dosage: json['dosage'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      frequency: json['frequency'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
