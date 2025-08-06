import 'package:flutter/material.dart';

class ChartData {
  ChartData(this.title, this.time, this.amount, [this.pointColor]);

  final String title;
  final String time;
  final double amount;
  final Color? pointColor;

  @override
  String toString() {
    return "Title $title, Amount $amount, $time $time";
  }
}
