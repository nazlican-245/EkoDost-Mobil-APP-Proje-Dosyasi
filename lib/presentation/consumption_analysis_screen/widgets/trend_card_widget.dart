import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TrendCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const TrendCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isPositive = data['isPositive'] as bool? ?? true;
    final double change = (data['change'] as num?)?.toDouble() ?? 0.0;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2C3E50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data['title'] as String? ?? '',
            style: const TextStyle(
              color: Color(0xFFB0BEC5),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Flexible(
            child: Text(
              data['value'] as String? ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Row(
            children: [
              CustomIconWidget(
                iconName: isPositive ? 'trending_down' : 'trending_up',
                color: isPositive
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFFF8C00),
                size: 14,
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
          Text(
            data['subtitle'] as String? ?? '',
            style: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 10),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
