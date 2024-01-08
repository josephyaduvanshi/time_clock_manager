import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/controllers/home_page_controller.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          DrawerListTile(
            title: "Reports",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              HomePageContr.to.selectedPage.value = "Reports";
              Scaffold.of(context).closeDrawer();
            },
          ),
          DrawerListTile(
            title: "Analytics",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              HomePageContr.to.selectedPage.value = "Analytics";
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
            title: "Past Reports",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              HomePageContr.to.selectedPage.value = "Past Reports";
              Scaffold.of(context).closeDrawer();
            },
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
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
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListTile(
        selected: HomePageContr.to.selectedPage.value == title,
        selectedTileColor: Colors.white10,
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: SvgPicture.asset(
          svgSrc,
          colorFilter: const ColorFilter.mode(
              Color.fromARGB(136, 255, 255, 255), BlendMode.srcIn),
          height: 16,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white54),
        ),
      );
    });
  }
}
