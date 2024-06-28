import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/controllers/auth_controller.dart';
import 'package:time_clock_manager/controllers/clockin_report_firestore_controller.dart';
import 'package:time_clock_manager/controllers/dashboard_clockin_controller.dart';
import 'package:time_clock_manager/responsive.dart';

import '../constants.dart';
import '../navigation/route_strings.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cont = AuthController.instance;
    return Obx(() {
      print(cont.firestoreUser.value?.avatar);
      return Container(
        margin: const EdgeInsets.only(left: defaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              // backgroundImage: NetworkImage(
              //   cont.firestoreUser.value?.photoUrl.toString() ??
              //       "https://www.gravatar.com/avatar/getee",
              // ),
              child: cont.firestoreUser.value?.avatar == null
                  ? CachedNetworkImage(
                      imageUrl: "https://www.gravatar.com/avatar/getee",
                    )
                  : CachedNetworkImage(
                      imageUrl: cont.firestoreUser.value?.avatar.toString() ??
                          "https://www.gravatar.com/avatar/getee"),
            ),
            if (!Responsive.isMobile(context))
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  child: cont.firestoreUser.value?.name == null
                      ? Text("Guest")
                      : Text(
                          "${cont.firestoreUser.value?.name}",
                          style: TextStyle(color: Colors.white),
                        )),
            PopupMenuButton(
                icon: const Icon(Icons.keyboard_arrow_down),
                padding: EdgeInsets.zero,
                position: PopupMenuPosition.under,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: TextButton(
                        onPressed: () async {
                          await ClockinReportFireStoreController.to
                              .addUserIdToAllEmployees();
                        },
                        child: Text("Settings"),
                      ),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                        onPressed: () {
                          if (Get.isRegistered<DashBoardClockInController>()) {
                            Get.find<DashBoardClockInController>().onClose();
                          }
                          cont.signOut();
                          Get.offAllNamed(RouteStrings.login);
                        },
                        child: Text("Sign Out"),
                      ),
                    ),
                  ];
                })
          ],
        ),
      );
    });
  }
}
