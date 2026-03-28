import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoalProbabilityWidget extends StatelessWidget {
  final double probability;
  final String goalName;
  final String motivationalMessage;
  final double currentKwh;
  final double targetKwh;

  const GoalProbabilityWidget({
    super.key,
    required this.probability,
    required this.goalName,
    required this.motivationalMessage,
    required this.currentKwh,
    required this.targetKwh,
  });

  Color get _probabilityColor {
    if (probability >= 0.75) return const Color(0xFF4CAF50);
    if (probability >= 0.5) return const Color(0xFFFFD700);
    return const Color(0xFFFF8C00);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2C3E50), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'flag',
                color: const Color(0xFF00D4AA),
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Hedef Başarı Olasılığı',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CircularPercentIndicator(
                radius: 12.w,
                lineWidth: 8,
                percent: probability.clamp(0.0, 1.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(probability * 100).toInt()}%',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'başarı',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        color: const Color(0xFFB0BEC5),
                      ),
                    ),
                  ],
                ),
                progressColor: _probabilityColor,
                backgroundColor: const Color(0xFF2C3E50),
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                animationDuration: 1000,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goalName,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      motivationalMessage,
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        color: const Color(0xFFB0BEC5),
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mevcut',
                                style: GoogleFonts.inter(
                                  fontSize: 8.sp,
                                  color: const Color(0xFFB0BEC5),
                                ),
                              ),
                              Text(
                                '${currentKwh.toStringAsFixed(1)} kWh',
                                style: GoogleFonts.inter(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hedef',
                                style: GoogleFonts.inter(
                                  fontSize: 8.sp,
                                  color: const Color(0xFFB0BEC5),
                                ),
                              ),
                              Text(
                                '${targetKwh.toStringAsFixed(1)} kWh',
                                style: GoogleFonts.inter(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _probabilityColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
