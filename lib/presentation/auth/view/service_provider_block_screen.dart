import 'package:flutter/material.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class ServiceProviderBlockScreen extends StatelessWidget {
  const ServiceProviderBlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Provider Access'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.construction,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 32),
            Text(
              'Under Development',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Service provider side application is under development. If you are interested to provide services then contact admin:\n\nPhone - 91XXXXXXXX\nEmail - dogesh@gmail.com',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AuthViewModel>().logout();
                Navigator.pop(context); // Go back to login
              },
              icon: const Icon(Icons.logout),
              label: const Text('Return to Login'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
