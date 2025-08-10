import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tracker/providers/transaction_api_provider.dart';
import '../models/transaction.dart';

class TransactionState {
  final List<Transaction> transactions;
  final Transaction selectedTransaction;
  bool isLoading;

  TransactionState({
    this.transactions = const [],
    Transaction? selectedTransaction,
    this.isLoading = false,
  }) : selectedTransaction =
           selectedTransaction ??
           Transaction(
             id: '',
             amount: 0,
             name: '',
             date: DateTime(2025),
             isIncome: true,
             note: "",
           );

  TransactionState copyWith({
    List<Transaction>? transactions,
    Transaction? selectedTransaction,
    bool? isLoading,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      selectedTransaction: selectedTransaction ?? this.selectedTransaction,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TransactionListNotifier extends StateNotifier<TransactionState> {
  final Ref ref;
  TransactionListNotifier(this.ref) : super(TransactionState());

  Future<void> addTransaction(Transaction transaction) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref
          .read(transactionApiProvider.notifier)
          .addTransaction(
            title: transaction.name,
            type: transaction.isIncome ? 'Income' : 'Expense',
            amount: transaction.amount,
            date: transaction.date.toIso8601String(),
            note: transaction.note,
          );
      // state = [transaction, ...state];
      state = state.copyWith(transactions: [transaction]);
    } catch (e) {
      Logger().e(e);
      state = state.copyWith(transactions: []);
      throw Exception("Can't add transaction, Please try again");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchRecentTransactions() async {
    state = state.copyWith(isLoading: true);

    try {
      final List<Transaction> transactions = await ref
          .read(transactionApiProvider.notifier)
          .fetchRecentTransactions();
      state = state.copyWith(transactions: transactions);
    } catch (e) {
      Logger().e(e);
      state = state.copyWith(transactions: []);
      throw Exception("Can't fetch recent transactions");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchTransactionHistory() async {
    state = state.copyWith(isLoading: true);

    try {
      final List<Transaction> transactions = await ref
          .read(transactionApiProvider.notifier)
          .fetchTransactionHistory();
      state = state.copyWith(transactions: transactions);
    } catch (e) {
      Logger().e(e);
      throw Exception("Can't fetch transactions");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getTransactionDetailsById(String transactionId) async {
    state = state.copyWith(isLoading: true);

    try {
      final Transaction? transaction = await ref
          .read(transactionApiProvider.notifier)
          .getTransactionDetailsById(transactionId);

      state = state.copyWith(selectedTransaction: transaction);
    } catch (e) {
      Logger().e(e);
      state = state.copyWith(selectedTransaction: null);
      throw Exception("Can't get transaction details");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> deleteTransaction(String transactionId, String date) async {
    state = state.copyWith(isLoading: true);
    try {
      final bool success = await ref
          .read(transactionApiProvider.notifier)
          .deleteTransaction(transactionId, date);

      if (success) {
        // Remove the deleted transaction from the current state
        final updatedTransactions = state.transactions
            .where((transaction) => transaction.id != transactionId)
            .toList();
        state = state.copyWith(transactions: updatedTransactions);
      }

      return success;
    } catch (e) {
      Logger().e(e);
      throw Exception("Can't delete transaction, Please try again");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final transactionListProvider =
    StateNotifierProvider<TransactionListNotifier, TransactionState>(
      (ref) => TransactionListNotifier(ref),
    );

// Recent Transactions Provider
class RecentTransactionListNotifier extends StateNotifier<TransactionState> {
  final Ref ref;
  RecentTransactionListNotifier(this.ref) : super(TransactionState());

  Future<void> fetchRecentTransactions() async {
    state = state.copyWith(isLoading: true);
    try {
      final List<Transaction> transactions = await ref
          .read(transactionApiProvider.notifier)
          .fetchRecentTransactions();
      state = state.copyWith(transactions: transactions);
    } catch (e) {
      Logger().e(e);
      state = state.copyWith(transactions: []);
      throw Exception("Can't fetch recent transactions");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final recentTransactionListProvider =
    StateNotifierProvider<RecentTransactionListNotifier, TransactionState>(
      (ref) => RecentTransactionListNotifier(ref),
    );

// All Transactions Provider
class AllTransactionListNotifier extends StateNotifier<TransactionState> {
  final Ref ref;
  AllTransactionListNotifier(this.ref) : super(TransactionState());

  Future<void> fetchTransactionHistory() async {
    state = state.copyWith(isLoading: true);
    try {
      final List<Transaction> transactions = await ref
          .read(transactionApiProvider.notifier)
          .fetchTransactionHistory();
      state = state.copyWith(transactions: transactions);
    } catch (e) {
      Logger().e(e);
      state = state.copyWith(transactions: []);
      throw Exception("Can't fetch transactions");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final allTransactionListProvider =
    StateNotifierProvider<AllTransactionListNotifier, TransactionState>(
      (ref) => AllTransactionListNotifier(ref),
    );
