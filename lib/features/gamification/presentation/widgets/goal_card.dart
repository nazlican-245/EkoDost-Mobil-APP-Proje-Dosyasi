import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/widgets/goal_progress_bar.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/custom_icon_widget.dart';

/// GoalCard — dashboard widget showing the active energy goal.
///
/// Guard: caller must check gamificationEnabled before rendering.
/// If gamificationEnabled is false, return SizedBox.shrink() at the call site.
///
/// Shows:
///   • GoalProgressBar (progress, goalKWh, currentKWh, deadline)
///   • Prediction probability chip (goalAchieveProbability)
///   • "Hedef Kur" CTA when goalStatus is pending / no active goal
class GoalCard extends StatelessWidget {
  /// Target kWh for the goal period.
  final double goalKWh;

  /// Current kWh consumed in the goal period.
  final double currentKWh;

  /// Progress 0–100 (100 = goal achieved).
  final double goalProgress;

  /// Goal deadline.
  final DateTime goalDeadline;

  /// Goal status: 'active' | 'achieved' | 'failed' | 'pending'
  final String goalStatus;

  /// Goal period label: 'daily' | 'weekly' | 'monthly'
  final String goalPeriod;

  /// Probability 0–1 that the goal will be achieved (from prediction model).
  final double goalAchieveProbability;

  /// Whether gamification is enabled for this research group.
  /// When false the widget renders nothing (SizedBox.shrink).
  final bool gamificationEnabled;

  /// Called when the user taps "Hedef Kur" CTA.
  final VoidCallback? onSetupGoal;

  const GoalCard({
    super.key,
    required this.goalKWh,
    required this.currentKWh,
    required this.goalProgress,
    required this.goalDeadline,
    required this.goalStatus,
    required this.goalPeriod,
    required this.goalAchieveProbability,
    required this.gamificationEnabled,
    this.onSetupGoal,
  });

  // ── Helpers ──────────────────────────────────────────────────────────────

  String get _periodLabel {
    switch (goalPeriod) {
      case 'daily':
        return 'Günlük';
      case 'weekly':
        return 'Haftalık';
      case 'monthly':
        return 'Aylık';
      default:
        return goalPeriod;
    }
  }

  String get _statusLabel {
    switch (goalStatus) {
      case 'achieved':
        return 'Tamamlandı 🎯';
      case 'failed':
        return 'Başarısız';
      case 'active':
        return 'Aktif';
      case 'pending':
        return 'Hedef Yok';
      default:
        return '';
    }
  }

  Color _statusColor() {
    switch (goalStatus) {
      case 'achieved':
        return AppTheme.successIndicator;
      case 'failed':
        return const Color(0xFFE53935);
      case 'active':
        return AppTheme.primaryAccent;
      case 'pending':
      default:
        return AppTheme.textSecondary;
    }
  }

  /// Probability chip color: green ≥70%, amber ≥40%, red <40%
  Color _probabilityColor() {
    if (goalAchieveProbability >= 0.70) return AppTheme.successIndicator;
    if (goalAchieveProbability >= 0.40) return AppTheme.warningAlert;
    return const Color(0xFFE53935);
  }

  bool get _hasActiveGoal => goalStatus == 'active' || goalStatus == 'achieved';

  @override
  Widget build(BuildContext context) {
    // ── gamificationEnabled guard ─────────────────────────────────────────
    if (!gamificationEnabled) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppTheme.primaryAccent.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header row ─────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CustomIconWidget(
                      iconName: 'track_changes',
                      color: AppTheme.primaryAccent,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enerji Hedefi',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        _periodLabel,
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Status chip
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.5.w,
                  vertical: 0.4.h,
                ),
                decoration: BoxDecoration(
                  color: _statusColor().withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  _statusLabel,
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // ── Active goal content ─────────────────────────────────────────
          if (_hasActiveGoal) ...[
            GoalProgressBar(
              progress: goalProgress,
              goalKWh: goalKWh,
              currentKWh: currentKWh,
              deadline: goalDeadline,
            ),

            SizedBox(height: 1.5.h),

            // Prediction probability chip
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'auto_graph',
                  color: _probabilityColor(),
                  size: 14,
                ),
                SizedBox(width: 1.5.w),
                Text(
                  'Başarı Tahmini:',
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(width: 1.5.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.3.h,
                  ),
                  decoration: BoxDecoration(
                    color: _probabilityColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    '%${(goalAchieveProbability * 100).toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: _probabilityColor(),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // ── No active goal — CTA ────────────────────────────────────────
          if (!_hasActiveGoal) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.textSecondary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Henüz aktif bir enerji hedefiniz yok.',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSetupGoal,
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: Text(
                  'Hedef Kur',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryAccent,
                  foregroundColor: AppTheme.primaryBackground,
                  padding: EdgeInsets.symmetric(vertical: 1.2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
