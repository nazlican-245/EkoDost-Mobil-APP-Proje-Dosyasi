import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class Step1HouseholdInfoWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>) onDataChanged;

  const Step1HouseholdInfoWidget({
    super.key,
    required this.data,
    required this.onDataChanged,
  });

  @override
  State<Step1HouseholdInfoWidget> createState() =>
      _Step1HouseholdInfoWidgetState();
}

class _Step1HouseholdInfoWidgetState extends State<Step1HouseholdInfoWidget> {
  late TextEditingController _sqmController;
  late TextEditingController _cityController;
  int _householdSize = 2;
  String _homeType = 'Daire';
  String? _sqmError;
  String? _cityError;

  final List<String> _homeTypes = [
    'Daire',
    'Müstakil Ev',
    'Villa',
    'Stüdyo',
    'Diğer',
  ];

  @override
  void initState() {
    super.initState();
    _householdSize = (widget.data['householdSize'] as int?) ?? 2;
    _homeType = (widget.data['homeType'] as String?) ?? 'Daire';
    _sqmController = TextEditingController(
      text: widget.data['squareMeters']?.toString() ?? '',
    );
    _cityController = TextEditingController(
      text: (widget.data['city'] as String?) ?? '',
    );
  }

  @override
  void dispose() {
    _sqmController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _updateData() {
    widget.onDataChanged({
      'householdSize': _householdSize,
      'homeType': _homeType,
      'squareMeters': _sqmController.text,
      'city': _cityController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hane Bilgilerinizi Girin',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Enerji tüketiminizi daha iyi analiz edebilmemiz için hane bilgilerinizi paylaşın.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          // Household Size
          Text(
            'Hane Büyüklüğü',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kişi Sayısı',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_householdSize > 1) {
                          setState(() => _householdSize--);
                          _updateData();
                        }
                      },
                      child: Container(
                        width: 10.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'remove',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$_householdSize',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        if (_householdSize < 10) {
                          setState(() => _householdSize++);
                          _updateData();
                        }
                      },
                      child: Container(
                        width: 10.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'add',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          // Home Type
          Text(
            'Konut Tipi',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          DropdownButtonFormField<String>(
            initialValue: _homeType,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'home',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            dropdownColor: theme.colorScheme.surface,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            items: _homeTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => _homeType = val);
                _updateData();
              }
            },
          ),
          SizedBox(height: 2.h),
          // Square Meters
          Text(
            'Yaklaşık Alan (m²)',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: _sqmController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Örn: 85',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'square_foot',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixText: 'm²',
              errorText: _sqmError,
            ),
            onChanged: (val) {
              setState(() {
                _sqmError = val.isEmpty ? 'Alan bilgisi gereklidir' : null;
              });
              _updateData();
            },
          ),
          SizedBox(height: 2.h),
          // City
          Text(
            'Şehir',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: _cityController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Örn: İstanbul',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'location_city',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              errorText: _cityError,
            ),
            onChanged: (val) {
              setState(() {
                _cityError = val.isEmpty ? 'Şehir bilgisi gereklidir' : null;
              });
              _updateData();
            },
          ),
        ],
      ),
    );
  }
}
