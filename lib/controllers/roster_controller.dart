import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_clock_manager/main.dart';
import 'package:time_clock_manager/models/enployee_model.dart';
import 'package:time_clock_manager/models/roster_model.dart';
import 'package:time_clock_manager/service/roster_firestore_service.dart';
import '../models/request_model.dart';
import '../service/firebase_replacment_requests_service.dart';
import 'auth_controller.dart';

enum ViewType { Weekly, Fortnightly, Monthly }

class RosterController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final FirestoreRequestReplacementService _requestService =
      FirestoreRequestReplacementService();

  var rosters = <RosterModel>[].obs;
  var userRosters = <RosterModel>[].obs;
  var employees = <EmployeeModel>[].obs;
  var selectedEmployee = Rx<EmployeeModel?>(null);
  var isLoading = false.obs;
  var isCustomView = isAdmin.value.obs;
  var sentRequests = <RequestModel>[].obs;
  var receivedRequests = <RequestModel>[].obs;

  GlobalKey<FormFieldState> employeeDropdownKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> positionDropdownKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> storeDropdownKey = GlobalKey<FormFieldState>();

  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  var selectedWeekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)).obs;
  var selectedWeekRosters = <RosterModel>[].obs;
  var viewType = ViewType.Weekly.obs;
  var firstDate =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)).obs;
  var lastDate =
      DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)).obs;
  var focusDate = DateTime.now().obs;

  final userNameController = TextEditingController();
  final selectedPosition = Position.ALLROUNDER.name.obs;
  final startTimeController = TextEditingController();
  final finishTimeController = TextEditingController();
  final storeController = TextEditingController(text: Store.values.first.name);
  final shiftDescriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllRosters();
    fetchUserRosters(Get.find<AuthController>().firebaseUser.value!.uid);
    fetchEmployees();
  }

  void fetchEmployees() {
    _firestoreService.getEmployees().listen((employeeData) {
      employees.assignAll(employeeData);
    });
  }

  Future<void> sendReplacementRequest(RequestModel request) async {
    try {
      await _requestService.sendReplacementRequest(request);
      Get.snackbar('Success', 'Replacement request sent successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> respondToRequest(
    String userId,
    String requestId,
    RequestStatus status,
    String replyMessage,
  ) async {
    try {
      await _requestService.respondToRequest(
        requestId,
        userId,
        status,
        replyMessage,
      );
      Get.snackbar('Success', 'Response sent successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Stream<List<RequestModel>> getSentRequests(String senderId) {
    return _requestService.getSentRequests(senderId);
  }

  Stream<List<RequestModel>> getReceivedRequests(String recipientId) {
    return _requestService.getReceivedRequests(recipientId).map((requests) {
      return requests.where((request) {
        return request.recipientId == "ALL" ||
            request.recipientId == recipientId;
      }).toList();
    });
  }

  String generateIdRequests() {
    return _requestService.generateId();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
    fetchDayRosters(selectedDay);
  }

  void fetchDayRosters(DateTime date) {
    isLoading.value = true;
    if (isAdmin.value) {
      log('Fetching all rosters for the day admin: $date');
      final filteredRosters = rosters.where((roster) {
        return roster.startTime.year == date.year &&
            roster.startTime.month == date.month &&
            roster.startTime.day == date.day;
      }).toList();
      userRosters.assignAll(filteredRosters);
    } else {
      log('Fetching user rosters for the day non admin: $date');
      final filteredRosters = rosters
          .where((roster) {
            return roster.startTime.year == date.year &&
                roster.startTime.month == date.month &&
                roster.startTime.day == date.day;
          })
          .toList()
          .where((element) =>
              element.userId ==
              Get.find<AuthController>().firebaseUser.value!.uid)
          .toList();
      userRosters.assignAll(filteredRosters);
    }

    isLoading.value = false;
  }

  void onFormatChanged(CalendarFormat format) {
    // Handle format change
  }

  void fetchAllRosters() {
    _firestoreService.getAllRosters().listen((rosterData) {
      rosters.assignAll(rosterData);
    });
  }

  void fetchUserRosters(String userId) {
    _firestoreService.getRosters(userId).listen((rosterData) {
      userRosters.assignAll(rosterData);
    });
  }

  void fetchWeekRosters() {
    final weekStart = selectedDay.value
        .subtract(Duration(days: selectedDay.value.weekday - 1));
    _firestoreService.getWeekRosters(weekStart).listen((rosterData) {
      selectedWeekRosters.assignAll(rosterData);
    });
  }

  Future<void> addWeeklyRoster() async {
    log('Adding Roster');
    if (selectedEmployee.value == null) {
      log('No employee selected');
      Get.snackbar('Error', 'Please select an employee');
      return;
    }
    log('Employee selected');

    try {
      log('Parsing time');
      final startTime = _parseTimeOfDay(startTimeController.text.trim());
      final finishTime = _parseTimeOfDay(finishTimeController.text.trim());

      if (startTime == null || finishTime == null) {
        throw FormatException('Invalid time format');
      }

      // Validate the store and position values
      final storeName = storeController.text.trim();
      final positionName = selectedPosition.value.trim();

      if (storeName.isEmpty || !Store.values.any((e) => e.name == storeName)) {
        throw ArgumentError('Invalid store name: $storeName');
      }
      if (positionName.isEmpty ||
          !Position.values.any((e) => e.name == positionName)) {
        throw ArgumentError('Invalid position name: $positionName');
      }

      final newRoster = RosterModel(
        id: _firestoreService.generateId(),
        userId: selectedEmployee.value!.id,
        userName: selectedEmployee.value!.name,
        userAvatr: selectedEmployee.value!.avatar,
        position: Position.values.byName(positionName),
        startTime: DateTime(selectedDay.value.year, selectedDay.value.month,
            selectedDay.value.day, startTime.hour, startTime.minute),
        finishTime: DateTime(selectedDay.value.year, selectedDay.value.month,
            selectedDay.value.day, finishTime.hour, finishTime.minute),
        store: Store.values.byName(storeName),
        shiftDescription: shiftDescriptionController.text,
        isDraft: true,
      );
      log('New Roster: $newRoster');

      await _firestoreService.addRoster(newRoster);
      log('Roster Added');
      fetchWeekRosters();
      log('Week Rosters Fetched');
      Get.snackbar('Success', 'Roster added successfully');
    } catch (e) {
      log('Error: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> addPublishIndividualRoster() async {
    log('Adding Roster');
    if (selectedEmployee.value == null) {
      log('No employee selected');
      Get.snackbar('Error', 'Please select an employee');
      return;
    }
    log('Employee selected');

    try {
      log('Parsing time');
      final startTime = _parseTimeOfDay(startTimeController.text.trim());
      final finishTime = _parseTimeOfDay(finishTimeController.text.trim());

      if (startTime == null || finishTime == null) {
        throw FormatException('Invalid time format');
      }

      // Validate the store and position values
      final storeName = storeController.text.trim();
      final positionName = selectedPosition.value.trim();

      if (storeName.isEmpty || !Store.values.any((e) => e.name == storeName)) {
        throw ArgumentError('Invalid store name: $storeName');
      }
      if (positionName.isEmpty ||
          !Position.values.any((e) => e.name == positionName)) {
        throw ArgumentError('Invalid position name: $positionName');
      }

      final newRoster = RosterModel(
        id: _firestoreService.generateId(),
        userId: selectedEmployee.value!.id,
        userName: selectedEmployee.value!.name,
        userAvatr: selectedEmployee.value!.avatar,
        position: Position.values.byName(positionName),
        startTime: DateTime(selectedDay.value.year, selectedDay.value.month,
            selectedDay.value.day, startTime.hour, startTime.minute),
        finishTime: DateTime(selectedDay.value.year, selectedDay.value.month,
            selectedDay.value.day, finishTime.hour, finishTime.minute),
        store: Store.values.byName(storeName),
        shiftDescription: shiftDescriptionController.text,
        isDraft: false,
      );
      log('New Roster: $newRoster');

      await _firestoreService.addRoster(newRoster);
      log('Roster Added');
      fetchWeekRosters();
      log('Week Rosters Fetched');
      Get.snackbar('Success', 'Roster added successfully');
    } catch (e) {
      log('Error: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateRoster(RosterModel roster) async {
    try {
      await _firestoreService.updateRoster(roster);
      fetchWeekRosters();
      Get.snackbar('Success', 'Roster updated successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteRoster(String id) async {
    try {
      await _firestoreService.deleteRoster(id);
      fetchWeekRosters();
      Get.snackbar('Success', 'Roster deleted successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteAllShifts() async {
    try {
      for (var roster in selectedWeekRosters) {
        await _firestoreService.deleteRoster(roster.id);
      }
      fetchWeekRosters();
      Get.snackbar('Success', 'All shifts deleted successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> publishAllShifts() async {
    try {
      for (var roster in selectedWeekRosters) {
        final updatedRoster = RosterModel(
          id: roster.id,
          userId: roster.userId,
          userName: roster.userName,
          userAvatr: roster.userAvatr,
          position: roster.position,
          startTime: roster.startTime,
          finishTime: roster.finishTime,
          store: roster.store,
          shiftDescription: roster.shiftDescription,
          isDraft: false,
        );
        await _firestoreService.updateRoster(updatedRoster);
      }
      fetchWeekRosters();
      Get.snackbar('Success', 'All shifts published successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void resetForm() {
    selectedEmployee.value = null;
    userNameController.clear();
    startTimeController.clear();
    finishTimeController.clear();
    storeController.text = Store.values.first.name;
    selectedPosition.value = Position.ALLROUNDER.name;
    shiftDescriptionController.clear();
    employeeDropdownKey.currentState!.reset();
    positionDropdownKey.currentState!.reset();
    storeDropdownKey.currentState!.reset();
  }

  Future<void> copyPreviousWeekRosters(DateTime weekStart) async {
    try {
      await _firestoreService.copyPreviousWeekRosters(weekStart);
      fetchWeekRosters();
      Get.snackbar('Success', 'Rosters copied from previous week');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  TimeOfDay? _parseTimeOfDay(String timeString) {
    try {
      log('Time String: $timeString');
      final timeParts = timeString.split(RegExp(r'[: ]'));
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = timeParts[2].toUpperCase();

      final isPM = period == 'PM';
      final correctedHour = isPM ? (hour % 12) + 12 : (hour % 12);

      log('Parsed Time: $correctedHour:$minute');
      return TimeOfDay(hour: correctedHour, minute: minute);
    } catch (e) {
      log('Time parsing error: $e');
      return null;
    }
  }

  Future<void> fetchRostersByDate(DateTime date) async {
    try {
      isLoading.value = true;
      focusDate.value = date;
      String userId = Get.find<AuthController>().firebaseUser.value!.uid;
      final start = DateTime(date.year, date.month, date.day);
      final end = DateTime(date.year, date.month, date.day, 23, 59, 59);
      final snapshot =
          await _firestoreService.getRostersByDate(userId, start, end);
      userRosters.assignAll(snapshot);
      isLoading.value = false;
    } catch (e) {
      log('Error: $e');
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  void updateViewType(ViewType newViewType) {
    viewType.value = newViewType;
    updateDateRange();
    fetchRostersForCurrentView();
  }

  void updateDateRange() {
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (viewType.value) {
      case ViewType.Weekly:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = startDate.add(Duration(days: 6));
        break;
      case ViewType.Fortnightly:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = startDate.add(Duration(days: 13));
        break;
      case ViewType.Monthly:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
    }

    firstDate.value = startDate;
    lastDate.value = endDate;
    focusDate.value = startDate;
  }

  void fetchRostersForCurrentView() {
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (viewType.value) {
      case ViewType.Weekly:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = startDate.add(Duration(days: 6));
        break;
      case ViewType.Fortnightly:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = startDate.add(Duration(days: 13));
        break;
      case ViewType.Monthly:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
    }

    fetchRostersInRange(startDate, endDate);
  }

  double calculateTotalHours(
    String userId,
  ) {
    double totalHours = 0.0;
    final List<RosterModel> employeeRosters =
        rosters.where((roster) => roster.userId == userId).toList();
    totalHours = employeeRosters.fold(0.0, (sum, roster) {
      return sum + roster.finishTime.difference(roster.startTime).inHours;
    });
    return totalHours.toPrecision(2);
  }

  Future<void> fetchRostersInRange(DateTime start, DateTime end) async {
    try {
      isLoading.value = true;
      String userId = Get.find<AuthController>().firebaseUser.value!.uid;
      final snapshot =
          await _firestoreService.getRostersByDate(userId, start, end);
      userRosters.assignAll(snapshot);
      isLoading.value = false;
    } catch (e) {
      log('Error: $e');
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
