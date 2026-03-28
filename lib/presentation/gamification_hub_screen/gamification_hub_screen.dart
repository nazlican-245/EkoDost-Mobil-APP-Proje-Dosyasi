import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../features/feedback/presentation/widgets/mission_widget.dart';
import '../../features/gamification/presentation/widgets/goal_card.dart';
import '../../features/gamification/presentation/widgets/streak_broken_modal.dart';
import '../../features/gamification/presentation/widgets/streak_flame.dart';
import './widgets/achievement_badge_widget.dart';
import './widgets/challenge_card_widget.dart';
import './widgets/hero_points_widget.dart';
import './widgets/leaderboard_preview_widget.dart';
import './widgets/level_progress_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/streak_counter_widget.dart';

class GamificationHubScreen extends StatefulWidget {
  const GamificationHubScreen({super.key});

  @override
  State<GamificationHubScreen> createState() => _GamificationHubScreenState();
}

class _GamificationHubScreenState extends State<GamificationHubScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _gamificationEnabled = true;

  final int _totalPoints = 4250;
  final int _currentLevel = 7;
  final int _currentXP = 320;
  final int _nextLevelXP = 500;
  final int _streakDays = 12;

  // Goal data for GoalCard
  final double _goalKWh = 300.0;
  final double _currentKWh = 204.0;
  final double _goalProgress = 68.0;
  final String _goalStatus = 'active';
  final String _goalPeriod = 'monthly';
  final double _goalAchieveProbability = 0.74;

  // Mission data for MissionWidget
  final double _savedKWh = 28.5;
  final double _baselineKWh = 312.8;
  final int _periodDays = 30;

  // Streak shield count for StreakBrokenModal demo
  final int _streakShield = 2;

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

  final List<Map<String, dynamic>> _challenges = [
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

  final List<Map<String, dynamic>> _recentActivity = [
    {
      "id": 1,
      "action": "Günlük hedef tamamlandı",
      "points": "+50",
      "time": "2 saat önce",
      "icon": "check_circle",
      "color": 0xFF4CAF50,
    },
    {
      "id": 2,
      "action": "Rozet kazanıldı: Çevre Dostu",
      "points": "+100",
      "time": "Dün",
      "icon": "military_tech",
      "color": 0xFFFFD700,
    },
    {
      "id": 3,
      "action": "Haftalık mücadele tamamlandı",
      "points": "+200",
      "time": "2 gün önce",
      "icon": "emoji_events",
      "color": 0xFFFF8C00,
    },
    {
      "id": 4,
      "action": "Gece tasarrufu başarısı",
      "points": "+75",
      "time": "3 gün önce",
      "icon": "nightlight",
      "color": 0xFF8E44AD,
    },
    {
      "id": 5,
      "action": "Seri rekoru: 10 gün",
      "points": "+150",
      "time": "4 gün önce",
      "icon": "local_fire_department",
      "color": 0xFFFF8C00,
    },
  ];

  final List<Map<String, dynamic>> _leaderboard = [
    {
      "rank": 1,
      "name": "Ayşe K.",
      "points": 6820,
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1ee2bcef3-1763301295581.png",
      "semanticLabel": "Profile photo of a woman with dark hair",
      "isCurrentUser": false,
    },
    {
      "rank": 2,
      "name": "Mehmet Y.",
      "points": 5940,
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1d90a96ad-1763299909299.png",
      "semanticLabel": "Profile photo of a man with short hair",
      "isCurrentUser": false,
    },
    {
      "rank": 3,
      "name": "Fatma D.",
      "points": 5210,
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1453e1878-1763300003100.png",
      "semanticLabel": "Profile photo of a woman smiling",
      "isCurrentUser": false,
    },
    {
      "rank": 8,
      "name": "Sen",
      "points": 4250,
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_11e223970-1767170769836.png",
      "semanticLabel": "Your profile photo",
      "isCurrentUser": true,
    },
  ];

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _showBadgeDetails(Map<String, dynamic> badge) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.dividerSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  color: Color(badge["color"] as int).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(badge["color"] as int),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: badge["icon"] as String,
                    color: Color(badge["color"] as int),
                    size: 32,
                  ),
                ),
              ),
              SizedBox(height: 1.5.h),
              Text(
                badge["name"] as String,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                badge["description"] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                decoration: BoxDecoration(
                  color: (badge["earned"] as bool)
                      ? AppTheme.successIndicator.withValues(alpha: 0.2)
                      : AppTheme.dividerSubtle,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  (badge["earned"] as bool) ? "✓ Kazanıldı" : "Kilitli",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: (badge["earned"] as bool)
                        ? AppTheme.successIndicator
                        : AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        );
      },
    );
  }

  void _showStreakBrokenDemo() {
    StreakBrokenModal.show(
      context,
      streakShield: _streakShield,
      gamificationEnabled: _gamificationEnabled,
      onUseShield: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kalkan kullanıldı! Serin korundu. 🛡️'),
            backgroundColor: Colors.blue,
          ),
        );
      },
      onDismiss: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppTheme.primaryAccent,
          backgroundColor: AppTheme.surfaceCard,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(theme),
                    SizedBox(height: 2.h),
                    HeroPointsWidget(
                      totalPoints: _totalPoints,
                      isLoading: _isLoading,
                      gamificationEnabled: _gamificationEnabled,
                    ),
                    SizedBox(height: 2.h),
                    LevelProgressWidget(
                      currentLevel: _currentLevel,
                      currentXP: _currentXP,
                      nextLevelXP: _nextLevelXP,
                      gamificationEnabled: _gamificationEnabled,
                    ),
                    SizedBox(height: 2.h),
                    // ── Streak row: StreakFlame + legacy counter ──────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: StreakFlame(
                            streakDays: _streakDays,
                            streakBroken: false,
                            streakFreeze: false,
                            gamificationEnabled: _gamificationEnabled,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: StreakCounterWidget(
                            streakDays: _streakDays,
                            gamificationEnabled: _gamificationEnabled,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    // ── StreakBrokenModal demo button ─────────────────────────
                    if (_gamificationEnabled)
                      GestureDetector(
                        onTap: _showStreakBrokenDemo,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.30),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                color: Colors.grey,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Seri Bitti Modalını Göster',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 2.h),
                    // ── GoalCard ─────────────────────────────────────────────
                    _buildSectionHeader(
                      theme,
                      "Enerji Hedefi",
                      Icons.track_changes,
                    ),
                    SizedBox(height: 1.h),
                    GoalCard(
                      goalKWh: _goalKWh,
                      currentKWh: _currentKWh,
                      goalProgress: _goalProgress,
                      goalDeadline: DateTime.now().add(const Duration(days: 8)),
                      goalStatus: _goalStatus,
                      goalPeriod: _goalPeriod,
                      goalAchieveProbability: _goalAchieveProbability,
                      gamificationEnabled: _gamificationEnabled,
                      onSetupGoal: () {},
                    ),
                    SizedBox(height: 2.h),
                    // ── MissionWidget ────────────────────────────────────────
                    _buildSectionHeader(theme, "Çevre Misyonu", Icons.eco),
                    SizedBox(height: 1.h),
                    MissionWidget(
                      savedKWh: _savedKWh,
                      baselineKWh: _baselineKWh,
                      periodDays: _periodDays,
                      missionTitle: 'Aylık Tasarruf Görevi',
                      missionCompleted: false,
                      gamificationEnabled: _gamificationEnabled,
                    ),
                    SizedBox(height: 2.h),
                    _buildSectionHeader(theme, "Rozetler", Icons.military_tech),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 14.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _badges.length,
                    separatorBuilder: (_, __) => SizedBox(width: 3.w),
                    itemBuilder: (context, index) {
                      final badge = _badges[index];
                      return GestureDetector(
                        onLongPress: () => _showBadgeDetails(badge),
                        onTap: () => _showBadgeDetails(badge),
                        child: AchievementBadgeWidget(
                          badge: badge,
                          gamificationEnabled: _gamificationEnabled,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    _buildSectionHeader(
                      theme,
                      "Aktif Mücadeleler",
                      Icons.flash_on,
                    ),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.5.h),
                    child: ChallengeCardWidget(
                      challenge: _challenges[index],
                      gamificationEnabled: _gamificationEnabled,
                    ),
                  );
                }, childCount: _challenges.length),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),
                    _buildSectionHeader(
                      theme,
                      "Son Aktiviteler",
                      Icons.history,
                    ),
                    SizedBox(height: 1.h),
                    RecentActivityWidget(
                      activities: _recentActivity,
                      gamificationEnabled: _gamificationEnabled,
                    ),
                    SizedBox(height: 2.h),
                    _buildSectionHeader(theme, "Liderboard", Icons.leaderboard),
                    SizedBox(height: 1.h),
                    LeaderboardPreviewWidget(
                      leaderboard: _leaderboard,
                      onViewAll: () {},
                      gamificationEnabled: _gamificationEnabled,
                    ),
                    SizedBox(height: 2.h),
                    _buildGamificationToggle(theme),
                    SizedBox(height: 3.h),
                  ],
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
              "Oyunlaştırma",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Tasarruf et, kazan, ilerlе!",
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dividerSubtle),
            ),
            child: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.primaryAccent,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon.codePoint == Icons.military_tech.codePoint
              ? 'military_tech'
              : icon.codePoint == Icons.flash_on.codePoint
              ? 'flash_on'
              : icon.codePoint == Icons.history.codePoint
              ? 'history'
              : 'leaderboard',
          color: AppTheme.primaryAccent,
          size: 20,
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGamificationToggle(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerSubtle),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.researchModule.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomIconWidget(
              iconName: 'science',
              color: AppTheme.researchModule,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Araştırma Modu",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Gamifikasyon özelliklerini aç/kapat",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _gamificationEnabled,
            onChanged: (val) => setState(() => _gamificationEnabled = val),
            activeThumbColor: AppTheme.primaryAccent,
          ),
        ],
      ),
    );
  }
}
