import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class Step4SummaryWidget extends StatelessWidget {
  final Map<String, dynamic> allData;
  final VoidCallback onEditStep1;
  final VoidCallback onEditStep2;

  const Step4SummaryWidget({
    super.key,
    required this.allData,
    required this.onEditStep1,
    required this.onEditStep2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final step1 = (allData['step1'] as Map<String, dynamic>?) ?? {};
    final step2 = (allData['step2'] as Map<String, dynamic>?) ?? {};
    final step3 = (allData['step3'] as Map<String, dynamic>?) ?? {};

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profil Özeti',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Bilgilerinizi gözden geçirin ve tamamlayın.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          // Household Info Card
          _buildSectionCard(
            theme: theme,
            title: 'Hane Bilgileri',
            iconName: 'home',
            iconColor: theme.colorScheme.primary,
            onEdit: onEditStep1,
            children: [
              _buildSummaryRow(
                theme,
                'Kişi Sayısı',
                '${step1['householdSize'] ?? 2} kişi',
              ),
              _buildSummaryRow(
                theme,
                'Konut Tipi',
                (step1['homeType'] as String?) ?? 'Daire',
              ),
              _buildSummaryRow(
                theme,
                'Alan',
                '${step1['squareMeters'] ?? '-'} m²',
              ),
              _buildSummaryRow(
                theme,
                'Şehir',
                (step1['city'] as String?) ?? '-',
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Meter Connection Card
          _buildSectionCard(
            theme: theme,
            title: 'Sayaç Bağlantısı',
            iconName: 'electric_meter',
            iconColor: const Color(0xFFFF8C00),
            onEdit: onEditStep2,
            children: [
              _buildSummaryRow(
                theme,
                'Sayaç ID',
                (step2['meterId'] as String?)?.isNotEmpty == true
                    ? (step2['meterId'] as String)
                    : 'Bağlanmadı',
              ),
              _buildSummaryRow(
                theme,
                'Durum',
                (step2['meterConnected'] as bool?) == true
                    ? 'Bağlı ✓'
                    : 'Bağlı Değil',
                valueColor: (step2['meterConnected'] as bool?) == true
                    ? const Color(0xFF4CAF50)
                    : theme.colorScheme.error,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Group Assignment Card
          _buildSectionCard(
            theme: theme,
            title: 'Grup Ataması',
            iconName: 'science',
            iconColor: const Color(0xFF8E44AD),
            onEdit: null,
            children: [
              _buildSummaryRow(
                theme,
                'Grup',
                (step3['groupName'] as String?) ?? 'Kontrol Grubu A',
              ),
              _buildSummaryRow(
                theme,
                'Deney',
                (step3['experimentName'] as String?) ?? 'EkoDost Pilot 2026',
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.15),
                  theme.colorScheme.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'celebration',
                  color: const Color(0xFFFFD700),
                  size: 32,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Harika! Profiliniz hazır.',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Gösterge paneline geçerek enerji tasarrufuna başlayın!',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required ThemeData theme,
    required String title,
    required String iconName,
    required Color iconColor,
    required VoidCallback? onEdit,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: iconName,
                    color: iconColor,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onEdit != null
                  ? GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'edit',
                              color: theme.colorScheme.primary,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Düzenle',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8E44AD).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'OTOMATİK',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF8E44AD),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          SizedBox(height: 1.5.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    ThemeData theme,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor ?? theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
