import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Statistics Screen')),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
