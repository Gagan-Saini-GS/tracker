import 'package:intl/intl.dart';

String formatXLabel(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  final day = date.day.toString();
  final month = DateFormat('MMM').format(date);
  return '$month $day\n($hour:$minute)';
}
