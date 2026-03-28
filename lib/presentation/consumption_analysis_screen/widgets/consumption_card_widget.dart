import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ConsumptionCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const ConsumptionCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isPositive = data['isPositive'] as bool? ?? true;
    final double change = (data['change'] as num?)?.toDouble() ?? 0.0;
    final double kwh = (data['kwh'] as num?)?.toDouble() ?? 0.0;

    return Container(
      width: 28.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPositive
              ? const Color(0xFF4CAF50).withValues(alpha: 0.4)
              : const Color(0xFFFF8C00).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data['date'] as String? ?? '',
            style: const TextStyle(
              color: Color(0xFFB0BEC5),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${kwh.toStringAsFixed(1)} kWh',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.4.h),
              Text(
                data['cost'] as String? ?? '',
                style: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Row(
            children: [
              CustomIconWidget(
                iconName: isPositive ? 'arrow_downward' : 'arrow_upward',
                color: isPositive
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFFF8C00),
                size: 12,
              ),
              SizedBox(width: 1.w),
              Flexible(
                child: Text(
                  '${change.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isPositive
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFFF8C00),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
