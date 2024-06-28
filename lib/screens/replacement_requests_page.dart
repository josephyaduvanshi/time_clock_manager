import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/controllers/roster_controller.dart';
import 'package:time_clock_manager/models/request_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../controllers/auth_controller.dart';

class ReplacementRequestsPage extends StatelessWidget {
  final RosterController controller = Get.put(RosterController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Replacement Requests'),
          backgroundColor: secondaryColor,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Sent Requests'),
              Tab(text: 'Received Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSentRequests(),
            _buildReceivedRequests(),
          ],
        ),
      ),
    );
  }

  Widget _buildSentRequests() {
    return StreamBuilder<List<RequestModel>>(
      stream: controller
          .getSentRequests(Get.find<AuthController>().firebaseUser.value!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final requests = snapshot.data ?? [];
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return _buildExpandableRequestCard(request, true);
          },
        );
      },
    );
  }

  Widget _buildReceivedRequests() {
    return StreamBuilder<List<RequestModel>>(
      stream: controller.getReceivedRequests(
          Get.find<AuthController>().firebaseUser.value!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final requests = snapshot.data ?? [];
        final userId = Get.find<AuthController>().firebaseUser.value!.uid;
        final filteredRequests =
            requests.where((request) => request.senderId != userId).toList();
        return ListView.builder(
          itemCount: filteredRequests.length,
          itemBuilder: (context, index) {
            final request = filteredRequests[index];
            return _buildExpandableRequestCard(request, false);
          },
        );
      },
    );
  }

  Widget _buildExpandableRequestCard(RequestModel request, bool isSent) {
    return ExpandableRequestCard(request: request, isSent: isSent);
  }

  Future<void> _showResponseDialog(
      RequestModel request, RequestStatus status) async {
    TextEditingController replyController = TextEditingController();

    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Respond to Request'),
          content: TextField(
            controller: replyController,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Reply Message',
              hintText: 'Enter your reply message here',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.respondToRequest(
                    AuthController.instance.firebaseUser.value!.uid,
                    request.id,
                    status,
                    replyController.text);
                Navigator.of(context).pop();
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }
}

class ExpandableRequestCard extends StatefulWidget {
  final RequestModel request;
  final bool isSent;

  const ExpandableRequestCard(
      {required this.request, required this.isSent, Key? key})
      : super(key: key);

  @override
  _ExpandableRequestCardState createState() => _ExpandableRequestCardState();
}

class _ExpandableRequestCardState extends State<ExpandableRequestCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasBeenAccepted = widget.request.recipientStatuses.values.any(
        (entry) =>
            entry['status'] ==
            RequestStatus.Accepted.toString().split('.').last);

    return Card(
      shadowColor: Colors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: bgColor,
              offset: Offset(10.0, 5.0),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
            BoxShadow(
              color: secondaryColor,
              offset: Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ),
          ],
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text('Request from ${widget.request.userName}')
                  .text
                  .bold
                  .lg
                  .make(),
              subtitle: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.request.position} at ${widget.request.store}',
                    ).text.bold.start.make(),
                    3.heightBox,
                    Text(
                      'Start Time: ${_formatDateTimeMinimal(widget.request.startTime)}',
                    )
                        .text
                        .bodySmall(context)
                        .start
                        .bold
                        .color(hasBeenAccepted
                            ? Colors.green
                            : Color.fromARGB(255, 116, 179, 210))
                        .make(),
                    3.heightBox,
                    Text(
                      'Finish Time: ${_formatDateTimeMinimal(widget.request.finishTime)}',
                    )
                        .text
                        .bodySmall(context)
                        .bold
                        .color(hasBeenAccepted
                            ? Colors.green
                            : Color.fromARGB(255, 116, 179, 210))
                        .start
                        .make(),
                    3.heightBox,
                  ],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  "Accepted: ${hasBeenAccepted ? 'Yes' : 'No'}"
                      .text
                      .bold
                      .color(hasBeenAccepted ? Colors.green : Vx.yellow400)
                      .make(),
                  3.widthBox,
                  Flexible(
                    child: IconButton(
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isExpanded)
              Column(
                children: [
                  _buildDetailRow(
                      'Start Time:', _formatDateTime(widget.request.startTime)),
                  _buildDivider(),
                  _buildDetailRow('Finish Time:',
                      _formatDateTime(widget.request.finishTime)),
                  _buildDivider(),
                  _buildDetailRow(
                      'Description:', widget.request.shiftDescription),
                  _buildDivider(),
                  _buildDetailRow('Message:', widget.request.message,
                      isMessage: true),
                  _buildDivider(),
                  _buildDetailRow(
                      "Hours",
                      widget.request.startTime
                          .difference(widget.request.finishTime)
                          .inHours
                          .toString()),
                  _buildDivider(),
                  if (widget.isSent)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        await _showStatusesDialog(widget.request);
                      },
                      child: Text('View Statuses',
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ).pOnly(top: 10),
                  if (!widget.isSent && !hasBeenAccepted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _showResponseDialog(
                                widget.request, RequestStatus.Accepted);
                          },
                          child: Text('Accept'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            await _showResponseDialog(
                                widget.request, RequestStatus.Rejected);
                          },
                          child: Text('Reject'),
                        ),
                      ],
                    ).paddingOnly(bottom: 10, right: 10),
                ],
              ).p(10),
          ],
        ),
      ).p(8),
    );
  }

  Widget _buildDetailRow(String title, String value,
      {bool isMessage = false, bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(title).text.bold.lg.make().py(3),
        ),
        Flexible(
          child: isMessage
              ? Text(value).text.lg.overflow(TextOverflow.ellipsis).make().py(3)
              : isStatus
                  ? Text(value)
                      .text
                      .bold
                      .color(value.contains('Accepted')
                          ? Colors.green
                          : value.contains('Rejected')
                              ? Colors.red
                              : Vx.yellow400)
                      .lg
                      .make()
                      .py(3)
                  : Text(value).text.bold.lg.make().py(3),
        ),
      ],
    ).px(8);
  }

  Widget _buildDivider() {
    return Divider().py(3).px(5);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('EEEE, MMM d, yyyy h:mm a').format(dateTime);
  }

  String _formatDateTimeMinimal(DateTime dateTime) {
    return DateFormat('MMM d, yyyy h:mm a').format(dateTime);
  }

  Future<void> _showResponseDialog(
    RequestModel request,
    RequestStatus status,
  ) async {
    TextEditingController replyController = TextEditingController();
    final RosterController controller = Get.find<RosterController>();

    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Respond to Request'),
          content: TextField(
            controller: replyController,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Reply Message',
              hintText: 'Enter your reply message here',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.respondToRequest(
                    AuthController.instance.firebaseUser.value!.uid,
                    request.id,
                    status,
                    replyController.text);
                Navigator.of(context).pop();
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showStatusesDialog(RequestModel request) async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Statuses'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: request.recipientStatuses.entries
                  .where((entry) => entry.key != 'ALL')
                  .map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.value['name']}: ${entry.value['status']}',
                      style: TextStyle(
                        color: entry.value['status'] == 'Accepted'
                            ? Colors.green
                            : entry.value['status'] == 'Rejected'
                                ? Colors.red
                                : Colors.white,
                      ),
                    ),
                    if (request.recipientMessages[entry.key] != null &&
                        request.recipientMessages[entry.key]!.isNotEmpty)
                      Text('Message: ${request.recipientMessages[entry.key]}'),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
