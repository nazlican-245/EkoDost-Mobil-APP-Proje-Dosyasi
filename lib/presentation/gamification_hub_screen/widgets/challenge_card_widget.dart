import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChallengeCardWidget extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final bool gamificationEnabled;

  const ChallengeCardWidget({
    super.key,
    required this.challenge,
    this.gamificationEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!gamificationEnabled) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final Color cardColor = Color(challenge["color"] as int);
    final double progress = challenge["progress"] as double;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: challenge["icon"] as String,
                color: cardColor,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        challenge["title"] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.4.h,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "+${challenge["reward"]} puan",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cardColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.4.h),
                Text(
                  challenge["description"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 6,
                        percent: progress.clamp(0.0, 1.0),
                        backgroundColor: AppTheme.dividerSubtle,
                        progressColor: cardColor,
                        barRadius: const Radius.circular(3),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cardColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.4.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.textSecondary,
                      size: 12,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      challenge["deadline"] as String,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
