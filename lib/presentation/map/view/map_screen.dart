import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../viewmodel/map_viewmodel.dart';
import '../../home/view/app_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  
  final LatLng _center = const LatLng(28.7041, 77.1025); // Default: New Delhi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Services'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Consumer<MapViewModel>(
        builder: (context, mapViewModel, child) {
          if (mapViewModel.isLoading && mapViewModel.markers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.dogesh_app',
              ),
              MarkerLayer(
                markers: mapViewModel.markers,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Refresh map manually for now, or toggle list view in future
          context.read<MapViewModel>().loadProviders();
        },
        label: const Text('Refresh'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}
