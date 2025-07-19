class CaretakeeProfile {
  final String id;
  final String name;
  final String relationship;
  final String? avatarUrl;
  final int age;

  CaretakeeProfile({
    required this.id,
    required this.name,
    required this.relationship,
    this.avatarUrl,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'avatarUrl': avatarUrl,
      'age': age,
    };
  }

  factory CaretakeeProfile.fromJson(Map<String, dynamic> json) {
    return CaretakeeProfile(
      id: json['id'],
      name: json['name'],
      relationship: json['relationship'],
      avatarUrl: json['avatarUrl'],
      age: json['age'],
    );
  }
}
