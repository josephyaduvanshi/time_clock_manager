import 'package:get/get.dart';
import 'package:time_clock_manager/bindings/main_screen_bindings.dart';
import 'package:time_clock_manager/navigation/route_strings.dart';
import 'package:time_clock_manager/screens/auth/login_page.dart';
import 'package:time_clock_manager/screens/dashboard/dashboard_screen.dart';
import 'package:time_clock_manager/screens/main/main_screen.dart';
import 'package:time_clock_manager/screens/past_reports_page.dart';
import 'package:time_clock_manager/screens/reports_screen.dart';
import 'package:time_clock_manager/screens/settings_page.dart';
import 'package:time_clock_manager/screens/timetactic_analytics.dart';
import 'package:time_clock_manager/screens/timetactic_documents_page.dart';

class RouteLink {
  static List<GetPage<dynamic>>? routes = [
    GetPage(
      name: RouteStrings.home,
      page: () =>
          MainScreen(),
      binding: MainScreenBindings(),
    ),
    GetPage(
      name: RouteStrings.dashboard,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: RouteStrings.documents,
      page: () => const TimeTacticDocumentsPage(),
    ),
    GetPage(
      name: RouteStrings.analytics,
      page: () => const TimeTacticAnalytics(),
    ),
    GetPage(
      name: RouteStrings.settings,
      page: () => const SettingsPage(),
    ),
    GetPage(
      name: RouteStrings.reports,
      page: () => const ReportsPage(),
    ),
    GetPage(
      name: RouteStrings.pastReports,
      page: () => const PastReportsPage(),
    ),
    GetPage(
      name: RouteStrings.login,
      page: () =>  LoginPage(),
    ),
  ];
}
