class Transaction {
  final String name;
  final double amount;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.name,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}
