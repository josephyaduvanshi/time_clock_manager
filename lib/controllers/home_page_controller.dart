import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/screens/dashboard/dashboard_screen.dart';
import 'package:time_clock_manager/screens/past_reports_page.dart';
import 'package:time_clock_manager/screens/profile_page.dart';
import 'package:time_clock_manager/screens/reports_screen.dart';
import 'package:time_clock_manager/screens/settings_page.dart';
import 'package:time_clock_manager/screens/timetactic_analytics.dart';
import 'package:time_clock_manager/screens/timetactic_documents_page.dart';

class HomePageContr extends GetxController {
  var selectedPage = "Dashboard".obs;
  static HomePageContr get to => Get.find();
  final Map<String, Widget> pages = {
    "Dashboard": DashboardScreen(),
    "Documents": TimeTacticDocumentsPage(),
    "Analytics": TimeTacticAnalytics(),
    "Settings": SettingsPage(),
    "Reports": ReportsPage(),
    "Profile": ProfilePage(),
    "Past Reports": PastReportsPage(),
  };
}
