import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker/screens/home/balance_card.dart';
import 'package:tracker/screens/home/transaction_item.dart';
import 'package:tracker/utils/getGreeting.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF63B5AF),
      body: Stack(
        children: [
          // Background top decoration (optional, for effect)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getGreeting(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Gagan Saini',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(65),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    // Balance Card
                    // BalanceCard(),
                  ],
                ),
              ),
            ),
          ),
          // Main content
          Positioned.fill(
            top: 220,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // BalanceCard positioned to overlap
                  Transform.translate(
                    offset: const Offset(0, -80), // Move card up to overlap
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: BalanceCard(),
                    ),
                  ),
                  // Transaction History Section
                  _buildTransactionHistory(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF63B5AF),
        onPressed: () {
          context.go('/add-transaction');
        },
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Expanded _buildTransactionHistory() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Transactions History',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'See all',
                  style: TextStyle(
                    color: Color(0xFF63B5AF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  // Transaction List
                  TransactionItem(
                    icon: Icons.work,
                    iconBg: Color(0xFFE5F8ED),
                    iconAsset:
                        'assets/images/man.png', // Placeholder, replace with Upwork logo asset if available
                    title: 'Upwork',
                    date: 'Today',
                    amount: '+ 850.00',
                    isIncome: true,
                  ),
                  TransactionItem(
                    icon: Icons.person,
                    iconBg: Color(0xFFE5E5E5),
                    iconAsset: null,
                    title: 'Transfer',
                    date: 'Yesterday',
                    amount: '- 85.00',
                    isIncome: false,
                  ),
                  TransactionItem(
                    icon: Icons.account_balance_wallet,
                    iconBg: Color(0xFFE5F8ED),
                    iconAsset: null,
                    title: 'Paypal',
                    date: 'Jan 30, 2022',
                    amount: '+ ₹ 1,406.00',
                    isIncome: true,
                  ),
                  TransactionItem(
                    icon: Icons.ondemand_video,
                    iconBg: Color(0xFFFDECEA),
                    iconAsset: null,
                    title: 'Youtube',
                    date: 'Jan 16, 2022',
                    amount: '- 11.99',
                    isIncome: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class _Avatar extends StatelessWidget {
//   final String image;
//   const _Avatar({required this.image});

//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(radius: 28, backgroundImage: AssetImage(image));
//   }
// }

// const SizedBox(height: 30),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: const [
//     Text(
//       'Send Again',
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 16,
//       ),
//     ),
//     Text(
//       'See all',
//       style: TextStyle(
//         color: Color(0xFF63B5AF),
//         fontWeight: FontWeight.w600,
//       ),
//     ),
//   ],
// ),
// const SizedBox(height: 16),
// SizedBox(
//   height: 60,
//   child: ListView(
//     scrollDirection: Axis.horizontal,
//     children: [
//       _Avatar(image: 'assets/images/man.png'),
//       const SizedBox(width: 12),
//       _Avatar(image: 'assets/images/man.png'),
//       const SizedBox(width: 12),
//       _Avatar(image: 'assets/images/man.png'),
//       const SizedBox(width: 12),
//       _Avatar(image: 'assets/images/man.png'),
//       const SizedBox(width: 12),
//       _Avatar(image: 'assets/images/man.png'),
//     ],
//   ),
// ),
