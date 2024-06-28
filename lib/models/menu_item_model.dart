import 'package:flutter/widgets.dart';

class MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  MenuItem({required this.icon, required this.label, this.onTap});
}
