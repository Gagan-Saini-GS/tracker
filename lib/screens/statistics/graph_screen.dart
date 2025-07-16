import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tracker/screens/statistics/time_filter_button.dart';

// --- 1. Data Model ---
class ChartData {
  ChartData(this.x, this.y, [this.pointColor]);
  final String x;
  final double y;
  final Color? pointColor;
}

// --- 2. Providers ---

// Provider for chart data (simulated data based on time filter)
final chartDataProvider = Provider.family<List<ChartData>, TimeFilter>((
  ref,
  filter,
) {
  // In a real application, you would fetch data based on the filter
  // For demonstration, we'll generate dummy data.
  switch (filter) {
    case TimeFilter.day:
      return [
        ChartData('8 AM', 100),
        ChartData('12 PM', 250, const Color(0xFF63B5AF)),
        ChartData('4 PM', 150),
        ChartData('8 PM', 300),
      ];
    case TimeFilter.week:
      return [
        ChartData('Mon', 120),
        ChartData('Tue', 280),
        ChartData('Wed', 190),
        ChartData('Thu', 350),
        ChartData('Fri', 220, const Color(0xFF63B5AF)),
        ChartData('Sat', 400),
        ChartData('Sun', 300),
      ];
    case TimeFilter.month:
      return [
        ChartData('Mar', 1230),
        ChartData('Apr', 850),
        ChartData('May', 1900, const Color(0xFF63B5AF)),
        ChartData('Jun', 1500),
        ChartData('Jul', 1700),
        ChartData('Aug', 1300),
        ChartData('Sep', 1600),
      ];
    case TimeFilter.year:
      return [
        ChartData('Jan', 5000),
        ChartData('Feb', 6500),
        ChartData('Mar', 5800),
        ChartData('Apr', 7200),
        ChartData('May', 6000),
        ChartData('Jun', 7500),
        ChartData('Jul', 6800, const Color(0xFF63B5AF)),
        ChartData('Aug', 8000),
        ChartData('Sep', 7100),
        ChartData('Oct', 8500),
        ChartData('Nov', 7800),
        ChartData('Dec', 9000),
      ];
  }
});

// --- 3. Chart Widget ---
class ReusableLineChart extends ConsumerWidget {
  const ReusableLineChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeFilter = ref.watch(timeFilterProvider);
    final chartData = ref.watch(chartDataProvider(timeFilter));

    // Find the data point to highlight (e.g., the one with a specific color)
    final highlightedPoint = chartData.firstWhere(
      (data) => data.pointColor != null,
      orElse: () => ChartData('', 0), // Return a dummy if no highlight
    );

    return Container(
      height: 250, // Fixed height for the chart
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          SfCartesianChart(
            plotAreaBorderWidth: 0, // Remove chart border
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(
                width: 0,
              ), // Remove vertical grid lines
              axisLine: const AxisLine(width: 0), // Remove X-axis line
              labelStyle: TextStyle(
                color: Colors.grey[600],
              ), // X-axis label color
              majorTickLines: const MajorTickLines(
                width: 0,
              ), // Remove X-axis ticks
            ),
            primaryYAxis: NumericAxis(
              isVisible: false, // Hide Y-axis
              majorGridLines: const MajorGridLines(
                width: 0,
              ), // Remove horizontal grid lines
              axisLine: const AxisLine(width: 0), // Remove Y-axis line
            ),
            series: <CartesianSeries>[
              SplineAreaSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                color: const Color(
                  0xFF63B5AF,
                ).withAlpha(100), // Area fill color
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF63B5AF).withAlpha(100),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderColor: const Color(0xFF63B5AF), // Line color
                borderWidth: 2,
                splineType: SplineType.natural, // Smooth curve
                markerSettings: MarkerSettings(
                  isVisible: true,
                  height: 8,
                  width: 8,
                  shape: DataMarkerType.circle,
                  color: const Color(0xFF63B5AF),
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
                              color: const Color(0xFF63B5AF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '\$${data.y.toStringAsFixed(0)}',
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
          if (highlightedPoint.x != '')
            Positioned(
              left: _getPointXPosition(highlightedPoint.x, chartData, context),
              top:
                  _getPointYPosition(highlightedPoint.y, chartData, context) -
                  50, // Adjust position
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF63B5AF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '\$${highlightedPoint.y.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper to approximate X position for custom tooltip
  double _getPointXPosition(
    String xValue,
    List<ChartData> data,
    BuildContext context,
  ) {
    final index = data.indexWhere((element) => element.x == xValue);
    if (index == -1) return 0;

    final chartWidth =
        MediaQuery.of(context).size.width - 32; // Subtract padding
    final segmentWidth = chartWidth / (data.length - 1);
    return (index * segmentWidth) +
        16 -
        20; // Adjust for padding and tooltip width
  }

  // Helper to approximate Y position for custom tooltip
  double _getPointYPosition(
    double yValue,
    List<ChartData> data,
    BuildContext context,
  ) {
    final maxVal = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final minVal = data.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final chartHeight = 250.0; // Chart height
    final yAxisRange = maxVal - minVal;
    if (yAxisRange == 0) return chartHeight / 2; // Avoid division by zero

    final normalizedY = (yValue - minVal) / yAxisRange;
    return chartHeight -
        (normalizedY * chartHeight); // Invert for screen coordinates
  }
}
