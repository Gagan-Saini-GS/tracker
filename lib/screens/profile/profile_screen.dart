import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Profile Screen')),
      bottomNavigationBar: BottomNavBar(currentIndex: 4),
    );
  }
}
