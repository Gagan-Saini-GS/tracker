import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tracker/enums/timefilter.dart';
import 'package:tracker/models/chart_data.dart';
import 'package:tracker/models/transaction.dart';
import 'package:tracker/providers/token_interceptor_provider.dart';
import 'package:tracker/utils/getTimefilterText.dart';

class RollupDataState {
  final String periodKey;
  final String periodType;
  final String transactionType;
  final double amount;

  RollupDataState({
    this.periodKey = "",
    this.periodType = "",
    this.transactionType = "",
    this.amount = 0,
  });

  RollupDataState copyWith({
    String? periodKey,
    String? periodType,
    String? transactionType,
    double? amount,
  }) {
    return RollupDataState(
      periodKey: periodKey ?? this.periodKey,
      periodType: periodType ?? this.periodType,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
    );
  }
}

class TransactionRollupApiState {
  final bool isLoading;
  final String? error;
  final List<ChartData> graphData;
  final List<Transaction> transactions;

  TransactionRollupApiState({
    this.isLoading = false,
    this.error,
    this.graphData = const [],
    this.transactions = const [],
  });

  TransactionRollupApiState copyWith({
    bool? isLoading,
    String? error,
    List<ChartData>? graphData,
    List<Transaction>? transactions,
  }) {
    return TransactionRollupApiState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      graphData: graphData ?? this.graphData,
      transactions: transactions ?? this.transactions,
    );
  }
}

class TransactionRollupApiNotifier
    extends StateNotifier<TransactionRollupApiState> {
  final Ref ref;

  TransactionRollupApiNotifier(this.ref) : super(TransactionRollupApiState());

  Future<List<Transaction>> getStats(
    TimeFilter timefilter,
    String startDate,
    String endDate,
    String type,
  ) async {
    state = state.copyWith(isLoading: true);

    try {
      final tokenInterceptor = ref.read(tokenInterceptorProvider);

      final response = await tokenInterceptor.makeAuthenticatedRequest(
        'rollups/stats',
        'GET',
        queryParams: {
          "type": type,
          "period": getTimeFilterText(timefilter.name),
          "start_date": startDate,
          "end_date": endDate,
        },
      );

      final graphData = (response["data"] as List).map((transaction) {
        return ChartData(
          transaction["period_key"],
          transaction["period_key"],
          (transaction["total_amount"] as num).toDouble(),
        );
      }).toList();

      final transactionData = (response["transactions"] as List)
          .map((tx) => Transaction.fromJson(tx))
          .toList();

      state = state.copyWith(
        graphData: graphData,
        transactions: transactionData,
      );

      return transactionData;
    } catch (error) {
      Logger().e(error);
      state = state.copyWith(
        error: "Failed to get the summary ${error.toString()}",
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }

    return [];
  }

  Future<void> getSummary() async {}
}

final transactionRollupApiProvider =
    StateNotifierProvider<
      TransactionRollupApiNotifier,
      TransactionRollupApiState
    >((ref) {
      return TransactionRollupApiNotifier(ref);
    });
