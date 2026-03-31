import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/firebase_auth_repository.dart';
import 'data/repositories/firebase_provider_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/provider_repository.dart';
import 'presentation/auth/viewmodel/auth_viewmodel.dart';
import 'presentation/map/viewmodel/map_viewmodel.dart';
import 'data/repositories/firebase_pet_repository.dart';
import 'domain/repositories/pet_repository.dart';
import 'presentation/home/viewmodel/pet_viewmodel.dart';
import 'data/repositories/firebase_booking_repository.dart';
import 'domain/repositories/booking_repository.dart';
import 'presentation/booking/viewmodel/booking_viewmodel.dart';
import 'presentation/home/viewmodel/navigation_viewmodel.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }
  runApp(const DogeshApp());
}

class DogeshApp extends StatelessWidget {
  const DogeshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => FirebaseAuthRepository(),
        ),
        Provider<ProviderRepository>(
          create: (_) => FirebaseProviderRepository(),
        ),
        Provider<PetRepository>(
          create: (_) => FirebasePetRepository(),
        ),
        Provider<BookingRepository>(
          create: (_) => FirebaseBookingRepository(),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(
            authRepository: context.read<AuthRepository>(),
          )..initializeUser(),
        ),
        ChangeNotifierProvider<MapViewModel>(
          create: (context) => MapViewModel(
            providerRepository: context.read<ProviderRepository>(),
          )..loadProviders(),
        ),
        ChangeNotifierProvider<PetViewModel>(
          create: (context) => PetViewModel(
            petRepository: context.read<PetRepository>(),
          ),
        ),
        ChangeNotifierProvider<BookingViewModel>(
          create: (context) => BookingViewModel(
            bookingRepository: context.read<BookingRepository>(),
          ),
        ),
        ChangeNotifierProvider<NavigationViewModel>(
          create: (_) => NavigationViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'DOGESH',
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.login,
      ),
    );
  }
}
