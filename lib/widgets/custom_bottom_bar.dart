import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation items for the EkoDost bottom bar
enum BottomNavItem { dashboard, analysis, gamification, profile }

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Map<BottomNavItem, int>? badgeCounts;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.badgeCounts,
  });

  static const Color _background = Color(0xFF1A2332);
  static const Color _selected = Color(0xFF00D4AA);
  static const Color _unselected = Color(0xFFB0BEC5);
  static const Color _indicator = Color(0xFF00D4AA);

  void _handleTap(BuildContext context, int index) {
    HapticFeedback.lightImpact();
    onTap(index);
  }

  int _getBadgeCount(BottomNavItem item) {
    return badgeCounts?[item] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _background,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.30),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(color: Color(0xFF2C3E50), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _buildNavItem(
                context,
                index: 0,
                item: BottomNavItem.dashboard,
                icon: Icons.bolt_outlined,
                activeIcon: Icons.bolt,
                label: 'Dashboard',
              ),
              _buildNavItem(
                context,
                index: 1,
                item: BottomNavItem.analysis,
                icon: Icons.bar_chart_outlined,
                activeIcon: Icons.bar_chart,
                label: 'Analiz',
              ),
              _buildNavItem(
                context,
                index: 2,
                item: BottomNavItem.gamification,
                icon: Icons.emoji_events_outlined,
                activeIcon: Icons.emoji_events,
                label: 'Ödüller',
              ),
              _buildNavItem(
                context,
                index: 3,
                item: BottomNavItem.profile,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required BottomNavItem item,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;
    final int badge = _getBadgeCount(item);

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleTap(context, index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _indicator.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        isSelected ? activeIcon : icon,
                        key: ValueKey(isSelected),
                        color: isSelected ? _selected : _unselected,
                        size: 24,
                      ),
                    ),
                  ),
                  if (badge > 0)
                    Positioned(
                      top: -4,
                      right: -2,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8C00),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _background, width: 1.5),
                        ),
                        child: Text(
                          badge > 99 ? '99+' : badge.toString(),
                          style: GoogleFonts.roboto(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? _selected : _unselected,
                  letterSpacing: 0.2,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
