import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/alert_settings_panel_widget.dart';
import './widgets/anomaly_card_widget.dart';
import './widgets/forecast_card_widget.dart';
import './widgets/goal_probability_widget.dart';
import './widgets/seasonal_model_widget.dart';
import './widgets/trend_projection_widget.dart';

class PredictionsAndAlertsScreen extends StatefulWidget {
  const PredictionsAndAlertsScreen({super.key});

  @override
  State<PredictionsAndAlertsScreen> createState() =>
      _PredictionsAndAlertsScreenState();
}

class _PredictionsAndAlertsScreenState
    extends State<PredictionsAndAlertsScreen> {
  final List<Map<String, dynamic>> _anomalies = [
    {
      'id': 1,
      'title': 'Gece Yarısı Yüksek Tüketim',
      'timestamp': '09.03.2026 - 02:34',
      'severity': 'high',
      'description':
          'Gece 02:00-03:00 saatleri arasında normalin %85 üzerinde tüketim tespit edildi. Bu durum büyük olasılıkla arka planda çalışan bir cihazdan kaynaklanmaktadır.',
      'value': '4.2 kWh (Normal: 0.8 kWh)',
    },
    {
      'id': 2,
      'title': 'Hafta Sonu Tüketim Artışı',
      'timestamp': '07.03.2026 - 14:15',
      'severity': 'medium',
      'description':
          'Geçen hafta sonu tüketim ortalamanın %40 üzerinde seyretti. Klima veya ısıtma sisteminin uzun süre açık kaldığı düşünülmektedir.',
      'value': '12.8 kWh (Normal: 9.1 kWh)',
    },
    {
      'id': 3,
      'title': 'Sabah Pik Saati Anomalisi',
      'timestamp': '06.03.2026 - 07:45',
      'severity': 'low',
      'description':
          'Sabah 07:00-08:00 saatlerinde hafif bir tüketim artışı gözlemlendi. Olağan sabah rutininden biraz daha fazla enerji kullanıldı.',
      'value': '2.1 kWh (Normal: 1.6 kWh)',
    },
  ];

  List<Map<String, dynamic>> get _activeAnomalies =>
      _anomalies.where((a) => !(a['dismissed'] as bool? ?? false)).toList();

  int get _alertCount => _activeAnomalies.length;

  void _dismissAnomaly(int id) {
    final index = _anomalies.indexWhere((a) => a['id'] == id);
    if (index != -1) {
      setState(() => _anomalies[index]['dismissed'] = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Uyarı kapatıldı',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'Geri Al',
            textColor: const Color(0xFF00D4AA),
            onPressed: () =>
                setState(() => _anomalies[index]['dismissed'] = false),
          ),
          backgroundColor: const Color(0xFF2C3E50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _investigateAnomaly(int id) {
    HapticFeedback.mediumImpact();
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/consumption-analysis-screen');
  }

  void _showSettingsPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) =>
          AlertSettingsPanelWidget(onClose: () => Navigator.pop(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 1.h),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ForecastCardWidget(
                        predictedAmount: 847.50,
                        confidenceLow: 780.0,
                        confidenceHigh: 915.0,
                        progressValue: 0.62,
                        month: 'Mart 2026',
                      ),
                      SizedBox(height: 2.h),
                      const TrendProjectionWidget(),
                      SizedBox(height: 2.h),
                      GoalProbabilityWidget(
                        probability: 0.73,
                        goalName: 'Aylık %15 Tasarruf Hedefi',
                        motivationalMessage:
                            'Harika gidiyorsunuz! Mevcut hızınızla hedefinize ulaşma olasılığınız yüksek. Birkaç küçük değişiklikle %90\'a çıkabilirsiniz.',
                        currentKwh: 187.4,
                        targetKwh: 220.0,
                      ),
                      SizedBox(height: 2.h),
                      _buildAnomalySection(),
                      SizedBox(height: 2.h),
                      const SeasonalModelWidget(),
                      SizedBox(height: 2.h),
                      _buildOfflineIndicator(),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSettingsPanel,
        backgroundColor: const Color(0xFF00D4AA),
        foregroundColor: const Color(0xFF0A1628),
        child: CustomIconWidget(
          iconName: 'tune',
          color: const Color(0xFF0A1628),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2C3E50)),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'arrow_back_ios_new',
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tahmin & Uyarılar',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'AI destekli tüketim analizi',
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  color: const Color(0xFFB0BEC5),
                ),
              ),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: const Color(0xFF1A2332),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2C3E50)),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'notifications_outlined',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            if (_alertCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCF6679),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$_alertCount',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnomalySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'warning_amber',
              color: const Color(0xFFFF8C00),
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Anomali Tespiti',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C00).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_activeAnomalies.length} aktif',
                style: GoogleFonts.inter(
                  fontSize: 8.sp,
                  color: const Color(0xFFFF8C00),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        _activeAnomalies.isEmpty
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2332),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2C3E50)),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: const Color(0xFF4CAF50),
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Aktif anomali bulunmuyor',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: const Color(0xFFB0BEC5),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _activeAnomalies.length,
                itemBuilder: (context, index) {
                  final anomaly = _activeAnomalies[index];
                  return Dismissible(
                    key: Key('anomaly_${anomaly['id']}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 4.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: const Color(0xFF4CAF50),
                        size: 24,
                      ),
                    ),
                    onDismissed: (_) => _dismissAnomaly(anomaly['id'] as int),
                    child: AnomalyCardWidget(
                      anomaly: anomaly,
                      onDismiss: () => _dismissAnomaly(anomaly['id'] as int),
                      onInvestigate: () =>
                          _investigateAnomaly(anomaly['id'] as int),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildOfflineIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2C3E50)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Son güncelleme: 09.03.2026 22:03',
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                color: const Color(0xFFB0BEC5),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CustomIconWidget(
            iconName: 'sync',
            color: const Color(0xFF00D4AA),
            size: 16,
          ),
        ],
      ),
    );
  }
}
