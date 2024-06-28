// To parse this JSON data, do
//
//     final clockingReportModel = clockingReportModelFromMap(jsonString);

import 'dart:convert';

ClockingReportModel clockingReportModelFromMap(String str) =>
    ClockingReportModel.fromMap(json.decode(str));

String clockingReportModelToMap(ClockingReportModel data) =>
    json.encode(data.toMap());

Employee employeeFromMap(String str) => Employee.fromMap(json.decode(str));

String employeeToMap(Employee data) => json.encode(data.toMap());

class ClockingReportModel {
  final List<Employee> employees;
  final double calculatedTotalHours;
  final double reportedTotalHours;
  final String startDate;
  final String endDate;

  ClockingReportModel({
    required this.employees,
    required this.calculatedTotalHours,
    required this.reportedTotalHours,
    required this.startDate,
    required this.endDate,
  });

  factory ClockingReportModel.fromMap(Map<String, dynamic> json) =>
      ClockingReportModel(
        employees: List<Employee>.from(
            json["employees"].map((x) => Employee.fromMap(x))),
        calculatedTotalHours: json["calculatedTotalHours"]?.toDouble(),
        reportedTotalHours: json["reportedTotalHours"]?.toDouble(),
        startDate: json["startDate"],
        endDate: json["endDate"],
      );

  Map<String, dynamic> toMap() => {
        "employees": List<dynamic>.from(employees.map((x) => x.toMap())),
        "calculatedTotalHours": calculatedTotalHours,
        "reportedTotalHours": reportedTotalHours,
        "startDate": startDate,
        "endDate": endDate,
      };
}

class Employee {
  final String id;
  final String name;
  final List<Hour> hours;
  final String pin;

  Employee({
    required this.id,
    required this.name,
    required this.hours,
    required this.pin,
  });

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["name"],
        hours: List<Hour>.from(json["hours"].map((x) => Hour.fromMap(x))),
        pin: json["pin"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "hours": List<dynamic>.from(hours.map((x) => x.toMap())),
        "pin": pin,
      };
}

class Hour {
  final DateTime date;
  final double hours;

  Hour({
    required this.date,
    required this.hours,
  });

  factory Hour.fromMap(Map<String, dynamic> json) => Hour(
        date: DateTime.parse(json["date"]),
        hours: json["hours"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "date": date.toIso8601String(),
        "hours": hours,
      };
}
