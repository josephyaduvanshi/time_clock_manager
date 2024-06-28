import 'package:cloud_firestore/cloud_firestore.dart';

enum Store {
  GREENWAY,
  WESTON,
  // add other stores as needed
}

class DailyReportModel {
  final String id;
  final DateTime date;
  final double delivery;
  final double shop;
  final double pickup;
  final Map<String, List<dynamic>> onlineOrderSources;
  final double grossSales;
  final double netSales;
  final double gst;
  final Map<String, double> instorePayments;
  final Map<String, List<dynamic>> allDayOrderOverview;
  final int newCustomers;
  final Timestamp submittedTime;
  final DateTime reportDate;
  final Store store;

  DailyReportModel({
    required this.id,
    required this.date,
    required this.delivery,
    required this.shop,
    required this.pickup,
    required this.onlineOrderSources,
    required this.grossSales,
    required this.netSales,
    required this.gst,
    required this.instorePayments,
    required this.allDayOrderOverview,
    required this.newCustomers,
    required this.submittedTime,
    required this.reportDate,
    required this.store,
  });

  factory DailyReportModel.fromMap(Map<String, dynamic> data, String id) {
    return DailyReportModel(
      id: id,
      date: (data['date'] as Timestamp).toDate(),
      delivery: data['delivery'],
      shop: data['shop'],
      pickup: data['pickup'],
      onlineOrderSources:
          Map<String, List<dynamic>>.from(data['onlineOrderSources']),
      grossSales: data['grossSales'],
      netSales: data['netSales'],
      gst: data['gst'],
      instorePayments: Map<String, double>.from(data['instorePayments']),
      allDayOrderOverview:
          Map<String, List<dynamic>>.from(data['allDayOrderOverview']),
      newCustomers: data['newCustomers'],
      submittedTime: data['submittedTime'],
      reportDate: (data['reportDate'] as Timestamp).toDate(),
      store: Store.values.byName(data['store']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'delivery': delivery,
      'shop': shop,
      'pickup': pickup,
      'onlineOrderSources': onlineOrderSources,
      'grossSales': grossSales,
      'netSales': netSales,
      'gst': gst,
      'instorePayments': instorePayments,
      'allDayOrderOverview': allDayOrderOverview,
      'newCustomers': newCustomers,
      'submittedTime': submittedTime,
      'reportDate': reportDate,
      'store': store.name,
    };
  }
}
