import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/constants.dart';
import 'package:time_clock_manager/controllers/home_page_controller.dart';

import '../../responsive.dart';
import '../../widgets/header.dart';
import 'components/side_menu.dart';

class MainScreen extends GetView<HomePageContr> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: Responsive.isMobile(context),
          backgroundColor: bgColor,
          title: Responsive.isMobile(context)
              ? Row(
                  children: [
                    Expanded(
                      child: SearchField(), // Elongated search field for mobile
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      controller.selectedPage.value,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                        width: 20), // Spacing between title and search field
                    Expanded(
                      child: SearchField(),
                    ),
                  ],
                ),
          actions: [
            Padding(
              padding: EdgeInsets.all(8), // Adjust padding for spacing
              child: const ProfileCard(),
            ),
          ],
        ),
        drawer: const SideMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // We want this side menu only for large screen
              if (Responsive.isDesktop(context) || Responsive.isTablet(context))
                const Expanded(
                  // default flex = 1
                  // and it takes 1/6 part of the screen
                  child: SideMenu(),
                ),
              Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: controller.pages[controller.selectedPage.value]!,
              ),
            ],
          ),
        ),
      );
    });
  }
}
