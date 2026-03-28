import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../theme/app_theme.dart';
import '../../../../widgets/custom_icon_widget.dart';

/// StreakBrokenModal — displays a bottom sheet when the user's streak is broken.
///
/// Guard: pass [gamificationEnabled] = false to skip showing the modal entirely.
///
/// Props:
///   [streakShield]        — number of shields remaining (≥1 shows shield button)
///   [onUseShield]         — called when user confirms shield use;
///                           caller is responsible for POST /streak/shield
///   [onDismiss]           — called when user dismisses without using a shield
///   [gamificationEnabled] — research group flag; false = do not show modal
///
/// Usage:
///   StreakBrokenModal.show(
///     context,
///     streakShield: model.streakShield,
///     gamificationEnabled: research.gamificationEnabled,
///     onUseShield: () async {
///       await ref.read(gamificationRepositoryProvider).useStreakShield();
///       ref.invalidate(gamificationProvider);
///     },
///     onDismiss: () {},
///   );
class StreakBrokenModal extends StatelessWidget {
  /// Remaining streak shields. If > 0 the "Kalkanı Kullan" button is shown.
  final int streakShield;

  /// Invoked when the user taps "Kalkanı Kullan". Caller must POST /streak/shield.
  final VoidCallback onUseShield;

  /// Invoked when the user dismisses the modal without using a shield.
  final VoidCallback onDismiss;

  const StreakBrokenModal._({
    required this.streakShield,
    required this.onUseShield,
    required this.onDismiss,
  });

  // ── Static show helper ───────────────────────────────────────────────────

  /// Shows the modal bottom sheet.
  ///
  /// Returns immediately (no-op) when [gamificationEnabled] is false.
  static Future<void> show(
    BuildContext context, {
    required int streakShield,
    required bool gamificationEnabled,
    required VoidCallback onUseShield,
    required VoidCallback onDismiss,
  }) async {
    // gamificationEnabled guard — never show for control group
    if (!gamificationEnabled) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StreakBrokenModal._(
        streakShield: streakShield,
        onUseShield: () {
          Navigator.of(ctx).pop();
          onUseShield();
        },
        onDismiss: () {
          Navigator.of(ctx).pop();
          onDismiss();
        },
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool hasShield = streakShield > 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 4.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ─────────────────────────────────────────────────
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.dividerSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 2.5.h),

          // ── Broken flame icon ────────────────────────────────────────────
          Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.40),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'local_fire_department',
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .scaleXY(
                begin: 0.7,
                end: 1.0,
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ),

          SizedBox(height: 2.h),

          // ── Title ────────────────────────────────────────────────────────
          Text(
                'Serin Sıfırlandı 😔',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(delay: 150.ms, duration: 350.ms)
              .slideY(begin: 0.2, end: 0.0, duration: 350.ms),

          SizedBox(height: 1.h),

          // ── Subtitle / motivational text ─────────────────────────────────
          Text(
            hasShield
                ? 'Bugün hedefe ulaşamadın, ama bir kalkanın var!\nKalkanını kullanarak serini koru.'
                : 'Bugün hedefe ulaşamadın. Ama her yeni gün\nyeni bir başlangıçtır. Yeniden başla! 💪',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 250.ms, duration: 350.ms),

          SizedBox(height: 2.5.h),

          // ── Shield info chip (only when shield available) ─────────────────
          if (hasShield) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'shield',
                    color: Colors.blue,
                    size: 16,
                  ),
                  SizedBox(width: 1.5.w),
                  Text(
                    '$streakShield kalkan mevcut',
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 350.ms, duration: 300.ms),

            SizedBox(height: 2.h),
          ],

          // ── Primary action: Use Shield ────────────────────────────────────
          if (hasShield)
            SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onUseShield,
                    icon: CustomIconWidget(
                      iconName: 'shield',
                      color: AppTheme.primaryBackground,
                      size: 18,
                    ),
                    label: Text(
                      'Kalkanı Kullan',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: AppTheme.textPrimary,
                      padding: EdgeInsets.symmetric(vertical: 1.6.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 300.ms)
                .slideY(begin: 0.3, end: 0.0, duration: 300.ms),

          if (hasShield) SizedBox(height: 1.2.h),

          // ── Secondary action: Dismiss ─────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onDismiss,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                padding: EdgeInsets.symmetric(vertical: 1.6.h),
                side: BorderSide(color: AppTheme.dividerSubtle, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                hasShield ? 'Şimdi Değil' : 'Tamam, Anladım',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ).animate().fadeIn(
            delay: hasShield ? 480.ms : 400.ms,
            duration: 300.ms,
          ),
        ],
      ),
    );
  }
}
