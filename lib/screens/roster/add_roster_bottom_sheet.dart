import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/widgets/custom_buuton_with_splash.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:time_clock_manager/controllers/roster_controller.dart';
import 'package:time_clock_manager/models/enployee_model.dart';
import 'package:time_clock_manager/models/roster_model.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class AddRosterBottomSheet extends StatelessWidget {
  final RosterModel? roster;

  AddRosterBottomSheet({Key? key, this.roster}) : super(key: key);

  final RosterController controller = Get.find<RosterController>();

  @override
  Widget build(BuildContext context) {
    if (roster != null) {
      controller.selectedEmployee.value =
          controller.employees.firstWhere((e) => e.id == roster!.userId);
      controller.selectedPosition.value = roster!.position.name;
      controller.startTimeController.text =
          DateFormat.jm().format(roster!.startTime);
      controller.finishTimeController.text =
          DateFormat.jm().format(roster!.finishTime);
      controller.storeController.text = roster!.store.name;
      controller.shiftDescriptionController.text = roster!.shiftDescription;
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            return DropdownButtonFormField<EmployeeModel>(
              key: controller.employeeDropdownKey,
              isExpanded: true,
              value: controller.selectedEmployee.value,
              elevation: 8,
              padding: const EdgeInsets.all(8),
              focusColor: Colors.transparent,
              iconEnabledColor: Colors.amber,
              borderRadius: BorderRadius.circular(16),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(
                  color: Colors.greenAccent,
                ),
                contentPadding: EdgeInsets.all(15),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(77, 77, 205, 1.0),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                fillColor: secondaryColor,
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(71, 70, 79, 1.0)),
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                labelText: "Select Employee",
                hintText: "Please select an employee",
                labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              dropdownColor: secondaryColor,
              items: controller.employees.map((employee) {
                return DropdownMenuItem<EmployeeModel>(
                  value: employee,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CircleAvatar(
                          child: employee.avatar.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: employee.avatar,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      "https://www.gravatar.com/avatar/get",
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                          radius: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(employee.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedEmployee.value = value;
                }
              },
            );
          }),
          DropdownButtonFormField<String>(
            value: controller.selectedPosition.value,
            key: controller.positionDropdownKey,
            items: Position.values
                .map((position) => DropdownMenuItem<String>(
                      value: position.name,
                      child: Text(position.name),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedPosition.value = value;
              }
            },
            isExpanded: true,
            elevation: 8,
            padding: const EdgeInsets.all(8),
            focusColor: Colors.transparent,
            iconEnabledColor: Colors.amber,
            borderRadius: BorderRadius.circular(16),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              floatingLabelStyle: const TextStyle(
                color: Colors.greenAccent,
              ),
              contentPadding: EdgeInsets.all(15),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(77, 77, 205, 1.0),
                ),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              fillColor: secondaryColor,
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(71, 70, 79, 1.0)),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.white),
              ),
              labelText: "Position",
              labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            dropdownColor: secondaryColor,
          ),
          TextField(
            controller: controller.startTimeController,
            decoration: const InputDecoration(
              label: Text("Start Time"),
              floatingLabelStyle: TextStyle(
                color: Colors.greenAccent,
              ),
              contentPadding: EdgeInsets.all(15),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(77, 77, 205, 1.0)),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              fillColor: secondaryColor,
              labelStyle: TextStyle(color: Colors.white, fontSize: 18),
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(71, 70, 79, 1.0)),
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              filled: true,
            ),
            onTap: () async {
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                controller.startTimeController.text = time.format(context);
              }
            },
          ).p(8),
          TextField(
            controller: controller.finishTimeController,
            decoration: const InputDecoration(
              label: Text("Finish Time"),
              floatingLabelStyle: TextStyle(
                color: Colors.greenAccent,
              ),
              contentPadding: EdgeInsets.all(15),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(77, 77, 205, 1.0)),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              fillColor: secondaryColor,
              labelStyle: TextStyle(color: Colors.white, fontSize: 18),
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(71, 70, 79, 1.0)),
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              filled: true,
            ),
            onTap: () async {
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                controller.finishTimeController.text = time.format(context);
              }
            },
          ).p(8),
          DropdownButtonFormField<String>(
            key: controller.storeDropdownKey,
            value: Store.GREENWAY.name,
            items: Store.values
                .map((store) => DropdownMenuItem<String>(
                      value: store.name,
                      child: Text(store.name),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.storeController.text = value;
              }
            },
            isExpanded: true,
            elevation: 8,
            padding: const EdgeInsets.all(8),
            focusColor: Colors.transparent,
            iconEnabledColor: Colors.amber,
            borderRadius: BorderRadius.circular(16),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              floatingLabelStyle: const TextStyle(
                color: Colors.greenAccent,
              ),
              contentPadding: EdgeInsets.all(15),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(77, 77, 205, 1.0)),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              fillColor: secondaryColor,
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(71, 70, 79, 1.0)),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.white),
              ),
              labelText: "Store",
              labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            dropdownColor: secondaryColor,
          ),
          TextField(
            controller: controller.shiftDescriptionController,
            decoration: InputDecoration(labelText: 'Shift Description'),
          ).p(8),
          SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: CustomButtonWithSplash(
                  colorDarkMode: Color.fromARGB(255, 199, 85, 85),
                  colorLightMode: Color.fromARGB(255, 199, 85, 85),
                  onTap: () {
                    controller.selectedEmployee = Rx<EmployeeModel?>(null);
                    Navigator.pop(context);
                    controller.resetForm();
                  },
                  title: "Exit",
                ).p(8),
              ),
              Flexible(
                child: CustomButtonWithSplash(
                  colorDarkMode: Color.fromARGB(255, 85, 146, 199),
                  colorLightMode: const Color.fromARGB(255, 85, 199, 89),
                  onTap: () async {
                    if (roster != null) {
                      // Update existing roster
                      await controller.updateRoster(roster!.copyWith(
                        userId: controller.selectedEmployee.value!.id,
                        userName: controller.selectedEmployee.value!.name,
                        position: Position.values
                            .byName(controller.selectedPosition.value),
                        startTime: DateFormat.jm()
                            .parse(controller.startTimeController.text),
                        finishTime: DateFormat.jm()
                            .parse(controller.finishTimeController.text),
                        store: Store.values
                            .byName(controller.storeController.text),
                        shiftDescription:
                            controller.shiftDescriptionController.text,
                      ));
                    } else {
                      await controller.addWeeklyRoster();
                    }
                    controller.resetForm();
                    log('Roster Added or Updated');
                    Navigator.pop(context);
                  },
                  title: roster != null ? "Save as Draft" : "Add Roster",
                ).p(8),
              ),
              Flexible(
                child: CustomButtonWithSplash(
                  colorDarkMode: const Color.fromARGB(255, 85, 199, 89),
                  colorLightMode: const Color.fromARGB(255, 85, 199, 89),
                  onTap: () async {
                    if (roster != null) {
                      // Update and publish existing roster
                      await controller.updateRoster(roster!.copyWith(
                        userId: controller.selectedEmployee.value!.id,
                        userName: controller.selectedEmployee.value!.name,
                        position: Position.values
                            .byName(controller.selectedPosition.value),
                        startTime: DateFormat.jm()
                            .parse(controller.startTimeController.text),
                        finishTime: DateFormat.jm()
                            .parse(controller.finishTimeController.text),
                        store: Store.values
                            .byName(controller.storeController.text),
                        shiftDescription:
                            controller.shiftDescriptionController.text,
                        isDraft: false,
                      ));
                    } else {
                      await controller.addPublishIndividualRoster();
                    }
                    controller.resetForm();
                    log('Roster Added or Updated');
                    Navigator.pop(context);
                  },
                  title: roster == null ? "Publish" : "Update and Publish",
                ).p(8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
