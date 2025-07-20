import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';

class TransactionListNotifier extends StateNotifier<List<Transaction>> {
  TransactionListNotifier() : super([]);

  void addTransaction(Transaction transaction) {
    state = [transaction, ...state];
  }
}

final transactionListProvider =
    StateNotifierProvider<TransactionListNotifier, List<Transaction>>(
      (ref) => TransactionListNotifier(),
    );
