import 'package:tracker/models/transaction.dart';

class TransactionSummary {
  final List<Transaction> transactions;
  final double expense;
  final double income;
  final double saving;

  const TransactionSummary({
    required this.transactions,
    required this.expense,
    required this.income,
    required this.saving,
  });
}
