import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class PeakHourCardWidget extends StatelessWidget {
  const PeakHourCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<BarChartGroupData> barGroups = [
      _buildBar(0, 1.2, false),
      _buildBar(1, 0.8, false),
      _buildBar(2, 0.6, false),
      _buildBar(3, 0.5, false),
      _buildBar(4, 0.7, false),
      _buildBar(5, 1.1, false),
      _buildBar(6, 2.3, false),
      _buildBar(7, 3.8, false),
      _buildBar(8, 4.2, true),
      _buildBar(9, 3.9, true),
      _buildBar(10, 3.1, false),
      _buildBar(11, 2.8, false),
    ];

    final List<String> hours = [
      '00',
      '02',
      '04',
      '06',
      '08',
      '10',
      '12',
      '14',
      '16',
      '18',
      '20',
      '22',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerSubtle),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YOĞUN SAAT GÖSTERGESİ',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                decoration: BoxDecoration(
                  color: AppTheme.warningAlert.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '08:00 - 10:00 Yoğun',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.warningAlert,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Semantics(
            label: 'Saatlik elektrik tüketim grafiği',
            child: SizedBox(
              height: 18.h,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 5.0,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= hours.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            hours[idx],
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.textSecondary,
                              fontSize: 8,
                            ),
                          );
                        },
                        reservedSize: 20,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 2 != 0) return const SizedBox.shrink();
                          return Text(
                            '${value.toInt()}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.textSecondary,
                              fontSize: 8,
                            ),
                          );
                        },
                        reservedSize: 20,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: AppTheme.dividerSubtle.withValues(alpha: 0.5),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              _buildLegend(AppTheme.primaryAccent, 'Normal'),
              SizedBox(width: 4.w),
              _buildLegend(AppTheme.warningAlert, 'Yoğun Saat'),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBar(int x, double y, bool isPeak) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isPeak ? AppTheme.warningAlert : AppTheme.primaryAccent,
          width: 8,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}
