import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/statistics');
        break;
      case 2:
        context.go('/wallet');
        break;
      case 3:
        context.go('/profile');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 0,
      height: 60, // Reduced from default ~80
      padding: EdgeInsets.zero, // Remove padding to let Container handle it
      child: Row(
        mainAxisAlignment: currentIndex == 0
            ? MainAxisAlignment.spaceAround
            : MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(Icons.home_outlined, 0, context),
          _buildIconButton(Icons.data_saver_off_outlined, 1, context),
          if (currentIndex == 0) const SizedBox(width: 40),
          _buildIconButton(Icons.account_balance_wallet_outlined, 2, context),
          _buildIconButton(Icons.person_outline, 3, context),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, int index, BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 25, // Reduced icon size
        icon: Icon(
          icon,
          color: currentIndex == index
              ? const Color(0xFF63B5AF)
              : Colors.grey[400],
        ),
        onPressed: () => _onTap(context, index),
      ),
    );
  }
}
