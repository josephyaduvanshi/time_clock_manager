import 'package:get/get.dart';
import 'package:time_clock_manager/controllers/employee_availability_controller.dart';


class StaffAvailabilityBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeAvailabilityController());
  }
}
