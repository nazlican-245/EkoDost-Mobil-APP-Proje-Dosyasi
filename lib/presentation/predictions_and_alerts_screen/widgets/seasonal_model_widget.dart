import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SeasonalModelWidget extends StatelessWidget {
  const SeasonalModelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> seasonData = [
      {'month': 'Oca', 'temp': -2.0, 'consumption': 18.5},
      {'month': 'Şub', 'temp': 1.0, 'consumption': 17.2},
      {'month': 'Mar', 'temp': 8.0, 'consumption': 13.4},
      {'month': 'Nis', 'temp': 14.0, 'consumption': 10.8},
      {'month': 'May', 'temp': 20.0, 'consumption': 9.2},
      {'month': 'Haz', 'temp': 27.0, 'consumption': 14.6},
      {'month': 'Tem', 'temp': 32.0, 'consumption': 19.8},
      {'month': 'Ağu', 'temp': 31.0, 'consumption': 20.1},
      {'month': 'Eyl', 'temp': 24.0, 'consumption': 15.3},
      {'month': 'Eki', 'temp': 16.0, 'consumption': 11.7},
      {'month': 'Kas', 'temp': 8.0, 'consumption': 14.2},
      {'month': 'Ara', 'temp': 2.0, 'consumption': 17.9},
    ];

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
                iconName: 'wb_sunny',
                color: const Color(0xFFFFD700),
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Mevsimsel Tüketim Modeli',
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
          SizedBox(height: 0.5.h),
          Text(
            'Sıcaklık-tüketim korelasyonu',
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              color: const Color(0xFFB0BEC5),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 20.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 25,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
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
                        final idx = v.toInt();
                        return idx >= 0 && idx < seasonData.length
                            ? Text(
                                seasonData[idx]['month'] as String,
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
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: const Color(0xFF2C3E50), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(seasonData.length, (i) {
                  final consumption = (seasonData[i]['consumption'] as double);
                  final temp = (seasonData[i]['temp'] as double);
                  final isHot = temp > 20;
                  final isCold = temp < 5;
                  final barColor = isHot
                      ? const Color(0xFFFF8C00)
                      : isCold
                      ? const Color(0xFF8E44AD)
                      : const Color(0xFF00D4AA);
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: consumption,
                        color: barColor,
                        width: 2.w,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 1.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(const Color(0xFF8E44AD), 'Soğuk'),
              SizedBox(width: 3.w),
              _legendDot(const Color(0xFF00D4AA), 'Ilıman'),
              SizedBox(width: 3.w),
              _legendDot(const Color(0xFFFF8C00), 'Sıcak'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 8.sp,
            color: const Color(0xFFB0BEC5),
          ),
        ),
      ],
    );
  }
}
