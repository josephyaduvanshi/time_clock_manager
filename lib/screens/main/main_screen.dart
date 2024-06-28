import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_clock_manager/constants.dart';
import 'package:time_clock_manager/controllers/auth_controller.dart';
import 'package:time_clock_manager/controllers/home_page_controller.dart';
import 'package:time_clock_manager/models/enployee_model.dart';
import 'package:time_clock_manager/utils/time_tactic_utils.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../main.dart';
import '../../responsive.dart';
import '../../widgets/header.dart';
import '../../widgets/profile_card.dart';
import 'components/side_menu.dart';

class MainScreen extends GetView<HomePageContr> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Store storeName =
        AuthController.instance.firestoreUser.value?.store ?? Store.GREENWAY;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: Responsive.isMobile(context),
        backgroundColor: bgColor,
        title: Responsive.isMobile(context)
            ? Obx(() {
                return Visibility(
                  visible: AuthController.instance.userRole.isAdmin,
                  replacement: "Time Tactician"
                      .text
                      .textStyle(
                        GoogleFonts.pacifico(),
                      )
                      .xl4
                      .make(),
                  child: Row(
                    children: [
                      Expanded(
                        child:
                            SearchField(), // Elongated search field for mobile
                      ),
                    ],
                  ),
                );
              })
            : Obx(() {
                return Row(
                  children: [
                    Text(
                      controller.selectedPage.value,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(width: 20),
                    Visibility(
                      visible: AuthController.instance.userRole.isAdmin,
                      replacement: Expanded(
                        child:
                            "Manoosh ${storeName.name.firstLetterUpperCase()}"
                                .text
                                .xl4
                                .textStyle(
                                  GoogleFonts.pacifico(),
                                )
                                .make()
                                .centered()
                                .shimmer(
                                    showGradient: true,
                                    duration: const Duration(seconds: 10),
                                    gradient: const LinearGradient(
                                      colors: [Vx.purple400, Vx.blue500],
                                    )),
                      ),
                      child: Expanded(
                        child: SearchField(),
                      ),
                    ),
                  ],
                );
              }),
        actions: [
          Padding(
            padding: EdgeInsets.all(8), // Adjust padding for spacing
            child: const ProfileCard(),
          ),
        ],
      ),
      drawer: SideMenu(
        // We want this side menu only for large screen
        isAdmin: isAdmin.value,
      ),
      body: Obx(() {
        return SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // We want this side menu only for large screen
              if (Responsive.isDesktop(context) || Responsive.isTablet(context))
                Expanded(
                  // default flex = 1
                  // and it takes 1/6 part of the screen
                  child: SideMenu(
                    isAdmin: isAdmin.value,
                  ),
                ),
              Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: controller.pages[controller.selectedPage.value]!,
              ),
            ],
          ),
        );
      }),
    );
  }
}
