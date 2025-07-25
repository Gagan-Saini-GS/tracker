import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker/providers/transaction_provider.dart';
import 'package:tracker/screens/home/balance_card.dart';
import 'package:tracker/screens/home/transaction_item.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/formatDate.dart';
import 'package:tracker/utils/getGreeting.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: greenColor,
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
                color: whiteColor.withAlpha(25),
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
                  vertical: 20,
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
                              style: TextStyle(color: whiteColor, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Gagan Saini',
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: whiteColor.withAlpha(65),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.notifications_none,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          // Main content
          Positioned.fill(
            top: 220,
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
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
                  _buildTransactionHistory(ref),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        onPressed: () {
          context.go('/add-transaction');
        },
        elevation: 4,
        child: Icon(Icons.add, color: whiteColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Expanded _buildTransactionHistory(WidgetRef ref) {
    final transactions = ref.watch(transactionListProvider);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions History',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'See all',
                  style: TextStyle(
                    color: greenColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                      child: Text(
                        'No Transactions Yet.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: grayColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        return TransactionItem(
                          icon: tx.isIncome ? Icons.work : Icons.ondemand_video,
                          iconBg: tx.isIncome
                              ? greenColor.withAlpha(65)
                              : redColor.withAlpha(65),
                          iconAsset: null,
                          title: tx.name,
                          date: formatDateTimeWithMonthName(tx.date),
                          amount:
                              "${tx.isIncome ? '+' : '-'} ₹${tx.amount.toStringAsFixed(2)}",
                          isIncome: tx.isIncome,
                        );
                      },
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
