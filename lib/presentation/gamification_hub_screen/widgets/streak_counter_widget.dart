import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StreakCounterWidget extends StatefulWidget {
  final int streakDays;
  final bool gamificationEnabled;

  const StreakCounterWidget({
    super.key,
    required this.streakDays,
    this.gamificationEnabled = true,
  });

  @override
  State<StreakCounterWidget> createState() => _StreakCounterWidgetState();
}

class _StreakCounterWidgetState extends State<StreakCounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.gamificationEnabled) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.warningAlert.withValues(alpha: 0.15),
            AppTheme.surfaceCard,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.warningAlert.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Text(
              "🔥",
              style: TextStyle(fontSize: 14.sp > 32 ? 32 : 14.sp),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.streakDays} Günlük Seri!",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.warningAlert,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Harika gidiyorsun! Seriyi kırma.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
            decoration: BoxDecoration(
              color: AppTheme.warningAlert.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  color: AppTheme.warningAlert,
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Text(
                  "En iyi: 18",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.warningAlert,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
