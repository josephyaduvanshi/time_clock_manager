import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_clock_manager/models/enployee_model.dart';

enum Position {
  MANAGER,
  TEAM_LEADER,
  PIZZAMAKER,
  ALLROUNDER,
  DRIVER,
  CLEANING_STAFF,
  CUSTOMER_SERVICE,
  BASES_MAKER,
  WRAP,
  TRAINER,
}

class RosterModel {
  final String id;
  final String userId;
  final String userAvatr;
  final String userName;
  final Position position;
  final DateTime startTime;
  final DateTime finishTime;
  final Store store;
  final String shiftDescription;
  final bool isDraft;

  RosterModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatr,
    required this.position,
    required this.startTime,
    required this.finishTime,
    required this.store,
    this.shiftDescription = '',
    this.isDraft = false,
  });

  RosterModel copyWith({
    String? id,
    String? userId,
    String? userAvatr,
    String? userName,
    Position? position,
    DateTime? startTime,
    DateTime? finishTime,
    Store? store,
    String? shiftDescription,
    bool? isDraft,
  }) {
    return RosterModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userAvatr: userAvatr ?? this.userAvatr,
      userName: userName ?? this.userName,
      position: position ?? this.position,
      startTime: startTime ?? this.startTime,
      finishTime: finishTime ?? this.finishTime,
      store: store ?? this.store,
      shiftDescription: shiftDescription ?? this.shiftDescription,
      isDraft: isDraft ?? this.isDraft,
    );
  }

  factory RosterModel.fromMap(Map<String, dynamic> json, String id) =>
      RosterModel(
        id: id,
        userId: json['userId'],
        userName: json['userName'],
        userAvatr: json['userAvatr'],
        position: Position.values.byName(json['position']),
        startTime: (json['startTime'] as Timestamp).toDate(),
        finishTime: (json['finishTime'] as Timestamp).toDate(),
        store: Store.values.byName(json['store']),
        shiftDescription: json['shiftDescription'] ?? '',
        isDraft: json['isDraft'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userName': userName,
        'userAvatr': userAvatr,
        'position': position.name,
        'startTime': startTime,
        'finishTime': finishTime,
        'store': store.name,
        'shiftDescription': shiftDescription,
        'isDraft': isDraft,
      };
}
