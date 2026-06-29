import 'package:intl/intl.dart';
import 'package:tracker/enums/dateformat.dart';

String formatDateWithLabel(String date, DateLabelFormat format) {
  final d = DateTime.parse(date);

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
