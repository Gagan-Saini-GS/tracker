class Transaction {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final String note;

  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.isIncome,
    this.note = "",
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      name: json['title'] ?? json['name'] ?? '',
      amount: double.parse(json['amount'] ?? 0),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      isIncome: json['type'] == 'Income',
      note: json['note'] ?? '',
    );
  }
}
