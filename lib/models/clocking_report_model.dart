// To parse this JSON data, do
//
//     final clockingReportModel = clockingReportModelFromMap(jsonString);

import 'dart:convert';

ClockingReportModel clockingReportModelFromMap(String str) =>
    ClockingReportModel.fromMap(json.decode(str));

String clockingReportModelToMap(ClockingReportModel data) =>
    json.encode(data.toMap());

class ClockingReportModel {
  final List<Employee> employees;
  final double calculatedTotalHours;
  final double reportedTotalHours;

  ClockingReportModel({
    required this.employees,
    required this.calculatedTotalHours,
    required this.reportedTotalHours,
  });

  factory ClockingReportModel.fromMap(Map<String, dynamic> json) =>
      ClockingReportModel(
        employees: List<Employee>.from(
            json["employees"].map((x) => Employee.fromMap(x))),
        calculatedTotalHours: json["calculatedTotalHours"]?.toDouble(),
        reportedTotalHours: json["reportedTotalHours"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "employees": List<dynamic>.from(employees.map((x) => x.toMap())),
        "calculatedTotalHours": calculatedTotalHours,
        "reportedTotalHours": reportedTotalHours,
      };
}

class Employee {
  final String id;
  final String name;
  final double hours;

  Employee({
    required this.id,
    required this.name,
    required this.hours,
  });

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["name"],
        hours: json["hours"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "hours": hours,
      };
}
