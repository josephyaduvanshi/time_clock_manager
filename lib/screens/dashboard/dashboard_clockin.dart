import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_clock_manager/responsive.dart';
import 'package:time_clock_manager/utils/name_formatter.dart';
import 'package:time_clock_manager/widgets/bottom_sheets/authenticte_pin_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants.dart';
import '../../controllers/dashboard_clockin_controller.dart';
import '../../models/enployee_model.dart';

class ClockinClockOutApp extends GetView<DashBoardClockInController> {
  const ClockinClockOutApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashBoardClockInController());
    log("ClockinClockOutApp build");
    log("ClockinClockOutApp build ${controller.employees.length}");
    EmployeeModel emptyEmployee = EmployeeModel(
        id: "",
        email: "",
        name: "",
        dateOfBirth: "",
        mobileNumber: "",
        store: Store.GREENWAY,
        avatar: "",
        role: Role.STAFF,
        status: Status.ACTIVE,
        username: "",
        availability: Availability(
          sun: Fri(start: 0, finish: 0),
          mon: Fri(start: 0, finish: 0),
          tue: Fri(start: 0, finish: 0),
          wed: Fri(start: 0, finish: 0),
          thu: Fri(start: 0, finish: 0),
          fri: Fri(start: 0, finish: 0),
          sat: Fri(start: 0, finish: 0),
        ),
        baseRate: 0.0,
        employmentType: EmploymentType.BY_PART_TIME,
        pin: "");

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: defaultPadding),
            Obx(() {
              log("ClockinClockOutApp build ${controller.employees.length}");
              return Responsive(
                mobile: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 1,
                        child: DropdownButtonFormField<EmployeeModel>(
                          isExpanded: true,
                          elevation: 8,
                          padding: const EdgeInsets.all(8),
                          focusColor: Colors.transparent,
                          iconEnabledColor: Colors.amber,
                          borderRadius: BorderRadius.circular(16),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            floatingLabelStyle: const TextStyle(
                              color: Colors.greenAccent,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            labelText: "Select Username",
                            labelStyle: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          dropdownColor: secondaryColor,
                          value: controller.employees
                                  .firstWhere(
                                      (e) =>
                                          e.id ==
                                          controller.selectedEmployeeId.value,
                                      orElse: () => emptyEmployee)
                                  .id
                                  .isEmpty
                              ? null
                              : controller.employees.firstWhere((e) =>
                                  e.id == controller.selectedEmployeeId.value),
                          selectedItemBuilder: (context) {
                            return controller.employees
                                .map((e) => e
                                    .name.inTitleCase.text.center.lg.center
                                    .make()
                                    .centered()
                                    .px(8))
                                .toList();
                          },
                          hint: "Select Your Username".text.xl.make(),
                          items: controller.employees
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.username),
                                  ))
                              .toList(),
                          onChanged: (EmployeeModel? selected) {
                            if (selected != null) {
                              controller.selectedEmployeeId.value = selected.id;
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LiveTimeWidget(),
                              if (controller.isClockedIn.isTrue)
                                "Elapsed: ${controller.getElapsedTime()}"
                                    .text
                                    .scale(0.8)
                                    .make()
                                    .px(5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                  OutlinedButton.icon(
                    icon: Icon(controller.isClockedIn.isTrue
                        ? Icons.timer_off
                        : Icons.timer),
                    onPressed: () async {
                      showAuthenticatePinScreen(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      foregroundColor: Colors.white,
                      // backgroundColor: Colors.blueGrey,
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    label: (controller.isClockedIn.isFalse
                            ? "Clock In"
                            : "Clock Out")
                        .text
                        .make()
                        .p(10)
                        .px(20),
                  )
                      .disabled(controller.selectedEmployeeId.value.isEmpty)
                      .centered()
                ]),
                desktop: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<EmployeeModel>(
                        isExpanded: true,
                        elevation: 8,
                        padding: const EdgeInsets.all(8),
                        focusColor: Colors.transparent,
                        iconEnabledColor: Colors.amber,
                        borderRadius: BorderRadius.circular(16),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          floatingLabelStyle: const TextStyle(
                            color: Colors.greenAccent,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: "Select Username",
                          labelStyle: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        dropdownColor: secondaryColor,
                        value: controller.employees
                                .firstWhere(
                                    (e) =>
                                        e.id ==
                                        controller.selectedEmployeeId.value,
                                    orElse: () => emptyEmployee)
                                .id
                                .isEmpty
                            ? null
                            : controller.employees.firstWhere((e) =>
                                e.id == controller.selectedEmployeeId.value),
                        selectedItemBuilder: (context) {
                          return controller.employees
                              .map((e) => e
                                  .name.inTitleCase.text.center.lg.center
                                  .make()
                                  .centered()
                                  .px(8))
                              .toList();
                        },
                        hint: "Select Your Username".text.xl.make(),
                        items: controller.employees
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.username),
                                ))
                            .toList(),
                        onChanged: (EmployeeModel? selected) {
                          if (selected != null) {
                            controller.selectedEmployeeId.value = selected.id;
                          }
                        },
                      ),
                    ),
                    Flexible(
                      child: Obx(() {
                        return Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LiveTimeWidget(),
                              if (controller.isClockedIn.isTrue)
                                "Elapsed: ${controller.getElapsedTime()}"
                                    .text
                                    .scale(0.8)
                                    .make()
                                    .px(5),
                            ],
                          ),
                        );
                      }),
                    ),
                    Expanded(
                      flex: 1,
                      child: Obx(() {
                        return OutlinedButton.icon(
                          icon: Icon(controller.isClockedIn.isTrue
                              ? Icons.timer_off
                              : Icons.timer),
                          onPressed: () async {
                            showAuthenticatePinScreen(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(10),
                            foregroundColor: Colors.white,
                            // backgroundColor: Colors.blueGrey,
                            side: BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          label: (controller.isClockedIn.isFalse
                                  ? "Clock In"
                                  : "Clock Out")
                              .text
                              .make()
                              .p(10),
                        ).disabled(controller.selectedEmployeeId.value.isEmpty);
                      }),
                    ),
                  ],
                ),
              );
            }),
            Obx(() {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    sortColumnIndex: 0,
                    sortAscending: true,
                    dataRowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected))
                          return Theme.of(Get.context!)
                              .colorScheme
                              .primary
                              .withOpacity(0.08);
                        return secondaryColor;
                      },
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: secondaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    columns: const [
                      DataColumn(label: Text('Employee')),
                      DataColumn(label: Text('Day')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Clock In')),
                      DataColumn(label: Text('Clock Out')),
                      DataColumn(label: Text('Hours Accumulated')),
                    ],
                    rows: controller.todayRecords.map<DataRow>((record) {
                      return DataRow(cells: [
                        DataCell(record
                            .employeeName.inTitleCase.text.isIntrinsic
                            .make()),
                        DataCell(Text(record.dayOfWeek)),
                        DataCell(Text(record.formattedDateTimeClockIn)),
                        DataCell(
                            Text(record.formattedTimeClockIn, softWrap: true)),
                        DataCell(Text(record.formattedTimeClockOut)),
                        DataCell(GestureDetector(
                            onTap: () {
                              controller.isDecimalHour.value =
                                  !controller.isDecimalHour.value;
                            },
                            child: Visibility(
                                visible: controller.isDecimalHour.isTrue,
                                replacement: Text(record.getDuration()),
                                child: Text(record.getDurationDecimal())))),
                      ]);
                    }).toList(),
                  ),
                ),
              ).py(30);
            }),
          ],
        ),
      ),
    );
  }
}

class LiveTimeWidget extends StatelessWidget {
  const LiveTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assuming DashBoardClockInController is already available in the widget tree
    final controller = Get.find<DashBoardClockInController>();

    return Obx(() => Text(
          DateFormat('hh:mm:ss a').format(controller.liveTime.value),
          style: TextStyle(fontSize: 16, color: Colors.white),
        ));
  }
}
