import 'package:flutter/material.dart';
import 'package:time_clock_manager/models/dashboard_tile_model.dart';

import '../constants.dart';
import 'daily_info_card.dart';

class DailyInfoCardGrid extends StatelessWidget {
  const DailyInfoCardGrid({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => DailyInfoCard(info: demoMyFiles[index]),
    );
  }
}
