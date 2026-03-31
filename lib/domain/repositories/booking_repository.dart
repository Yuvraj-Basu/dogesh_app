import '../models/booking_model.dart';

abstract class BookingRepository {
  Future<Booking> createBooking({
    required String petOwnerId,
    required String petId,
    required String petName,
    required String serviceType,
    required String location,
    required DateTime scheduledAt,
  });

  Future<List<Booking>> getUserBookings(String userId);

  Future<void> submitReview({
    required String bookingId,
    required String providerId,
    required String reviewerName,
    required double rating,
    required String comment,
    String? adminFeedback,
  });
}
