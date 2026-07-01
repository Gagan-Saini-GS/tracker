import 'package:tracker/models/transaction.dart';

class TransactionSummary {
  final List<Transaction> transactions;
  final Map<String, dynamic> pagination;

  const TransactionSummary({
    required this.transactions,
    required this.pagination,
  });
}
