import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../map/view/map_screen.dart';
import '../../profile/view/profile_screen.dart';

import '../../booking/view/booking_screen.dart';
import '../../home/view/pet_home_screen.dart';
import '../viewmodel/navigation_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Widget> _screens = const [
    PetHomeScreen(),
    MapScreen(),
    BookingScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<NavigationViewModel>().currentIndex;

    return Scaffold(
      body: _screens[currentIndex],
    );
  }
}
