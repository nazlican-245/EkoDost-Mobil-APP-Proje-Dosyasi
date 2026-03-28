import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrendProjectionWidget extends StatefulWidget {
  const TrendProjectionWidget({super.key});

  @override
  State<TrendProjectionWidget> createState() => _TrendProjectionWidgetState();
}

class _TrendProjectionWidgetState extends State<TrendProjectionWidget> {
  int _selectedRange = 1; // 0=haftalık, 1=aylık, 2=yıllık

  final List<Map<String, dynamic>> _ranges = [
    {'label': 'Haftalık', 'days': 7},
    {'label': 'Aylık', 'days': 30},
    {'label': 'Yıllık', 'days': 365},
  ];

  List<FlSpot> _getActualSpots() {
    return [
      const FlSpot(0, 12.5),
      const FlSpot(1, 14.2),
      const FlSpot(2, 11.8),
      const FlSpot(3, 15.6),
      const FlSpot(4, 13.1),
      const FlSpot(5, 16.4),
      const FlSpot(6, 14.9),
    ];
  }

  List<FlSpot> _getPredictedSpots() {
    return [
      const FlSpot(6, 14.9),
      const FlSpot(7, 15.8),
      const FlSpot(8, 17.2),
      const FlSpot(9, 16.5),
      const FlSpot(10, 18.1),
      const FlSpot(11, 19.3),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2C3E50), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'trending_up',
                color: const Color(0xFF00D4AA),
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Tüketim Trend Projeksiyonu',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: List.generate(_ranges.length, (i) {
              final selected = _selectedRange == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedRange = i),
                child: Container(
                  margin: EdgeInsets.only(right: 2.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 0.6.h,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF00D4AA).withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF00D4AA)
                          : const Color(0xFF2C3E50),
                    ),
                  ),
                  child: Text(
                    _ranges[i]['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      color: selected
                          ? const Color(0xFF00D4AA)
                          : const Color(0xFFB0BEC5),
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 22.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: const Color(0xFF2C3E50), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}',
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          color: const Color(0xFFB0BEC5),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final labels = [
                          'Pzt',
                          'Sal',
                          'Çar',
                          'Per',
                          'Cum',
                          'Cmt',
                          'Paz',
                          'T+1',
                          'T+2',
                          'T+3',
                          'T+4',
                          'T+5',
                        ];
                        final idx = v.toInt();
                        return idx >= 0 && idx < labels.length
                            ? Text(
                                labels[idx],
                                style: GoogleFonts.inter(
                                  fontSize: 7.sp,
                                  color: const Color(0xFFB0BEC5),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getActualSpots(),
                    isCurved: true,
                    color: const Color(0xFF00D4AA),
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF00D4AA).withValues(alpha: 0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: _getPredictedSpots(),
                    isCurved: true,
                    color: const Color(0xFFFF8C00),
                    barWidth: 2.5,
                    dashArray: [6, 4],
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFFF8C00).withValues(alpha: 0.08),
                    ),
                  ),
                ],
                minY: 8,
                maxY: 22,
              ),
            ),
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              _legendItem(const Color(0xFF00D4AA), 'Gerçek Tüketim'),
              SizedBox(width: 4.w),
              _legendItem(const Color(0xFFFF8C00), 'Tahmin (AI)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 3,
          color: color,
          margin: const EdgeInsets.only(right: 6),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9.sp,
            color: const Color(0xFFB0BEC5),
          ),
        ),
      ],
    );
  }
}
