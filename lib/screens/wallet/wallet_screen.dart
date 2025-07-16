import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Wallet Screen')),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}
