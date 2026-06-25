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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '₹ ${(transactionsState.income - transactionsState.expense - transactionsState.saving).toStringAsFixed(2)}',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: whiteColor.withAlpha(50),
                  border: Border.all(
                    width: 1,
                    color: whiteColor.withAlpha(100),
                  ),
                ),
                child: Icon(Icons.emoji_events_outlined, color: whiteColor),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BalanceDetail(
                label: 'Expenses',
                amount: transactionsState.expense,
                icon: Icons.arrow_upward,
              ),
              _BalanceDetail(
                label: 'Saving',
                amount: transactionsState.saving,
                icon: Icons.account_balance_outlined,
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
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
