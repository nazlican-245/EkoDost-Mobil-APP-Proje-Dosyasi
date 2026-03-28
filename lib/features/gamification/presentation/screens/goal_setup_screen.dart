import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/widgets/goal_progress_bar.dart';
import '../../../../core/utils/calculations.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/custom_icon_widget.dart';

/// GoalSetupScreen
///
/// Allows the user to configure a new energy goal and submit it via
/// POST /goals.
///
/// Fields:
///   • goalPeriod  — DropdownButtonFormField (günlük / haftalık / aylık)
///   • goalKWh     — TextFormField (numeric, > 0 and < kWhMonth)
///   • goalDeadline — auto-calculated from period, shown read-only
///
/// On submit: calls the provided [onSubmitGoal] callback with the
/// selected values, then pops the route.
///
/// Pass [kWhMonth] from the consumption provider so the validator can
/// enforce goalKWh < kWhMonth.
class GoalSetupScreen extends StatefulWidget {
  /// Current month's kWh consumption — used for upper-bound validation.
  final double kWhMonth;

  /// Called with (goalKWh, goalPeriod, goalDeadline) when the form is
  /// valid and the user confirms.  Perform the POST /goals call here.
  final Future<void> Function(
    double goalKWh,
    String goalPeriod,
    DateTime goalDeadline,
  )?
  onSubmitGoal;

  const GoalSetupScreen({super.key, required this.kWhMonth, this.onSubmitGoal});

  @override
  State<GoalSetupScreen> createState() => _GoalSetupScreenState();
}

class _GoalSetupScreenState extends State<GoalSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _kWhController = TextEditingController();

  String _selectedPeriod = 'monthly';
  bool _isSubmitting = false;

  // ── Deadline calculation ─────────────────────────────────────────────────

  DateTime _calculateDeadline(String period) {
    final now = DateTime.now();
    switch (period) {
      case 'daily':
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
      case 'weekly':
        // End of the current ISO week (Sunday)
        final daysUntilSunday = 7 - now.weekday;
        final sunday = now.add(Duration(days: daysUntilSunday));
        return DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
      case 'monthly':
      default:
        // Last moment of the current month
        final lastDay = DateTime(now.year, now.month + 1, 0);
        return DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
    }
  }

  String _deadlineDisplayLabel(String period) {
    final deadline = _calculateDeadline(period);
    final months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    switch (period) {
      case 'daily':
        return 'Bugün 23:59';
      case 'weekly':
        return '${deadline.day} ${months[deadline.month - 1]} ${deadline.year}, 23:59';
      case 'monthly':
      default:
        return '${deadline.day} ${months[deadline.month - 1]} ${deadline.year}, 23:59';
    }
  }

  // ── Validation ───────────────────────────────────────────────────────────

  String? _validateKWh(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Lütfen bir kWh değeri girin.';
    }
    final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
    if (parsed == null) {
      return 'Geçerli bir sayı girin.';
    }
    if (parsed <= 0) {
      return 'Hedef 0 kWh\'den büyük olmalıdır.';
    }
    if (parsed >= widget.kWhMonth) {
      return 'Hedef bu ayki tüketiminizden (${widget.kWhMonth.toStringAsFixed(1)} kWh) küçük olmalıdır.';
    }
    return null;
  }

  // ── Submit ───────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final goalKWh = double.parse(
      _kWhController.text.trim().replaceAll(',', '.'),
    );
    final deadline = _calculateDeadline(_selectedPeriod);

    setState(() => _isSubmitting = true);

    try {
      await widget.onSubmitGoal?.call(goalKWh, _selectedPeriod, deadline);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Hedef başarıyla oluşturuldu! 🎯',
              style: GoogleFonts.inter(color: AppTheme.textPrimary),
            ),
            backgroundColor: AppTheme.successIndicator,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Hedef kaydedilemedi. Lütfen tekrar deneyin.',
              style: GoogleFonts.inter(color: AppTheme.textPrimary),
            ),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _kWhController.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deadline = _calculateDeadline(_selectedPeriod);

    // Preview progress — 0 until user enters a value
    final enteredKWh =
        double.tryParse(_kWhController.text.trim().replaceAll(',', '.')) ?? 0.0;
    // Spec: goalProgress = ((goalKWh - actualKWh) / goalKWh * 100).clamp(0, 100)
    final previewProgress = enteredKWh > 0
        ? goalProgress(enteredKWh, widget.kWhMonth)
        : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceCard,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppTheme.textPrimary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Enerji Hedefi Kur',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Info banner ───────────────────────────────────────────
                Container(
                  padding: EdgeInsets.all(3.5.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: AppTheme.primaryAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'lightbulb_outline',
                        color: AppTheme.primaryAccent,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Bu ayki tüketiminiz: ${widget.kWhMonth.toStringAsFixed(1)} kWh. Hedef bu değerden küçük olmalıdır.',
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            color: AppTheme.primaryAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // ── Period picker ─────────────────────────────────────────
                Text(
                  'Hedef Dönemi',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 1.h),
                DropdownButtonFormField<String>(
                  initialValue: _selectedPeriod,
                  dropdownColor: AppTheme.surfaceCard,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppTheme.textPrimary,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.surfaceCard,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: AppTheme.dividerSubtle),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: AppTheme.dividerSubtle),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppTheme.primaryAccent,
                        width: 2,
                      ),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Günlük')),
                    DropdownMenuItem(value: 'weekly', child: Text('Haftalık')),
                    DropdownMenuItem(value: 'monthly', child: Text('Aylık')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedPeriod = value);
                    }
                  },
                ),

                SizedBox(height: 2.5.h),

                // ── kWh input ─────────────────────────────────────────────
                Text(
                  'Hedef Tüketim (kWh)',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _kWhController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppTheme.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Örn: 150',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppTheme.textSecondary,
                    ),
                    suffixText: 'kWh',
                    suffixStyle: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppTheme.primaryAccent,
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceCard,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: AppTheme.dividerSubtle),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: AppTheme.dividerSubtle),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppTheme.primaryAccent,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFFE53935)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFE53935),
                        width: 2,
                      ),
                    ),
                    errorStyle: GoogleFonts.inter(
                      fontSize: 9.sp,
                      color: const Color(0xFFE53935),
                    ),
                  ),
                  validator: _validateKWh,
                  onChanged: (_) => setState(() {}),
                ),

                SizedBox(height: 2.5.h),

                // ── Deadline (read-only) ───────────────────────────────────
                Text(
                  'Bitiş Tarihi',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.dividerSubtle.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppTheme.dividerSubtle),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'event',
                        color: AppTheme.textSecondary,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        _deadlineDisplayLabel(_selectedPeriod),
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // ── Live preview ──────────────────────────────────────────
                if (enteredKWh > 0 && enteredKWh < widget.kWhMonth) ...[
                  Text(
                    'Önizleme',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(3.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: AppTheme.primaryAccent.withValues(alpha: 0.2),
                      ),
                    ),
                    child: GoalProgressBar(
                      progress: previewProgress,
                      goalKWh: enteredKWh,
                      currentKWh: widget.kWhMonth,
                      deadline: deadline,
                    ),
                  ),
                  SizedBox(height: 3.h),
                ],

                // ── Submit button ─────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryAccent,
                      foregroundColor: AppTheme.primaryBackground,
                      disabledBackgroundColor: AppTheme.primaryAccent
                          .withValues(alpha: 0.5),
                      padding: EdgeInsets.symmetric(vertical: 1.8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 2,
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryBackground,
                              ),
                            ),
                          )
                        : Text(
                            'Hedefi Kaydet',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
