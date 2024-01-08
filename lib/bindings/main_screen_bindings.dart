import 'package:get/get.dart';
import 'package:time_clock_manager/controllers/home_page_controller.dart';

class MainScreenBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageContr());
  }
}
