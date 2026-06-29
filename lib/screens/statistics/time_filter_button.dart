import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tracker/enums/timefilter.dart';
import 'package:tracker/providers/chart_data_provider.dart';
import 'package:tracker/providers/expense_type_provider.dart';
import 'package:tracker/providers/time_filter_provider.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/getTimefilterText.dart';

class TimeFilterButtons extends ConsumerWidget {
  const TimeFilterButtons({super.key});

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
    final selectedFilter = ref.watch(timeFilterProvider);
    final selectedExpenseType = ref.watch(expenseTypeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: TimeFilter.values.map((filter) {
        final selectedDateRange = ref.watch(selectedDateRangeProvider);
        final isSelected =
            selectedDateRange == null && selectedFilter == filter;

        return Expanded(
          child: GestureDetector(
            // Fetch chart data for the new time filter selected
            onTap: () {
              ref.read(timeFilterProvider.notifier).state = filter;
              ref.read(selectedDateRangeProvider.notifier).state =
                  null; // clear date range
              ref
                  .read(chartDataProvider(filter).notifier)
                  .fetchChartData(filter);

              Logger().f("Calling from time filter button");

              // ref.read(transactionRollupApiProvider.notifier).getStats(filter);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? getColorByType(selectedExpenseType)
                    : grayColor.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  getTimeFilterText(filter.name),
                  style: TextStyle(
                    fontSize: 20,
                    color: isSelected
                        ? whiteColor
                        : lightGrayColor.withAlpha(200),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
