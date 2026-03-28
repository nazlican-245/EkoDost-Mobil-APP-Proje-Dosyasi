import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnomalyCardWidget extends StatefulWidget {
  final Map<String, dynamic> anomaly;
  final VoidCallback onDismiss;
  final VoidCallback onInvestigate;

  const AnomalyCardWidget({
    super.key,
    required this.anomaly,
    required this.onDismiss,
    required this.onInvestigate,
  });

  @override
  State<AnomalyCardWidget> createState() => _AnomalyCardWidgetState();
}

class _AnomalyCardWidgetState extends State<AnomalyCardWidget> {
  bool _expanded = false;

  Color _severityColor(String severity) {
    switch (severity) {
      case 'high':
        return const Color(0xFFCF6679);
      case 'medium':
        return const Color(0xFFFF8C00);
      default:
        return const Color(0xFFFFD700);
    }
  }

  String _severityLabel(String severity) {
    switch (severity) {
      case 'high':
        return 'Yüksek';
      case 'medium':
        return 'Orta';
      default:
        return 'Düşük';
    }
  }

  @override
  Widget build(BuildContext context) {
    final severity = widget.anomaly['severity'] as String? ?? 'low';
    final color = _severityColor(severity);

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.anomaly['title'] as String? ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.3.h,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _severityLabel(severity),
                                style: GoogleFonts.inter(
                                  fontSize: 8.sp,
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          widget.anomaly['timestamp'] as String? ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 8.sp,
                            color: const Color(0xFFB0BEC5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: _expanded
                        ? 'keyboard_arrow_up'
                        : 'keyboard_arrow_down',
                    color: const Color(0xFFB0BEC5),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: const Color(0xFF2C3E50), height: 1),
                  SizedBox(height: 1.5.h),
                  Text(
                    widget.anomaly['description'] as String? ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      color: const Color(0xFFB0BEC5),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'bolt',
                        color: const Color(0xFFFFD700),
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Anormal tüketim: ${widget.anomaly['value'] ?? ''}',
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Nasıl hesaplandı? →',
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        color: const Color(0xFF00D4AA),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onDismiss,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFB0BEC5),
                            side: const BorderSide(color: Color(0xFF2C3E50)),
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Kapat',
                            style: GoogleFonts.inter(fontSize: 9.sp),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onInvestigate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color.withValues(alpha: 0.2),
                            foregroundColor: color,
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'İncele',
                            style: GoogleFonts.inter(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
