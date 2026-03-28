/// Core calculation constants and helpers for energy/CO₂ computations.
///
/// All screens and widgets MUST import these constants instead of
/// hardcoding values. This ensures a single source of truth for
/// CO2_FACTOR and TREE_ABSORPTION across the entire application.
library;

// ── Constants ──────────────────────────────────────────────────────────────

/// kg CO₂ emitted per kWh of electricity consumed (Turkey grid average).
/// Spec: co2Saved = (baselineKWh - actualKWh) * 0.45
const double CO2_FACTOR = 0.45;

/// kg CO₂ absorbed by one mature tree per year (~21 kg/year).
/// Spec: treesEquivalent = co2Saved / 21
const double TREE_ABSORPTION = 21.0;

// ── Helper functions ───────────────────────────────────────────────────────

/// Returns kg CO₂ produced by [kWh] units of electricity.
double co2FromKWh(double kWh) => kWh * CO2_FACTOR;

/// Returns CO₂ saved (kg) when [savedKWh] kWh were avoided vs baseline.
///
/// Spec: co2Saved = (baselineKWh - actualKWh) * 0.45
/// When called with savedKWh = baselineKWh - actualKWh, result is correct.
double co2Saved(double savedKWh) => savedKWh * CO2_FACTOR;

/// Returns the number of trees equivalent to absorbing [co2Kg] kg of CO₂.
///
/// Spec: treesEquivalent = co2Saved / 21
double treesEquivalent(double co2Kg, {int days = 30}) {
  return co2Kg / TREE_ABSORPTION;
}

/// Returns goal progress percentage clamped to [0, 100].
///
/// Spec: goalProgress = ((goalKWh - actualKWh) / goalKWh * 100).clamp(0, 100)
/// Returns 0 when goalKWh is zero or negative.
double goalProgress(double goalKWh, double actualKWh) {
  if (goalKWh <= 0) return 0.0;
  return ((goalKWh - actualKWh) / goalKWh * 100.0).clamp(0.0, 100.0);
}

/// Increments streak count by 1 on a successful day.
int incrementStreak(int currentStreak) => currentStreak + 1;

/// Resets streak to 0 (called only when shield count is 0).
int resetStreak() => 0;

/// Applies a shield: streak is preserved, shield count decremented.
/// Returns the new shield count (minimum 0).
int useStreakShield(int currentShields) =>
    (currentShields - 1).clamp(0, currentShields);

/// Masks the middle segment(s) of a dash-separated meter/sayaç number.
///
/// Example: TR-2024-00847 → TR-****-00847
/// Keeps the first and last segments visible; replaces all middle segments
/// with asterisks of the same length.
String maskSensitiveNumber(String value) {
  final parts = value.split('-');
  if (parts.length < 3) return value;
  final masked = parts
      .sublist(1, parts.length - 1)
      .map((p) => '*' * p.length)
      .toList();
  return [parts.first, ...masked, parts.last].join('-');
}
