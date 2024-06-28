import 'dart:convert';
import 'dart:math';

import 'package:intl/intl.dart';

class ClockinReportUtils {
  List<Map<String, dynamic>> extractUserHours(String text) {
    final RegExp userPattern = RegExp(r'([A-Z ]+) - ([A-Za-z. ]+)\s+([\d.]+)');
    final RegExp hoursPattern =
        RegExp(r'(\d{2}/\d{2}/\d{2,4})\s+\d+\s+\d+\s+([\d.]+)');
    final userMatches = userPattern.allMatches(text);
    final hoursMatches = hoursPattern.allMatches(text);

    List<Map<String, dynamic>> userHours = [];
    int hoursIndex = 0;

    for (final userMatch in userMatches) {
      Map<String, double> dailyHours = {};
      // double totalHours = 0.0;

      while (hoursIndex < hoursMatches.length &&
          hoursMatches.elementAt(hoursIndex).start < userMatch.start) {
        final hoursMatch = hoursMatches.elementAt(hoursIndex);
        String dateString = hoursMatch.group(1)!.trim();
        DateTime date = DateFormat('dd/MM/yy').parse(dateString);
        String formattedDate =
            DateFormat('yyyy-MM-dd 00:00:00.000').format(date);
        double hours = double.tryParse(hoursMatch.group(2)!.trim()) ?? 0.0;

        // Accumulate hours by date
        dailyHours.update(formattedDate,
            (existingHours) => roundToPrecision(existingHours + hours, 2),
            ifAbsent: () => hours);
        // totalHours += hours;
        hoursIndex++;
      }

      String id = userMatch.group(1)!.trim();
      String name = userMatch.group(2)!.trim();

      // Convert the dailyHours map to a list of maps
      List<Map<String, dynamic>> aggregatedHoursList = dailyHours.entries
          .map((entry) => {'date': entry.key, 'hours': entry.value})
          .toList();

      userHours.add({
        'id': id,
        'name': name,
        'hours': aggregatedHoursList,
        // 'total_hours': totalHours
      });
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

  String finalJsonConvert(String text) {
    final userHours = extractUserHours(text);
    double calculatedTotalHours = userHours.fold(0, (sum, user) {
      return sum +
          (user['hours'] as List<Map<String, dynamic>>).fold(0,
              (innerSum, hoursEntry) {
            return innerSum + (hoursEntry['hours']);
          });
    });
    double reportedTotalHours = extractReportTotalHours(text);
    Map<String, String> dates = extractDates(text);
    final jsonData = convertToJson(
      userHours,
      roundToPrecision(calculatedTotalHours, 2),
      roundToPrecision(reportedTotalHours, 2),
      dates,
    );
    return jsonData;
  }
}
