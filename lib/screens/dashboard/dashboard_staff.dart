import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/menu_item_model.dart';
import '../../navigation/route_strings.dart';
import '../../responsive.dart';

class DashboardStaffPage extends StatelessWidget {
  const DashboardStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> menuItems = [
      MenuItem(
        icon: Icons.view_list,
        label: "View Roster",
        onTap: () {
          Get.toNamed(RouteStrings.viewRoster);
          print("View Roster");
        },
      ),
      MenuItem(
        icon: Icons.request_page,
        label: "Leave Requests",
        onTap: () {
          print("Leave Requests");
        },
      ),
      MenuItem(
        icon: Icons.schedule,
        label: "Availability",
        onTap: () async {
          await Get.toNamed(RouteStrings.staffAvailable);
          print("Staff Availability");
        },
      ),
      MenuItem(
        icon: Icons.approval,
        label: "Replacement Requests",
        onTap: () {
          print("Stores");
        },
      ),
      MenuItem(
        icon: Icons.payments,
        label: "Pay Accumulated",
        onTap: () {
          print("Pay Accumulated");
        },
      ),
    ];
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
