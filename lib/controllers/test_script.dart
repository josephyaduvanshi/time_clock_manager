import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../models/enployee_model.dart';

Random random = Random();

Future<void> generateAndStoreTimeRecords() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime start = DateTime(2023, 12, 1);
  DateTime end = DateTime.now();
  List<DateTime> workDays = getWorkDaysExcludingWeekendsAndHolidays(start, end);

  var employeesSnapshot = await firestore.collection('users_granite').get();
  List<EmployeeModel> employees = employeesSnapshot.docs
      .map((doc) => EmployeeModel.fromMap(doc.data(), doc.id))
      .toList();

  for (var employee in employees) {
    for (var day in workDays) {
      DateTime morningClockIn = DateTime(day.year, day.month, day.day, 9);
      DateTime breakStart =
          DateTime(day.year, day.month, day.day, 13); // Break starts at 1 PM
      DateTime breakEnd =
          breakStart.add(Duration(minutes: 30)); // Break ends at 1:30 PM
      DateTime shiftEnd = DateTime(
          day.year, day.month, day.day, 17); // Regular shift end at 5 PM

      // Adding random overtime
      if (random.nextInt(10) < 2) {
        // 20% chance
        int overtimeMinutes = random.nextInt(180); // up to 3 extra hours
        shiftEnd = shiftEnd.add(Duration(minutes: overtimeMinutes));
      }

      // Morning session clock-in to break start
      await storeTimeRecord(firestore, employee, morningClockIn, breakStart);

      // After break till end of the shift
      await storeTimeRecord(firestore, employee, breakEnd, shiftEnd);
    }
  }
}

Future<void> storeTimeRecord(FirebaseFirestore firestore,
    EmployeeModel employee, DateTime clockIn, DateTime clockOut) async {
  await firestore
      .collection('users_granite')
      .doc(employee.id)
      .collection('timeRecords')
      .add({
    'clockIn': clockIn,
    'clockOut': clockOut,
    'employeeId': employee.id,
    'employeeName': employee.name,
    'dayOfWeek': DateFormat('EEEE').format(clockIn),
  });
}

List<DateTime> getWorkDaysExcludingWeekendsAndHolidays(
    DateTime start, DateTime end) {
  List<DateTime> days = [];
  List<DateTime> publicHolidays = getPublicHolidays2023();

  for (int i = 0; i <= end.difference(start).inDays; i++) {
    DateTime day = start.add(Duration(days: i));
    if (day.weekday != DateTime.saturday &&
        day.weekday != DateTime.sunday &&
        !publicHolidays.contains(day)) {
      days.add(day);
    }
  }
  return days;
}

List<DateTime> getPublicHolidays2023() {
  return [
    DateTime(2023, 1, 1),
    DateTime(2023, 1, 3),
    DateTime(2023, 1, 26),
    DateTime(2023, 4, 7),
    DateTime(2023, 4, 8),
    DateTime(2023, 4, 9),
    DateTime(2023, 4, 10),
    DateTime(2023, 4, 25),
    DateTime(2023, 6, 12),
    DateTime(2023, 8, 7),
    DateTime(2023, 10, 2),
    DateTime(2023, 12, 25),
    DateTime(2023, 12, 26),
  ];
}
