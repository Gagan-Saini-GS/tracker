import 'package:flutter/material.dart';

class ChartData {
  ChartData(this.x, this.y, [this.pointColor]);

  final String x;
  final double y;
  final Color? pointColor;
}
