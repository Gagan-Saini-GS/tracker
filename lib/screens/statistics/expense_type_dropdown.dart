import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the selected expense type
final expenseTypeProvider = StateProvider<String>((ref) => 'Expense');

class ExpenseTypeDropdown extends ConsumerWidget {
  const ExpenseTypeDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedExpenseType = ref.watch(expenseTypeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedExpenseType,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          onChanged: (String? newValue) {
            if (newValue != null) {
              ref.read(expenseTypeProvider.notifier).state = newValue;
            }
          },
          // I'll add Saving later.
          items: <String>['Expense', 'Income'].map<DropdownMenuItem<String>>((
            String value,
          ) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }
}
