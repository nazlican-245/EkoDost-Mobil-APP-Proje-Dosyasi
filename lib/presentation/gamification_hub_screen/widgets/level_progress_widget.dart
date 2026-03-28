import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LevelProgressWidget extends StatelessWidget {
  final int currentLevel;
  final int currentXP;
  final int nextLevelXP;
  final bool gamificationEnabled;

  const LevelProgressWidget({
    super.key,
    required this.currentLevel,
    required this.currentXP,
    required this.nextLevelXP,
    this.gamificationEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!gamificationEnabled) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final double progress = currentXP / nextLevelXP;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.warningAlert,
                          AppTheme.gamificationHighlight,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "$currentLevel",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryBackground,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Seviye $currentLevel",
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Enerji Ustası",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.warningAlert,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$currentXP / $nextLevelXP XP",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    "Sonraki: Seviye ${currentLevel + 1}",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.primaryAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          LinearPercentIndicator(
            width: double.infinity - 8.w,
            lineHeight: 10,
            percent: progress.clamp(0.0, 1.0),
            backgroundColor: AppTheme.dividerSubtle,
            linearGradient: LinearGradient(
              colors: [AppTheme.warningAlert, AppTheme.gamificationHighlight],
            ),
            barRadius: const Radius.circular(5),
            padding: EdgeInsets.zero,
          ),
          SizedBox(height: 0.8.h),
          Text(
            "${nextLevelXP - currentXP} XP daha kazan → Seviye ${currentLevel + 1} aç",
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
