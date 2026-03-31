import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../home/view/app_drawer.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/booking_viewmodel.dart';
import '../../../domain/models/booking_model.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch bookings when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthViewModel>().currentUser?.id;
      if (userId != null) {
        context.read<BookingViewModel>().fetchUserBookings(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Upcoming'),
                Tab(text: 'Past'),
              ],
            ),
            Expanded(
              child: Consumer<BookingViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading && viewModel.upcomingBookings.isEmpty && viewModel.pastBookings.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return TabBarView(
                    children: [
                      _buildBookingsList(viewModel.upcomingBookings, isUpcoming: true),
                      _buildBookingsList(viewModel.pastBookings, isUpcoming: false),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, Booking booking) {
    double localRating = 5.0;
    final publicController = TextEditingController();
    final adminController = TextEditingController(); // visible to admin only

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave a Review'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rate your experience out of 5:'),
                const SizedBox(height: 8),
                Center(
                  child: RatingBar.builder(
                    initialRating: 5.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      localRating = rating;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: publicController,
                  decoration: const InputDecoration(
                    labelText: 'Public comment (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: adminController,
                  decoration: const InputDecoration(
                    labelText: 'Admin Feedback (private, optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final authVm = context.read<AuthViewModel>();
                final userName = authVm.currentUser?.name ?? 'User';
                final bookingVm = context.read<BookingViewModel>();
                
                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );

                final success = await bookingVm.submitReview(
                  bookingId: booking.id,
                  providerId: booking.providerId ?? 'unknown',
                  reviewerName: userName,
                  rating: localRating,
                  comment: publicController.text.trim(),
                  adminFeedback: adminController.text.trim(),
                );

                // Safe context access after async
                if (!context.mounted) return;

                // Pop loading
                Navigator.pop(context);

                if (success) {
                  Navigator.pop(context); // Pop dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Review submitted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to submit review.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, {required bool isUpcoming}) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(isUpcoming ? 'No upcoming bookings.' : 'No past bookings.'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final userId = context.read<AuthViewModel>().currentUser?.id;
        if (userId != null) {
          await context.read<BookingViewModel>().fetchUserBookings(userId);
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          
          Color statusColor;
          switch (booking.status.toLowerCase().replaceAll(' ', '_')) {
            case 'pending':
              statusColor = Colors.orange;
              break;
            case 'allocated_to_expert':
            case 'in_process':
            case 'in_progress':
              statusColor = Colors.blue;
              break;
            case 'completed':
              statusColor = Colors.green;
              break;
            case 'canceled':
            case 'cancelled':
              statusColor = Colors.red;
              break;
            default:
              statusColor = Colors.blue; // Default to blue for any custom upcoming status
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('${booking.serviceType} for ${booking.petName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Date: ${booking.scheduledAt.day}/${booking.scheduledAt.month}/${booking.scheduledAt.year}'),
                  Text('Location: ${booking.location}'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      booking.status.toUpperCase().replaceAll('_', ' '),
                      style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: isUpcoming && booking.status == 'pending'
                  ? ElevatedButton(
                      onPressed: () {
                        // TODO: Implement cancel request logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cancellation not yet implemented')),
                        );
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red,
                        elevation: 0,
                      ),
                      child: const Text('Cancel')
                    )
                  : booking.status == 'completed' 
                      ? booking.hasReview
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : ElevatedButton(
                              onPressed: () => _showReviewDialog(context, booking),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Review', style: TextStyle(fontSize: 12)),
                            )
                      : null,
            ),
          );
        },
      ),
    );
  }
}
