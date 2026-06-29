import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tracker/models/chart_data.dart';
import 'package:tracker/providers/transaction_filter_provider.dart';
import 'package:tracker/providers/transaction_rollup_api_provider.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/formatDateWithLabel.dart';
import 'package:tracker/utils/getDateFormatStyleByPeriodType.dart';
import 'package:tracker/utils/getTransactionType.dart';
import 'package:tracker/widgets/loader.dart';

// Convert this to normal consumer widget.
class ReusableLineChart extends ConsumerStatefulWidget {
  const ReusableLineChart({super.key});

  @override
  ConsumerState<ReusableLineChart> createState() => _ReusableLineChart();
}

class _ReusableLineChart extends ConsumerState<ReusableLineChart> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final transactionFilterState = ref.watch(transactionFilterProvider);
    final selectedExpenseType = transactionFilterState.type;
    final rollupDataState = ref.watch(transactionRollupApiProvider);

    if (rollupDataState.isLoading && rollupDataState.graphData.isEmpty) {
      final bool isIncome = selectedExpenseType == "Income";

      return Loader(
        title: isIncome ? "Loading Income..." : "Loading Expense...",
        backgroundColor: whiteColor,
        foregroundColor: isIncome ? greenColor : redColor,
      );
    }

    final highlightedPoint =
        _selectedIndex != null &&
            _selectedIndex! < rollupDataState.graphData.length
        ? rollupDataState.graphData[_selectedIndex!]
        : ChartData("", "", 0);

    final dateFormatStyle = getDateFormatStyleByPeriodType(
      transactionFilterState.periodType,
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
              majorGridLines: MajorGridLines(
                width: 0,
                color: whiteColor.withAlpha(50),
              ), // Remove vertical grid lines
              axisLine: const AxisLine(width: 1), // Remove X-axis line
              labelStyle: TextStyle(color: whiteColor), // X-axis label color
              majorTickLines: const MajorTickLines(
                width: 0,
              ), // Remove X-axis ticks
            ),
            primaryYAxis: NumericAxis(
              // isVisible: false, // Hide Y-axis
              majorGridLines: MajorGridLines(
                width: 1,
                color: whiteColor.withAlpha(50),
              ), // Remove horizontal grid lines
              axisLine: const AxisLine(width: 1), // Remove Y-axis line
              majorTickLines: const MajorTickLines(width: 0),
              labelStyle: TextStyle(color: whiteColor), // Y-axis label color
            ),
            series: <CartesianSeries>[
              SplineAreaSeries<ChartData, String>(
                dataSource: rollupDataState.graphData,
                xValueMapper: (ChartData data, _) =>
                    formatDateWithLabel(data.time, dateFormatStyle),
                yValueMapper: (ChartData data, _) => data.amount,
                color: getColorByTransactionType(
                  selectedExpenseType,
                ), // Area fill color
                gradient: LinearGradient(
                  colors: [
                    getColorByTransactionType(
                      selectedExpenseType,
                    ).withAlpha(100),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderColor: getColorByTransactionType(
                  selectedExpenseType,
                ), // Line color
                borderWidth: 2,
                splineType: SplineType.natural, // Smooth curve
                onPointTap: (ChartPointDetails details) {
                  final index = details.pointIndex;
                  if (index != null && index >= 0) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }
                },

                markerSettings: MarkerSettings(
                  isVisible: true,
                  height: 10,
                  width: 10,
                  shape: DataMarkerType.circle,
                  // image: const NetworkImage(
                  //   "https://i.pinimg.com/control1/736x/ea/25/cd/ea25cd897d9693ad276f81b6e6026522.jpg",
                  // ),
                  color: getColorByTransactionType(selectedExpenseType),
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
                        if (_selectedIndex != null &&
                            _selectedIndex! >= 0 &&
                            pointIndex == _selectedIndex) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: getColorByTransactionType(
                                selectedExpenseType,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '₹${rollupDataState.graphData[_selectedIndex!].amount}',
                              style: TextStyle(
                                color: whiteColor,
                                backgroundColor: getColorByTransactionType(
                                  selectedExpenseType,
                                ),
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
