import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/controllers/auth_controller.dart';
import 'package:time_clock_manager/navigation/route_strings.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/menu_item_model.dart';
import '../responsive.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  // Step 3: Create a List of Menu Items
  final List<MenuItem> menuItems = [
    MenuItem(
      icon: Icons.emoji_people,
      label: "User Update",
      onTap: () {
        print("User Update");
      },
    ),
    MenuItem(icon: Icons.person, label: "Profile Update", onTap: () {}),
    MenuItem(icon: Icons.security, label: "Security", onTap: () {}),
    MenuItem(icon: Icons.person_add, label: "Create Employee", onTap: () {}),
    MenuItem(
        icon: Icons.password_rounded,
        label: "User Pins",
        onTap: () {
          Get.toNamed(RouteStrings.usersPin);
        }),
    MenuItem(icon: Icons.settings, label: "App Settings", onTap: () {}),
    MenuItem(
        icon: Icons.create,
        label: "Create Account",
        onTap: () {
          Get.toNamed(RouteStrings.signUp);
        }),
    MenuItem(
        icon: Icons.logout,
        label: "Logout",
        onTap: () async {
          await AuthController.instance.signOut();
          Get.offAllNamed(RouteStrings.login);
        }),
  ];

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Wrap(
          spacing: 30,
          runSpacing: 20,
          children: menuItems
              .map((item) => OutlinedButton.icon(
                    icon: Icon(item.icon),
                    onPressed: item.onTap,
                    style: OutlinedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      backgroundColor: Colors.transparent,
                    ),
                    label: item.label.text.make().p(16),
                  ).pOnly(bottom: 8))
              .toList(),
        ).p(20).centered().py(20),
      ),
      desktop: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return OutlinedButton.icon(
            icon: Icon(item.icon),
            onPressed: item.onTap,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(10),
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            label: item.label.text.make().p(10),
          );
        },
      ).p(20),
    );
  }
}
