import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../features/gamification/presentation/widgets/goal_card.dart';
import '../../../features/gamification/presentation/widgets/streak_flame.dart';
import '../../../presentation/gamification_hub_screen/widgets/achievement_badge_widget.dart';
import '../../../presentation/gamification_hub_screen/widgets/challenge_card_widget.dart';
import '../../../presentation/gamification_hub_screen/widgets/hero_points_widget.dart';

class GamificationScreen extends StatefulWidget {
  const GamificationScreen({super.key});

  @override
  State<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends State<GamificationScreen> {
  // Research group flag — set to true for gamification group
  final bool _gamificationEnabled = true;

  // Streak data
  final int _streakDays = 12;
  final bool _streakBroken = false;
  final bool _streakFreeze = false;

  // Goal data
  final double _goalKWh = 300.0;
  final double _currentKWh = 204.0;
  final double _goalProgress = 68.0;
  final String _goalStatus = 'active';
  final String _goalPeriod = 'monthly';
  final double _goalAchieveProbability = 0.74;
  late final DateTime _goalDeadline;

  // Points data
  final int _totalPoints = 4250;

  // Badge data
  final List<Map<String, dynamic>> _badges = [
    {
      "id": 1,
      "name": "Enerji Tasarrufu",
      "icon": "bolt",
      "color": 0xFF00D4AA,
      "earned": true,
      "description": "7 gün üst üste enerji tasarrufu yaptın!",
    },
    {
      "id": 2,
      "name": "Çevre Dostu",
      "icon": "eco",
      "color": 0xFF4CAF50,
      "earned": true,
      "description": "CO2 emisyonunu %20 azalttın.",
    },
    {
      "id": 3,
      "name": "Gece Kuşu",
      "icon": "nightlight",
      "color": 0xFF8E44AD,
      "earned": true,
      "description": "Gece saatlerinde tüketimi optimize ettin.",
    },
    {
      "id": 4,
      "name": "Süper Tasarrufçu",
      "icon": "star",
      "color": 0xFFFFD700,
      "earned": false,
      "description": "Aylık hedefini %30 aşarak tamamla.",
    },
    {
      "id": 5,
      "name": "Sosyal Kahraman",
      "icon": "people",
      "color": 0xFFFF8C00,
      "earned": false,
      "description": "3 arkadaşını platforma davet et.",
    },
    {
      "id": 6,
      "name": "Araştırmacı",
      "icon": "science",
      "color": 0xFF8E44AD,
      "earned": false,
      "description": "Tüm anket görevlerini tamamla.",
    },
  ];

  // Active challenges
  final List<Map<String, dynamic>> _activeChallenges = [
    {
      "id": 1,
      "title": "Günlük Tasarruf",
      "description": "Bugün %10 daha az enerji kullan",
      "type": "daily",
      "progress": 0.65,
      "reward": 50,
      "icon": "flash_on",
      "color": 0xFF00D4AA,
      "deadline": "Bugün 23:59",
    },
    {
      "id": 2,
      "title": "Haftalık Şampiyon",
      "description": "Bu hafta 5 gün hedefini tamamla",
      "type": "weekly",
      "progress": 0.4,
      "reward": 200,
      "icon": "emoji_events",
      "color": 0xFFFFD700,
      "deadline": "3 gün kaldı",
    },
    {
      "id": 3,
      "title": "Gece Tasarrufu",
      "description": "22:00-06:00 arası tüketimi azalt",
      "type": "daily",
      "progress": 0.8,
      "reward": 75,
      "icon": "nightlight_round",
      "color": 0xFF8E44AD,
      "deadline": "Bugün 23:59",
    },
  ];

  @override
  void initState() {
    super.initState();
    _goalDeadline = DateTime.now().add(const Duration(days: 18));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App bar ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 0),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF00D4AA), Color(0xFF4CAF50)],
                      ).createShader(bounds),
                      child: Text(
                        'Ödüller',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.emoji_events,
                      color: AppTheme.primaryAccent,
                      size: 6.w,
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 2.h)),

            // ── gamificationEnabled guard message ────────────────────────
            if (!_gamificationEnabled)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: AppTheme.dividerSubtle),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.textSecondary,
                          size: 5.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'Bu özellik sizin grubunuz için aktif değildir.',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ── Streak Flame ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: StreakFlame(
                  streakDays: _streakDays,
                  streakBroken: _streakBroken,
                  streakFreeze: _streakFreeze,
                  gamificationEnabled: _gamificationEnabled,
                ),
              ),
            ),

            if (_gamificationEnabled)
              SliverToBoxAdapter(child: SizedBox(height: 2.h)),

            // ── Goal Card ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: GoalCard(
                  goalKWh: _goalKWh,
                  currentKWh: _currentKWh,
                  goalProgress: _goalProgress,
                  goalDeadline: _goalDeadline,
                  goalStatus: _goalStatus,
                  goalPeriod: _goalPeriod,
                  goalAchieveProbability: _goalAchieveProbability,
                  gamificationEnabled: _gamificationEnabled,
                ),
              ),
            ),

            if (_gamificationEnabled)
              SliverToBoxAdapter(child: SizedBox(height: 2.h)),

            // ── Points Card (HeroPointsWidget) ───────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: HeroPointsWidget(
                  totalPoints: _totalPoints,
                  gamificationEnabled: _gamificationEnabled,
                ),
              ),
            ),

            if (_gamificationEnabled)
              SliverToBoxAdapter(child: SizedBox(height: 2.h)),

            // ── Badge Grid section header ────────────────────────────────
            if (_gamificationEnabled)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'ROZETLER',
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

            if (_gamificationEnabled)
              SliverToBoxAdapter(child: SizedBox(height: 1.h)),

            // ── Badge Grid ───────────────────────────────────────────────
            if (_gamificationEnabled)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => AchievementBadgeWidget(
                      badge: _badges[index],
                      gamificationEnabled: _gamificationEnabled,
                    ),
                    childCount: _badges.length,
                  ),
                ),
              ),

            if (_gamificationEnabled)
              SliverToBoxAdapter(child: SizedBox(height: 2.h)),

            // ── Active Challenges section header ─────────────────────────
            if (_gamificationEnabled)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'AKTİF GÖREVLER',
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

            if (_gamificationEnabled)
              SliverToBoxAdapter(child: SizedBox(height: 1.h)),

            // ── Active Challenges list ────────────────────────────────────
            if (_gamificationEnabled)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 1.5.h),
                      child: ChallengeCardWidget(
                        challenge: _activeChallenges[index],
                        gamificationEnabled: _gamificationEnabled,
                      ),
                    ),
                    childCount: _activeChallenges.length,
                  ),
                ),
              ),

            SliverToBoxAdapter(child: SizedBox(height: 3.h)),
          ],
        ),
      ),
    );
  }
}
