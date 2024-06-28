import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/home_page_controller.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListTile(
        selected: HomePageContr.to.selectedPage.value == title,
        selectedTileColor: Colors.white10,
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: SvgPicture.asset(
          svgSrc,
          colorFilter: const ColorFilter.mode(
              Color.fromARGB(136, 255, 255, 255), BlendMode.srcIn),
          height: 16,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white54),
        ),
      );
    });
  }
}
