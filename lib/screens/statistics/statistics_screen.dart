import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/providers/expense_type_provider.dart';
import 'package:tracker/providers/transaction_provider.dart';
import 'package:tracker/screens/home/transaction_item.dart';
import 'package:tracker/screens/statistics/expense_type_dropdown.dart';
import 'package:tracker/screens/statistics/graph_screen.dart';
import 'package:tracker/screens/statistics/time_filter_button.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/formatDate.dart';
import 'package:tracker/widgets/bottom_nav_bar.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionListProvider);
    final selectedExpenseType = ref.watch(expenseTypeProvider);

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: blackColor),
        //   onPressed: () {
        //     context.go("/home");
        //   },
        // ),
        // centerTitle: true,
        title: Text(
          'Statistics',
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: selectedExpenseType == "Income"
                  ? greenColor.withAlpha(65)
                  : redColor.withAlpha(65),
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
                      ? greenColor
                      : redColor,
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
          Divider(height: 1, color: grayColor, indent: 16, endIndent: 16),
          const SizedBox(height: 20),

          const ReusableLineChart(),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Spending',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
                Icon(Icons.sort, color: grayColor),
              ],
            ),
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                        amount: "${tx.isIncome ? '+' : '-'} ₹${tx.amount}",
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
