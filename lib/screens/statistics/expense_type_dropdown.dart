import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/providers/expense_type_provider.dart';

class ExpenseTypeDropdown extends ConsumerWidget {
  const ExpenseTypeDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedExpenseType = ref.watch(expenseTypeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            '$selectedExpenseType Graph',
            style: TextStyle(
              fontSize: 20,
              color: selectedExpenseType == "Income"
                  ? const Color(0xFF63B5AF)
                  : const Color(0xFFE83559),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: selectedExpenseType == "Income"
                ? const Color(0xFF63B5AF).withAlpha(65)
                : const Color(0xFFE83559).withAlpha(65),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isDense: true,
              value: selectedExpenseType,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref.read(expenseTypeProvider.notifier).state = newValue;
                }
              },
              // I'll add Saving later.
              items: <String>['Expense', 'Income']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
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
