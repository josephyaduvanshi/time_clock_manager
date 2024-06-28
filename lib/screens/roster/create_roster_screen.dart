import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants.dart';
import '../../controllers/roster_controller.dart';
import 'add_roster_bottom_sheet.dart';
import 'roster_display_card.dart';

class CreateRosterPage extends StatelessWidget {
  CreateRosterPage({Key? key}) : super(key: key);

  final RosterController controller = Get.put(RosterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Create Roster".text.make(),
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              DropdownButton<CalendarFormat>(
                value: controller.viewType.value == ViewType.Weekly
                    ? CalendarFormat.week
                    : controller.viewType.value == ViewType.Fortnightly
                        ? CalendarFormat.twoWeeks
                        : CalendarFormat.month,
                items: [
                  DropdownMenuItem(
                    value: CalendarFormat.week,
                    child: Text("Weekly"),
                  ),
                  DropdownMenuItem(
                    value: CalendarFormat.twoWeeks,
                    child: Text("Fortnightly"),
                  ),
                  DropdownMenuItem(
                    value: CalendarFormat.month,
                    child: Text("Monthly"),
                  ),
                ],
                onChanged: (format) {
                  if (format == CalendarFormat.week) {
                    controller.updateViewType(ViewType.Weekly);
                  } else if (format == CalendarFormat.twoWeeks) {
                    controller.updateViewType(ViewType.Fortnightly);
                  } else if (format == CalendarFormat.month) {
                    controller.updateViewType(ViewType.Monthly);
                  }
                },
              ),
              OutlinedButton(
                onPressed: () async {
                  await controller.publishAllShifts();
                },
                child: Text("Publish All Shifts"),
              ),
              OutlinedButton(
                onPressed: () async {
                  await controller.deleteAllShifts();
                },
                child: Text("Delete All Shifts"),
              ),
              OutlinedButton(
                onPressed: () async {
                  await controller.copyPreviousWeekRosters(
                      controller.selectedWeekStart.value);
                },
                child: Text("Copy Shift Last Week"),
              ),
            ],
          ),
          Obx(() {
            return TableCalendar(
              firstDay: DateTime.utc(2024, 05, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: controller.focusedDay.value,
              calendarFormat: controller.viewType.value == ViewType.Weekly
                  ? CalendarFormat.week
                  : controller.viewType.value == ViewType.Fortnightly
                      ? CalendarFormat.twoWeeks
                      : CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) {
                return isSameDay(controller.selectedDay.value, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                controller.onDaySelected(selectedDay, focusedDay);
              },
              onPageChanged: (focusedDay) {
                controller.focusedDay.value = focusedDay;
              },
            );
          }),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.selectedWeekRosters.length,
                itemBuilder: (context, index) {
                  final roster = controller.selectedWeekRosters[index];
                  return RosterCard(
                    roster: roster,
                    onEdit: () {
                      showModalBottomSheet(
                        isDismissible: false,
                        isScrollControlled: true,
                        backgroundColor: secondaryColor,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        context: context,
                        builder: (context) => AddRosterBottomSheet(
                          roster: roster,
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.selectedEmployee.value = null;
          showModalBottomSheet(
            isDismissible: false,
            isScrollControlled: true,
            backgroundColor: secondaryColor,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            context: context,
            builder: (context) => AddRosterBottomSheet(),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: secondaryColor,
      ),
    );
  }
}
