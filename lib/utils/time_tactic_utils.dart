import 'dart:convert';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../models/enployee_model.dart';

class TimeTacticUtils {
  static TimeTacticUtils get instance => TimeTacticUtils();
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

  static Logger get log => Logger(
        printer: PrettyPrinter(
          stackTraceBeginIndex: 0,
          methodCount: 2,
          errorMethodCount: null,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          printTime: true,
          levelColors: {
            /*
              0:  Black,      8:  Grey
              1:  Red,        9:  Red Ascend
              2:  Green,      10: Green Ascend
              3:  Yellow      11: Yellow Ascend
              4:  Blue        12: Blue Ascend
              5:  Purple      13: Purple Ascend
              6:  Turquoise   14: Turquoise Ascend
              7:  White       15: Bright White 
            */
            Level.trace: const AnsiColor.fg(11),
            Level.debug: const AnsiColor.fg(8),
            Level.info: const AnsiColor.fg(2),
            Level.warning: const AnsiColor.fg(5),
            Level.error: const AnsiColor.fg(9),
            Level.fatal: const AnsiColor.fg(1),
          },
        ),
        output: DeveloperConsoleOutput(),
      );
}

class DeveloperConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final StringBuffer buffer = StringBuffer();
    event.lines.forEach(buffer.writeln);
    if (kDebugMode) {
      log(buffer.toString());
    }
  }
}

extension RoleExtension on Role {
  bool get isAdmin => this == Role.ADMIN;
}
