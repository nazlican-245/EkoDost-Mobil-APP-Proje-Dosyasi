import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../core/utils/calculations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _bildirimler = true;
  bool _enerjiTasarrufu = true;
  bool _haftalikRapor = false;
  final bool _gamifikasyon = true;

  static const Color _bg = Color(0xFF0A1628);
  static const Color _surface = Color(0xFF1A2332);
  static const Color _accent = Color(0xFF00D4AA);
  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _textSecondary = Color(0xFFB0BEC5);
  static const Color _divider = Color(0xFF2C3E50);
  static const Color _warning = Color(0xFFFF8C00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildUserInfoCard()),
            SliverToBoxAdapter(child: _buildSectionTitle('Hane Bilgileri')),
            SliverToBoxAdapter(child: _buildHouseholdCard()),
            SliverToBoxAdapter(child: _buildSectionTitle('Tercihler')),
            SliverToBoxAdapter(child: _buildPreferencesCard()),
            SliverToBoxAdapter(child: _buildSectionTitle('Hesap Ayarları')),
            SliverToBoxAdapter(child: _buildAccountCard()),
            SliverToBoxAdapter(child: _buildLogoutButton()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF00D4AA), Color(0xFF4CAF50)],
            ).createShader(bounds),
            child: Text(
              'EkoDost',
              style: GoogleFonts.manrope(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accent.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.eco, color: _accent, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Aktif',
                  style: GoogleFonts.manrope(
                    fontSize: 11.sp,
                    color: _accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _divider),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4AA), Color(0xFF4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 32),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: _surface, width: 2),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 10),
                ),
              ),
            ],
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ahmet Yılmaz',
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'ahmet.yilmaz@email.com',
                  style: GoogleFonts.manrope(
                    fontSize: 11.sp,
                    color: _textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: const Color(0xFFFFD700), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Altın Üye',
                      style: GoogleFonts.manrope(
                        fontSize: 10.sp,
                        color: const Color(0xFFFFD700),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_right, color: _textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 0.8.h),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: _accent,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildHouseholdCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _divider),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.home_outlined,
            label: 'Konut Tipi',
            value: 'Daire (3+1)',
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.people_outline,
            label: 'Hane Nüfusu',
            value: '4 Kişi',
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Şehir',
            value: 'İstanbul',
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.bolt_outlined,
            label: 'Sayaç No',
            value: maskSensitiveNumber('TR-2024-00847'),
            valueColor: _accent,
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.group_outlined,
            label: 'Grup',
            value: 'A Grubu',
          ),
          _buildActionRow(label: 'Hane Bilgilerini Düzenle', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _divider),
      ),
      child: Column(
        children: [
          _buildToggleRow(
            icon: Icons.notifications_outlined,
            label: 'Bildirimler',
            subtitle: 'Anlık uyarı ve hatırlatmalar',
            value: _bildirimler,
            onChanged: (v) => setState(() => _bildirimler = v),
          ),
          _buildDivider(),
          _buildToggleRow(
            icon: Icons.eco_outlined,
            label: 'Enerji Tasarrufu İpuçları',
            subtitle: 'Günlük tasarruf önerileri',
            value: _enerjiTasarrufu,
            onChanged: (v) => setState(() => _enerjiTasarrufu = v),
          ),
          _buildDivider(),
          _buildToggleRow(
            icon: Icons.bar_chart_outlined,
            label: 'Haftalık Rapor',
            subtitle: 'E-posta ile haftalık özet',
            value: _haftalikRapor,
            onChanged: (v) => setState(() => _haftalikRapor = v),
          ),
          _buildDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            child: Row(
              children: [
                Icon(Icons.emoji_events_outlined, color: _accent, size: 20),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Oyunlaştırma',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: _textPrimary,
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        'Deney grubunuz araştırmacı tarafından belirlenir.',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: _textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  _gamifikasyon ? 'Açık' : 'Kapalı',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _gamifikasyon ? _accent : _textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 1.w),
                Icon(Icons.lock_outline, color: _textSecondary, size: 16),
              ],
            ),
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.language_outlined,
            label: 'Dil',
            value: 'Türkçe',
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _divider),
      ),
      child: Column(
        children: [
          _buildActionRow(
            icon: Icons.lock_outline,
            label: 'Şifre Değiştir',
            onTap: () {},
          ),
          _buildDivider(),
          _buildActionRow(
            icon: Icons.security_outlined,
            label: 'Gizlilik Ayarları',
            onTap: () {},
          ),
          _buildDivider(),
          _buildActionRow(
            icon: Icons.help_outline,
            label: 'Yardım & Destek',
            onTap: () {},
          ),
          _buildDivider(),
          _buildActionRow(
            icon: Icons.info_outline,
            label: 'Uygulama Hakkında',
            subtitle: 'Sürüm 1.0.0',
            onTap: () {},
          ),
          _buildDivider(),
          _buildActionRow(
            icon: Icons.delete_outline,
            label: 'Hesabı Sil',
            labelColor: const Color(0xFFCF6679),
            onTap: () => _showDeleteAccountDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showLogoutDialog(),
          icon: const Icon(Icons.logout, size: 18),
          label: Text(
            'Çıkış Yap',
            style: GoogleFonts.manrope(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: _warning,
            side: BorderSide(color: _warning.withValues(alpha: 0.5)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
      child: Row(
        children: [
          Icon(icon, color: _accent, size: 20),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12.sp,
                color: _textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: valueColor ?? _textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Icon(icon, color: _accent, size: 20),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 12.sp,
                    color: _textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 10.sp,
                    color: _textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: _accent,
            activeTrackColor: _accent.withValues(alpha: 0.3),
            inactiveThumbColor: _textSecondary,
            inactiveTrackColor: _divider,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    IconData? icon,
    required String label,
    String? subtitle,
    Color? labelColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: labelColor ?? _textSecondary, size: 20),
              SizedBox(width: 3.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.manrope(
                      fontSize: 12.sp,
                      color: labelColor ?? _textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.manrope(
                        fontSize: 10.sp,
                        color: _textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: _textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      color: Color(0xFF2C3E50),
      indent: 16,
      endIndent: 16,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Çıkış Yap',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?',
          style: GoogleFonts.manrope(color: const Color(0xFFB0BEC5)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'İptal',
              style: GoogleFonts.manrope(color: const Color(0xFFB0BEC5)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Çıkış Yap',
              style: GoogleFonts.manrope(
                color: _warning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Hesabı Sil',
          style: GoogleFonts.manrope(
            color: const Color(0xFFCF6679),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
          style: GoogleFonts.manrope(color: const Color(0xFFB0BEC5)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'İptal',
              style: GoogleFonts.manrope(color: const Color(0xFFB0BEC5)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Sil',
              style: GoogleFonts.manrope(
                color: const Color(0xFFCF6679),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
