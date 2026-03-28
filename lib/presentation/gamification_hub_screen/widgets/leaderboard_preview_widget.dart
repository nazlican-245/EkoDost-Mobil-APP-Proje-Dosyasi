import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LeaderboardPreviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard;
  final VoidCallback onViewAll;
  final bool gamificationEnabled;

  const LeaderboardPreviewWidget({
    super.key,
    required this.leaderboard,
    required this.onViewAll,
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
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leaderboard.length,
            separatorBuilder: (_, __) => Divider(
              color: AppTheme.dividerSubtle,
              height: 1,
              indent: 4.w,
              endIndent: 4.w,
            ),
            itemBuilder: (context, index) {
              final entry = leaderboard[index];
              final bool isCurrentUser = entry["isCurrentUser"] as bool;
              final int rank = entry["rank"] as int;

              Color rankColor = AppTheme.textSecondary;
              if (rank == 1) rankColor = AppTheme.gamificationHighlight;
              if (rank == 2) rankColor = const Color(0xFFC0C0C0);
              if (rank == 3) rankColor = const Color(0xFFCD7F32);

              return Container(
                color: isCurrentUser
                    ? AppTheme.primaryAccent.withValues(alpha: 0.08)
                    : Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 8.w,
                      child: Text(
                        rank <= 3 ? _getRankEmoji(rank) : "#$rank",
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: rankColor,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    ClipOval(
                      child: CustomImageWidget(
                        imageUrl: entry["avatar"] as String,
                        width: 9.w,
                        height: 9.w,
                        fit: BoxFit.cover,
                        semanticLabel: entry["semanticLabel"] as String,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        entry["name"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isCurrentUser
                              ? AppTheme.primaryAccent
                              : AppTheme.textPrimary,
                          fontWeight: isCurrentUser
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "${entry["points"]} puan",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isCurrentUser
                            ? AppTheme.primaryAccent
                            : AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(color: AppTheme.dividerSubtle, height: 1),
          TextButton(
            onPressed: onViewAll,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tam Listeyi Gör",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryAccent,
                  ),
                ),
                SizedBox(width: 1.w),
                CustomIconWidget(
                  iconName: 'arrow_forward',
                  color: AppTheme.primaryAccent,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return "🥇";
      case 2:
        return "🥈";
      case 3:
        return "🥉";
      default:
        return "#$rank";
    }
  }
}
