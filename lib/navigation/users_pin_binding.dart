import 'package:get/get.dart';

import '../controllers/users_pin_controller.dart';

class UsersPinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UsersPinController());
  }
}
