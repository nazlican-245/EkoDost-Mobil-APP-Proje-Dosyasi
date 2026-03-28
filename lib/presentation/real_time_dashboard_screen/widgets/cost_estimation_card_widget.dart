import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CostEstimationCardWidget extends StatelessWidget {
  final double estimatedCost;
  final bool isIncreasing;

  const CostEstimationCardWidget({
    super.key,
    required this.estimatedCost,
    required this.isIncreasing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trendColor = isIncreasing
        ? const Color(0xFFE53935)
        : AppTheme.successIndicator;

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
            'TAHMİNİ MALİYET',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondary,
              letterSpacing: 1.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '₺${estimatedCost.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomIconWidget(
                iconName: isIncreasing ? 'trending_up' : 'trending_down',
                color: trendColor,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            isIncreasing ? '+%8 geçen ay' : '-%5 geçen ay',
            style: theme.textTheme.bodySmall?.copyWith(color: trendColor),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Bu ay tahmini',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
