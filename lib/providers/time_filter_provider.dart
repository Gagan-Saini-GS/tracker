// Provider for the selected time filter
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/enums/timefilter.dart';

final timeFilterProvider = StateProvider<TimeFilter>((ref) => TimeFilter.day);
