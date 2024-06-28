import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/main.dart';
import 'package:time_clock_manager/screens/dashboard/dashboard_clockin.dart';
import 'package:time_clock_manager/screens/dashboard/dashboard_screen.dart';
import 'package:time_clock_manager/screens/dashboard/dashboard_staff.dart';
import 'package:time_clock_manager/screens/daily_reports/daily_reports_page.dart';
import 'package:time_clock_manager/screens/profile_page.dart';
import 'package:time_clock_manager/screens/reports_screen.dart';
import 'package:time_clock_manager/screens/settings_page.dart';
import 'package:time_clock_manager/screens/timetactic_analytics.dart';
import 'package:time_clock_manager/screens/timetactic_documents_page.dart';

import '../screens/roster/roster_page.dart';

class HomePageContr extends GetxController {
  var selectedPage = "Dashboard".obs;

  static HomePageContr get to => Get.find();
  final Map<String, Widget> pages = {
    "Dashboard": isAdmin.isTrue
        ? DashboardScreen()
        : isStaff.isTrue
            ? DashboardStaffPage()
            : ClockinClockOutApp(),
    "Documents": TimeTacticDocumentsPage(),
    "Weekly Reports": WeeklyReportPage(),
    "Settings": SettingsPage(),
    "Reports": ReportsPage(),
    "Profile": ProfilePage(),
    "Daily Reports": DailyReportsPage(),
    "Roster": RosterPage(),
  };
}
