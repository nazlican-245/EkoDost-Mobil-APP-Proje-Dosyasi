import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

class PeakHoursChartWidget extends StatelessWidget {
  const PeakHoursChartWidget({super.key});

  static const List<Map<String, dynamic>> _hourlyData = [
    {"hour": "00", "value": 1.2, "level": "low"},
    {"hour": "02", "value": 0.8, "level": "low"},
    {"hour": "04", "value": 0.6, "level": "low"},
    {"hour": "06", "value": 1.5, "level": "low"},
    {"hour": "08", "value": 3.2, "level": "medium"},
    {"hour": "10", "value": 2.8, "level": "medium"},
    {"hour": "12", "value": 3.9, "level": "medium"},
    {"hour": "14", "value": 2.5, "level": "medium"},
    {"hour": "16", "value": 3.7, "level": "medium"},
    {"hour": "18", "value": 5.4, "level": "high"},
    {"hour": "20", "value": 5.8, "level": "high"},
    {"hour": "22", "value": 4.1, "level": "high"},
  ];

  Color _colorForLevel(String level) {
    switch (level) {
      case 'high':
        return const Color(0xFFFF8C00);
      case 'medium':
        return const Color(0xFFFFD700);
      default:
        return const Color(0xFF00D4AA);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2C3E50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.h,
            child: Semantics(
              label: 'Saatlik tüketim yoğunluğu çubuk grafiği',
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 7,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: const Color(
                        0xFF0A1628,
                      ).withValues(alpha: 0.9),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                          BarTooltipItem(
                            '${rod.toY.toStringAsFixed(1)} kWh',
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
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
                        reservedSize: 20,
                        getTitlesWidget: (val, meta) {
                          final idx = val.toInt();
                          if (idx < 0 || idx >= _hourlyData.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            _hourlyData[idx]['hour'] as String,
                            style: const TextStyle(
                              color: Color(0xFFB0BEC5),
                              fontSize: 9,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: const Color(0xFF2C3E50), strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    _hourlyData.length,
                    (i) => BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: (_hourlyData[i]['value'] as num).toDouble(),
                          color: _colorForLevel(
                            _hourlyData[i]['level'] as String,
                          ),
                          width: 14,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendItem('Düşük', const Color(0xFF00D4AA)),
              SizedBox(width: 4.w),
              _legendItem('Orta', const Color(0xFFFFD700)),
              SizedBox(width: 4.w),
              _legendItem('Yüksek', const Color(0xFFFF8C00)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 11),
        ),
      ],
    );
  }
}
