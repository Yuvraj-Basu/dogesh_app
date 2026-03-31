import 'package:flutter/foundation.dart';
import '../../../domain/models/booking_model.dart';
import '../../../domain/repositories/booking_repository.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingRepository _bookingRepository;

  List<Booking> _upcomingBookings = [];
  List<Booking> _pastBookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  BookingViewModel({required BookingRepository bookingRepository})
      : _bookingRepository = bookingRepository;

  List<Booking> get upcomingBookings => _upcomingBookings;
  List<Booking> get pastBookings => _pastBookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserBookings(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final allBookings = await _bookingRepository.getUserBookings(userId);
      
      _pastBookings = allBookings.where((b) {
        final st = b.status.toLowerCase().replaceAll(' ', '_');
        return st == 'completed' || 
               st == 'canceled' ||
               st == 'cancelled';
      }).toList();

      _upcomingBookings = allBookings.where((b) {
        final st = b.status.toLowerCase().replaceAll(' ', '_');
        return st != 'completed' && 
               st != 'canceled' &&
               st != 'cancelled';
      }).toList();

    } catch (e) {
      _errorMessage = 'Failed to load bookings: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBooking({
    required String petOwnerId,
    required String petId,
    required String petName,
    required String serviceType,
    required String location,
    required DateTime scheduledAt,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newBooking = await _bookingRepository.createBooking(
        petOwnerId: petOwnerId,
        petId: petId,
        petName: petName,
        serviceType: serviceType,
        location: location,
        scheduledAt: scheduledAt,
      );
      
      // Auto-insert at top of upcoming
      _upcomingBookings.insert(0, newBooking);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create booking: $e';
      debugPrint(_errorMessage);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitReview({
    required String bookingId,
    required String providerId,
    required String reviewerName,
    required double rating,
    required String comment,
    String? adminFeedback,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _bookingRepository.submitReview(
        bookingId: bookingId,
        providerId: providerId,
        reviewerName: reviewerName,
        rating: rating,
        comment: comment,
        adminFeedback: adminFeedback,
      );

      // Optimistically update the local past booking list
      final idx = _pastBookings.indexWhere((b) => b.id == bookingId);
      if (idx != -1) {
        final b = _pastBookings[idx];
        // Create an updated booking with hasReview = true
        _pastBookings[idx] = Booking(
          id: b.id,
          petOwnerId: b.petOwnerId,
          providerId: b.providerId,
          petId: b.petId,
          petName: b.petName,
          serviceType: b.serviceType,
          location: b.location,
          scheduledAt: b.scheduledAt,
          cost: b.cost,
          status: b.status,
          hasReview: true,
          createdAt: b.createdAt,
        );
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit review: $e';
      debugPrint(_errorMessage);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
