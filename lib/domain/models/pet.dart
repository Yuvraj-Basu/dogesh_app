class Pet {
  final String id;
  final String ownerId;
  final String name;
  final String type; // 'Dog' or 'Cat'
  final String breed;
  final int ageInMonths;
  final String profileImageUrl;
  final DateTime createdAt;

  Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.type,
    required this.breed,
    required this.ageInMonths,
    this.profileImageUrl = '',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'type': type,
      'breed': breed,
      'ageInMonths': ageInMonths,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map, String documentId) {
    return Pet(
      id: documentId,
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'Dog',
      breed: map['breed'] ?? '',
      ageInMonths: map['ageInMonths'] ?? 0,
      profileImageUrl: map['profileImageUrl'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
