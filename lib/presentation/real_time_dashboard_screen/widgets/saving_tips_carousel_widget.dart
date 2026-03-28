import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SavingTipsCarouselWidget extends StatefulWidget {
  const SavingTipsCarouselWidget({super.key});

  @override
  State<SavingTipsCarouselWidget> createState() =>
      _SavingTipsCarouselWidgetState();
}

class _SavingTipsCarouselWidgetState extends State<SavingTipsCarouselWidget> {
  int _currentPage = 0;

  final List<Map<String, dynamic>> _tips = [
    {
      "icon": "lightbulb_outline",
      "color": AppTheme.gamificationHighlight,
      "title": "LED Ampul Kullanın",
      "description":
          "LED ampuller geleneksel ampullere göre %80 daha az enerji tüketir.",
      "saving": "Aylık ₺15 tasarruf",
    },
    {
      "icon": "ac_unit",
      "color": AppTheme.primaryAccent,
      "title": "Klima Ayarı",
      "description":
          "Klimanızı 24°C'ye ayarlayarak enerji tüketimini önemli ölçüde azaltın.",
      "saving": "Aylık ₺40 tasarruf",
    },
    {
      "icon": "local_laundry_service",
      "color": AppTheme.researchModule,
      "title": "Gece Çamaşır Yıkayın",
      "description":
          "Gece 22:00-06:00 arası elektrik tarifeleri daha düşüktür.",
      "saving": "Aylık ₺20 tasarruf",
    },
    {
      "icon": "power_settings_new",
      "color": AppTheme.warningAlert,
      "title": "Bekleme Modunu Kapatın",
      "description":
          "Cihazları bekleme modunda bırakmak yıllık %10 enerji israfına yol açar.",
      "saving": "Aylık ₺12 tasarruf",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: Text(
            'TASARRUF ÖNERİLERİ',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 14.h,
            viewportFraction: 0.88,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, _) => setState(() => _currentPage = index),
          ),
          items: _tips.map((tip) {
            final color = tip["color"] as Color;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.5.w),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomIconWidget(
                      iconName: tip["icon"] as String,
                      color: color,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tip["title"] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.4.h),
                        Text(
                          tip["description"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.4.h),
                        Text(
                          tip["saving"] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.successIndicator,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _tips.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              width: _currentPage == i ? 4.w : 2.w,
              height: 1.w,
              decoration: BoxDecoration(
                color: _currentPage == i
                    ? AppTheme.primaryAccent
                    : AppTheme.dividerSubtle,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
