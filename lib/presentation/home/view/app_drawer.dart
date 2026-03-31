import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routing/app_router.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/navigation_viewmodel.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;
    final navViewModel = context.watch<NavigationViewModel>();

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'Guest User'),
            accountEmail: Text(user?.email ?? 'Not logged in'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: user?.profileImageUrl != null && user!.profileImageUrl.isNotEmpty
                  ? NetworkImage(user.profileImageUrl)
                  : null,
              child: (user?.profileImageUrl == null || user!.profileImageUrl.isEmpty)
                  ? Text(
                      user?.name.isNotEmpty == true
                          ? user!.name.substring(0, 1).toUpperCase()
                          : 'U',
                      style: const TextStyle(fontSize: 40.0, color: Colors.blue),
                    )
                  : null,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text('My Pets'),
            selected: navViewModel.currentIndex == 0,
            onTap: () {
              navViewModel.setIndex(0);
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Explore Services'),
            selected: navViewModel.currentIndex == 1,
            onTap: () {
              navViewModel.setIndex(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Bookings'),
            selected: navViewModel.currentIndex == 2,
            onTap: () {
              navViewModel.setIndex(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            selected: navViewModel.currentIndex == 3,
            onTap: () {
              navViewModel.setIndex(3);
              Navigator.pop(context);
            },
          ),
          
          const Spacer(), // Pushes logout to the bottom
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context); // Close drawer
              await authViewModel.logout();
              if (context.mounted) {
                // Clear the whole navigation stack and go to Login
                Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false);
              }
            },
          ),
          const SizedBox(height: 16), // Padding at bottom
        ],
      ),
    );
  }
}
