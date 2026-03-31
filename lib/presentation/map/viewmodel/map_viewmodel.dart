import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../domain/repositories/provider_repository.dart';

class MapViewModel extends ChangeNotifier {
  final ProviderRepository _providerRepository;

  List<Marker> _markers = [];
  bool _isLoading = false;

  MapViewModel({required ProviderRepository providerRepository})
      : _providerRepository = providerRepository;

  List<Marker> get markers => _markers;
  bool get isLoading => _isLoading;

  Future<void> loadProviders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final providers = await _providerRepository.getNearbyProviders();
      
      _markers = providers.map((provider) {
        return Marker(
          width: 200.0,
          height: 100.0,
          point: LatLng(provider.latitude, provider.longitude),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '⭐ ${provider.rating.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ],
          ),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading map providers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
