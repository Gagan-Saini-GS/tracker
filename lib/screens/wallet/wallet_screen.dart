import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/providers/transaction_provider.dart';
import 'package:tracker/screens/home/transaction_item.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/formatDate.dart';
import '../../widgets/bottom_nav_bar.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch transaction history when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionListProvider.notifier).fetchTransactionHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionListProvider);

    final calculatedAmount = _calculateTotalBalance(transactions);

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          'Wallet',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        backgroundColor: greenColor,
        foregroundColor: whiteColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header section with total balance
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: calculatedAmount > 0
                  ? darkGreenColor.withAlpha(200)
                  : darkRedColor.withAlpha(175),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Balance',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '₹${calculatedAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Transaction list
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 64,
                          color: grayColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Transactions Yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: grayColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your transaction history will appear here',
                          style: TextStyle(fontSize: 14, color: grayColor),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
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
                        amount: tx.amount.toStringAsFixed(2),
                        isIncome: tx.isIncome,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  double _calculateTotalBalance(List transactions) {
    double balance = 0.0;
    for (var transaction in transactions) {
      if (transaction.isIncome) {
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      }
    }
    return balance;
  }
}
