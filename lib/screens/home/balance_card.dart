import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/providers/transaction_provider.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/widgets/loader.dart';

class BalanceCard extends ConsumerStatefulWidget {
  const BalanceCard({super.key});

  @override
  ConsumerState<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends ConsumerState<BalanceCard> {
  @override
  void initState() {
    super.initState();
    // Fetch transaction history when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(allTransactionListProvider.notifier).fetchTransactionHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsState = ref.watch(allTransactionListProvider);
    final transactions = transactionsState.transactions;

    if (transactionsState.isLoading && transactions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: balanceCardGreenColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Loader(
            title: "Loading Balance...",
            textStyle: TextStyle(color: whiteColor, fontSize: 18.0),
            backgroundColor: balanceCardGreenColor,
            transparent: true,
          ),
        ),
      );
    }

    final totalAmount = transactions.fold(
      0.0,
      (sum, item) => sum + (item.isIncome ? item.amount : -item.amount),
    );
    final totalIncome = transactions.fold(
      0.0,
      (sum, item) => sum + (item.isIncome ? item.amount : 0),
    );
    final totalExpense = transactions.fold(
      0.0,
      (sum, item) => sum + (item.isIncome ? 0 : item.amount),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: balanceCardGreenColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: blackColor.withAlpha(100),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.more_horiz, color: whiteColor),
            ],
          ),
          // const SizedBox(height: 10),
          Text(
            '₹ ${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              color: whiteColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BalanceDetail(
                label: 'Income',
                amount: totalIncome,
                icon: Icons.arrow_downward,
              ),
              _BalanceDetail(
                label: 'Expenses',
                amount: totalExpense,
                icon: Icons.arrow_upward,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceDetail extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  const _BalanceDetail({
    required this.label,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: whiteColor.withAlpha(50),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: whiteColor, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: whiteColor, fontSize: 14)),
            Text(
              '₹ ${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
