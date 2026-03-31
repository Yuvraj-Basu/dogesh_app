import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../home/viewmodel/pet_viewmodel.dart';
import '../viewmodel/booking_viewmodel.dart';
import '../../../domain/models/pet.dart';

class CreateBookingScreen extends StatefulWidget {
  final Pet? initialPet; // Optional, auto-select if launched from pet specific view

  const CreateBookingScreen({
    super.key,
    this.initialPet,
  });

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  
  Pet? _selectedPet;
  String _selectedService = 'Walking';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool _isFirstLoad = true;
  
  final List<String> _serviceOptions = [
    'Training',
    'Feeding',
    'Walking',
    'Full Day Care',
    'Doctor Appointment',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _selectedPet = widget.initialPet;
      // Fetch pets if empty (just in case they opened this screen directly)
      final petViewModel = context.read<PetViewModel>();
      final authViewModel = context.read<AuthViewModel>();
      if (petViewModel.pets.isEmpty && authViewModel.currentUser != null) {
        petViewModel.loadUserPets(authViewModel.currentUser!.id);
      }
      _isFirstLoad = false;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedPet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a pet')),
      );
      return;
    }
    
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time')),
      );
      return;
    }

    final scheduledDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
    
    final userId = context.read<AuthViewModel>().currentUser!.id;

    final success = await context.read<BookingViewModel>().createBooking(
      petOwnerId: userId,
      petId: _selectedPet!.id,
      petName: _selectedPet!.name,
      serviceType: _selectedService,
      location: _locationController.text.trim(),
      scheduledAt: scheduledDateTime,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking request created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<BookingViewModel>().isLoading;
    final petViewModel = context.watch<PetViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Service'),
        centerTitle: true,
      ),
      body: petViewModel.isLoading && petViewModel.pets.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Service Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Which Pet
                    DropdownButtonFormField<Pet>(
                      initialValue: _selectedPet?.id != null && petViewModel.pets.any((p) => p.id == _selectedPet!.id) 
                          ? petViewModel.pets.firstWhere((p) => p.id == _selectedPet!.id)
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Which Pet?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.pets),
                      ),
                      items: petViewModel.pets.map((Pet pet) {
                        return DropdownMenuItem<Pet>(
                          value: pet,
                          child: Text('${pet.name} (${pet.breed})'),
                        );
                      }).toList(),
                      onChanged: (Pet? newValue) {
                        setState(() => _selectedPet = newValue);
                      },
                      validator: (value) =>
                          value == null ? 'Please select a pet' : null,
                      hint: const Text('Select a Pet'),
                    ),
                    if (petViewModel.pets.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 12),
                        child: Text(
                          'You need to add a pet in "My Pets" first.',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Service Type
                    DropdownButtonFormField<String>(
                      initialValue: _selectedService,
                      decoration: InputDecoration(
                        labelText: 'Service Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.category),
                      ),
                      items: _serviceOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() => _selectedService = newValue);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Location
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location / Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter a location' : null,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Schedule',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Select Date',
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickTime,
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : 'Select Time',
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    const Card(
                      color: Color(0xFFE8F5E9),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Estimated Cost',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '₹ 0',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: isLoading || petViewModel.pets.isEmpty ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Confirm Booking Request',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
