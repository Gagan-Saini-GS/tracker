import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/providers/expense_type_provider.dart';
import 'package:tracker/providers/transaction_provider.dart';
import 'package:tracker/screens/home/transaction_item.dart';
import 'package:tracker/screens/statistics/expense_type_dropdown.dart';
import 'package:tracker/screens/statistics/graph_screen.dart';
import 'package:tracker/screens/statistics/time_filter_button.dart';
import 'package:tracker/widgets/bottom_nav_bar.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionListProvider);
    final selectedExpenseType = ref.watch(expenseTypeProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black87),
        //   onPressed: () {
        //     context.go("/home");
        //   },
        // ),
        // centerTitle: true,
        title: const Text(
          'Statistics',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: selectedExpenseType == "Income"
                  ? const Color(0xFF63B5AF).withAlpha(65)
                  : const Color(0xFFE83559).withAlpha(65),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              onTap: () {
                // Handle Download click
              },
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.file_download_outlined,
                  color: selectedExpenseType == "Income"
                      ? const Color(0xFF63B5AF)
                      : const Color(0xFFE83559),
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TimeFilterButtons(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
              child: ExpenseTypeDropdown(),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey[300],
            indent: 16,
            endIndent: 16,
          ),
          const SizedBox(height: 20),

          const ReusableLineChart(),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Spending',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Icon(Icons.sort, color: Colors.grey[600]),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Text(
                      'No Transactions Yet.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return TransactionItem(
                        icon: tx.isIncome ? Icons.work : Icons.ondemand_video,
                        iconBg: tx.isIncome
                            ? Color(0xFFE5F8ED)
                            : Color(0xFFFDECEA),
                        iconAsset: null,
                        title: tx.name,
                        date:
                            "${tx.date.day.toString().padLeft(2, '0')}/${tx.date.month.toString().padLeft(2, '0')}/${tx.date.year}",
                        amount:
                            "${tx.isIncome ? '+' : '-'} ₹${tx.amount.toStringAsFixed(2)}",
                        isIncome: tx.isIncome,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
