import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/co2_impact_widget.dart';
import './widgets/consumption_hero_card_widget.dart';
import './widgets/cost_estimation_card_widget.dart';
import './widgets/peak_hour_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/saving_tips_carousel_widget.dart';
import './widgets/today_summary_card_widget.dart';

class RealTimeDashboardScreenInitialPage extends StatefulWidget {
  const RealTimeDashboardScreenInitialPage({super.key});

  @override
  State<RealTimeDashboardScreenInitialPage> createState() =>
      _RealTimeDashboardScreenInitialPageState();
}

class _RealTimeDashboardScreenInitialPageState
    extends State<RealTimeDashboardScreenInitialPage> {
  bool _isRefreshing = false;
  final bool _isOffline = false;
  String _lastUpdated = '09.03.2026 21:58';

  double _currentKwh = 3.47;
  double _estimatedCost = 124.80;
  final bool _isCostIncreasing = true;
  double _co2Impact = 1.73;
  final double _co2Percentage = 0.62;

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      _isRefreshing = false;
      _currentKwh = 3.52;
      _estimatedCost = 126.72;
      _co2Impact = 1.76;
      _lastUpdated = '09.03.2026 22:00';
    });
  }

  void _showMetricDetail(BuildContext context, String title, String detail) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.dividerSubtle,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.textPrimary),
            ),
            SizedBox(height: 1.5.h),
            Text(
              detail,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Column(
            children: [
              _buildHeader(theme),
              SizedBox(height: 1.h),
              _isOffline ? _buildOfflineBanner(theme) : const SizedBox.shrink(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: AppTheme.primaryAccent,
                  backgroundColor: AppTheme.surfaceCard,
                  child: _isRefreshing
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryAccent,
                          ),
                        )
                      : ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            GestureDetector(
                              onLongPress: () => _showMetricDetail(
                                context,
                                'Anlık Tüketim Detayı',
                                'Şu anda eviniz saatte 3.47 kWh elektrik tüketiyor. Bu değer, sabah 08:00-10:00 arası yoğun kullanım saatlerine denk gelmektedir. Ortalama tüketiminizin %12 üzerinde.',
                              ),
                              child: ConsumptionHeroCardWidget(
                                currentKwh: _currentKwh,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onLongPress: () => _showMetricDetail(
                                      context,
                                      'Tahmini Maliyet Detayı',
                                      'Bu ayki tahmini faturanız ₺124,80 olarak hesaplanmıştır. Geçen aya göre %8 artış göstermektedir. Tasarruf önerilerini uygulayarak ₺30-40 tasarruf edebilirsiniz.',
                                    ),
                                    child: CostEstimationCardWidget(
                                      estimatedCost: _estimatedCost,
                                      isIncreasing: _isCostIncreasing,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: GestureDetector(
                                    onLongPress: () => _showMetricDetail(
                                      context,
                                      'CO₂ Etkisi Detayı',
                                      'Bugün 1.73 kg CO₂ salınımına katkıda bulundunuz. Türkiye elektrik şebekesi için ortalama emisyon faktörü 0.499 kg CO₂/kWh\'dir. Yenilenebilir enerji kullanımını artırarak bu değeri düşürebilirsiniz.',
                                    ),
                                    child: Co2ImpactWidget(
                                      co2Impact: _co2Impact,
                                      percentage: _co2Percentage,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            SavingTipsCarouselWidget(),
                            SizedBox(height: 2.h),
                            QuickActionsWidget(
                              onDeviceCheck: () => Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed('/household-profile-setup-screen'),
                              onSetGoal: () => Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed('/gamification-hub-screen'),
                              onAlertSettings: () => Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed('/predictions-and-alerts-screen'),
                            ),
                            SizedBox(height: 2.h),
                            TodaySummaryCardWidget(),
                            SizedBox(height: 2.h),
                            PeakHourCardWidget(),
                            SizedBox(height: 2.h),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EkoDost',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Gerçek Zamanlı Gösterge',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 2.w,
              height: 2.w,
              decoration: const BoxDecoration(
                color: AppTheme.successIndicator,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 1.w),
            Text(
              'Canlı',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.successIndicator,
              ),
            ),
            SizedBox(width: 3.w),
            GestureDetector(
              onTap: () => Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/predictions-and-alerts-screen'),
              child: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'notifications_outlined',
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: const BoxDecoration(
                        color: AppTheme.warningAlert,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOfflineBanner(ThemeData theme) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.warningAlert.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.warningAlert.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'wifi_off',
            color: AppTheme.warningAlert,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Çevrimdışı mod — Son güncelleme: $_lastUpdated',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.warningAlert,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
