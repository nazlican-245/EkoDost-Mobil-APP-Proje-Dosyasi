import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class Co2ImpactWidget extends StatelessWidget {
  final double co2Impact;
  final double percentage;

  const Co2ImpactWidget({
    super.key,
    required this.co2Impact,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
          Text(
            'CO₂ ETKİSİ',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondary,
              letterSpacing: 1.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Center(
            child: SizedBox(
              width: 15.w,
              height: 15.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: percentage.clamp(0.0, 1.0),
                    backgroundColor: AppTheme.dividerSubtle,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.successIndicator,
                    ),
                    strokeWidth: 5,
                  ),
                  Text(
                    '${(percentage * 100).toInt()}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 0.5.h),
          Center(
            child: Text(
              '${co2Impact.toStringAsFixed(2)} kg',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Center(
            child: Text(
              'Bugün CO₂',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
