import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/service_provider.dart';
import '../../domain/repositories/provider_repository.dart';

class FirebaseProviderRepository implements ProviderRepository {
  final FirebaseFirestore _firestore;

  FirebaseProviderRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ServiceProvider>> getNearbyProviders() async {
    try {
      // Fetch users where role is 'service_provider'
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'service_provider')
          .get();

      return snapshot.docs
          .map((doc) => ServiceProvider.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error fetching providers: $e');
      return [];
    }
  }
}
