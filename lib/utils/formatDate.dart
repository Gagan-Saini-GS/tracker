import 'package:intl/intl.dart';

String formatDateTime(DateTime date) {
  return DateFormat('dd/MM/yyyy hh:mm a').format(date);
}

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatDateTimeWithMonthName(DateTime date) {
  // MMM  -> First 3 character of month name ("Jan",...,"Jul"...., "Nov", "Dec")
  // d    -> Day of the month (e.g., "25")
  // y    -> Year (e.g., "2025")
  // hh   -> Hour in 12-hour format (01-12)
  // mm   -> Minute
  // a    -> AM/PM marker
  final format = DateFormat('MMM d, y (hh:mm a)');
  return format.format(date);
}
