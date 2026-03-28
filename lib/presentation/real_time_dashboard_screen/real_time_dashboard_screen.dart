import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_bar.dart';
import './real_time_dashboard_screen_initial_page.dart';

class RealTimeDashboardScreen extends StatefulWidget {
  const RealTimeDashboardScreen({super.key});

  @override
  RealTimeDashboardScreenState createState() => RealTimeDashboardScreenState();
}

class RealTimeDashboardScreenState extends State<RealTimeDashboardScreen> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int currentIndex = 0;

  final List<String> routes = [
    '/real-time-dashboard-screen',
    '/consumption-analysis-screen',
    '/gamification-screen',
    '/profile-screen',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomInset: true,
      body: Navigator(
        key: navigatorKey,
        initialRoute: '/real-time-dashboard-screen',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/real-time-dashboard-screen' || '/':
              return MaterialPageRoute(
                builder: (context) =>
                    const RealTimeDashboardScreenInitialPage(),
                settings: settings,
              );
            default:
              if (AppRoutes.routes.containsKey(settings.name)) {
                return MaterialPageRoute(
                  builder: AppRoutes.routes[settings.name]!,
                  settings: settings,
                );
              }
              return null;
          }
        },
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (!AppRoutes.routes.containsKey(routes[index])) {
            return;
          }
          if (currentIndex != index) {
            setState(() => currentIndex = index);
            navigatorKey.currentState?.pushReplacementNamed(routes[index]);
          }
        },
      ),
    );
  }
}
