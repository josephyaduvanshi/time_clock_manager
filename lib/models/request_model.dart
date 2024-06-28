
enum RequestStatus { Pending, Accepted, Rejected }

class RequestModel {
  final String id;
  final String userName;
  final String position;
  final String store;
  final DateTime startTime;
  final DateTime finishTime;
  final String shiftDescription;
  final String message;
  final String senderId;
  final String recipientId;
  final Map<String, Map<String, dynamic>> recipientStatuses;
  final Map<String, String> recipientMessages;

  RequestModel({
    required this.id,
    required this.userName,
    required this.position,
    required this.store,
    required this.startTime,
    required this.finishTime,
    required this.shiftDescription,
    required this.message,
    required this.senderId,
    required this.recipientId,
    required this.recipientStatuses,
    required this.recipientMessages,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      userName: json['userName'],
      position: json['position'],
      store: json['store'],
      startTime: DateTime.parse(json['startTime']),
      finishTime: DateTime.parse(json['finishTime']),
      shiftDescription: json['shiftDescription'],
      message: json['message'],
      senderId: json['senderId'],
      recipientId: json['recipientId'],
      recipientStatuses:
          Map<String, Map<String, dynamic>>.from(json['recipientStatuses']),
      recipientMessages: Map<String, String>.from(json['recipientMessages']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'position': position,
      'store': store,
      'startTime': startTime.toIso8601String(),
      'finishTime': finishTime.toIso8601String(),
      'shiftDescription': shiftDescription,
      'message': message,
      'senderId': senderId,
      'recipientId': recipientId,
      'recipientStatuses': recipientStatuses,
      'recipientMessages': recipientMessages,
    };
  }
}
