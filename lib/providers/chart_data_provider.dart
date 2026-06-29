import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tracker/enums/timePeriod.dart';
import 'package:tracker/enums/timefilter.dart';
import 'package:tracker/enums/transaction_type.dart';
import 'package:tracker/models/chart_data.dart';
import 'package:tracker/models/transaction.dart';
import 'package:tracker/providers/transaction_provider.dart';
import 'package:tracker/utils/formatXLabelForGraph.dart';

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

  bool getTypeValue(String type, TransactionType txType) {
    if (type == "Expense") {
      return txType == TransactionType.expense;
    } else if (type == "Income") {
      return txType == TransactionType.income;
    } else if (type == "Saving") {
      return txType == TransactionType.saving;
    }
    return false;
  }

  Future<List<ChartData>> fetchChartData(TimeFilter filter) async {
    state = state.copyWith(isLoading: true);

    try {
      // Fetch transaction history first
      await ref
          .read(allTransactionListProvider.notifier)
          .fetchTransactionHistory();

      final transactions = ref.watch(allTransactionListProvider).transactions;

      final chartData = transactions
          .map((transaction) {
            return ChartData(
              transaction.name,
              formatXLabel(transaction.date),
              transaction.amount,
            );
          })
          .toList()
          .reversed
          .toList();

      final listTransactions = transactions.toList().reversed.toList();

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

  void updateChartFromTransactions(List<Transaction> transactions) {
    final chartData = transactions
        .map((transaction) {
          return ChartData(
            transaction.name,
            formatXLabel(transaction.date),
            transaction.amount,
          );
        })
        .toList()
        .reversed
        .toList();

    state = state.copyWith(
      transactions: chartData,
      listTransactions: transactions.reversed.toList(),
    );
  }
}

final chartDataProvider =
    StateNotifierProvider.family<ChartDataNotifier, ChartDataState, TimePeriod>(
      (ref, filter) => ChartDataNotifier(ref),
    );
