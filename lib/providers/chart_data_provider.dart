import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/enums/timefilter.dart';
import 'package:tracker/models/chart_data.dart';
import 'package:tracker/utils/constants.dart';

final chartDataProvider = Provider.family<List<ChartData>, TimeFilter>((
  ref,
  filter,
) {
  // In a real application, you would fetch data based on the filter
  // For demonstration, we'll generate dummy data.
  switch (filter) {
    case TimeFilter.day:
      return [
        ChartData('8 AM', 100, greenColor),
        ChartData('12 PM', 250),
        ChartData('4 PM', 150),
        ChartData('8 PM', 300),
      ];
    case TimeFilter.week:
      return [
        ChartData('Mon', 120),
        ChartData('Tue', 280, greenColor),
        ChartData('Wed', 190),
        ChartData('Thu', 350),
        ChartData('Fri', 220),
        ChartData('Sat', 400),
        ChartData('Sun', 300),
      ];
    case TimeFilter.month:
      return [
        ChartData('Mar', 1230),
        ChartData('Apr', 850),
        ChartData('May', 1900, greenColor),
        ChartData('Jun', 1500),
        ChartData('Jul', 1700),
        ChartData('Aug', 1300),
        ChartData('Sep', 1600),
      ];
    case TimeFilter.year:
      return [
        ChartData('Jan', 5000),
        ChartData('Feb', 6500),
        ChartData('Mar', 5800, greenColor),
        ChartData('Apr', 7200),
        ChartData('May', 6000),
        ChartData('Jun', 7500),
        ChartData('Jul', 6800),
        ChartData('Aug', 8000),
        ChartData('Sep', 7100),
        ChartData('Oct', 8500),
        ChartData('Nov', 7800),
        ChartData('Dec', 9000),
      ];
  }
});
