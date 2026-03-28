import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onDeviceCheck;
  final VoidCallback onSetGoal;
  final VoidCallback onAlertSettings;

  const QuickActionsWidget({
    super.key,
    required this.onDeviceCheck,
    required this.onSetGoal,
    required this.onAlertSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actions = [
      {
        "label": "Cihazları\nKontrol Et",
        "icon": "devices",
        "color": AppTheme.primaryAccent,
        "onTap": onDeviceCheck,
      },
      {
        "label": "Hedef\nBelirle",
        "icon": "flag",
        "color": AppTheme.gamificationHighlight,
        "onTap": onSetGoal,
      },
      {
        "label": "Uyarı\nAyarları",
        "icon": "notifications_active",
        "color": AppTheme.warningAlert,
        "onTap": onAlertSettings,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HIZLI İŞLEMLER',
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppTheme.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: actions.map((action) {
            final color = action["color"] as Color;
            return Expanded(
              child: GestureDetector(
                onTap: action["onTap"] as VoidCallback,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.5.w),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: action["icon"] as String,
                          color: color,
                          size: 20,
                        ),
                      ),
                      SizedBox(height: 0.8.h),
                      Text(
                        action["label"] as String,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
