import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/pet_viewmodel.dart';
import '../../../domain/models/pet.dart';
import 'add_pet_dialog.dart';
import 'pet_details_bottom_sheet.dart';
import 'app_drawer.dart';

class PetHomeScreen extends StatefulWidget {
  const PetHomeScreen({super.key});

  @override
  State<PetHomeScreen> createState() => _PetHomeScreenState();
}

class _PetHomeScreenState extends State<PetHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPets();
    });
  }

  void _loadPets() {
    final authViewModel = context.read<AuthViewModel>();
    final user = authViewModel.currentUser;
    if (user != null) {
      context.read<PetViewModel>().loadUserPets(user.id);
    }
  }

  void _showAddPetDialog(BuildContext context, String ownerId) {
    showDialog(
      context: context,
      builder: (context) => AddPetDialog(ownerId: ownerId),
    );
  }

  void _showPetDetails(BuildContext context, Pet pet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PetDetailsBottomSheet(pet: pet),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;

    if (user == null) {
      return const Center(child: Text('Please log in to manage pets.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Consumer<PetViewModel>(
        builder: (context, petViewModel, child) {
          if (petViewModel.isLoading && petViewModel.pets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (petViewModel.errorMessage != null && petViewModel.pets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${petViewModel.errorMessage}'),
                  ElevatedButton(
                    onPressed: _loadPets,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (petViewModel.pets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No pets yet!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your furry friends to get started.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddPetDialog(context, user.id),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Pet'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadPets(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: petViewModel.pets.length,
              itemBuilder: (context, index) {
                final pet = petViewModel.pets[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _showPetDetails(context, pet),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            backgroundImage: pet.profileImageUrl.isNotEmpty
                                ? NetworkImage(pet.profileImageUrl)
                                : null,
                            child: pet.profileImageUrl.isEmpty
                                ? Icon(
                                    pet.type.toLowerCase() == 'cat' 
                                        ? Icons.pets 
                                        : Icons.pets,
                                    size: 30,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${pet.breed} • ${pet.ageInMonths} months',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: authViewModel.currentUser != null && context.watch<PetViewModel>().pets.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showAddPetDialog(context, user.id),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
