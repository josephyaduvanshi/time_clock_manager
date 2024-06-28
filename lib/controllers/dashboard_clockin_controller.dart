import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/enployee_model.dart';

class DashBoardClockInController extends GetxController {
  static DashBoardClockInController instance = Get.find();
  RxString selectedEmployeeId = "".obs;
  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  Rx<DateTime?> lastClockInTime = Rxn<DateTime>();
  RxBool isClockedIn = false.obs;
  final RxBool isDecimalHour = true.obs;
  final RxString store = ''.obs;

  RxList<TimeRecord> todayRecords = <TimeRecord>[].obs;
  final authenticateTextController = TextEditingController().obs;
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    store.value = isGreenway.value ? "Greenway" : "Weston";
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateLiveTime());
    fetchEmployees();
    fetchAllTodaysTimeRecords();
    selectedEmployeeId.listen((_) => updateClockInStatus());
  }

  final Rx<DateTime> liveTime = DateTime.now().obs;
  void updateLiveTime() {
    liveTime.value = DateTime.now().add(Duration(seconds: 1));
  }

  @override
  void onClose() {
    authenticateTextController.value.dispose();
    resetSelection();
    timer.cancel();
    super.onClose();
  }

  void fetchEmployees() {
    FirebaseFirestore.instance
        .collection('users')
        .where('store', isEqualTo: store.value)
        .snapshots()
        .listen((snapshot) {
      employees.value = snapshot.docs
          .map((doc) => EmployeeModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> fetchAllTodaysTimeRecords() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    var employeesWithRecords = await FirebaseFirestore.instance
        .collection('users')
        .where('store', isEqualTo: store.value)
        .get();
    List<TimeRecord> allRecords = [];

    for (var employeeDoc in employeesWithRecords.docs) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(employeeDoc.id)
          .collection('timeRecords')
          .where('clockIn',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('clockIn', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('clockIn')
          .get();

      var dayRecords = querySnapshot.docs
          .map((doc) => TimeRecord.fromMap(doc.data(), doc.id))
          .toList();
      allRecords.addAll(dayRecords);
    }
    todayRecords.value = allRecords;
  }

  Future<void> clockIn(String employeeId, String pin) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(employeeId)
        .collection('timeRecords')
        .add({
      'clockIn': FieldValue.serverTimestamp(),
      'employeeId': employeeId,
      'employeeName': employees.firstWhere((e) => e.id == employeeId).name,
      'clockOut': null,
    });
    updateClockInStatus();
  }

  Future<void> clockOut(String employeeId, String pin) async {
    var collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(employeeId)
        .collection('timeRecords');

    var querySnapshot = await collectionRef
        .where('clockOut', isNull: true)
        .orderBy('clockIn', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({
        'clockOut': FieldValue.serverTimestamp(),
      });
      updateClockInStatus();
    } else {
      print("No clock-in record found to clock out.");
    }
  }

  void updateClockInStatus() async {
    if (selectedEmployeeId.value.isEmpty) {
      isClockedIn.value = false;
      return;
    }

    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(selectedEmployeeId.value)
        .collection('timeRecords')
        .orderBy('clockIn', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var lastRecord = querySnapshot.docs.first.data();
      isClockedIn.value = lastRecord['clockOut'] == null;
      if (isClockedIn.value) {
        lastClockInTime.value = (lastRecord['clockIn'] as Timestamp).toDate();
      } else {
        lastClockInTime.value = null;
      }
    } else {
      isClockedIn.value = false;
      lastClockInTime.value = null;
    }
  }

  bool authenticatePin(String employeeId, String pin) {
    EmployeeModel employeeDoc = employees.firstWhere((e) => e.id == employeeId);
    return employeeDoc.pin == pin;
  }

  Future<String> getAccumulatedHours(String employeeId) async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(employeeId)
        .collection('timeRecords')
        .where('clockIn',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('clockIn', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('clockIn')
        .get();

    List<TimeRecord> records = querySnapshot.docs
        .map((doc) => TimeRecord.fromMap(doc.data(), doc.id))
        .toList();

    int totalMinutes = 0;
    for (int i = 0; i < records.length; i += 2) {
      if (i + 1 < records.length) {
        DateTime clockInTime = records[i].clockIn;
        DateTime clockOutTime = records[i + 1].clockIn;
        Duration difference = clockOutTime.difference(clockInTime);
        totalMinutes += difference.inMinutes;
      }
    }

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return "$hours hours $minutes minutes";
  }

  void resetSelection() {
    selectedEmployeeId.value = "";
    lastClockInTime.value = null;
    isClockedIn.value = false;
    authenticateTextController.value.clear();
    update(); // Forces a UI update in GetX if needed
  }

  String calculateAccumulatedHours(List<TimeRecord> records) {
    int totalMinutes = 0;

    for (var record in records) {
      if (record.clockOut != null) {
        Duration difference = record.clockOut!.difference(record.clockIn);
        totalMinutes += difference.inMinutes;
      }
    }

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    return "$hours hours $minutes minutes";
  }

  String getElapsedTime() {
    if (lastClockInTime.value == null) return '';
    Duration elapsed = DateTime.now().difference(lastClockInTime.value!);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(elapsed.inHours);
    final minutes = twoDigits(elapsed.inMinutes.remainder(60));
    final seconds = twoDigits(elapsed.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}

class TimeRecord {
  final String id;
  final DateTime clockIn;
  final DateTime? clockOut;
  final String employeeId;
  final String employeeName;

  TimeRecord({
    required this.id,
    required this.clockIn,
    this.clockOut,
    required this.employeeId,
    required this.employeeName,
  });

  factory TimeRecord.fromMap(Map<String, dynamic> map, String documentId) {
    return TimeRecord(
      id: documentId,
      clockIn: (map['clockIn'] as Timestamp).toDate(),
      clockOut: map['clockOut'] != null
          ? (map['clockOut'] as Timestamp).toDate()
          : null,
      employeeId: map['employeeId'],
      employeeName: map['employeeName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clockIn': clockIn,
      'clockOut': clockOut,
      'employeeId': employeeId,
      'employeeName': employeeName,
    };
  }

  String get formattedDateClockIn => DateFormat('yyyy-MM-dd').format(clockIn);

  String get formattedDateTimeClockIn =>
      DateFormat('yyyy-MM-dd').format(clockIn);

  String get formattedDateTimeClockOut =>
      clockOut != null ? DateFormat('yyyy-MM-dd').format(clockOut!) : '';

  String getDuration() {
    if (clockOut == null) return "In Progress";
    final duration = clockOut!.difference(clockIn);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours hours $minutes minutes $seconds seconds";
  }

  String getDurationDecimal() {
    if (clockOut == null) return "In Progress";
    final duration = clockOut!.difference(clockIn);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return "${(hours + (minutes / 60) + (seconds / 3600)).toPrecision(2)} hours";
  }

  String get formattedTimeClockIn => DateFormat('hh:mm:ss a').format(clockIn);
  String get formattedTimeClockOut =>
      clockOut != null ? DateFormat('hh:mm:ss a').format(clockOut!) : 'Not yet';
  String get dayOfWeek => DateFormat('EEEE').format(clockIn);
}
