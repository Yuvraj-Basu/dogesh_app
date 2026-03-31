import '../models/pet.dart';

abstract class PetRepository {
  /// Add a new pet for a user
  Future<Pet> addPet({
    required String ownerId,
    required String name,
    required String type,
    required String breed,
    required int ageInMonths,
    String profileImageUrl = '',
  });

  /// Get all pets for a specific user
  Future<List<Pet>> getUserPets(String ownerId);

  /// Delete a pet
  Future<void> deletePet(String ownerId, String petId);
}
