import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:time_clock_manager/controllers/auth_controller.dart';
import 'package:time_clock_manager/controllers/home_page_controller.dart';
import 'package:time_clock_manager/utils/time_tactic_utils.dart';

import '../../../widgets/dashboard_list_tile.dart';

class SideMenu extends StatelessWidget {
  final bool isAdmin;
  const SideMenu({
    Key? key,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("SideMenu build ${AuthController.instance.userRole.isAdmin}");
    return Drawer(
      backgroundColor: Color.fromARGB(255, 41, 45, 76),
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              HomePageContr.to.selectedPage.value = "Dashboard";
              Scaffold.of(context).closeDrawer();
            },
          ),
          Visibility(
            visible: isAdmin,
            child: Column(
              children: [
                DrawerListTile(
                  title: "Clockin Reports",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {
                    HomePageContr.to.selectedPage.value = "Reports";
                    Scaffold.of(context).closeDrawer();
                  },
                ),
                DrawerListTile(
                  title: "Roster Admin",
                  svgSrc: "assets/icons/roster.svg",
                  press: () {
                    HomePageContr.to.selectedPage.value = "Roster";
                    Scaffold.of(context).closeDrawer();
                  },
                ),
                DrawerListTile(
                  title: "Weekly Reports",
                  svgSrc: "assets/icons/menu_task.svg",
                  press: () {
                    HomePageContr.to.selectedPage.value = "Weekly Reports";
                    Scaffold.of(context).closeDrawer();
                  },
                ),
                DrawerListTile(
                  title: "Documents",
                  svgSrc: "assets/icons/menu_doc.svg",
                  press: () {
                    HomePageContr.to.selectedPage.value = "Documents";
                    Scaffold.of(context).closeDrawer();
                  },
                ),
                DrawerListTile(
                  title: "Daily Reports",
                  svgSrc: "assets/icons/menu_store.svg",
                  press: () {
                    HomePageContr.to.selectedPage.value = "Daily Reports";
                    Scaffold.of(context).closeDrawer();
                  },
                ),
                DrawerListTile(
                  title: "Deliveries",
                  svgSrc: "assets/icons/delivery.svg",
                  press: () {
                    HomePageContr.to.selectedPage.value = "Profile";
                    Scaffold.of(context).closeDrawer();
                  },
                ),
                DrawerListTile(
                  title: "Settings",
                  svgSrc: "assets/icons/menu_setting.svg",
                  press: () {
                    HomePageContr.to.selectedPage.value = "Settings";
                    Scaffold.of(context).closeDrawer();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
