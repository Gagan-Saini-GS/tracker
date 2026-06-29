import 'package:tracker/enums/dateformat.dart';
import 'package:tracker/enums/timePeriod.dart';

DateLabelFormat getDateFormatStyleByPeriodType(TimePeriod periodType) {
  if (periodType == TimePeriod.daily) {
    return DateLabelFormat.dMMM;
  } else if (periodType == TimePeriod.weekly) {
    return DateLabelFormat.ddmmyy;
  } else if (periodType == TimePeriod.monthly) {
    return DateLabelFormat.month;
  } else if (periodType == TimePeriod.yearly) {
    return DateLabelFormat.year;
  }

  return DateLabelFormat.iso;
}
