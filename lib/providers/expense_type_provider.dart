// Provider for the selected expense type
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseTypeProvider = StateProvider<String>((ref) => 'Expense');
