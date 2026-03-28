import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final bool gamificationEnabled;

  const RecentActivityWidget({
    super.key,
    required this.activities,
    this.gamificationEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!gamificationEnabled) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerSubtle),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (_, __) => Divider(
          color: AppTheme.dividerSubtle,
          height: 1,
          indent: 4.w,
          endIndent: 4.w,
        ),
        itemBuilder: (context, index) {
          final activity = activities[index];
          final Color actColor = Color(activity["color"] as int);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            child: Row(
              children: [
                Container(
                  width: 9.w,
                  height: 9.w,
                  decoration: BoxDecoration(
                    color: actColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: activity["icon"] as String,
                      color: actColor,
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity["action"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        activity["time"] as String,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  activity["points"] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.successIndicator,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
