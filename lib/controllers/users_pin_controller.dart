import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/main.dart';

import '../models/enployee_model.dart';

class UsersPinController extends GetxController {
  String get _collection => "users";

  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;

  String get store => isGreenway.value ? "Greenway" : "Weston";

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  void fetchEmployees() {
    print("fetchEmployees $_collection");
    FirebaseFirestore.instance
        .collection(_collection)
        .where('store', isEqualTo: store)
        .snapshots()
        .listen((snapshot) {
      employees.value = snapshot.docs
          .map((doc) => EmployeeModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  void updateUserPin(String id, String pin) async {
    await FirebaseFirestore.instance
        .collection(_collection)
        .doc(id)
        .update({'pin': pin});
  }
}
