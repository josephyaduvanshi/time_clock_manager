import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
            "Daily Reports",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Center(
          child: ElevatedButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5,
                vertical:
                    defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
              ),
            ),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['xlsx', 'xls', 'csv', 'txt'],
              );
              if (result != null) {
                Uint8List? fileBytes = result.files.single.bytes;
                String fileContent = utf8.decode(fileBytes!);
                // Use 'fileContent' as needed
                final userHours = extractUserHours(
                  fileContent,
                );
                double calculatedTotalHours =
                    userHours.fold(0, (sum, item) => sum + item['hours']);
                double reportedTotalHours =
                    extractReportTotalHours(fileContent);
                Map<String, String> dates = extractDates(fileContent);
                final jsonData = convertToJson(
                    userHours, calculatedTotalHours, reportedTotalHours, dates);
                print(jsonData);
                print("====================================");
                // print(fileContent); // Fo
              } else {
                print('No file selected.');
              }
            },
            icon: const Icon(Icons.add),
            label: const Text("Import Daily Report"),
          ),
        ),
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

List<Map<String, dynamic>> extractUserHours(String text) {
  final RegExp pattern = RegExp(r'([A-Z]+) - ([A-Za-z. ]+)\s+([\d.]+)');
  final matches = pattern.allMatches(text);

  List<Map<String, dynamic>> userHours = [];

  for (final match in matches) {
    String id = match.group(1).toString().trim();
    String name = match.group(2).toString().trim();
    double hours = double.tryParse(match.group(3).toString().trim()) ?? 0.0;

    userHours.add({'id': id, 'name': name, 'hours': hours});
  }

  return userHours;
}

double extractReportTotalHours(String text) {
  final RegExp totalPattern = RegExp(r'Report Total\s+([\d.]+)');
  final totalMatch = totalPattern.firstMatch(text);
  return totalMatch != null
      ? double.tryParse(totalMatch.group(1).toString().trim()) ?? 0.0
      : 0.0;
}

Map<String, String> extractDates(String text) {
  final RegExp datePattern =
      RegExp(r'From:\s+(\d{2}/\d{2}/\d{4})\s+To:\s+(\d{2}/\d{2}/\d{4})');
  final dateMatch = datePattern.firstMatch(text);
  return {
    'startDate': dateMatch?.group(1) ?? '',
    'endDate': dateMatch?.group(2) ?? ''
  };
}

String convertToJson(
    List<Map<String, dynamic>> data,
    double calculatedTotalHours,
    double reportedTotalHours,
    Map<String, String> dates) {
  Map<String, dynamic> finalData = {
    'employees': data,
    'calculatedTotalHours': calculatedTotalHours,
    'reportedTotalHours': reportedTotalHours,
    'startDate': dates['startDate'],
    'endDate': dates['endDate']
  };
  return jsonEncode(finalData);
}

double roundToPrecision(double value, int places) {
  double mod = pow(10.0, places).toDouble();
  return ((value * mod).round().toDouble() / mod);
}
