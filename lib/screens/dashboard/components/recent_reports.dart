import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/controllers/clockin_report_firestore_controller.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants.dart';
import '../../../models/recent_week_model.dart';

class RecentReportsClockin extends StatelessWidget {
  const RecentReportsClockin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<RecentWeekModel> recentWeekList =
          ClockinReportFireStoreController.to.getLastSevenDaysHours();
      log(recentWeekList.map((e) => e.hours).toString());
      return Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Clocking Reports",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: defaultPadding,
                // minWidth: 600,
                columns: const [
                  DataColumn(
                    label: Text("Day"),
                  ),
                  DataColumn(
                    label: Text("Date"),
                  ),
                  DataColumn(
                    label: Text("Hours"),
                  ),
                ],
                rows: List.generate(
                  recentWeekModelList.length,
                  (index) => recentFileDataRow(recentWeekList[index]),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

DataRow recentFileDataRow(RecentWeekModel recentWeekModel) {
  return DataRow(
    cells: [
      DataCell(
        recentWeekModel.title.text.isIntrinsic.blue300.make(),
      ),
      DataCell(recentWeekModel.date.text.isIntrinsic.purple400.make()),
      DataCell(recentWeekModel.hours.text.isIntrinsic.green300.make()),
    ],
  );
}
