import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/controllers/auth_controller.dart';
import 'package:time_clock_manager/controllers/employee_availability_controller.dart';
import 'package:time_clock_manager/models/enployee_model.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants.dart';
import 'user_availability_card.dart';

class StaffAvailabilityPage extends StatelessWidget {
  const StaffAvailabilityPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeeAvailabilityController());

    EmployeeModel? getCurrentEmployee(List<EmployeeModel> employees) {
      final authController = Get.find<AuthController>();
      log('current user: ${authController.firebaseUser.value!.uid}');
      log('employees: ${employees.map((element) => element.name)}');
      for (var employee in employees) {
        log('employee: ${employee.name}');
      }

      try {
        final currentEmployee = employees.firstWhere(
          (element) => element.id == authController.firebaseUser.value!.uid,
        );
        return currentEmployee;
      } catch (e) {
        log('No matching employee found for the current user');
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: "Availability".text.make(),
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<EmployeeModel>>(
          stream: controller.employeeStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final employees = snapshot.data ?? [];
            final currentEmployee = getCurrentEmployee(employees);

            if (currentEmployee != null) {
              return ListView(
                children: [
                  UserAvailabilityCard(employee: currentEmployee),
                ],
              );
            } else {
              return Center(
                child: Text('No matching employee found for the current user'),
              );
            }
          },
        ),
      ),
    );
  }
}
