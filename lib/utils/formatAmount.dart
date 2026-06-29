import 'package:intl/intl.dart';
import 'package:tracker/enums/amountformat.dart';

String formatAmount(
  num amount, {
  AmountFormat format = AmountFormat.indianLong,
}) {
  switch (format) {
    case AmountFormat.indianLong:
      return NumberFormat('#,##,##0.##', 'en_IN').format(amount);

    case AmountFormat.usLong:
      return NumberFormat('#,##0.##', 'en_US').format(amount);

    case AmountFormat.indianShort:
      return _formatIndianShort(amount, false);

    case AmountFormat.indianCompact:
      return _formatIndianShort(amount, true);

    case AmountFormat.usShort:
      return _formatUSShort(amount, false);

    case AmountFormat.usCompact:
      return _formatUSShort(amount, true);

    case AmountFormat.scientific:
      return amount.toStringAsExponential(2);

    case AmountFormat.abbreviated:
      return _formatIndianShort(amount, true);
  }
}

String _formatIndianShort(num amount, bool compact) {
  final abs = amount.abs();

  if (abs >= 10000000) {
    final value = amount / 10000000;
    return '${value.toStringAsFixed(2)}${compact ? 'Cr' : ' Crore'}';
  }

  if (abs >= 100000) {
    final value = amount / 100000;
    return '${value.toStringAsFixed(2)}${compact ? 'L' : ' Lakh'}';
  }

  if (abs >= 1000) {
    final value = amount / 1000;
    return '${value.toStringAsFixed(2)}${compact ? 'K' : ' Thousand'}';
  }

  return amount.toString();
}

String _formatUSShort(num amount, bool compact) {
  final abs = amount.abs();

  if (abs >= 1000000000) {
    final value = amount / 1000000000;
    return '${value.toStringAsFixed(2)}${compact ? 'B' : ' Billion'}';
  }

  if (abs >= 1000000) {
    final value = amount / 1000000;
    return '${value.toStringAsFixed(2)}${compact ? 'M' : ' Million'}';
  }

  if (abs >= 1000) {
    final value = amount / 1000;
    return '${value.toStringAsFixed(2)}${compact ? 'K' : ' Thousand'}';
  }

  return amount.toString();
}

String cleanAmount(String amount) {
  return amount.replaceAll(RegExp(r'[^0-9.,]'), '');
}
