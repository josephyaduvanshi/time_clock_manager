import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_clock_manager/constants.dart';
import 'package:time_clock_manager/utils/snack_bar_custom.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/clockin_report_firestore_controller.dart';
import '../models/clocking_report_model.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ClockinReportFireStoreController.to;
    print(
        'controller.filteredEmployeeHours.length: ${controller.filteredEmployeeHours.length}' +
            "Rebuild ReportsPage");
    return Obx(() {
      return NotificationListener<OverscrollNotification>(
        onNotification: (notification) =>
            notification.metrics.axis == Axis.horizontal,
        child: ListView(
          shrinkWrap: true,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.spaceBetween,
              spacing: defaultPadding,
              runSpacing: defaultPadding,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding / 2,
                    ),
                  ),
                  onPressed: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      initialDateRange: controller.selectedDateRange.value,
                    );
                    if (picked != null &&
                        picked != controller.selectedDateRange.value) {
                      print('picked: $picked');
                      controller.setSelectedDateRange(picked);
                    }
                    controller.filterEmployeeHoursByDateRange();
                  },
                  child: controller.selectedDateRange.value.toString() == "null"
                      ? "Select Date Range".text.make()
                      : controller
                          .selectedDateRange.value?.startEndFormatted.text
                          .make(),
                ),
                // 10.widthBox,
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding / 2,
                    ),
                  ),
                  onPressed: () => controller.resetDateRange(),
                  child: Text('Reset'),
                ),
                OutlinedButton(
                  // Add this button
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding / 2,
                    ),
                  ),
                  onPressed: () => showAddUpdateHoursBottomSheet(context),
                  child: Text('Add/Update Hours'),
                ),
              ],
            ).px(8).py(20),
            Visibility(
              visible: controller.filteredEmployeeHours.isNotEmpty,
              replacement: "No data found".text.makeCentered().p(20),
              child: NotificationListener<OverscrollNotification>(
                  onNotification: (notification) =>
                      notification.metrics.axis == Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: buildDataTable(controller.filteredEmployeeHours),
                  )),
            ),
          ],
        ),
      );
    });
  }
}

// Inside EmployeeHoursPage

Widget buildDataTable(List<Map<String, dynamic>> employeeHours) {
  var totals =
      ClockinReportFireStoreController.to.calculateGroupedHours(employeeHours);
  var totalHoursPerEmployee =
      totals['totalHoursPerEmployee'] as Map<String, double>;
  var totalHoursPerDay = totals['totalHoursPerDay'] as Map<String, double>;

  List<DataRow> rows = [];
  final totalRowStyle = TextStyle(fontWeight: FontWeight.bold);
  final separatorStyle = TextStyle(color: Colors.transparent);

  for (var employeeData in employeeHours) {
    String employeeName = employeeData['name'];
    var hoursList = employeeData['hours'] as List<dynamic>;

    // Individual hour entries
    for (var hourData in hoursList) {
      var hour = Hour.fromMap(hourData);
      String dateKey = hour.date.toIso8601String().substring(0, 10);
      rows.add(DataRow(cells: [
        DataCell(Text(employeeName)),
        DataCell(Text(dateKey)),
        DataCell(Text(hour.hours.toStringAsFixed(2))),
        DataCell(Text(totalHoursPerDay[dateKey]?.toStringAsFixed(2) ?? '0.00')),
      ]));
      employeeName = '';
    }

    rows.add(DataRow(cells: [
      DataCell(Text('Total', style: totalRowStyle)),
      DataCell(Text('')),
      DataCell(Text(
          totalHoursPerEmployee[employeeData['name']]?.toStringAsFixed(2) ??
              '0.00',
          style: totalRowStyle)),
      DataCell(Text('')),
    ]));

    rows.add(DataRow(cells: [
      DataCell(Text('', style: separatorStyle)),
      DataCell(Text('', style: separatorStyle)),
      DataCell(Text('', style: separatorStyle)),
      DataCell(Text('', style: separatorStyle)),
    ]));
  }
  return DataTable(
    dividerThickness: 0.9,
    dataRowColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected))
          return Theme.of(Get.context!).colorScheme.primary.withOpacity(0.08);
        return secondaryColor;
      },
    ),
    decoration: BoxDecoration(
      border: Border.all(color: secondaryColor),
      borderRadius: BorderRadius.circular(10),
    ),
    sortAscending: true,
    sortColumnIndex: 0,
    columns: [
      DataColumn(
        label: Text('Name'),
        onSort: (columnIndex, ascending) {
          ClockinReportFireStoreController.to.sortByName();
        },
      ),
      DataColumn(
        label: Text('Date'),
      ),
      DataColumn(
        label: Text('Hours'),
      ),
      const DataColumn(label: Text('Total Hours on Date')),
    ],
    rows: rows,
  ).p(8);
}

extension on DateTimeRange {
  String get startEndFormatted {
    return DateFormat.yMMMMd().format(start) +
        " to " +
        DateFormat.yMMMMd().format(end);
  }
}

void showAddUpdateHoursBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    isDismissible: true,
    isScrollControlled: true,
    // constraints: BoxConstraints(
    //   maxHeight: MediaQuery.of(context).size.height,
    // ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.8,
              shouldCloseOnMinExtent: false,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return AddUpdateHoursForm();
              }),
        ),
      );
    },
  );
}

class AddUpdateHoursForm extends StatefulWidget {
  @override
  _AddUpdateHoursFormState createState() => _AddUpdateHoursFormState();
}

class _AddUpdateHoursFormState extends State<AddUpdateHoursForm> {
  final _formKey = GlobalKey<FormState>();
  String employeeId = '';
  String date = '';
  String hours = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Enter Employee ID (e.g. JOS)",
              label: Text("Employee ID *"),
              floatingLabelStyle: TextStyle(
                color: Color.fromRGBO(77, 77, 205, 1.0),
              ),
              contentPadding: EdgeInsets.all(15),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(77, 77, 205, 1.0),
                ),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              fillColor: secondaryColor,
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(71, 70, 79, 1.0)),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              filled: true,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter employee ID';
              }
              return null;
            },
            onSaved: (value) => employeeId = value!,
          ).px(12).py(10),
          TextFormField(
            readOnly: true,
            onTap: () async {
              await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    date = DateFormat('yyyy-MM-dd').format(value);
                  });
                }
              });
            },
            controller: TextEditingController(text: date),
            decoration: const InputDecoration(
              hintText: "Select Date (YYYY-MM-DD)",
              label: Text("Date"),
              floatingLabelStyle: TextStyle(
                color: Color.fromRGBO(77, 77, 205, 1.0),
              ),
              contentPadding: EdgeInsets.all(15),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(77, 77, 205, 1.0),
                ),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              fillColor: secondaryColor,
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(71, 70, 79, 1.0)),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              filled: true,
            ),
            validator: (value) {
              if (value!.isEmpty ||
                  !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                return 'Please enter a valid date';
              }
              return null;
            },
            onSaved: (value) => date = value!,
          ).px(12).py(10),
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Enter Hours (e.g. 8.5)",
              label: Text("Hours"),
              floatingLabelStyle: TextStyle(
                color: Color.fromRGBO(77, 77, 205, 1.0),
              ),
              contentPadding: EdgeInsets.all(15),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(77, 77, 205, 1.0),
                ),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              fillColor: secondaryColor,
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(71, 70, 79, 1.0)),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              filled: true,
            ),
            validator: (value) {
              if (value!.isEmpty || double.tryParse(value) == null) {
                return 'Please enter valid hours';
              }
              return null;
            },
            onSaved: (value) => hours = value!,
          ).px(12).py(10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5,
                vertical: defaultPadding / 2,
              ),
            ),
            onPressed: () async {
              print("dddd");
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Call your method to add or update hours
                print(employeeId);
                print(date);

                final success = await ClockinReportFireStoreController.to
                    .addOrUpdateEmployeeHours(
                  employeeId,
                  date,
                  double.parse(hours),
                );
                if (success) {
                  Get.back();
                  ShowSnackBar.snackSuccess(
                      title: "Success",
                      sub: "Hours added/updated successfully");
                } else {
                  ShowSnackBar.snackError(
                      title: "Error", sub: "Something went wrong");
                }
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
