import 'package:flutter/foundation.dart';
import '../../../domain/models/pet.dart';
import '../../../domain/repositories/pet_repository.dart';

class PetViewModel extends ChangeNotifier {
  final PetRepository _petRepository;

  PetViewModel({required PetRepository petRepository})
      : _petRepository = petRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Pet> _pets = [];
  List<Pet> get pets => _pets;

  Future<void> loadUserPets(String ownerId) async {
    _setLoading(true);
    _clearError();

    try {
      _pets = await _petRepository.getUserPets(ownerId);
    } catch (e) {
      _errorMessage = 'Failed to load pets: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addPet({
    required String ownerId,
    required String name,
    required String type,
    required String breed,
    required int ageInMonths,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final newPet = await _petRepository.addPet(
        ownerId: ownerId,
        name: name,
        type: type,
        breed: breed,
        ageInMonths: ageInMonths,
      );
      
      _pets.insert(0, newPet); // Add to top of list
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add pet: $e';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
