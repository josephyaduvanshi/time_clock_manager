import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants.dart'; // Ensure this is the correct path to your constants
import '../controllers/clockin_report_firestore_controller.dart'; // Correct path to your controller

class WeeklyReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClockinReportFireStoreController>();

    DateTime now = DateTime.now();
    DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.getAppBarTitle())),
        actions: [
          Flexible(
            child: IconButton(
              icon: Icon(Icons.date_range),
              onPressed: () => controller.selectDate(context),
            ),
          ),
          10.widthBox,
          Flexible(
            child: DropdownButtonFormField(
              value: controller.isFortnightly.value,
              isExpanded: false,
              items: [
                DropdownMenuItem(
                  child: Text('Weekly'),
                  value: false,
                ),
                DropdownMenuItem(
                  child: Text('Fortnightly'),
                  value: true,
                ),
              ],
              elevation: 8,
              padding: EdgeInsets.all(8),
              focusColor: Colors.transparent,
              iconEnabledColor: Colors.amber,
              borderRadius: BorderRadius.circular(16),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white),
                ),
                contentPadding: EdgeInsets.all(16),
                floatingLabelStyle: TextStyle(
                  color: Colors.greenAccent,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                labelText: "Selected View",
                labelStyle: TextStyle(color: Colors.white, fontSize: 18),
              ),
              dropdownColor: secondaryColor,
              onChanged: controller.toggleViewMode,
            ),
          ),
          10.widthBox,
          Visibility(
            visible: !controller.isDownloading.value,
            replacement: CircularProgressIndicator().centered().px(12),
            child: Flexible(
              child: IconButton.filledTonal(
                      color: Colors.greenAccent,
                      onPressed: () async {
                        final h = controller.getStructuredDataForExport();

                        await controller.downloadFile(
                            data: h,
                            filename:
                                "weekly_hours_report $weekStart to ${weekStart.add(Duration(days: 6))} ${controller.isFortnightly.value ? "and ${weekStart.add(Duration(days: 7))} to ${weekStart.add(Duration(days: 13))}" : ""}");
                      },
                      icon: Icon(Icons.file_download).px(12))
                  .px(12),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return CircularProgressIndicator().centered();
        } else {
          return ListView(
            children: [
              buildWeeklyReportTable(
                  controller.currentWeekReport, weekStart, context),
              Visibility(
                visible: controller.isFortnightly.value,
                child: buildWeeklyReportTable(controller.nextWeekReport,
                    weekStart.add(Duration(days: 7)), context),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget buildWeeklyReportTable(
      RxMap weeklyData, DateTime weekStart, BuildContext context) {
    // Calculate total hours for each day
    Map<String, double> dailyTotals = {
      'Monday': 0.0,
      'Tuesday': 0.0,
      'Wednesday': 0.0,
      'Thursday': 0.0,
      'Friday': 0.0,
      'Saturday': 0.0,
      'Sunday': 0.0,
    };
    weeklyData.forEach((employee, hours) {
      hours.forEach((day, hours) {
        if (day != 'Total Hours') {
          dailyTotals[day] = (dailyTotals[day] ?? 0.0) + hours;
        }
      });
    });

    List<DataColumn> columns = [
      DataColumn(label: Text('Employee')),
      ...List.generate(
          7,
          (index) => DataColumn(
              label: Text(DateFormat('EEEE')
                  .format(weekStart.add(Duration(days: index)))))),
      DataColumn(label: Text('Total Hours')),
    ];

    List<DataRow> dataRows = weeklyData.entries.map((entry) {
      List<DataCell> cells = [
        DataCell(Text(entry.key)),
        ...List.generate(7, (index) {
          String day =
              DateFormat('EEEE').format(weekStart.add(Duration(days: index)));
          return DataCell(Text(entry.value[day]?.toStringAsFixed(2) ?? '0.00'));
        }),
        DataCell(
            Text(entry.value['Total Hours']?.toStringAsFixed(2) ?? '0.00')),
      ];
      return DataRow(cells: cells);
    }).toList();

    DataRow totalsRow = DataRow(
      cells: [
        DataCell(Text('Daily Totals',
            style: TextStyle(fontWeight: FontWeight.bold))),
        ...dailyTotals.entries
            .map((e) => DataCell(Text(e.value.toStringAsFixed(2))))
            .toList(),
        DataCell(Text(
            dailyTotals.values.reduce((a, b) => a + b).toStringAsFixed(2))),
      ],
    );
    dataRows.add(totalsRow);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
                dataRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected))
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.08);
                    return secondaryColor; // Make sure this is defined in your constants
                  },
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          secondaryColor), // Ensure secondaryColor is defined
                  borderRadius: BorderRadius.circular(10),
                ),
                columns: columns,
                rows: dataRows)
            .px(16)
            .py(12),
      ),
    );
  }
}
