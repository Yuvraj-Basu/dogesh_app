class Booking {
  final String id;
  final String petOwnerId;
  final String? providerId; // Null until an admin assigns a provider
  final String petId;
  final String petName;
  final String serviceType;
  final String location;
  final DateTime scheduledAt;
  final double cost;
  final String status; // 'pending', 'allocated_to_expert', 'in_process', 'completed', 'canceled'
  final bool hasReview;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.petOwnerId,
    this.providerId,
    required this.petId,
    required this.petName,
    required this.serviceType,
    required this.location,
    required this.scheduledAt,
    this.cost = 0.0,
    this.status = 'pending',
    this.hasReview = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petOwnerId': petOwnerId,
      'providerId': providerId,
      'petId': petId,
      'petName': petName,
      'serviceType': serviceType,
      'location': location,
      'scheduledAt': scheduledAt.toIso8601String(),
      'cost': cost,
      'status': status,
      'hasReview': hasReview,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, String documentId) {
    return Booking(
      id: documentId,
      petOwnerId: map['petOwnerId'] ?? '',
      providerId: map['providerId'],
      petId: map['petId'] ?? '',
      petName: map['petName'] ?? 'Unknown Pet',
      serviceType: map['serviceType'] ?? '',
      location: map['location'] ?? '',
      scheduledAt: map['scheduledAt'] != null 
          ? DateTime.parse(map['scheduledAt']) 
          : DateTime.now(),
      cost: (map['cost'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      hasReview: map['hasReview'] ?? false,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }
}
