class ServiceProvider {
  final String id;
  final String name;
  final String email;
  final String role;
  final double latitude;
  final double longitude;
  final List<String> servicesOffered;
  final double rating;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.latitude,
    required this.longitude,
    required this.servicesOffered,
    this.rating = 0.0,
  });

  factory ServiceProvider.fromMap(Map<String, dynamic> map, String documentId) {
    return ServiceProvider(
      id: documentId,
      name: map['name'] ?? 'Unknown Provider',
      email: map['email'] ?? '',
      role: map['role'] ?? 'service_provider',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      servicesOffered: List<String>.from(map['servicesOffered'] ?? []),
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }
}
