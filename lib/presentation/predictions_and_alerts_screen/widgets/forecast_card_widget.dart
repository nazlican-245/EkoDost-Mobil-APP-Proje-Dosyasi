import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ForecastCardWidget extends StatelessWidget {
  final double predictedAmount;
  final double confidenceLow;
  final double confidenceHigh;
  final double progressValue;
  final String month;

  const ForecastCardWidget({
    super.key,
    required this.predictedAmount,
    required this.confidenceLow,
    required this.confidenceHigh,
    required this.progressValue,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1A2332), const Color(0xFF0F1E35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00D4AA).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'receipt_long',
                color: const Color(0xFF00D4AA),
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Fatura Tahmini',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF00D4AA),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4AA).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  month,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    color: const Color(0xFF00D4AA),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tahmini Tutar',
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        color: const Color(0xFFB0BEC5),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '₺${predictedAmount.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Güven Aralığı: ₺${confidenceLow.toStringAsFixed(0)} - ₺${confidenceHigh.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        color: const Color(0xFFB0BEC5),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 3.w),
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progressValue,
                      strokeWidth: 6,
                      backgroundColor: const Color(0xFF2C3E50),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progressValue > 0.8
                            ? const Color(0xFFFF8C00)
                            : const Color(0xFF00D4AA),
                      ),
                    ),
                    Text(
                      '${(progressValue * 100).toInt()}%',
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 6,
              backgroundColor: const Color(0xFF2C3E50),
              valueColor: AlwaysStoppedAnimation<Color>(
                progressValue > 0.8
                    ? const Color(0xFFFF8C00)
                    : const Color(0xFF00D4AA),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ay başı',
                style: GoogleFonts.inter(
                  fontSize: 8.sp,
                  color: const Color(0xFFB0BEC5),
                ),
              ),
              Text(
                'Ay sonu',
                style: GoogleFonts.inter(
                  fontSize: 8.sp,
                  color: const Color(0xFFB0BEC5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
