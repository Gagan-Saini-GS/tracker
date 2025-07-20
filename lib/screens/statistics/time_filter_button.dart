import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/enums/timefilter.dart';
import 'package:tracker/providers/expense_type_provider.dart';
import 'package:tracker/providers/time_filter_provider.dart';
import 'package:tracker/utils/capitalize.dart';
import 'package:tracker/utils/constants.dart';

class TimeFilterButtons extends ConsumerWidget {
  const TimeFilterButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(timeFilterProvider);
    final selectedExpenseType = ref.watch(expenseTypeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: TimeFilter.values.map((filter) {
        final isSelected = selectedFilter == filter;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              ref.read(timeFilterProvider.notifier).state = filter;
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? selectedExpenseType == "Income"
                          ? greenColor
                          : redColor
                    : grayColor.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  filter.name.capitalize(),
                  style: TextStyle(
                    color: isSelected ? whiteColor : blackColor,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
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
