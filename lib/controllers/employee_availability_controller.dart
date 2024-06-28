import 'dart:developer';

import 'package:get/get.dart';

import '../models/enployee_model.dart';
import '../service/employee_service.dart';

class EmployeeAvailabilityController extends GetxController {
  final EmployeeFirestoreService _firestoreService = EmployeeFirestoreService();
  Stream<List<EmployeeModel>> get employeeStream =>
      _firestoreService.getEmployees();

  var employees = <EmployeeModel>[].obs;
  final currentEmployee = Rx<EmployeeModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  void fetchEmployees() {
    _firestoreService.getEmployees().listen((employeeData) {
      employees.assignAll(employeeData);
    });
    log('employees: ${employees.map((element) => element.toMap())}');
  }
}
