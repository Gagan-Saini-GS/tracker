import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tracker/providers/transaction_api_provider.dart';
import '../models/transaction.dart';

class TransactionListNotifier extends StateNotifier<List<Transaction>> {
  final Ref ref;
  TransactionListNotifier(this.ref) : super([]);

  Future<void> addTransaction(Transaction transaction) async {
    await ref
        .read(transactionApiProvider.notifier)
        .addTransaction(
          title: transaction.name,
          type: transaction.isIncome ? 'Income' : 'Expense',
          amount: transaction.amount,
          date: transaction.date.toIso8601String(),
          note: transaction.note,
        );
    state = [transaction, ...state];
  }

  Future<void> fetchRecentTransactions() async {
    final List<Transaction> transactions = await ref
        .read(transactionApiProvider.notifier)
        .fetchRecentTransactions();
    state = transactions;
  }

  Future<void> fetchTransactionHistory() async {
    final List<Transaction> transactions = await ref
        .read(transactionApiProvider.notifier)
        .fetchTransactionHistory();
    Logger().f("Transaction List $transactions");
    state = transactions;
  }
}

final transactionListProvider =
    StateNotifierProvider<TransactionListNotifier, List<Transaction>>(
      (ref) => TransactionListNotifier(ref),
    );
