import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowSnackBar {
  static const _snackBarDuration = Duration(seconds: 3);

  static void _showSnackBar(String title, String sub, Color color,
      IconData icon, void Function(GetSnackBar)? onTap,
      {Color? textColor}) {
    Get.snackbar(title, sub,
        shouldIconPulse: false,
        onTap: onTap,
        icon: Icon(icon, color: textColor ?? Colors.white),
        duration: _snackBarDuration,
        backgroundColor: color,
        overlayColor: color,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        colorText: textColor ?? Colors.white,
        forwardAnimationCurve: Curves.easeIn,
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING);
  }

  static void snackError(
      {required String title,
      required String sub,
      Color? color,
      void Function(GetSnackBar)? onTap,
      IconData? icon}) {
    _showSnackBar(
        title, sub, color ?? Colors.red, icon ?? Icons.shield_rounded, onTap);
  }

  static void snackSuccess(
      {required String title,
      required String sub,
      Color? color,
      void Function(GetSnackBar)? onTap,
      IconData? icon}) {
    _showSnackBar(
        title, sub, color ?? Colors.green, icon ?? Icons.shield_rounded, onTap);
  }
}
