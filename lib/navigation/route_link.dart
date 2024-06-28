import 'package:get/get.dart';
import 'package:time_clock_manager/bindings/main_screen_bindings.dart';
import 'package:time_clock_manager/navigation/route_strings.dart';
import 'package:time_clock_manager/navigation/staff_availability_bindings.dart';
import 'package:time_clock_manager/navigation/view_roster_page_bindings.dart';
import 'package:time_clock_manager/screens/auth/login_page.dart';
import 'package:time_clock_manager/screens/auth/sign_up_page.dart';
import 'package:time_clock_manager/screens/dashboard/dashboard_screen.dart';
import 'package:time_clock_manager/screens/main/main_screen.dart';
import 'package:time_clock_manager/screens/daily_reports/daily_reports_page.dart';
import 'package:time_clock_manager/screens/reports_screen.dart';
import 'package:time_clock_manager/screens/roster/create_roster_screen.dart';
import 'package:time_clock_manager/screens/roster/staff_availability_page.dart';
import 'package:time_clock_manager/screens/roster/view_roster_page.dart';
import 'package:time_clock_manager/screens/settings_page.dart';
import 'package:time_clock_manager/screens/timetactic_analytics.dart';
import 'package:time_clock_manager/screens/timetactic_documents_page.dart';

import '../screens/users_pins_page.dart';
import 'users_pin_binding.dart';

class RouteLink {
  static List<GetPage<dynamic>>? routes = [
    GetPage(
      name: RouteStrings.home,
      page: () => MainScreen(),
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
      name: RouteStrings.weeklyReports,
      page: () => WeeklyReportPage(),
    ),
    GetPage(
      name: RouteStrings.settings,
      page: () => SettingsPage(),
    ),
    GetPage(
      name: RouteStrings.reports,
      page: () => const ReportsPage(),
    ),
    GetPage(
      name: RouteStrings.dailyReports,
      page: () => const DailyReportsPage(),
    ),
    GetPage(
      name: RouteStrings.login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: RouteStrings.signUp,
      page: () => SignUpUI(),
    ),
    GetPage(
      name: RouteStrings.usersPin,
      page: () => UsersPinPage(),
      binding: UsersPinBinding(),
    ),
    GetPage(
      name: RouteStrings.staffAvailable,
      page: () => StaffAvailabilityPage(),
      binding: StaffAvailabilityBindings(),
    ),
    GetPage(
      name: RouteStrings.viewRoster,
      page: () => ViewRosterPage(),
      binding: ViewRosterBindings(),
    ),
    GetPage(
      name: RouteStrings.createRoster,
      page: () => CreateRosterPage(),
      // binding: UsersPinBinding(),
    ),
  ];
}
