import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/booking_model.dart';
import '../../domain/repositories/booking_repository.dart';

class FirebaseBookingRepository implements BookingRepository {
  final FirebaseFirestore _firestore;

  FirebaseBookingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Booking> createBooking({
    required String petOwnerId,
    required String petId,
    required String petName,
    required String serviceType,
    required String location,
    required DateTime scheduledAt,
  }) async {
    try {
      final docRef = _firestore.collection('bookings').doc();
      final now = DateTime.now();

      final newBooking = Booking(
        id: docRef.id,
        petOwnerId: petOwnerId,
        providerId: null, // Always unassigned on creation
        petId: petId,
        petName: petName,
        serviceType: serviceType,
        location: location,
        scheduledAt: scheduledAt,
        cost: 0.0, // Free for now
        status: 'pending',
        createdAt: now,
      );

      await docRef.set(newBooking.toMap());

      return newBooking;
    } catch (e) {
      debugPrint('Error creating booking: $e');
      rethrow;
    }
  }

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('petOwnerId', isEqualTo: userId)
          .get();

      final bookings = snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
          
      // Sort in memory to avoid needing a Firestore composite index
      bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return bookings;
    } catch (e) {
      debugPrint('Error fetching user bookings: $e');
      return [];
    }
  }

  @override
  Future<void> submitReview({
    required String bookingId,
    required String providerId,
    required String reviewerName,
    required double rating,
    required String comment,
    String? adminFeedback,
  }) async {
    try {
      final docRef = _firestore.collection('reviews').doc();
      final now = DateTime.now();

      final reviewData = {
        'id': docRef.id,
        'providerId': providerId,
        'reviewerName': reviewerName,
        'rating': rating,
        'comment': comment,
        'adminFeedback': adminFeedback,
        'createdAt': now.toIso8601String(),
        'bookingId': bookingId,
      };

      // Run in transaction: Add review AND mark booking as having review
      await _firestore.runTransaction((transaction) async {
        final bookingRef = _firestore.collection('bookings').doc(bookingId);
        
        transaction.set(docRef, reviewData);
        transaction.update(bookingRef, {'hasReview': true});
      });

    } catch (e) {
      debugPrint('Error submitting review: $e');
      rethrow;
    }
  }
}
