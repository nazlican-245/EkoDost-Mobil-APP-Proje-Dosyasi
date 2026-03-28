import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgeWidget extends StatelessWidget {
  final Map<String, dynamic> badge;
  final bool gamificationEnabled;

  const AchievementBadgeWidget({
    super.key,
    required this.badge,
    this.gamificationEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!gamificationEnabled) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final bool earned = badge["earned"] as bool;
    final Color badgeColor = Color(badge["color"] as int);

    return Container(
      width: 22.w,
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: earned
            ? badgeColor.withValues(alpha: 0.12)
            : AppTheme.dividerSubtle.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: earned
              ? badgeColor.withValues(alpha: 0.4)
              : AppTheme.dividerSubtle,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: earned
                      ? badgeColor.withValues(alpha: 0.2)
                      : AppTheme.dividerSubtle,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: badge["icon"] as String,
                    color: earned
                        ? badgeColor
                        : AppTheme.textSecondary.withValues(alpha: 0.4),
                    size: 22,
                  ),
                ),
              ),
              if (!earned)
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBackground.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'lock',
                      color: AppTheme.textSecondary,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 0.8.h),
          Text(
            badge["name"] as String,
            style: theme.textTheme.labelSmall?.copyWith(
              color: earned ? AppTheme.textPrimary : AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
