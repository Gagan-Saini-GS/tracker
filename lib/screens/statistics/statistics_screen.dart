import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tracker/providers/chart_data_provider.dart';
import 'package:tracker/providers/expense_type_provider.dart';
import 'package:tracker/providers/time_filter_provider.dart';
import 'package:tracker/providers/transaction_provider.dart';
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
  bool _isDateRangeLoading = false;

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

  String _formatDateRange(DateTimeRange range) {
    final DateFormat fmt = DateFormat('MMM d, yy');
    return '${fmt.format(range.start)} - ${fmt.format(range.end)}';
  }

  @override
  Widget build(BuildContext context) {
    final selectedExpenseType = ref.watch(expenseTypeProvider);
    final filter = ref.watch(timeFilterProvider);
    final selectedDateRange = ref.watch(selectedDateRangeProvider);
    final chartDataState = ref.watch(chartDataProvider(filter));
    final transactions = chartDataState.listTransactions.reversed.toList();
    final transactionController = ref.read(transactionListProvider.notifier);
    final chartDataController = ref.read(chartDataProvider(filter).notifier);
    final transactionState = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: darkGrayColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Statistics',
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),

            if (selectedDateRange != null) ...[
              Text(
                _formatDateRange(selectedDateRange),
                style: TextStyle(
                  color: getColorByType(selectedExpenseType),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range_outlined, color: whiteColor),
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: selectedDateRange,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: whiteColor,
                        onPrimary: darkGrayColor,
                        surface: darkGrayColor,
                        onSurface: whiteColor,
                        surfaceContainerHigh: darkGrayColor,
                        surfaceContainer: darkGrayColor,
                        surfaceTint: Colors.transparent,
                      ),
                      datePickerTheme: DatePickerThemeData(
                        backgroundColor: darkGrayColor,
                        headerBackgroundColor: darkGrayColor,
                        headerForegroundColor: whiteColor,
                        surfaceTintColor: Colors.transparent,
                        rangeSelectionBackgroundColor: whiteColor.withAlpha(50),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (range != null) {
                ref.read(selectedDateRangeProvider.notifier).state = range;
                setState(() {
                  _isDateRangeLoading = true; // show loader
                });

                try {
                  final endOfDay = DateTime(
                    range.end.year,
                    range.end.month,
                    range.end.day,
                    23,
                    59,
                    59,
                    999,
                  );

                  // Fetch statistics using range.start and range.end
                  final transactions = await transactionController
                      .getTransactionsByDateRange(
                        startDate: range.start.toIso8601String(),
                        endDate: endOfDay.toIso8601String(),
                        type: selectedExpenseType,
                      );

                  chartDataController.updateChartFromTransactions(transactions);
                } finally {
                  setState(() => _isDateRangeLoading = false);
                }
              }
            },
          ),
        ],
      ),
      body:
          chartDataState.isLoading ||
              _isDateRangeLoading ||
              transactionState.isLoading
          ? Center(
              child: Loader(
                title: getLoadingByType(selectedExpenseType),
                backgroundColor: getColorByType(selectedExpenseType),
                foregroundColor: darkGrayColor,
                transparent: true,
                textStyle: TextStyle(color: whiteColor),
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
