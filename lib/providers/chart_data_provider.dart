import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/enums/timefilter.dart';
import 'package:tracker/models/chart_data.dart';
import 'package:tracker/providers/expense_type_provider.dart';
import 'package:tracker/providers/transaction_provider.dart';

final now = DateTime.now();
final today = DateTime(now.year, now.month, now.day);

final chartDataProvider = Provider.family<List<ChartData>, TimeFilter>((
  ref,
  filter,
) {
  final transactions = ref.watch(transactionListProvider);
  final selectedExpenseType = ref.watch(expenseTypeProvider);

  // Determine the start date based on the selected range.
  DateTime startDate;
  switch (filter) {
    case TimeFilter.week:
      // The last 7 days means we go back 6 days from today.
      startDate = today.subtract(const Duration(days: 6));
      break;
    case TimeFilter.month:
      // The last 30 days means we go back 29 days from today.
      startDate = today.subtract(const Duration(days: 29));
      break;
    case TimeFilter.year:
      // The last year (365 days).
      startDate = today.subtract(const Duration(days: 365));
      break;
    case TimeFilter.day:
      // If just "Today", the start and end dates are the same.
      startDate = today;
      break;
  }

  // switch (filter) {
  //   case TimeFilter.day:
  return transactions
      .where((transaction) {
        final transactionDate = DateTime(
          transaction.date.year,
          transaction.date.month,
          transaction.date.day,
        );
        // Check if the transaction's date and show only if within the selected range.
        final bool isInDateRange =
            !transactionDate.isBefore(startDate) &&
            !transactionDate.isAfter(today);

        // Match the dropdown value type
        final bool isCorrectType = selectedExpenseType == "Income"
            ? transaction.isIncome
            : !transaction.isIncome;

        return isInDateRange && isCorrectType;
      })
      .map((transaction) {
        final String hour = transaction.date.hour < 9
            ? "0${transaction.date.hour}"
            : transaction.date.hour.toString();
        final String minute = transaction.date.minute == 9
            ? "0${transaction.date.minute}"
            : transaction.date.minute.toString();

        return ChartData(transaction.name, '$hour:$minute', transaction.amount);
      })
      .toList()
      .reversed
      .toList();
});
