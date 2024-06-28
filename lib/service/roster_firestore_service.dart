import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_clock_manager/main.dart';
import 'package:time_clock_manager/models/roster_model.dart';

import '../models/enployee_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<List<EmployeeModel>> getEmployees() {
    final store = isGreenway.value ? "Greenway" : "Weston";
    return _db
        .collection('users')
        .where('store', isEqualTo: store)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EmployeeModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<RosterModel>> getRosters(String userId) {
    return _db
        .collection('roster')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RosterModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<RosterModel>> getWeekRosters(DateTime weekStart) {
    final weekEnd = weekStart.add(Duration(days: 6));
    return _db
        .collection('roster')
        .where('startTime', isGreaterThanOrEqualTo: weekStart)
        .where('startTime', isLessThanOrEqualTo: weekEnd)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RosterModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addRoster(RosterModel roster) async {
    final duplicateCheck = await _db
        .collection('roster')
        .where('userId', isEqualTo: roster.userId)
        .where('startTime', isEqualTo: roster.startTime)
        .where('finishTime', isEqualTo: roster.finishTime)
        .where('store', isEqualTo: roster.store.name)
        .get();

    if (duplicateCheck.docs.isEmpty) {
      await _db.collection('roster').add(roster.toMap());
    } else {
      throw Exception('Duplicate roster found');
    }
  }

  Future<void> updateRoster(RosterModel roster) {
    return _db.collection('roster').doc(roster.id).update(roster.toMap());
  }

  Future<void> deleteRoster(String id) {
    return _db.collection('roster').doc(id).delete();
  }

  Stream<List<RosterModel>> getAllRosters() {
    return _db.collection('roster').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => RosterModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<void> copyPreviousWeekRosters(DateTime weekStart) async {
    final previousWeekStart = weekStart.subtract(Duration(days: 7));
    final previousWeekEnd = previousWeekStart.add(Duration(days: 6));

    final previousWeekRosters = await _db
        .collection('roster')
        .where('startTime', isGreaterThanOrEqualTo: previousWeekStart)
        .where('startTime', isLessThanOrEqualTo: previousWeekEnd)
        .get();

    final batch = _db.batch();
    for (final doc in previousWeekRosters.docs) {
      final oldRoster = RosterModel.fromMap(doc.data(), doc.id);
      final newStartTime = oldRoster.startTime.add(Duration(days: 7));
      final newFinishTime = oldRoster.finishTime.add(Duration(days: 7));

      final newRoster = RosterModel(
        id: _db.collection('roster').doc().id,
        userId: oldRoster.userId,
        userName: oldRoster.userName,
        userAvatr: oldRoster.userAvatr,
        position: oldRoster.position,
        startTime: newStartTime,
        finishTime: newFinishTime,
        store: oldRoster.store,
        shiftDescription: oldRoster.shiftDescription,
        isDraft: true,
      );

      batch.set(_db.collection('roster').doc(newRoster.id), newRoster.toMap());
    }

    await batch.commit();
  }

  Future<List<RosterModel>> getRostersByDate(
      String userId, DateTime start, DateTime end) async {
    final snapshot = await _db
        .collection('rosters')
        .where('userId', isEqualTo: userId)
        .where('startTime', isGreaterThanOrEqualTo: start)
        .where('startTime', isLessThanOrEqualTo: end)
        .get();

    return snapshot.docs
        .map((doc) => RosterModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  String generateId() {
    return _db.collection('roster').doc().id;
  }
}
