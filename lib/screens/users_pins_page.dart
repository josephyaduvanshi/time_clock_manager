import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants.dart';
import '../controllers/users_pin_controller.dart';
import '../responsive.dart';

class UsersPinPage extends GetView<UsersPinController> {
  const UsersPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UsersPinController());
    log("UsersPinPage build");
    return Scaffold(
      appBar: AppBar(
        title: "Users Pin".text.make(),
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final employees = controller.employees;
        if (employees.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: employees.length,
          itemBuilder: (context, index) {
            return Responsive(
              mobile: CustomEmployeeCardWeb(
                userName: employees[index].name,
                index: index + 1,
                pin: employees[index].pin,
                // darkMode: true,
                // borderColor: Colors.blueGrey,
                // primaryShimmerColor: Colors.blue,
                // secondaryShimmerColor: Colors.blueAccent,
              ).px(20),
              tablet: CustomEmployeeCardWeb(
                userName: employees[index].name,
                index: index + 1,
                pin: employees[index].pin,
              ).px(50), // Example adjustment for tablet
              desktop: CustomEmployeeCardWeb(
                userName: employees[index].name,
                index: index + 1,
                pin: employees[index].pin,
              ).px(200), // Example adjustment for desktop
            );
          },
        );
      }),
    );
  }
}

class CustomEmployeeCardWeb extends StatelessWidget {
  final String userName;
  final int index;
  final String pin;

  const CustomEmployeeCardWeb({
    Key? key,
    required this.userName,
    required this.index,
    required this.pin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Defining color variations
    const Color purpleAccent =
        Color(0xFF6A53A1); // Purple accent for icons or highlights
    const Color textLight =
        Colors.white70; // Lighter text for better readability in dark mode

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            secondaryColor, // Using the secondary color for the card background
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.25), // Softer shadow for dark mode
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor:
                primaryColor, // Using the primary color for the circle avatar
            child: Text(
              "$index",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    color: textLight, // Light text color for better contrast
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Pin: $pin",
                  style: TextStyle(
                      fontSize: 16, color: textLight), // Light text color
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit,
                color: purpleAccent), // Purple accent for the edit icon
            onPressed: () {
              // Implement edit functionality
            },
          ),
        ],
      ),
    );
  }
}
