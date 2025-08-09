import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tracker/models/chart_data.dart';
import 'package:tracker/providers/chart_data_provider.dart';
import 'package:tracker/providers/expense_type_provider.dart';
import 'package:tracker/providers/time_filter_provider.dart';
import 'package:tracker/utils/constants.dart';

class ReusableLineChart extends ConsumerStatefulWidget {
  const ReusableLineChart({super.key});

  @override
  ConsumerState<ReusableLineChart> createState() => _ReusableLineChart();
}

class _ReusableLineChart extends ConsumerState<ReusableLineChart> {
  @override
  void initState() {
    super.initState();
    // Fetch transaction history when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Calling fetchChartData to get real data for chart.
      final timeFilter = ref.read(timeFilterProvider);
      ref
          .read(chartDataProvider(timeFilter).notifier)
          .fetchChartData(timeFilter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeFilter = ref.watch(timeFilterProvider);
    final selectedExpenseType = ref.watch(expenseTypeProvider);
    final chartDataState = ref.watch(chartDataProvider(timeFilter));

    if (chartDataState.isLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              backgroundColor: greenColor,
              color: whiteColor,
              strokeWidth: 5,
            ),
            SizedBox(height: 16),
            Text("Loading transactions...", style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    // Find the data point to highlight (e.g., the one with a specific color)
    final highlightedPoint = chartDataState.transactions.firstWhere(
      (data) => data.pointColor != null,
      orElse: () => ChartData("", "", 0), // Return a dummy if no highlight
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
              labelStyle: TextStyle(color: grayColor), // X-axis label color
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
                dataSource: chartDataState.transactions,
                xValueMapper: (ChartData data, _) => data.time,
                yValueMapper: (ChartData data, _) => data.amount,
                color: selectedExpenseType == "Income"
                    ? greenColor.withAlpha(100)
                    : redColor.withAlpha(100), // Area fill color
                gradient: LinearGradient(
                  colors: [
                    selectedExpenseType == "Income"
                        ? greenColor.withAlpha(100)
                        : redColor.withAlpha(100),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderColor: selectedExpenseType == "Income"
                    ? greenColor
                    : redColor, // Line color
                borderWidth: 2,
                splineType: SplineType.natural, // Smooth curve
                markerSettings: MarkerSettings(
                  isVisible: true,
                  height: 8,
                  width: 8,
                  shape: DataMarkerType.circle,
                  color: selectedExpenseType == "Income"
                      ? greenColor
                      : redColor,
                ),
                // Data label settings for the highlighted point
                dataLabelSettings: DataLabelSettings(
                  isVisible: highlightedPoint.time == ''
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
                        if (data.x == highlightedPoint.amount) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: selectedExpenseType == "Income"
                                  ? greenColor
                                  : redColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '₹${data.y.toStringAsFixed(0)}',
                              style: TextStyle(color: whiteColor, fontSize: 12),
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
          //     left: _getPointXPosition(highlightedPoint.x, chartDataState, context),
          //     top:
          //         _getPointYPosition(highlightedPoint.y, chartDataState, context) -
          //         50, // Adjust position
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //       decoration: BoxDecoration(
          //         color: greenColor,
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       child: Text(
          //         '\$${highlightedPoint.y.toStringAsFixed(0)}',
          //         style: const TextStyle(color: whiteColor, fontSize: 12),
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
