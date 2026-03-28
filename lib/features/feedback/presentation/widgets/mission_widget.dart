import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/calculations.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/custom_icon_widget.dart';

/// MissionWidget — displays the user's environmental impact as a "mission".
///
/// Shows:
///   • CO₂ saved (kg) derived from [savedKWh] using [CO2_FACTOR]
///   • Tree equivalence derived using [TREE_ABSORPTION] (animated count)
///   • A motivational mission title and progress bar
///   • Optional mission badge when [missionCompleted] is true
///
/// Guard: pass [gamificationEnabled] = false to render nothing (SizedBox.shrink).
///
/// Props:
///   [savedKWh]            — kWh saved vs. baseline in the current period
///   [baselineKWh]         — baseline consumption for the period (used for %)
///   [periodDays]          — number of days in the period (default 30)
///   [missionTitle]        — short mission label shown in the header
///   [missionCompleted]    — true when the mission target has been reached
///   [gamificationEnabled] — research group flag; false = hide widget
class MissionWidget extends StatefulWidget {
  /// kWh saved compared to baseline in the current period.
  final double savedKWh;

  /// Baseline kWh for the period (used to compute progress %).
  final double baselineKWh;

  /// Number of days in the measurement period (used for tree calculation).
  final int periodDays;

  /// Short mission label shown in the card header.
  final String missionTitle;

  /// True when the mission target has been reached.
  final bool missionCompleted;

  /// Research group flag. When false the widget renders SizedBox.shrink().
  final bool gamificationEnabled;

  const MissionWidget({
    super.key,
    required this.savedKWh,
    required this.baselineKWh,
    required this.periodDays,
    required this.missionTitle,
    required this.missionCompleted,
    required this.gamificationEnabled,
  });

  @override
  State<MissionWidget> createState() => _MissionWidgetState();
}

class _MissionWidgetState extends State<MissionWidget>
    with SingleTickerProviderStateMixin {
  // Animated tree count — counts up from 0 to the computed value.
  late AnimationController _treeController;
  late Animation<double> _treeAnimation;

  @override
  void initState() {
    super.initState();
    _treeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _treeAnimation = Tween<double>(begin: 0, end: _computedTrees).animate(
      CurvedAnimation(parent: _treeController, curve: Curves.easeOutCubic),
    );

    // Start the count-up after a short entrance delay.
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _treeController.forward();
    });
  }

  @override
  void didUpdateWidget(MissionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.savedKWh != widget.savedKWh ||
        oldWidget.periodDays != widget.periodDays) {
      _treeAnimation = Tween<double>(begin: 0, end: _computedTrees).animate(
        CurvedAnimation(parent: _treeController, curve: Curves.easeOutCubic),
      );
      _treeController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _treeController.dispose();
    super.dispose();
  }

  // ── Derived values (use calculations.dart — never hardcode) ───────────────

  /// CO₂ saved in kg using CO2_FACTOR from calculations.dart.
  double get _co2SavedKg => co2Saved(widget.savedKWh.clamp(0, double.infinity));

  /// Tree equivalence using TREE_ABSORPTION from calculations.dart.
  double get _computedTrees =>
      treesEquivalent(_co2SavedKg, days: widget.periodDays.clamp(1, 365));

  /// Progress 0–1 clamped; 0 when baseline is zero.
  double get _progress {
    if (widget.baselineKWh <= 0) return 0.0;
    return (widget.savedKWh / widget.baselineKWh).clamp(0.0, 1.0);
  }

  /// Progress percentage label.
  String get _progressLabel => '%${(_progress * 100).toStringAsFixed(0)}';

  // ── Colors ────────────────────────────────────────────────────────────────

  Color get _accentColor {
    if (widget.missionCompleted) return AppTheme.gamificationHighlight;
    if (_progress >= 0.75) return AppTheme.successIndicator;
    if (_progress >= 0.40) return AppTheme.primaryAccent;
    return AppTheme.warningAlert;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // gamificationEnabled guard — hides widget for control group
    if (!widget.gamificationEnabled) return const SizedBox.shrink();

    return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: _accentColor.withValues(alpha: 0.30)),
            boxShadow: [
              BoxShadow(
                color: _accentColor.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──────────────────────────────────────────────────────
              _buildHeader(),

              SizedBox(height: 2.h),

              // ── CO₂ + Tree stats row ─────────────────────────────────────────
              _buildStatsRow(),

              SizedBox(height: 2.h),

              // ── Progress bar ─────────────────────────────────────────────────
              _buildProgressSection(),

              // ── Completed badge ──────────────────────────────────────────────
              if (widget.missionCompleted) ...[
                SizedBox(height: 1.5.h),
                _buildCompletedBadge(),
              ],
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(
          begin: 0.15,
          end: 0.0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }

  // ── Sub-builders ──────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: _accentColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: CustomIconWidget(
            iconName: 'eco',
            color: _accentColor,
            size: 20,
          ),
        ),
        SizedBox(width: 2.5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Çevre Misyonu',
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                widget.missionTitle,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        // Progress % chip
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.4.h),
          decoration: BoxDecoration(
            color: _accentColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            _progressLabel,
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: _accentColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        // CO₂ saved stat
        Expanded(
          child: _StatCard(
            icon: 'cloud_off',
            iconColor: AppTheme.primaryAccent,
            value: _co2SavedKg.toStringAsFixed(2),
            unit: 'kg CO₂',
            label: 'Tasarruf',
          ),
        ),
        SizedBox(width: 3.w),
        // Tree equivalence stat (animated)
        Expanded(
          child: AnimatedBuilder(
            animation: _treeAnimation,
            builder: (context, _) {
              return _StatCard(
                icon: 'park',
                iconColor: AppTheme.successIndicator,
                value: _treeAnimation.value.toStringAsFixed(1),
                unit: 'ağaç',
                label: 'Eşdeğer',
                animating: _treeController.isAnimating,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Misyon İlerlemesi',
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              '${widget.savedKWh.toStringAsFixed(1)} / ${widget.baselineKWh.toStringAsFixed(1)} kWh',
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.8.h),
        // Animated progress bar via flutter_animate
        ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Stack(
            children: [
              // Track
              Container(
                height: 8,
                width: double.infinity,
                color: AppTheme.dividerSubtle,
              ),
              // Fill
              FractionallySizedBox(
                widthFactor: _progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _accentColor.withValues(alpha: 0.70),
                        _accentColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
              ).animate().scaleX(
                begin: 0.0,
                end: 1.0,
                duration: 900.ms,
                delay: 300.ms,
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedBadge() {
    return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.gamificationHighlight.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: AppTheme.gamificationHighlight.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.gamificationHighlight,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'Misyon Tamamlandı! 🌍',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.gamificationHighlight,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: 400.ms)
        .scaleXY(
          begin: 0.90,
          end: 1.0,
          delay: 200.ms,
          duration: 400.ms,
          curve: Curves.easeOutBack,
        );
  }
}

// ── Internal stat card ─────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String value;
  final String unit;
  final String label;
  final bool animating;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.unit,
    required this.label,
    this.animating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppTheme.dividerSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CustomIconWidget(iconName: icon, color: iconColor, size: 14),
              SizedBox(width: 1.5.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 8.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: iconColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 1.w),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  unit,
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
