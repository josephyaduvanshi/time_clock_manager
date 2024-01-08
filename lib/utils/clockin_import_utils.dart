import 'dart:convert';
import 'dart:math';

class ClockinReportUtils {
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

  String finalJsonConvert(String data) {
    final userHours = extractUserHours(
      data,
    );
    double calculatedTotalHours =
        userHours.fold(0, (sum, item) => sum + item['hours']);
    double reportedTotalHours = extractReportTotalHours(data);
    Map<String, String> dates = extractDates(data);
    final jsonData = convertToJson(
      userHours,
      roundToPrecision(calculatedTotalHours, 2),
      roundToPrecision(reportedTotalHours, 2),
      dates,
    );
    return jsonData;
  }
}
