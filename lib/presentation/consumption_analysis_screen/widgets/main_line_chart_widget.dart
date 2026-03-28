import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

class MainLineChartWidget extends StatefulWidget {
  final List<FlSpot> spots;
  final List<String> labels;
  final String periodLabel;

  const MainLineChartWidget({
    super.key,
    required this.spots,
    required this.labels,
    required this.periodLabel,
  });

  @override
  State<MainLineChartWidget> createState() => _MainLineChartWidgetState();
}

class _MainLineChartWidgetState extends State<MainLineChartWidget> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final maxY = widget.spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minY = widget.spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);

    return Container(
      width: double.infinity,
      height: 28.h,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2C3E50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.periodLabel} Tüketim',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4AA).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'kWh',
                  style: TextStyle(
                    color: Color(0xFF00D4AA),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: Semantics(
              label: '${widget.periodLabel} tüketim çizgi grafiği',
              child: LineChart(
                LineChartData(
                  minY: (minY - (maxY - minY) * 0.1).clamp(0, double.infinity),
                  maxY: maxY + (maxY - minY) * 0.15,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: const Color(0xFF2C3E50), strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (val, meta) => Text(
                          val.toStringAsFixed(0),
                          style: const TextStyle(
                            color: Color(0xFFB0BEC5),
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: widget.spots.length > 10
                            ? (widget.spots.length / 6).ceilToDouble()
                            : 1,
                        getTitlesWidget: (val, meta) {
                          final idx = val.toInt();
                          if (idx < 0 || idx >= widget.labels.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            widget.labels[idx],
                            style: const TextStyle(
                              color: Color(0xFFB0BEC5),
                              fontSize: 9,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: const Color(
                        0xFF0A1628,
                      ).withValues(alpha: 0.9),
                      getTooltipItems: (spots) => spots
                          .map(
                            (s) => LineTooltipItem(
                              '${s.y.toStringAsFixed(1)} kWh',
                              const TextStyle(
                                color: Color(0xFF00D4AA),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    handleBuiltInTouches: true,
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: widget.spots,
                      isCurved: true,
                      color: const Color(0xFF00D4AA),
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: widget.spots.length <= 12,
                        getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                          radius: 3,
                          color: const Color(0xFF00D4AA),
                          strokeWidth: 1.5,
                          strokeColor: const Color(0xFF0A1628),
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF00D4AA).withValues(alpha: 0.25),
                            const Color(0xFF00D4AA).withValues(alpha: 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
