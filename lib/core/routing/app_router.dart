import 'package:flutter/material.dart';
import '../../presentation/home/view/home_screen.dart';
import '../../presentation/booking/view/create_booking_screen.dart';
import '../../domain/models/pet.dart';
import '../../presentation/auth/view/login_screen.dart';
import '../../presentation/auth/view/signup_screen.dart';
import '../../presentation/auth/view/service_provider_block_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String createBooking = '/create_booking';
  static const String providerBlock = '/provider_block';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case createBooking:
        final pet = settings.arguments as Pet?;
        return MaterialPageRoute(
          builder: (_) => CreateBookingScreen(initialPet: pet),
        );
      case providerBlock:
        return MaterialPageRoute(builder: (_) => const ServiceProviderBlockScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
