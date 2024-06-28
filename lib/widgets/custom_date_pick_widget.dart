import 'package:flutter/material.dart';
import 'package:time_clock_manager/controllers/clockin_report_firestore_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomDateRangeSelectWidget extends StatelessWidget {
  final void Function()? onTap;
  final ClockinReportFireStoreController controller;
  const CustomDateRangeSelectWidget(
      {super.key, required this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      readOnly: true,
      textAlign: TextAlign.center,
      onTap: onTap,
      controller: TextEditingController(
          text: controller.selectedDateRange.value.toString() == "null"
              ? "Select Date Range"
              : controller.selectedDateRange.value?.toString()),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.all(6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ).px(8).py(20);
  }
}
