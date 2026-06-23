import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker/providers/chart_data_provider.dart';
import 'package:tracker/providers/expense_type_provider.dart';
import 'package:tracker/providers/time_filter_provider.dart';
import 'package:tracker/screens/home/transaction_item.dart';
import 'package:tracker/screens/statistics/expense_type_dropdown.dart';
import 'package:tracker/screens/statistics/graph_screen.dart';
import 'package:tracker/screens/statistics/time_filter_button.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/formatDate.dart';
import 'package:tracker/widgets/bottom_nav_bar.dart';
import 'package:tracker/widgets/loader.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch transaction history when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Calling fetchChartData to get real data for chart.
      final timeFilter = ref.read(timeFilterProvider);
      ref
          .read(chartDataProvider(timeFilter).notifier)
          .fetchChartData(timeFilter);
    });
  }

  Color getColorByType(String type) {
    switch (type) {
      case "Expense":
        return redColor;
      case "Income":
        return greenColor;
      case "Saving":
        return blueColor;
      case "Goal":
        return blackColor;
      default:
        return whiteColor;
    }
  }

  String getLoadingByType(String type) {
    switch (type) {
      case "Expense":
        return "Loading Expense...";
      case "Income":
        return "Loading Income...";
      case "Saving":
        return "Loading Saving";
      case "Goal":
        return "Loading Goals...";
      default:
        return "Loading...";
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedExpenseType = ref.watch(expenseTypeProvider);

    final filter = ref.watch(timeFilterProvider);
    final transactionState = ref.watch(chartDataProvider(filter));
    final transactions = transactionState.listTransactions.reversed.toList();

    return Scaffold(
      backgroundColor: darkGrayColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Statistics',
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: transactionState.isLoading
          ? Center(
              child: Loader(
                title: getLoadingByType(selectedExpenseType),
                backgroundColor: getColorByType(selectedExpenseType),
                foregroundColor: whiteColor,
                transparent: true,
              ),
            )
          : Column(
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

                // Graph
                const ReusableLineChart(),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                        ),
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: getColorByType(selectedExpenseType),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          transactions.length.toString(),
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final tx = transactions[index];
                            return TransactionItem(
                              iconAsset: null,
                              title: tx.name,
                              date: formatDateTimeWithMonthName(tx.date),
                              amount:
                                  "${tx.isIncome ? '+' : '-'} ₹${tx.amount}",
                              isIncome: tx.isIncome,
                              type: tx.type,
                              transactionId: tx.id,
                            );
                          },
                        ),
                ),
              ],
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        onPressed: () {
          context.push('/add-transaction');
        },
        elevation: 4,
        child: Icon(Icons.add, color: whiteColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
