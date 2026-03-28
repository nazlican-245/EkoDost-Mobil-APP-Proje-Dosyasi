import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertSettingsPanelWidget extends StatefulWidget {
  final VoidCallback onClose;

  const AlertSettingsPanelWidget({super.key, required this.onClose});

  @override
  State<AlertSettingsPanelWidget> createState() =>
      _AlertSettingsPanelWidgetState();
}

class _AlertSettingsPanelWidgetState extends State<AlertSettingsPanelWidget> {
  double _sensitivity = 0.7;
  bool _pushEnabled = true;
  bool _emailEnabled = false;
  bool _highConsumptionAlert = true;
  bool _anomalyAlert = true;
  bool _goalAlert = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A2332),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'tune',
                color: const Color(0xFF00D4AA),
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Uyarı Ayarları',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onClose,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: const Color(0xFFB0BEC5),
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Hassasiyet Seviyesi',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              color: const Color(0xFFB0BEC5),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _sensitivity,
                  onChanged: (v) => setState(() => _sensitivity = v),
                  activeColor: const Color(0xFF00D4AA),
                  inactiveColor: const Color(0xFF2C3E50),
                ),
              ),
              Text(
                '${(_sensitivity * 100).toInt()}%',
                style: GoogleFonts.inter(fontSize: 9.sp, color: Colors.white),
              ),
            ],
          ),
          Divider(color: const Color(0xFF2C3E50)),
          SizedBox(height: 1.h),
          Text(
            'Bildirim Yöntemi',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 1.h),
          _switchRow(
            'Anlık Bildirim',
            _pushEnabled,
            (v) => setState(() => _pushEnabled = v),
            Icons.notifications_active,
          ),
          _switchRow(
            'E-posta',
            _emailEnabled,
            (v) => setState(() => _emailEnabled = v),
            Icons.email,
          ),
          Divider(color: const Color(0xFF2C3E50)),
          SizedBox(height: 1.h),
          Text(
            'Uyarı Türleri',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 1.h),
          _switchRow(
            'Yüksek Tüketim',
            _highConsumptionAlert,
            (v) => setState(() => _highConsumptionAlert = v),
            Icons.warning_amber,
          ),
          _switchRow(
            'Anomali Tespiti',
            _anomalyAlert,
            (v) => setState(() => _anomalyAlert = v),
            Icons.search,
          ),
          _switchRow(
            'Hedef Uyarıları',
            _goalAlert,
            (v) => setState(() => _goalAlert = v),
            Icons.flag,
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onClose,
              child: Text(
                'Kaydet',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _switchRow(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon.codePoint.toRadixString(16),
            color: const Color(0xFFB0BEC5),
            size: 18,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.white),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF00D4AA),
          ),
        ],
      ),
    );
  }
}
