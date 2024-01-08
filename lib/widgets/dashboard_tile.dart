import 'package:flutter/material.dart';
import 'package:time_clock_manager/controllers/auth_controller.dart';
import 'package:time_clock_manager/utils/clockin_import_utils.dart';
import 'package:time_clock_manager/utils/time_tactic_utils.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants.dart';
import '../responsive.dart';
import 'daily_info_card_widget.dart';

class DashboardTiles extends StatelessWidget {
  const DashboardTiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Daily Summary",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.spaceBetween,
          spacing: defaultPadding * 7,
          runSpacing: defaultPadding,
          children: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: _onPressedClockInOut,
              icon: const Icon(Icons.cloud_upload_rounded),
              label: const Text("Import Clock In/Out"),
            ).shimmer(
              primaryColor: Colors.purpleAccent,
              secondaryColor: Colors.blue,
              duration: const Duration(seconds: 7),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: _onPressedClockInOut,
              icon: const Icon(Icons.cloud_upload_rounded),
              label: const Text("Import Daily Report"),
            ).shimmer(
              primaryColor: Colors.purpleAccent,
              secondaryColor: Colors.blue,
              duration: const Duration(seconds: 7),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: _onPressedClockInOut,
              icon: const Icon(Icons.cloud_upload_rounded),
              label: const Text("Import Deliveries"),
            ).shimmer(
              primaryColor: Colors.purpleAccent,
              secondaryColor: Colors.blue,
              duration: const Duration(seconds: 7),
            ),
          ],
        ).p(16),
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: DailyInfoCardGrid(
            crossAxisCount: size.width < 650 ? 2 : 4,
            childAspectRatio: size.width < 650 && size.width > 350 ? 1.3 : 1,
          ),
          tablet: const DailyInfoCardGrid(),
          desktop: DailyInfoCardGrid(
            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

void _onPressedClockInOut() async {
  final content = await TimeTacticUtils.importFiles();
  if (content != null) {
    final clockinUtils = ClockinReportUtils();
    final clockinReport = clockinUtils.finalJsonConvert(content);
    print(clockinReport);
  } else {
    print('No file selected.');
  }
}
