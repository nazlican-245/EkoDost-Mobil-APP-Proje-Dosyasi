import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../theme/app_theme.dart';

/// StreakFlame — gamification widget displaying the user's current streak.
///
/// Three visual states:
///   • active  (streakBroken=false, streakFreeze=false) → orange flame, pulse animation
///   • frozen  (streakFreeze=true)                      → blue flame, slow pulse
///   • broken  (streakBroken=true)                      → grey flame, no animation
///
/// Guard: pass [gamificationEnabled] = false to render nothing (SizedBox.shrink).
///
/// Props:
///   [streakDays]          — current streak day count
///   [streakBroken]        — true when streak was broken today
///   [streakFreeze]        — true when a shield was used today
///   [gamificationEnabled] — research group flag; false = hide widget
class StreakFlame extends StatelessWidget {
  /// Current streak day count shown below the flame icon.
  final int streakDays;

  /// True when the streak was broken today (no shield used).
  final bool streakBroken;

  /// True when a streak shield was applied today.
  final bool streakFreeze;

  /// Research group flag. When false the widget renders SizedBox.shrink().
  final bool gamificationEnabled;

  const StreakFlame({
    super.key,
    required this.streakDays,
    required this.streakBroken,
    required this.streakFreeze,
    required this.gamificationEnabled,
  });

  // ── State resolution ────────────────────────────────────────────────────

  _FlameState get _state {
    if (streakBroken) return _FlameState.broken;
    if (streakFreeze) return _FlameState.frozen;
    return _FlameState.active;
  }

  Color get _flameColor {
    switch (_state) {
      case _FlameState.active:
        return Colors.orange;
      case _FlameState.frozen:
        return Colors.blue;
      case _FlameState.broken:
        return Colors.grey;
    }
  }

  Color get _glowColor {
    switch (_state) {
      case _FlameState.active:
        return Colors.orange.withValues(alpha: 0.30);
      case _FlameState.frozen:
        return Colors.blue.withValues(alpha: 0.25);
      case _FlameState.broken:
        return Colors.transparent;
    }
  }

  String get _stateLabel {
    switch (_state) {
      case _FlameState.active:
        return 'Aktif Seri';
      case _FlameState.frozen:
        return 'Seri Korundu';
      case _FlameState.broken:
        return 'Seri Bitti';
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // gamificationEnabled guard — hides all gamification UI for control group
    if (!gamificationEnabled) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: _flameColor.withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(color: _glowColor, blurRadius: 14, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Flame icon with conditional animation ─────────────────────
          _buildFlameIcon(),

          SizedBox(height: 0.8.h),

          // ── Streak day count ──────────────────────────────────────────
          Text(
            '$streakDays gün',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: _flameColor,
            ),
          ),

          SizedBox(height: 0.3.h),

          // ── State label ───────────────────────────────────────────────
          Text(
            _stateLabel,
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlameIcon() {
    final icon = Icon(
      Icons.local_fire_department_rounded,
      color: _flameColor,
      size: 7.w,
    );

    switch (_state) {
      case _FlameState.active:
        // Orange flame: repeating scale pulse (0.92 → 1.08) at 900 ms
        return icon
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scaleXY(
              begin: 0.92,
              end: 1.08,
              duration: 900.ms,
              curve: Curves.easeInOut,
            );

      case _FlameState.frozen:
        // Blue flame: slower, subtler pulse (0.95 → 1.05) at 1 400 ms
        return icon
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scaleXY(
              begin: 0.95,
              end: 1.05,
              duration: 1400.ms,
              curve: Curves.easeInOut,
            )
            .tint(color: Colors.blue.withValues(alpha: 0.20));

      case _FlameState.broken:
        // Grey flame: static, no animation
        return icon;
    }
  }
}

// ── Internal state enum ────────────────────────────────────────────────────

enum _FlameState { active, frozen, broken }
