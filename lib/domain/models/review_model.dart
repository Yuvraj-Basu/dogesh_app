class Review {
  final String id;
  final String providerId;
  final String reviewerName;
  final double rating;
  final String comment; // Public comment
  final String? adminFeedback; // Private feedback for admin only
  final DateTime createdAt;

  Review({
    required this.id,
    required this.providerId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    this.adminFeedback,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'providerId': providerId,
      'reviewerName': reviewerName,
      'rating': rating,
      'comment': comment,
      'adminFeedback': adminFeedback,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map, String documentId) {
    return Review(
      id: documentId,
      providerId: map['providerId'] ?? '',
      reviewerName: map['reviewerName'] ?? 'Anonymous',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
      adminFeedback: map['adminFeedback'],
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }
}
