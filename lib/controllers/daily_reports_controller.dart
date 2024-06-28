import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_report_model.dart';

class DailyReportsController extends GetxController {
  var dailyReports = <DailyReportModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchDailyReports();
  }

  void fetchDailyReports() {
    _firestore.collection('dailyreports').snapshots().listen((snapshot) {
      dailyReports.value = snapshot.docs.map((doc) {
        return DailyReportModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> addDailyReport(DailyReportModel report) async {
    await _firestore.collection('dailyreports').add(report.toMap());
  }
}
