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
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: secondaryColor,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(
                    info.image,
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                info.title.text.xl
                    .make()
                    .p(5)
                    .box
                    .color(Colors.black.withOpacity(0.2))
                    .customRounded(BorderRadius.circular(10))
                    .makeCentered()
                    .p(5),
                const SizedBox(height: defaultPadding),
                info.subtitle.text.lg
                    .make()
                    .p(5)
                    .box
                    .color(Colors.blueGrey.withOpacity(0.7))
                    .customRounded(BorderRadius.circular(10))
                    .makeCentered()
                    .p(5),
                const SizedBox(height: defaultPadding),
                info.desc.text.make(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
