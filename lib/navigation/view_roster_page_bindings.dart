import 'package:get/get.dart';
import 'package:time_clock_manager/controllers/roster_controller.dart';

class ViewRosterBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RosterController());
  }
}
