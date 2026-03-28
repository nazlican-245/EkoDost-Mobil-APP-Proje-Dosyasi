import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HeroPointsWidget extends StatefulWidget {
  final int totalPoints;
  final bool isLoading;
  final bool gamificationEnabled;

  const HeroPointsWidget({
    super.key,
    required this.totalPoints,
    this.isLoading = false,
    this.gamificationEnabled = true,
  });

  @override
  State<HeroPointsWidget> createState() => _HeroPointsWidgetState();
}

class _HeroPointsWidgetState extends State<HeroPointsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
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
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryAccent.withValues(alpha: 0.2),
            AppTheme.primaryBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryAccent.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryAccent.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Toplam Puanın",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 0.5.h),
                widget.isLoading
                    ? Container(
                        width: 30.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: AppTheme.dividerSubtle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                    : ScaleTransition(
                        scale: _scaleAnimation,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.totalPoints.toString(),
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: AppTheme.primaryAccent,
                                fontWeight: FontWeight.w800,
                                fontSize: 36.sp > 48 ? 48 : 36.sp,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Padding(
                              padding: EdgeInsets.only(bottom: 0.5.h),
                              child: Text(
                                "puan",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'trending_up',
                      color: AppTheme.successIndicator,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "+425 bu hafta",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successIndicator,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              color: AppTheme.gamificationHighlight.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.gamificationHighlight.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                "🪙",
                style: TextStyle(fontSize: 14.sp > 28 ? 28 : 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
