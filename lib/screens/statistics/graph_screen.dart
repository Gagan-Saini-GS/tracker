import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tracker/models/chart_data.dart';
import 'package:tracker/providers/chart_data_provider.dart';
import 'package:tracker/providers/expense_type_provider.dart';
import 'package:tracker/providers/time_filter_provider.dart';

class ReusableLineChart extends ConsumerWidget {
  const ReusableLineChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeFilter = ref.watch(timeFilterProvider);
    final selectedExpenseType = ref.watch(expenseTypeProvider);
    final chartData = ref.watch(chartDataProvider(timeFilter));

    // Find the data point to highlight (e.g., the one with a specific color)
    final highlightedPoint = chartData.firstWhere(
      (data) => data.pointColor != null,
      orElse: () => ChartData('', 0), // Return a dummy if no highlight
    );

    return Container(
      height: 250, // Fixed height for the chart
      padding: const EdgeInsets.symmetric(horizontal: 8),
      // decoration: BoxDecoration(border: Border.all(width: 2)),
      child: Stack(
        children: [
          SfCartesianChart(
            plotAreaBorderWidth: 0, // Remove chart border
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(
                width: 0,
              ), // Remove vertical grid lines
              axisLine: const AxisLine(width: 1), // Remove X-axis line
              labelStyle: TextStyle(
                color: Colors.grey[600],
              ), // X-axis label color
              majorTickLines: const MajorTickLines(
                width: 0,
              ), // Remove X-axis ticks
            ),
            primaryYAxis: NumericAxis(
              // isVisible: false, // Hide Y-axis
              majorGridLines: const MajorGridLines(
                width: 1,
              ), // Remove horizontal grid lines
              axisLine: const AxisLine(width: 1), // Remove Y-axis line
              majorTickLines: const MajorTickLines(width: 0),
            ),
            series: <CartesianSeries>[
              SplineAreaSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                color: selectedExpenseType == "Income"
                    ? const Color(0xFF63B5AF).withAlpha(100)
                    : const Color(0xFFE83559).withAlpha(100), // Area fill color
                gradient: LinearGradient(
                  colors: [
                    selectedExpenseType == "Income"
                        ? const Color(0xFF63B5AF).withAlpha(100)
                        : const Color(0xFFE83559).withAlpha(100),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderColor: selectedExpenseType == "Income"
                    ? const Color(0xFF63B5AF)
                    : const Color(0xFFE83559), // Line color
                borderWidth: 2,
                splineType: SplineType.natural, // Smooth curve
                markerSettings: MarkerSettings(
                  isVisible: true,
                  height: 8,
                  width: 8,
                  shape: DataMarkerType.circle,
                  color: selectedExpenseType == "Income"
                      ? const Color(0xFF63B5AF)
                      : const Color(0xFFE83559),
                ),
                // Data label settings for the highlighted point
                dataLabelSettings: DataLabelSettings(
                  isVisible: highlightedPoint.x == ''
                      ? false
                      : true, // Only show if a point is highlighted
                  labelAlignment: ChartDataLabelAlignment.top,
                  builder:
                      (
                        dynamic data,
                        dynamic point,
                        dynamic series,
                        int pointIndex,
                        int seriesIndex,
                      ) {
                        if (data.x == highlightedPoint.x) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: selectedExpenseType == "Income"
                                  ? const Color(0xFF63B5AF)
                                  : const Color(0xFFE83559),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '₹${data.y.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                ),
              ),
            ],
          ),
          // Custom tooltip for the highlighted point (if needed, otherwise SfCartesianChart's tooltip can be used)
          // if (highlightedPoint.x != '')
          //   Positioned(
          //     left: _getPointXPosition(highlightedPoint.x, chartData, context),
          //     top:
          //         _getPointYPosition(highlightedPoint.y, chartData, context) -
          //         50, // Adjust position
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //       decoration: BoxDecoration(
          //         color: const Color(0xFF63B5AF),
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       child: Text(
          //         '\$${highlightedPoint.y.toStringAsFixed(0)}',
          //         style: const TextStyle(color: Colors.white, fontSize: 12),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  // // Helper to approximate X position for custom tooltip
  // double _getPointXPosition(
  //   String xValue,
  //   List<ChartData> data,
  //   BuildContext context,
  // ) {
  //   final index = data.indexWhere((element) => element.x == xValue);
  //   if (index == -1) return 0;

  //   final chartWidth =
  //       MediaQuery.of(context).size.width - 32; // Subtract padding
  //   final segmentWidth = chartWidth / (data.length - 1);
  //   return (index * segmentWidth) +
  //       16 -
  //       20; // Adjust for padding and tooltip width
  // }

  // // Helper to approximate Y position for custom tooltip
  // double _getPointYPosition(
  //   double yValue,
  //   List<ChartData> data,
  //   BuildContext context,
  // ) {
  //   final maxVal = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
  //   final minVal = data.map((e) => e.y).reduce((a, b) => a < b ? a : b);
  //   final chartHeight = 250.0; // Chart height
  //   final yAxisRange = maxVal - minVal;
  //   if (yAxisRange == 0) return chartHeight / 2; // Avoid division by zero

  //   final normalizedY = (yValue - minVal) / yAxisRange;
  //   return chartHeight -
  //       (normalizedY * chartHeight); // Invert for screen coordinates
  // }
}
