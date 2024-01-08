import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants.dart';
import '../models/dashboard_tile_model.dart';

class DailyInfoCard extends StatelessWidget {
  const DailyInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final DashboardTiles info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: "20 Hours".text.xl2.make().centered(),
    );
  }
}
