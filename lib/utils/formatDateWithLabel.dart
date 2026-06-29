import 'package:intl/intl.dart';
import 'package:tracker/enums/dateformat.dart';

String normalizeDateString(String date) {
  // YYYY -> 2026 -> 2026-01-01 so it can be parsed
  if (RegExp(r'^\d{4}$').hasMatch(date)) {
    return '$date-01-01';
  }

  // YYYY-MM -> 2026-03 -> 2026-03-01 so it can be parsed
  if (RegExp(r'^\d{4}-\d{2}$').hasMatch(date)) {
    return '$date-01';
  }

  // Assume already YYYY-MM-DD or a valid ISO date
  return date;
}

String formatDateWithLabel(String date, DateLabelFormat format) {
  final normalizedDate = normalizeDateString(date);
  final d = DateTime.parse(normalizedDate);

  switch (format) {
    case DateLabelFormat.iso:
      return DateFormat('yyyy-MM-dd').format(d);

    case DateLabelFormat.ddMMyyyy:
      return DateFormat('dd-MM-yyyy').format(d);

    case DateLabelFormat.ddmmyy:
      return DateFormat('dd-MM-yy').format(d);

    case DateLabelFormat.dMMMyyyy:
      return DateFormat('d MMM, yyyy').format(d);

    case DateLabelFormat.MMMdyyyy:
      return DateFormat('MMM d, yyyy').format(d);

    case DateLabelFormat.MMMdyy:
      return DateFormat('MMM d, yy').format(d);

    case DateLabelFormat.dMMM:
      return DateFormat('d MMM').format(d);

    case DateLabelFormat.MMMd:
      return DateFormat('MMM d').format(d);

    case DateLabelFormat.month:
      return DateFormat('MMMM').format(d);

    case DateLabelFormat.year:
      return DateFormat('yyyy').format(d);
  }
}
