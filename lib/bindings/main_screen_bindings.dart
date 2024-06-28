import 'package:get/get.dart';
import 'package:time_clock_manager/controllers/clockin_report_firestore_controller.dart';
import 'package:time_clock_manager/controllers/home_page_controller.dart';

class MainScreenBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageContr());
    Get.lazyPut(() => ClockinReportFireStoreController());
  }
}
