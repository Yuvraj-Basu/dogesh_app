import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/pet.dart';
import '../../domain/repositories/pet_repository.dart';

class FirebasePetRepository implements PetRepository {
  final FirebaseFirestore _firestore;

  FirebasePetRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Pet> addPet({
    required String ownerId,
    required String name,
    required String type,
    required String breed,
    required int ageInMonths,
    String profileImageUrl = '',
  }) async {
    try {
      final petsCollection = _firestore
          .collection('users')
          .doc(ownerId)
          .collection('pets');

      final docRef = petsCollection.doc();
      
      final pet = Pet(
        id: docRef.id,
        ownerId: ownerId,
        name: name,
        type: type,
        breed: breed,
        ageInMonths: ageInMonths,
        profileImageUrl: profileImageUrl,
        createdAt: DateTime.now(),
      );

      await docRef.set(pet.toMap());

      return pet;
    } catch (e) {
      debugPrint('Add Pet Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Pet>> getUserPets(String ownerId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('pets')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Pet.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Get User Pets Error: $e');
      return [];
    }
  }

  @override
  Future<void> deletePet(String ownerId, String petId) async {
    try {
      await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('pets')
          .doc(petId)
          .delete();
    } catch (e) {
      debugPrint('Delete Pet Error: $e');
      rethrow;
    }
  }
}
