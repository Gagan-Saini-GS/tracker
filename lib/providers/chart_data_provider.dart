import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tracker/enums/timefilter.dart';
import 'package:tracker/models/chart_data.dart';
import 'package:tracker/models/transaction.dart';
import 'package:tracker/providers/expense_type_provider.dart';
import 'package:tracker/providers/transaction_provider.dart';

final now = DateTime.now();
final today = DateTime(now.year, now.month, now.day);

class ChartDataState {
  final List<ChartData> transactions;
  final List<Transaction> listTransactions;
  final bool isLoading;

  ChartDataState({
    this.transactions = const [],
    this.listTransactions = const [],
    this.isLoading = false,
  });

  ChartDataState copyWith({
    List<ChartData>? transactions,
    List<Transaction>? listTransactions,
    bool? isLoading,
  }) {
    return ChartDataState(
      transactions: transactions ?? this.transactions,
      listTransactions: listTransactions ?? this.listTransactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChartDataNotifier extends StateNotifier<ChartDataState> {
  final Ref ref;
  ChartDataNotifier(this.ref) : super(ChartDataState());

  Future<List<ChartData>> fetchChartData(TimeFilter filter) async {
    state = state.copyWith(isLoading: true);

    try {
      // Fetch transaction history first
      await ref
          .read(allTransactionListProvider.notifier)
          .fetchTransactionHistory();

      final transactions = ref.watch(allTransactionListProvider).transactions;
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

      final chartData = transactions
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
            final String hour = transaction.date.hour < 10
                ? "0${transaction.date.hour}"
                : transaction.date.hour.toString();
            final String minute = transaction.date.minute < 10
                ? "0${transaction.date.minute}"
                : transaction.date.minute.toString();

            return ChartData(
              transaction.name,
              '$hour:$minute',
              transaction.amount,
            );
          })
          .toList()
          .reversed
          .toList();

      final listTransactions = transactions
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
          .toList()
          .reversed
          .toList();

      state = state.copyWith(
        transactions: chartData,
        listTransactions: listTransactions,
      );

      return chartData;
    } catch (e) {
      Logger().e(e);
      state = state.copyWith(transactions: [], listTransactions: []);
      return [];
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final chartDataProvider =
    StateNotifierProvider.family<ChartDataNotifier, ChartDataState, TimeFilter>(
      (ref, filter) => ChartDataNotifier(ref),
    );
