import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/step1_household_info_widget.dart';
import './widgets/step2_meter_connection_widget.dart';
import './widgets/step3_group_assignment_widget.dart';
import './widgets/step4_summary_widget.dart';
import './widgets/step_indicator_widget.dart';

class HouseholdProfileSetupScreen extends StatefulWidget {
  const HouseholdProfileSetupScreen({super.key});

  @override
  State<HouseholdProfileSetupScreen> createState() =>
      _HouseholdProfileSetupScreenState();
}

class _HouseholdProfileSetupScreenState
    extends State<HouseholdProfileSetupScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 1;
  final int _totalSteps = 4;
  bool _isCompleting = false;

  final Map<String, dynamic> _step1Data = {
    'householdSize': 2,
    'homeType': 'Daire',
    'squareMeters': '',
    'city': '',
  };

  final Map<String, dynamic> _step2Data = {
    'meterId': '',
    'meterConnected': false,
  };

  final Map<String, dynamic> _step3Data = {
    'groupName': 'Kontrol Grubu A',
    'experimentName': 'EkoDost Pilot Çalışması 2026',
    'cohortId': 'EKD-2026-C01',
  };

  late AnimationController _celebrationController;
  late Animation<double> _celebrationAnimation;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _celebrationAnimation = CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    );
    _loadSavedData();
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedStep1 = prefs.getString('household_step1');
      final savedStep2 = prefs.getString('household_step2');
      if (savedStep1 != null) {
        final decoded = jsonDecode(savedStep1) as Map<String, dynamic>;
        setState(() => _step1Data.addAll(decoded));
      }
      if (savedStep2 != null) {
        final decoded = jsonDecode(savedStep2) as Map<String, dynamic>;
        setState(() => _step2Data.addAll(decoded));
      }
    } catch (_) {}
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('household_step1', jsonEncode(_step1Data));
      await prefs.setString('household_step2', jsonEncode(_step2Data));
    } catch (_) {}
  }

  bool _validateCurrentStep() {
    if (_currentStep == 1) {
      final sqm = (_step1Data['squareMeters'] as String?) ?? '';
      final city = (_step1Data['city'] as String?) ?? '';
      if (sqm.isEmpty || city.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lütfen tüm alanları doldurun.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return false;
      }
    }
    return true;
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
      _saveData();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _completeSetup() async {
    setState(() => _isCompleting = true);
    await _celebrationController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _isCompleting = false);
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamed('/real-time-dashboard-screen');
    }
  }

  void _skipSetup() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/real-time-dashboard-screen');
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return Step1HouseholdInfoWidget(
          data: _step1Data,
          onDataChanged: (data) => setState(() => _step1Data.addAll(data)),
        );
      case 2:
        return Step2MeterConnectionWidget(
          data: _step2Data,
          onDataChanged: (data) => setState(() => _step2Data.addAll(data)),
        );
      case 3:
        return Step3GroupAssignmentWidget(data: _step3Data);
      case 4:
        return Step4SummaryWidget(
          allData: {
            'step1': _step1Data,
            'step2': _step2Data,
            'step3': _step3Data,
          },
          onEditStep1: () => setState(() => _currentStep = 1),
          onEditStep2: () => setState(() => _currentStep = 2),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentStep > 1
                      ? GestureDetector(
                          onTap: _prevStep,
                          child: Container(
                            width: 10.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'arrow_back_ios',
                                color: theme.colorScheme.onSurface,
                                size: 18,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(width: 10.w),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'bolt',
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'EkoDost',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _skipSetup,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      minimumSize: Size(10.w, 5.h),
                    ),
                    child: Text(
                      'Atla',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              // Step Indicator
              StepIndicatorWidget(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
              ),
              SizedBox(height: 2.h),
              // Step Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(_currentStep),
                    child: _buildCurrentStep(),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              // Bottom Button
              ScaleTransition(
                scale: _currentStep == 4
                    ? _celebrationAnimation
                    : const AlwaysStoppedAnimation(1.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isCompleting
                        ? null
                        : _currentStep == _totalSteps
                        ? _completeSetup
                        : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentStep == _totalSteps
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isCompleting
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.onPrimary,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentStep == _totalSteps
                                    ? 'Kurulumu Tamamla'
                                    : 'İleri',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                iconName: _currentStep == _totalSteps
                                    ? 'check_circle'
                                    : 'arrow_forward',
                                color: theme.colorScheme.onPrimary,
                                size: 20,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
