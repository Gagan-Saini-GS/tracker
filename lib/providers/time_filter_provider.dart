// Provider for the selected time filter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/enums/timefilter.dart';

final timeFilterProvider = StateProvider<TimeFilter>((ref) => TimeFilter.week);
final selectedDateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);
