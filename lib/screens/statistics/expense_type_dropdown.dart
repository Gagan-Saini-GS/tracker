import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/providers/expense_type_provider.dart';
import 'package:tracker/providers/time_filter_provider.dart';
import 'package:tracker/providers/chart_data_provider.dart';
import 'package:tracker/providers/transaction_provider.dart';
import 'package:tracker/utils/constants.dart';

class ExpenseTypeDropdown extends ConsumerWidget {
  const ExpenseTypeDropdown({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedExpenseType = ref.watch(expenseTypeProvider);
    final filter = ref.watch(timeFilterProvider);
    final chartDataController = ref.read(chartDataProvider(filter).notifier);
    final transactionController = ref.read(transactionListProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            '$selectedExpenseType Graph',
            style: TextStyle(
              fontSize: 20,
              color: getColorByType(selectedExpenseType),
              // color: selectedExpenseType == "Income" ? greenColor : redColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: getColorByType(selectedExpenseType).withAlpha(190),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isDense: true,
              value: selectedExpenseType,
              icon: Icon(Icons.arrow_drop_down, color: whiteColor),
              style: TextStyle(color: whiteColor, fontSize: 16),
              dropdownColor: darkGrayColor,
              onChanged: (String? newValue) async {
                if (newValue != null) {
                  ref.read(expenseTypeProvider.notifier).state = newValue;

                  final timeFilter = ref.read(timeFilterProvider);
                  final dateRange = ref.read(selectedDateRangeProvider);

                  if (dateRange != null) {
                    // Custom date range takes priority — re-fetch with same range, new type
                    final endOfDay = DateTime(
                      dateRange.end.year,
                      dateRange.end.month,
                      dateRange.end.day,
                      23,
                      59,
                      59,
                      999,
                    );
                    final transactions = await transactionController
                        .getTransactionsByDateRange(
                          startDate: dateRange.start.toIso8601String(),
                          endDate: endOfDay.toIso8601String(),
                          type: newValue,
                        );

                    chartDataController.updateChartFromTransactions(
                      transactions,
                    );
                  } else {
                    // No custom range — use currently selected time filter (existing behavior)
                    ref
                        .read(chartDataProvider(timeFilter).notifier)
                        .fetchChartData(timeFilter);
                  }
                }
              },

              // onChanged: (String? newValue) {
              //   if (newValue != null) {
              //     ref.read(expenseTypeProvider.notifier).state = newValue;
              //     // Fetch chart data for the new expense type
              //     final timeFilter = ref.read(timeFilterProvider);
              //     ref
              //         .read(chartDataProvider(timeFilter).notifier)
              //         .fetchChartData(timeFilter);
              //   }
              // },
              // I'll add Saving later.
              items: <String>['Expense', 'Income', 'Saving']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: whiteColor)),
                    );
                  })
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
