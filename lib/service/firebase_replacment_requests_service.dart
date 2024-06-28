import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_clock_manager/models/request_model.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class FirestoreRequestReplacementService {
  final CollectionReference _requestCollection =
      FirebaseFirestore.instance.collection('replacementRequests');

  Future<void> sendReplacementRequest(RequestModel request) async {
    try {
      await _requestCollection.doc(request.id).set(request.toJson());
    } catch (e) {
      print('Error sending replacement request: $e');
      rethrow;
    }
  }

  Future<void> respondToRequest(String requestId, String userId,
      RequestStatus status, String replyMessage) async {
    try {
      final requestDoc = await _requestCollection.doc(requestId).get();
      if (requestDoc.exists) {
        final requestData = requestDoc.data() as Map<String, dynamic>;
        final request = RequestModel.fromJson(requestData);

        // Check if the request has already been accepted
        if (request.recipientStatuses.values.any((entry) =>
            entry['status'] ==
            RequestStatus.Accepted.toString().split('.').last)) {
          throw Exception('Request has already been accepted by someone else.');
        }

        final userName = Get.find<AuthController>().firestoreUser.value!.name;

        await _requestCollection.doc(requestId).update({
          'recipientStatuses.$userId': {
            'status': status.toString().split('.').last,
            'name': userName
          },
          'recipientMessages.$userId': replyMessage,
        });
      }
    } catch (e) {
      print('Error responding to request: $e');
      rethrow;
    }
  }

  Stream<List<RequestModel>> getSentRequests(String senderId) {
    return _requestCollection
        .where('senderId', isEqualTo: senderId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                RequestModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<RequestModel>> getReceivedRequests(String recipientId) {
    return _requestCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => RequestModel.fromJson(doc.data() as Map<String, dynamic>))
        .where((request) =>
            request.recipientId == "ALL" ||
            request.recipientStatuses.containsKey(recipientId))
        .toList());
  }

  String generateId() {
    return _requestCollection.doc().id;
  }
}
