import 'dart:convert';
import 'dart:developer' show log;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_clock_manager/main.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import '../models/clocking_report_model.dart';
import '../models/enployee_model.dart';
import '../models/recent_week_model.dart';

class ClockinReportFireStoreController extends GetxController {
  static ClockinReportFireStoreController to = Get.find();
  static String _collection =
      isGreenway.isTrue ? 'employees' : 'employees_weston';
  var isNameSorted = false.obs;
  var isDateSorted = false.obs;
  var isHoursSorted = false.obs;
  final Map<String, Map<String, double>> weeklyReport = {};
  late Future<Map<String, Map<String, double>>> futureGetWeeklyData;
  final Rx<DateTime?> selectedDate = DateTime.now().obs;
  final RxBool isFortnightly = false.obs;
  final RxMap currentWeekReport = {}.obs;
  final RxMap nextWeekReport = {}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isDownloading = false.obs;

  final RxBool isLoadingWeek2 = false.obs;

  final Rx<ViewMode> viewMode = ViewMode.Weekly.obs;
  final Map<String, Map<String, double>> weeklyReport_1 = {};
  Future<void> downloadFile(
      {required Map<String, dynamic> data, required String filename}) async {
    try {
      isDownloading.value = true;
      final url =
          "https://web-production-7ea4d.up.railway.app/weekly_hours_report"; // Replace with the actual URL

      // Correct the variable name from 'h' to 'data'
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data), // Ensure 'data' is properly encodable to JSON
        headers: {
          "Content-Type": "application/json",
        },
      );

      Uint8List content = response.bodyBytes;
      final blob = html.Blob([content]);
      final url_ = html.Url.createObjectUrlFromBlob(blob);
      // ignore: unused_local_variable
      final anchor = html.AnchorElement(href: url_)
        ..setAttribute("download", "${filename}.xlsx")
        ..click();

      html.Url.revokeObjectUrl(url_);
      isDownloading.value = false;
    } catch (e) {
      print("Error downloading the file: $e");
    }
  }

  void fetchWeekData(DateTime date) {
    isLoading.value = true;
    DateTime weekStart = date.subtract(Duration(days: date.weekday - 1));
    selectedDate.value = weekStart;

    // Fetch current week data
    getWeeklyData(weekStart).then((value) {
      currentWeekReport.clear();
      currentWeekReport.addAll(value);
      if (isFortnightly.value) {
        // Fetch next week data if fortnightly mode is on
        getWeeklyData(weekStart.add(Duration(days: 7))).then((nextValue) {
          nextWeekReport.clear();
          nextWeekReport.addAll(nextValue);
          isLoading.value = false;
        });
      } else {
        isLoading.value = false;
      }
    });
  }

  void toggleViewMode(v) {
    isFortnightly.toggle();
    fetchWeekData(selectedDate.value!);
  }

  Map<String, dynamic> getStructuredDataForExport() {
    Map<String, dynamic> data = {
      "data": {
        "currentWeek": currentWeekReport,
        "nextWeek": isFortnightly.value ? nextWeekReport : {},
      },
      "viewMode": isFortnightly.value ? "Fortnightly" : "Weekly",
      "startDate": DateFormat('yyyy-MM-dd').format(selectedDate.value!),
      "endDate": DateFormat('yyyy-MM-dd').format(selectedDate.value!
          .add(Duration(days: isFortnightly.value ? 13 : 6))),
    };
    return data;
  }

  String getAppBarTitle() {
    final DateFormat formatter = DateFormat('MMMM d');
    if (isFortnightly.value) {
      final nextWeekStart = selectedDate.value!.add(Duration(days: 7));
      return 'Fortnightly Report for ${formatter.format(selectedDate.value!)} - ${formatter.format(nextWeekStart.add(Duration(days: 6)))}';
    } else {
      return 'Weekly Report for ${formatter.format(selectedDate.value!)} - ${formatter.format(selectedDate.value!.add(Duration(days: 6)))}';
    }
  }

  void selectDate(BuildContext context) async {
    final controller = Get.find<ClockinReportFireStoreController>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != controller.selectedDate.value) {
      controller.setSelectedDate(
          picked); // Update the selected date in the controller
    }
  }

  void setSelectedDate(DateTime date) {
    // Adjust the date to the start of the week (Monday)
    DateTime weekStart = date.subtract(Duration(days: date.weekday - 1));
    selectedDate.value = weekStart;

    isLoading.value = true;
    getWeeklyData(weekStart).then((value) {
      weeklyReport.clear();
      weeklyReport.addAll(value);
      isLoading.value = false;
      update(); // If using update() to refresh UI
    });
  }

  // Method to sort by name
  void sortByName() {
    isNameSorted.toggle();
    employeeHours.sort((a, b) {
      final name = "name";

      return isNameSorted.isTrue
          ? a[name].compareTo(b[name])
          : b[name].compareTo(a[name]);
    });
  }

  // Method to sort by date
  void sortByDate() {
    isDateSorted.toggle();
    employeeHours.sort((a, b) {
      return isDateSorted.isTrue
          ? a["hours"].first["date"].compareTo(b["hours"].first["date"])
          : b["hours"].first["date"].compareTo(a["hours"].first["date"]);
    });
  }

  // Method to sort by hours
  void sortByHours() {
    isHoursSorted.toggle();
    employeeHours.sort((a, b) {
      return isHoursSorted.isTrue
          ? a["hours"].first["hours"].compareTo(b["hours"].first["hours"])
          : b["hours"].first["hours"].compareTo(a["hours"].first["hours"]);
    });
  }

  RxList<Map<String, dynamic>> employeeHours = <Map<String, dynamic>>[].obs;
  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;

  Rx<DateTimeRange?> selectedDateRange = Rxn<DateTimeRange>();
  RxList<Map<String, dynamic>> filteredEmployeeHours =
      <Map<String, dynamic>>[].obs;

  void setSelectedDateRange(DateTimeRange range) {
    selectedDateRange.value = range;
    log('Selected date range: $range');
    filterEmployeeHoursByDateRange();
    update(["reportsPage"]);
  }

  void filterEmployeeHoursByDateRange() {
    if (selectedDateRange.value == null) {
      filteredEmployeeHours.assignAll(employeeHours);
    } else {
      DateTime start = selectedDateRange.value!.start;
      DateTime end = selectedDateRange.value!.end;

      filteredEmployeeHours.value = employeeHours
          .map((employeeData) {
            var filteredHours =
                (employeeData['hours'] as List).where((hourData) {
              DateTime hourDate = DateTime.parse(hourData['date']);
              // Ensure the date is at or after the start date and before the end of the range
              return hourDate.isAtSameMomentAs(start) ||
                  (hourDate.isAfter(start) &&
                      hourDate.isBefore(end.add(Duration(days: 1))));
            }).toList();

            return {'name': employeeData['name'], 'hours': filteredHours};
          })
          .where((employeeData) => (employeeData['hours'] as List).isNotEmpty)
          .toList();
    }
    update(); // Notify listeners
  }

  void resetDateRange() {
    selectedDateRange.value = null;
    filterEmployeeHoursByDateRange();
  }

  // Call this method after fetching data from Firestore
  void onDataFetched() {
    filterEmployeeHoursByDateRange(); // Apply initial filter
  }

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeHours();
    isLoading.value = true;
    fetchWeekData(selectedDate.value!);
  }

  void fetchEmployeeHours() {
    FirebaseFirestore.instance
        .collection(_collection)
        .snapshots()
        .listen((snapshot) {
      log('Employee hours fetched successfully');
      employeeHours.value = snapshot.docs.map((doc) => doc.data()).toList();
      employees.value = snapshot.docs
          .map((doc) => EmployeeModel.fromMap(doc.data(), doc.id))
          .toList();
      onDataFetched();
    });
  }

  Future<bool> addOrUpdateEmployeeHours(
      String employeeId, String date, double hours) async {
    if (employeeId.isEmpty || date.isEmpty) {
      print("Invalid input data");
      return false;
    }

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentReference employeeDocRef =
          firestore.collection(_collection).doc(employeeId);

      DocumentSnapshot employeeSnapshot = await employeeDocRef.get();
      Map<String, dynamic> employeeData =
          employeeSnapshot.data() as Map<String, dynamic>? ?? {};
      List<dynamic> hoursList = employeeData['hours'] ?? [];

      // Check if the date already exists in the hours list
      int existingIndex =
          hoursList.indexWhere((element) => element['date'] == date);

      if (existingIndex >= 0) {
        // Update the existing record
        hoursList[existingIndex]['hours'] = hours;
      } else {
        // Add a new record
        hoursList.add({'date': date, 'hours': hours});
      }

      // Set the name as ID if the employee does not exist, otherwise use the existing name
      String name = employeeSnapshot.exists ? employeeData['name'] : employeeId;

      // Update Firestore
      await employeeDocRef
          .set({'name': name, 'hours': hoursList}, SetOptions(merge: true));

      print("Employee hours updated successfully");
      return true;
    } catch (e) {
      print("Failed to update employee hours: $e");
      return false;
    }
  }

  List<Map<String, dynamic>> getEmployeeHours(String employeeId) {
    return employeeHours
        .where((element) => element['employeeId'] == employeeId)
        .toList();
  }

  double getTotalHoursForSpecificDate(String specificDate) {
    double totalHours = 0;

    for (var employeeData in employeeHours) {
      var hoursList = employeeData['hours'] as List<dynamic>;

      for (var hourData in hoursList) {
        var hour = Hour.fromMap(hourData);
        String dateKey = DateFormat('yyyy-MM-dd').format(hour.date);
        if (dateKey == specificDate) {
          totalHours += hour.hours;
        }
      }
    }

    log('Hours for $specificDate: $totalHours');
    return totalHours;
  }

// Modify this method to fetch from the 'timeRecords' subcollection and calculate weekly hours.
  Future<Map<String, Map<String, double>>> getWeeklyData(
      DateTime weekStart) async {
    DateTime weekEnd = weekStart.add(Duration(days: 6));
    Map<String, Map<String, double>> weeklyReport = {};

    var employeeSnapshot =
        await FirebaseFirestore.instance.collection(_collection).get();
    for (var doc in employeeSnapshot.docs) {
      String employeeId = doc.id;
      String employeeName = doc.data()['name'] ?? 'Unknown';

      // Initialize default structure for weekly data
      Map<String, double> employeeWeeklyHours = {
        'Monday': 0.0,
        'Tuesday': 0.0,
        'Wednesday': 0.0,
        'Thursday': 0.0,
        'Friday': 0.0,
        'Saturday': 0.0,
        'Sunday': 0.0,
        'Total Hours': 0.0,
      };

      // Fetch time records for the week
      var timeRecordsSnapshot = await FirebaseFirestore.instance
          .collection(_collection)
          .doc(employeeId)
          .collection('timeRecords')
          .where('clockIn', isGreaterThanOrEqualTo: weekStart)
          .where('clockIn', isLessThanOrEqualTo: weekEnd)
          .get();

      for (var timeRecordDoc in timeRecordsSnapshot.docs) {
        var timeRecord = timeRecordDoc.data();
        DateTime clockIn = (timeRecord['clockIn'] as Timestamp).toDate();
        DateTime? clockOut = timeRecord['clockOut'] != null
            ? (timeRecord['clockOut'] as Timestamp).toDate()
            : null;

        if (clockOut != null) {
          Duration duration = clockOut.difference(clockIn);
          double hours = (duration.inMinutes / 60.0).toPrecision(2);
          String dayOfWeek = DateFormat('EEEE').format(clockIn);

          // Accumulate hours per day
          if (employeeWeeklyHours.containsKey(dayOfWeek)) {
            employeeWeeklyHours[dayOfWeek] =
                (employeeWeeklyHours[dayOfWeek] ?? 0) + hours;
            employeeWeeklyHours['Total Hours'] =
                (employeeWeeklyHours['Total Hours'] ?? 0) + hours;
          }
        }
      }

      weeklyReport[employeeName] = employeeWeeklyHours;
    }

    return weeklyReport;
  }

  List<RecentWeekModel> getLastSevenDaysHours() {
    DateTime now = DateTime.now();
    List<RecentWeekModel> recentWeekList = [];

    for (int i = 6; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      String dayOfWeek = DateFormat('EEEE').format(date);

      log('Fetching hours for date: $formattedDate'); // Debug log
      double totalHours =
          getTotalHoursForSpecificDate(formattedDate).toPrecision(2);

      recentWeekList.add(RecentWeekModel(
        title: dayOfWeek,
        date: formattedDate,
        hours: totalHours,
      ));
    }

    return recentWeekList;
  }

  Map<String, dynamic> calculateGroupedHours(final employeeHours) {
    Map<String, double> totalHoursPerEmployee = {};
    Map<String, double> totalHoursPerDay = {};

    for (var employeeData in employeeHours) {
      String employeeName = employeeData['name'];
      double totalHoursForEmployee = 0;
      var hoursList = employeeData['hours'] as List<dynamic>;

      for (var hourData in hoursList) {
        var hour = Hour.fromMap(hourData);
        String dateKey = hour.date.toIso8601String().substring(0, 10);
        totalHoursForEmployee += hour.hours;
        totalHoursPerDay[dateKey] =
            (totalHoursPerDay[dateKey] ?? 0) + hour.hours;
      }

      totalHoursPerEmployee[employeeName] = totalHoursForEmployee;
    }

    return {
      'totalHoursPerEmployee': totalHoursPerEmployee,
      'totalHoursPerDay': totalHoursPerDay,
    };
  }

  Map<String, double> getTotalHoursPerDay() {
    Map<String, double> totalHoursPerDay = {};
    for (var employee in employeeHours) {
      for (var hourEntry in employee['hours']) {
        log(hourEntry['date']);
        log(hourEntry['hours'].toString());
        totalHoursPerDay[hourEntry['date']] =
            (totalHoursPerDay[hourEntry['date']] ?? 0) + hourEntry['hours'];
      }
    }
    return totalHoursPerDay;
  }

  double getTotalHoursForDate(String date) {
    double totalHours = 0;
    for (var employee in employeeHours) {
      for (var hourEntry in employee['hours']) {
        if (hourEntry['date'] == date) {
          totalHours += hourEntry['hours'];
        }
      }
    }
    return totalHours;
  }

  Future<void> importDataToFirestore(String jsonData) async {
    final ClockingReportModel report = clockingReportModelFromMap(jsonData);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (Employee employee in report.employees) {
      final DocumentReference employeeDocRef =
          firestore.collection(_collection).doc(employee.id);

      Map<String, dynamic>? currentData = await employeeDocRef
          .get()
          .then((doc) => doc.data() as Map<String, dynamic>?);
      List<dynamic> currentHours =
          currentData?['hours'] as List<dynamic>? ?? [];

      for (Hour hour in employee.hours) {
        String date = hour.date.toIso8601String().substring(0, 10);
        Map<String, Object> newHourData = {'date': date, 'hours': hour.hours};

        int existingIndex = currentHours.indexWhere((h) => h['date'] == date);
        if (existingIndex >= 0) {
          currentHours[existingIndex] = newHourData;
        } else {
          currentHours.add(newHourData);
        }
      }

      await employeeDocRef.set({'name': employee.name, 'hours': currentHours},
          SetOptions(merge: true));
    }
  }

  Future<void> addUserIdToAllEmployees() async {
    final CollectionReference employees =
        FirebaseFirestore.instance.collection('employees');

    // Fetch all employee documents
    final QuerySnapshot employeeSnapshot = await employees.get();
    final List<QueryDocumentSnapshot> documents = employeeSnapshot.docs;

    // Update each document with a PIN
    for (var doc in documents) {
      await employees
          .doc(doc.id)
          .update({
            'userId': doc.id,
          })
          .then((_) => print('PIN added to ${doc.id}'))
          .catchError(
              (error) => print('Failed to add PIN to ${doc.id}: $error'));
    }
  }
}

enum ViewMode {
  Weekly,
  Fortnightly,
}
