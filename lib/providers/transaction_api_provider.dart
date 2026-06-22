import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tracker/models/transaction.dart';
import 'package:tracker/models/transaction_summary.dart';
import 'package:tracker/providers/token_interceptor_provider.dart';

class TransactionApiState {
  final List<Transaction> transactions;
  final double income;
  final double expense;
  final double saving;
  final bool isLoading;
  final String? error;

  TransactionApiState({
    this.transactions = const [],
    this.isLoading = false,
    this.income = 0,
    this.expense = 0,
    this.saving = 0,
    this.error,
  });

  TransactionApiState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    double? income,
    double? expense,
    double? saving,
    String? error,
  }) {
    return TransactionApiState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      saving: saving ?? this.saving,
      error: error,
    );
  }
}

class TransactionApiNotifier extends StateNotifier<TransactionApiState> {
  final Ref ref;
  TransactionApiNotifier(this.ref) : super(TransactionApiState());

  Future<List<Transaction>> fetchRecentTransactions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tokenInterceptor = ref.read(tokenInterceptorProvider);

      final response = await tokenInterceptor.makeAuthenticatedRequest(
        'transactions/recent',
        'GET',
      );

      final List<dynamic> transactionsData = response['data'] ?? [];
      final transactions = transactionsData
          .map((data) => Transaction.fromJson(data))
          .toList();

      state = state.copyWith(transactions: transactions, isLoading: false);

      return transactions;
    } catch (e) {
      Logger().e(e);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch transactions: ${e.toString()}',
      );
    }

    return [];
  }

  Future<TransactionSummary> fetchTransactionHistory() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tokenInterceptor = ref.read(tokenInterceptorProvider);

      final response = await tokenInterceptor.makeAuthenticatedRequest(
        'transactions/history',
        'GET',
      );

      final totals = response['data']['totalCount'];
      final List<dynamic> transactionsData =
          response['data']['transactions'] ?? [];
      final transactions = transactionsData
          .map((data) => Transaction.fromJson(data))
          .toList();

      state = state.copyWith(
        transactions: transactions,
        expense: double.tryParse(totals[0]['_sum']['amount'].toString()) ?? 0.0,
        income: double.tryParse(totals[1]['_sum']['amount'].toString()) ?? 0.0,
        saving: double.tryParse(totals[2]['_sum']['amount'].toString()) ?? 0.0,
        isLoading: false,
      );

      return TransactionSummary(
        transactions: transactions,
        expense: double.tryParse(totals[0]['_sum']['amount'].toString()) ?? 0.0,
        income: double.tryParse(totals[1]['_sum']['amount'].toString()) ?? 0.0,
        saving: double.tryParse(totals[2]['_sum']['amount'].toString()) ?? 0.0,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch transaction history: ${e.toString()}',
      );
    }

    return TransactionSummary(
      transactions: [],
      expense: 0,
      income: 0,
      saving: 0,
    );
  }

  Future<bool> addTransaction({
    required String title,
    required String type,
    required double amount,
    required String date,
    String? note,
  }) async {
    try {
      final tokenInterceptor = ref.read(tokenInterceptorProvider);

      final response = await tokenInterceptor.makeAuthenticatedRequest(
        'transactions/add',
        'POST',
        body: {
          'title': title,
          'type': type,
          'amount': amount,
          'date': date,
          if (note != null) 'note': note,
        },
      );

      final newTransaction = Transaction.fromJson(response['data']);

      // Add to current state
      state = state.copyWith(
        transactions: [newTransaction, ...state.transactions],
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add transaction: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> deleteTransaction(String transactionId, String date) async {
    try {
      final tokenInterceptor = ref.read(tokenInterceptorProvider);

      await tokenInterceptor.makeAuthenticatedRequest(
        'transactions/$transactionId',
        'DELETE',
        body: {'date': date},
      );

      // Remove from current state
      state = state.copyWith(
        transactions: state.transactions
            .where((transaction) => transaction.id != transactionId)
            .toList(),
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete transaction: ${e.toString()}',
      );
      return false;
    }
  }

  Future<Transaction?> getTransactionDetailsById(String transactionId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tokenInterceptor = ref.read(tokenInterceptorProvider);

      final response = await tokenInterceptor.makeAuthenticatedRequest(
        'transactions/$transactionId',
        'GET',
      );

      final transactionData = response['data'];
      final transaction = Transaction.fromJson(transactionData);

      state = state.copyWith(isLoading: false);
      return transaction;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch transaction details: ${e.toString()}',
      );
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final transactionApiProvider =
    StateNotifierProvider<TransactionApiNotifier, TransactionApiState>((ref) {
      return TransactionApiNotifier(ref);
    });
