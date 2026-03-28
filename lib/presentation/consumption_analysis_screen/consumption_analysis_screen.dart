import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import '../../features/gamification/presentation/widgets/goal_card.dart';
import '../../features/gamification/presentation/widgets/streak_flame.dart';
import '../../features/feedback/presentation/widgets/mission_widget.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/consumption_card_widget.dart';
import './widgets/export_bottom_sheet_widget.dart';
import './widgets/main_line_chart_widget.dart';
import './widgets/peak_hours_chart_widget.dart';
import './widgets/trend_card_widget.dart';

class ConsumptionAnalysisScreen extends StatefulWidget {
  const ConsumptionAnalysisScreen({super.key});

  @override
  State<ConsumptionAnalysisScreen> createState() =>
      _ConsumptionAnalysisScreenState();
}

class _ConsumptionAnalysisScreenState extends State<ConsumptionAnalysisScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  int _selectedPeriodIndex = 0;
  final List<String> _periods = ['Günlük', 'Haftalık', 'Aylık'];

  final List<Map<String, dynamic>> _dailyCards = [
    {
      "date": "09 Mar",
      "kwh": 12.4,
      "cost": "₺74,40",
      "change": -8.2,
      "isPositive": true,
    },
    {
      "date": "08 Mar",
      "kwh": 13.5,
      "cost": "₺81,00",
      "change": 3.1,
      "isPositive": false,
    },
    {
      "date": "07 Mar",
      "kwh": 11.8,
      "cost": "₺70,80",
      "change": -12.5,
      "isPositive": true,
    },
    {
      "date": "06 Mar",
      "kwh": 14.2,
      "cost": "₺85,20",
      "change": 6.7,
      "isPositive": false,
    },
    {
      "date": "05 Mar",
      "kwh": 10.9,
      "cost": "₺65,40",
      "change": -18.0,
      "isPositive": true,
    },
    {
      "date": "04 Mar",
      "kwh": 15.1,
      "cost": "₺90,60",
      "change": 9.4,
      "isPositive": false,
    },
    {
      "date": "03 Mar",
      "kwh": 13.8,
      "cost": "₺82,80",
      "change": -2.1,
      "isPositive": true,
    },
  ];

  final List<Map<String, dynamic>> _trendCards = [
    {
      "title": "Bu Hafta",
      "value": "87,3 kWh",
      "change": -5.4,
      "isPositive": true,
      "subtitle": "Geçen haftaya göre",
    },
    {
      "title": "Bu Ay",
      "value": "312,8 kWh",
      "change": 2.1,
      "isPositive": false,
      "subtitle": "Geçen aya göre",
    },
    {
      "title": "Tahmini Fatura",
      "value": "₺1.876,80",
      "change": -3.2,
      "isPositive": true,
      "subtitle": "Geçen aya göre",
    },
    {
      "title": "CO₂ Etkisi",
      "value": "156,4 kg",
      "change": -5.4,
      "isPositive": true,
      "subtitle": "Bu ay toplam",
    },
  ];

  List<FlSpot> get _chartSpots {
    if (_selectedPeriodIndex == 0) {
      return [
        FlSpot(0, 2.1),
        FlSpot(1, 1.8),
        FlSpot(2, 0.9),
        FlSpot(3, 0.5),
        FlSpot(4, 1.2),
        FlSpot(5, 3.4),
        FlSpot(6, 4.1),
        FlSpot(7, 3.8),
        FlSpot(8, 2.9),
        FlSpot(9, 2.2),
        FlSpot(10, 1.9),
        FlSpot(11, 1.5),
        FlSpot(12, 2.8),
        FlSpot(13, 3.1),
        FlSpot(14, 2.7),
        FlSpot(15, 2.4),
        FlSpot(16, 3.6),
        FlSpot(17, 4.8),
        FlSpot(18, 5.2),
        FlSpot(19, 4.9),
        FlSpot(20, 4.3),
        FlSpot(21, 3.7),
        FlSpot(22, 2.8),
        FlSpot(23, 2.1),
      ];
    } else if (_selectedPeriodIndex == 1) {
      return [
        FlSpot(0, 12.4),
        FlSpot(1, 13.5),
        FlSpot(2, 11.8),
        FlSpot(3, 14.2),
        FlSpot(4, 10.9),
        FlSpot(5, 15.1),
        FlSpot(6, 13.8),
      ];
    } else {
      return [
        FlSpot(0, 87.3),
        FlSpot(1, 92.1),
        FlSpot(2, 78.4),
        FlSpot(3, 95.6),
        FlSpot(4, 88.2),
        FlSpot(5, 102.4),
        FlSpot(6, 91.7),
        FlSpot(7, 85.3),
        FlSpot(8, 98.1),
        FlSpot(9, 79.6),
        FlSpot(10, 93.4),
        FlSpot(11, 88.9),
      ];
    }
  }

  List<String> get _chartLabels {
    if (_selectedPeriodIndex == 0) {
      return ['00', '03', '06', '09', '12', '15', '18', '21'];
    } else if (_selectedPeriodIndex == 1) {
      return ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    } else {
      return [
        'Oca',
        'Şub',
        'Mar',
        'Nis',
        'May',
        'Haz',
        'Tem',
        'Ağu',
        'Eyl',
        'Eki',
        'Kas',
        'Ara',
      ];
    }
  }

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _showExportSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ExportBottomSheetWidget(
        onExportCsv: () => _exportData('csv'),
        onExportJson: () => _exportData('json'),
      ),
    );
  }

  Future<void> _exportData(String format) async {
    Navigator.pop(context);
    final data = _dailyCards
        .map((e) => '${e["date"]},${e["kwh"]},${e["cost"]},${e["change"]}')
        .join('\n');
    final content = format == 'csv'
        ? 'Tarih,kWh,Maliyet,Değişim\n$data'
        : jsonEncode(_dailyCards);
    final filename =
        'tuketim_analizi_${DateTime.now().millisecondsSinceEpoch}.$format';

    try {
      if (kIsWeb) {
        final bytes = utf8.encode(content);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsString(content);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$filename indirildi'),
            backgroundColor: const Color(0xFF00D4AA),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dışa aktarma başarısız oldu.')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedPeriodIndex = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              _buildHeader(theme),
              SizedBox(height: 1.5.h),
              _buildSegmentedControl(theme),
              SizedBox(height: 1.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: const Color(0xFF00D4AA),
                  child: _isLoading
                      ? _buildSkeleton()
                      : _buildScrollContent(theme),
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
      children: [
        Expanded(
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF00D4AA), Color(0xFF4CAF50)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: const Text(
              'EkoDost',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GestureDetector(
          onTap: _showExportSheet,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2C3E50)),
            ),
            child: CustomIconWidget(
              iconName: 'share',
              color: const Color(0xFF00D4AA),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedControl(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2C3E50)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF00D4AA),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: const Color(0xFF0A1628),
        unselectedLabelColor: const Color(0xFFB0BEC5),
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
        ),
        unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
        ),
        tabs: _periods.map((p) => Tab(text: p)).toList(),
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(4),
      ),
    );
  }

  Widget _buildScrollContent(ThemeData theme) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 1.h),
        MainLineChartWidget(
          spots: _chartSpots,
          labels: _chartLabels,
          periodLabel: _periods[_selectedPeriodIndex],
        ),
        SizedBox(height: 2.h),
        _buildSectionTitle('Hedef İlerlemesi', theme),
        SizedBox(height: 1.h),
        GoalCard(
          goalKWh: 300.0,
          currentKWh: 204.0,
          goalProgress: 68.0,
          goalDeadline: DateTime.now().add(const Duration(days: 8)),
          goalStatus: 'active',
          goalPeriod: 'monthly',
          goalAchieveProbability: 0.74,
          gamificationEnabled: true,
          onSetupGoal: () {},
        ),
        SizedBox(height: 2.h),
        StreakFlame(
          streakDays: 7,
          streakBroken: false,
          streakFreeze: false,
          gamificationEnabled: true,
        ),
        SizedBox(height: 2.h),
        MissionWidget(
          savedKWh: 96.0,
          baselineKWh: 300.0,
          periodDays: 30,
          missionTitle: 'Aylık Tasarruf Misyonu',
          missionCompleted: false,
          gamificationEnabled: true,
        ),
        SizedBox(height: 2.h),
        _buildSectionTitle('Günlük Tüketim', theme),
        SizedBox(height: 1.h),
        SizedBox(
          height: 18.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dailyCards.length,
            separatorBuilder: (_, __) => SizedBox(width: 3.w),
            itemBuilder: (_, i) => ConsumptionCardWidget(data: _dailyCards[i]),
          ),
        ),
        SizedBox(height: 2.h),
        _buildSectionTitle('Yoğun Saatler', theme),
        SizedBox(height: 1.h),
        const PeakHoursChartWidget(),
        SizedBox(height: 2.h),
        _buildSectionTitle('Trend Analizi', theme),
        SizedBox(height: 1.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 1.5.h,
            childAspectRatio: 1.6,
          ),
          itemCount: _trendCards.length,
          itemBuilder: (_, i) => TrendCardWidget(data: _trendCards[i]),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        color: const Color(0xFFB0BEC5),
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600,
        fontSize: 10.sp,
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView(
      children: List.generate(
        4,
        (i) => Container(
          margin: EdgeInsets.only(bottom: 2.h),
          height: 15.h,
          decoration: BoxDecoration(
            color: const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
