import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routing/app_router.dart';
import '../../../domain/models/pet.dart';
import '../viewmodel/navigation_viewmodel.dart';

class PetDetailsBottomSheet extends StatelessWidget {
  final Pet pet;

  const PetDetailsBottomSheet({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                backgroundImage: pet.profileImageUrl.isNotEmpty
                    ? NetworkImage(pet.profileImageUrl)
                    : null,
                child: pet.profileImageUrl.isEmpty
                    ? Icon(
                        pet.type.toLowerCase() == 'cat' 
                            ? Icons.pets 
                            : Icons.pets,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.type} • ${pet.breed}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                        '${pet.ageInMonths} months old',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              )
            ],
          ),
          const SizedBox(height: 32),
          
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context); // Close bottom sheet
              
              // Navigate to the book service flow, passing the pet
              Navigator.pushNamed(
                context, 
                AppRouter.createBooking,
                arguments: pet,
              );
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text('Book a New Service'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context); // Close bottom sheet
              context.read<NavigationViewModel>().setIndex(2); // Switch to Bookings tab
            },
            icon: const Icon(Icons.history),
            label: const Text('Service History'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 32), // Padding below buttons
        ],
      ),
    );
  }
}
