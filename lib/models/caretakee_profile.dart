class CaretakeeProfile {
  final String id;
  final String caretakerId;
  final String name;
  final String relationship;
  final String? avatarUrl;
  final int age;
  final DateTime createdAt;
  final DateTime updatedAt;

  CaretakeeProfile({
    required this.id,
    required this.caretakerId,
    required this.name,
    required this.relationship,
    this.avatarUrl,
    required this.age,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caretakerId': caretakerId,
      'name': name,
      'relationship': relationship,
      'avatarUrl': avatarUrl,
      'age': age,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CaretakeeProfile.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return CaretakeeProfile(
      id: json['id'] ?? '',
      caretakerId: json['caretakerId'] ?? '',
      name: json['name'] ?? '',
      relationship: json['relationship'] ?? '',
      avatarUrl: json['avatarUrl'],
      age: json['age'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : now,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : now,
    );
  }

  // Create a copy of the profile with updated fields
  CaretakeeProfile copyWith({
    String? id,
    String? caretakerId,
    String? name,
    String? relationship,
    String? avatarUrl,
    int? age,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CaretakeeProfile(
      id: id ?? this.id,
      caretakerId: caretakerId ?? this.caretakerId,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
