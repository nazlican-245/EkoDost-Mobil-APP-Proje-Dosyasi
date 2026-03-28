import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';

/// Reusable GoalProgressBar widget.
///
/// Shows an animated linear fill bar, percentage label,
/// kWh remaining to goal, and a deadline countdown.
///
/// Used inside GoalCard and GoalSetupScreen.
class GoalProgressBar extends StatelessWidget {
  /// Progress value from 0 to 100 (100 = goal achieved).
  final double progress;

  /// Target kWh for the goal period.
  final double goalKWh;

  /// Current kWh consumed in the goal period.
  final double currentKWh;

  /// Deadline for the goal.
  final DateTime deadline;

  const GoalProgressBar({
    super.key,
    required this.progress,
    required this.goalKWh,
    required this.currentKWh,
    required this.deadline,
  });

  // Clamp progress to [0, 100]
  double get _clampedProgress => progress.clamp(0.0, 100.0);

  // kWh remaining (can be 0 if goal achieved)
  double get _kWhRemaining =>
      (goalKWh - currentKWh).clamp(0.0, double.infinity);

  // Whether the goal has been achieved
  bool get _isAchieved => _clampedProgress >= 100.0;

  // Deadline countdown string
  String get _deadlineLabel {
    final now = DateTime.now();
    final diff = deadline.difference(now);

    if (diff.isNegative) return 'Süre doldu';

    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;

    if (days > 0) return '$days gün ${hours}s kaldı';
    if (hours > 0) return '${hours}s ${minutes}dk kaldı';
    return '${minutes}dk kaldı';
  }

  // Progress bar color based on progress level
  Color _barColor(BuildContext context) {
    if (_isAchieved) return AppTheme.successIndicator;
    if (_clampedProgress >= 75) return AppTheme.primaryAccent;
    if (_clampedProgress >= 40) return AppTheme.warningAlert;
    return const Color(0xFFE53935); // red — lagging behind
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = _barColor(context);
    final fraction = _clampedProgress / 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Top row: % label + kWh remaining ──────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Percentage label
            Row(
              children: [
                Text(
                  '${_clampedProgress.toStringAsFixed(0)}%',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: barColor,
                  ),
                ),
                SizedBox(width: 1.5.w),
                if (_isAchieved)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successIndicator.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      'Hedef Tamamlandı 🎯',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successIndicator,
                      ),
                    ),
                  ),
              ],
            ),
            // kWh remaining
            Text(
              _isAchieved
                  ? '${goalKWh.toStringAsFixed(1)} kWh hedef'
                  : '${_kWhRemaining.toStringAsFixed(1)} kWh kaldı',
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        // ── Animated progress bar ──────────────────────────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              // Background track
              Container(
                height: 1.2.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.dividerSubtle,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              // Animated fill
              FractionallySizedBox(
                widthFactor: fraction,
                child:
                    Container(
                          height: 1.2.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                barColor.withValues(alpha: 0.8),
                                barColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        )
                        .animate()
                        .scaleX(
                          begin: 0.0,
                          end: 1.0,
                          duration: 900.ms,
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.centerLeft,
                        )
                        .fadeIn(duration: 400.ms),
              ),
            ],
          ),
        ),

        SizedBox(height: 0.8.h),

        // ── Bottom row: goal kWh + deadline countdown ──────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Goal target
            Row(
              children: [
                Icon(
                  Icons.bolt_rounded,
                  size: 12.sp,
                  color: AppTheme.primaryAccent,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Hedef: ${goalKWh.toStringAsFixed(1)} kWh',
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            // Deadline countdown
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 12.sp,
                  color: deadline.difference(DateTime.now()).isNegative
                      ? AppTheme.warningAlert
                      : AppTheme.textSecondary,
                ),
                SizedBox(width: 1.w),
                Text(
                  _deadlineLabel,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    color: deadline.difference(DateTime.now()).isNegative
                        ? AppTheme.warningAlert
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
