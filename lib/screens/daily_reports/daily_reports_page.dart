import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/constants.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/daily_reports_controller.dart';
import 'daily_report_card.dart';
import 'daily_report_dialog.dart';

class DailyReportsPage extends StatelessWidget {
  const DailyReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DailyReportsController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return ListView(
            children: [
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Color.fromRGBO(77, 77, 205, 1.0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2,
                      vertical: defaultPadding / 2,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => DailyReportDialog(
                        controller: controller,
                      ),
                    );
                  },
                  child: "Add Daily Report".text.green300.make(),
                ),
              ),
              ...controller.dailyReports.map((report) {
                return ReportCard(
                  report: report,
                );
              }).toList(),
            ],
          );
        }),
      ),
    );
  }
}
