import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_clock_manager/controllers/roster_controller.dart';
import 'package:time_clock_manager/models/roster_model.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/enployee_model.dart';

class CustomRosterPage extends StatelessWidget {
  final RosterController controller = Get.put(RosterController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        20.heightBox,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() {
                final start =
                    DateFormat('MMM dd').format(controller.firstDate.value);
                final end =
                    DateFormat('MMM dd').format(controller.lastDate.value);
                return Flexible(
                  child: Chip(
                    label: Text('$start - $end'),
                    backgroundColor: Colors.grey[850],
                  ),
                );
              }),
              Flexible(
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Select Employee",
                    border: OutlineInputBorder(),
                  ),
                  items: controller.employees.map((employee) {
                    return DropdownMenuItem<String>(
                      value: employee.id,
                      child: Text(employee.name),
                    );
                  }).toList(),
                  onChanged: (value) {},
                ),
              ),
              Flexible(
                child: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(child: Text("Sort by Name")),
                      PopupMenuItem(child: Text("Sort by Total Hours")),
                    ];
                  },
                  child: Chip(
                    label: Text('Sort by Name'),
                    backgroundColor: Colors.grey[850],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Divider(thickness: 1, color: Colors.grey),
        // Main section with employee names and roster details

        Expanded(
          child: Row(
            children: [
              // Fixed Column for Employee Names
              Container(
                width: 150,
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.employees.length,
                    itemBuilder: (context, index) {
                      EmployeeModel employee = controller.employees[index];
                      return Container(
                        height: 120, // Fixed height for employee box
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[850],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: SizedBox(
                                height: 50,
                                child: CustomImageWidget(
                                  image: employee.avatar,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Flexible(
                              child: employee.name.text.center.medium
                                  .size(16)
                                  .overflow(TextOverflow.ellipsis)
                                  .make(),
                            ),
                            SizedBox(height: 4),
                            Flexible(
                              child: Text(
                                'Total Hours: ${controller.calculateTotalHours(employee.id)}',
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ).pOnly(top: 55),
              // Scrollable Grid for Roster Details
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Header
                        Row(
                          children: List.generate(
                            (controller.lastDate.value
                                    .difference(controller.firstDate.value)
                                    .inDays +
                                1),
                            (index) {
                              final date = controller.firstDate.value
                                  .add(Duration(days: index));
                              return Container(
                                width: 193, // Increased width for date column
                                height: 50, // Fixed height for date header
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[700],
                                ),
                                child: Text(
                                  DateFormat('EEE dd/MM').format(date),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                        // Employee Rosters
                        Expanded(
                          child: Row(
                            children: List.generate(
                              (controller.lastDate.value
                                      .difference(controller.firstDate.value)
                                      .inDays +
                                  1),
                              (columnIndex) {
                                final date = controller.firstDate.value
                                    .add(Duration(days: columnIndex));
                                return Container(
                                  width: 200, // Increased width for roster grid
                                  child: ListView.builder(
                                    itemCount: controller.employees.length,
                                    itemBuilder: (context, rowIndex) {
                                      EmployeeModel employee =
                                          controller.employees[rowIndex];
                                      List<RosterModel> employeeRosters =
                                          controller.rosters.where((roster) {
                                        return roster.userId == employee.id &&
                                            roster.startTime.year ==
                                                date.year &&
                                            roster.startTime.month ==
                                                date.month &&
                                            roster.startTime.day == date.day;
                                      }).toList();

                                      return Container(
                                        height:
                                            120, // Fixed height for roster box
                                        margin: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: employeeRosters.isEmpty
                                              ? Colors.grey[850]
                                              : employeeRosters.any((roster) =>
                                                      roster.isDraft)
                                                  ? Colors.red.shade300
                                                  : Colors.green[700],
                                        ),
                                        child: employeeRosters.isEmpty
                                            ? Center(
                                                child: Text(
                                                  'No Shifts',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: employeeRosters
                                                      .map((roster) {
                                                    return Column(
                                                      children: [
                                                        roster.userName.text
                                                            .center.bold
                                                            .size(16)
                                                            .color(Colors.white)
                                                            .make(),
                                                        SizedBox(height: 4),
                                                        Chip(
                                                          label: Text(
                                                            roster
                                                                .position.name,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.purple
                                                                  .shade400,
                                                        ),
                                                        SizedBox(height: 4),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.access_time,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              '${DateFormat.jm().format(roster.startTime)} - ${DateFormat.jm().format(roster.finishTime)}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({super.key, required this.image, this.errorWidget});

  final String image;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        imageUrl: image.isEmpty ? "https://www.gravatar.com/avatar/get" : image,
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
