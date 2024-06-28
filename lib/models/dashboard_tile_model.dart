import '../gen/assets.gen.dart';

class DashboardTiles {
  final String title, subtitle, desc, image;

  DashboardTiles({
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.image,
  });
}

List demoMyFiles = [
  DashboardTiles(
    title: "Web Orders",
    subtitle: "\$21132",
    desc: "9.5%",
    image: Assets.images.manoosh.path,
  ),
  DashboardTiles(
    title: "DoorDash Orders",
    subtitle: "\$212",
    desc: "9.5%",
    image: Assets.images.doordash.path,
  ),
  DashboardTiles(
    title: "UberEats Orders",
    subtitle: "\$212",
    desc: "9.5%",
    image: Assets.images.uberEats.path,
  ),
  DashboardTiles(
    title: "MenuLog Orders",
    subtitle: "\$212",
    desc: "9.5%",
    image: Assets.images.menulog.path,
  ),
];
