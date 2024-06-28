
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_clock_manager/main.dart';

import '../models/enployee_model.dart';

class EmployeeFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
final store = isGreenway.value ? "Greenway" : "Weston";
  Stream<List<EmployeeModel>> getEmployees() {
    log('store: $store');
    return _db.collection('users') 
    .where('store', isEqualTo: store)
    .snapshots().map((snapshot) => snapshot.docs
        .map((doc) => EmployeeModel.fromMap(doc.data(), doc.id))
        .toList());
  }
}
