import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodaySummaryCardWidget extends StatelessWidget {
  const TodaySummaryCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> summaryItems = [
      {
        "label": "Bugünkü Tüketim",
        "value": "18.4 kWh",
        "icon": "electric_bolt",
        "color": AppTheme.primaryAccent,
      },
      {
        "label": "Dünden Fark",
        "value": "+2.1 kWh",
        "icon": "compare_arrows",
        "color": AppTheme.warningAlert,
      },
      {
        "label": "Haftalık Ort.",
        "value": "16.8 kWh",
        "icon": "bar_chart",
        "color": AppTheme.researchModule,
      },
      {
        "label": "Bugünkü Maliyet",
        "value": "₺66,24",
        "icon": "payments",
        "color": AppTheme.gamificationHighlight,
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerSubtle),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BUGÜNÜN ÖZETİ',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 1.5.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 1.5.h,
              childAspectRatio: 2.8,
            ),
            itemCount: summaryItems.length,
            itemBuilder: (context, index) {
              final item = summaryItems[index];
              final color = item["color"] as Color;
              return Row(
                children: [
                  CustomIconWidget(
                    iconName: item["icon"] as String,
                    color: color,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item["value"] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item["label"] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.textSecondary,
                            fontSize: 9,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
