import 'package:flutter/material.dart';
import '../presentation/consumption_analysis_screen/consumption_analysis_screen.dart';
import '../presentation/household_profile_setup_screen/household_profile_setup_screen.dart';
import '../presentation/predictions_and_alerts_screen/predictions_and_alerts_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/real_time_dashboard_screen/real_time_dashboard_screen.dart';
import '../presentation/gamification_hub_screen/gamification_hub_screen.dart';
import '../features/gamification/presentation/gamification_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String consumptionAnalysis = '/consumption-analysis-screen';
  static const String householdProfileSetup = '/household-profile-setup-screen';
  static const String predictionsAndAlerts = '/predictions-and-alerts-screen';
  static const String authentication = '/authentication-screen';
  static const String realTimeDashboard = '/real-time-dashboard-screen';
  static const String gamificationHub = '/gamification-hub-screen';
  static const String gamification = '/gamification-screen';
  static const String profile = '/profile-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const RealTimeDashboardScreen(),
    consumptionAnalysis: (context) => const ConsumptionAnalysisScreen(),
    householdProfileSetup: (context) => const HouseholdProfileSetupScreen(),
    predictionsAndAlerts: (context) => const PredictionsAndAlertsScreen(),
    authentication: (context) => const AuthenticationScreen(),
    realTimeDashboard: (context) => const RealTimeDashboardScreen(),
    gamificationHub: (context) => const GamificationHubScreen(),
    gamification: (context) => const GamificationScreen(),
    profile: (context) => const ProfileScreen(),
    // TODO: Add your other routes here
  };
}
