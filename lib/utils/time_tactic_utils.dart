import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeTacticUtils {
  static Future<String?> importFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv', 'txt'],
    );
    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes;
      String fileContent = utf8.decode(fileBytes!);
      return fileContent;
    } else {
      // User canceled the picker
      Get.snackbar('Error', 'No file selected.',
          snackPosition: SnackPosition.TOP,
          overlayColor: Colors.red,
          shouldIconPulse: true,
          icon: Icon(
            Icons.shield_rounded,
            color: Colors.redAccent,
          ),
          duration: const Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          colorText: Colors.red,
          forwardAnimationCurve: Curves.elasticInOut,
          reverseAnimationCurve: Curves.fastOutSlowIn,
          snackStyle: SnackStyle.FLOATING,
          padding: EdgeInsets.all(16));
      return null;
    }
  }
}
