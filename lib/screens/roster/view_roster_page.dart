import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_clock_manager/controllers/roster_controller.dart';
import 'package:time_clock_manager/main.dart';
import 'package:time_clock_manager/models/roster_model.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants.dart';
import '../../models/request_model.dart';
import '../../models/enployee_model.dart';
import '../../responsive.dart';
import 'custom_roaster_view_page.dart';

class ViewRosterPage extends StatefulWidget {
  @override
  _ViewRosterPageState createState() => _ViewRosterPageState();
}

class _ViewRosterPageState extends State<ViewRosterPage> {
  final RosterController controller = Get.put(RosterController());

  @override
  void initState() {
    super.initState();
    controller.updateViewType(controller.viewType.value);
    controller.updateDateRange();
  }

  void _updateViewType(ViewType newViewType) {
    setState(() {
      controller.updateViewType(newViewType);
      controller.updateDateRange();
    });
  }

  DateTime _calculateLastDate() {
    DateTime lastDate;
    if (controller.viewType.value == ViewType.Weekly) {
      lastDate = controller.firstDate.value.add(Duration(days: 6));
    } else if (controller.viewType.value == ViewType.Fortnightly) {
      lastDate = controller.firstDate.value.add(Duration(days: 13));
    } else {
      lastDate = DateTime(controller.firstDate.value.year,
          controller.firstDate.value.month + 1, 0);
    }
    return lastDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('View Roster', style: TextStyle(color: Colors.white)),
        backgroundColor: secondaryColor,
        actions: [
          Visibility(
            visible: isAdmin.value,
            child: Obx(() {
              return Row(
                children: [
                  controller.isCustomView.value
                      ? Text('Standard View',
                          style: TextStyle(color: Colors.white))
                      : Text('Admin View',
                          style: TextStyle(color: Colors.white)),
                  6.widthBox,
                  Switch.adaptive(
                    value: controller.isCustomView.value,
                    onChanged: (bool value) {
                      controller.isCustomView.value = value;
                    },
                    activeColor: Colors.green,
                  ),
                ],
              );
            }),
          ),
          Obx(() {
            return SizedBox(
              width: Responsive.isMobile(context)
                  ? MediaQuery.of(context).size.width * 0.5
                  : MediaQuery.of(context).size.width * 0.19,
              child: DropdownButtonFormField<ViewType>(
                isExpanded: false,
                elevation: 8,
                padding: const EdgeInsets.all(8),
                focusColor: Colors.transparent,
                iconEnabledColor: Colors.amber,
                borderRadius: BorderRadius.circular(16),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.greenAccent,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  labelText: "Selected View",
                  labelStyle:
                      const TextStyle(color: Colors.white, fontSize: 18),
                ),
                dropdownColor: secondaryColor,
                value: controller.viewType.value,
                onChanged: (ViewType? newValue) {
                  if (newValue != null) {
                    _updateViewType(newValue);
                  }
                },
                items: ViewType.values.map((ViewType value) {
                  return DropdownMenuItem<ViewType>(
                    value: value,
                    child: Text(
                      value.name,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        log('Building roster list ${controller.lastDate.value}');
        log('Building first roster list ${controller.firstDate.value}');
        return Responsive(
          mobile: controller.isCustomView.value
              ? CustomRosterPage()
              : _buildContent(64.0, 64.0),
          tablet: controller.isCustomView.value
              ? CustomRosterPage()
              : _buildContent(70.0, 70.0),
          desktop: controller.isCustomView.value
              ? CustomRosterPage()
              : _buildContent(80.0, 80.0),
        );
      }),
    );
  }

  Widget _buildContent(double width, double height) {
    return Column(
      children: [
        Card(
          color: Colors.grey[850],
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: CustomDateTimeline(
            firstDate: controller.firstDate.value,
            focusDate: controller.focusDate,
            lastDate: _calculateLastDate(),
            onDateChange: (selectedDate) {
              controller.fetchDayRosters(selectedDate);
            },
            width: width,
            height: height,
          ).paddingSymmetric(vertical: 16.0).px(8),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: controller.userRosters.length,
              itemBuilder: (context, index) {
                final roster = controller.userRosters[index];
                return _buildRosterCard(roster);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRosterCard(RosterModel roster) {
    final double grossHours =
        roster.finishTime.difference(roster.startTime).inHours.toDouble();
    final double netHours =
        (grossHours > 8 ? grossHours - 0.5 : grossHours).toDouble();

    final double fontSizeLarge = Responsive.isDesktop(context)
        ? 17
        : Responsive.isTablet(context)
            ? 16
            : 14;
    final double fontSizeSmall = Responsive.isDesktop(context)
        ? 14
        : Responsive.isTablet(context)
            ? 12
            : 10;
    final double fontSizeMedium = Responsive.isDesktop(context)
        ? 16
        : Responsive.isTablet(context)
            ? 14
            : 12;

    return Card(
      color: bgColor,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(fontSizeMedium),
        side: BorderSide(color: Vx.blue500),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(fontSizeMedium),
        ),
        child: Padding(
          padding: EdgeInsets.all(fontSizeMedium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roster.userName.firstLetterUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSizeMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            roster.position.name,
                            style: TextStyle(
                                color: Colors.white, fontSize: fontSizeSmall),
                          ),
                          side: BorderSide(color: Colors.white),
                          backgroundColor: Colors.blue[800],
                        ),
                        SizedBox(width: 8),
                        Chip(
                          label: Text(
                            roster.store.name,
                            style: TextStyle(
                                color: Colors.white, fontSize: fontSizeSmall),
                          ),
                          side: BorderSide(color: Colors.white),
                          backgroundColor:
                              const Color.fromARGB(255, 30, 104, 141),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          '${DateFormat.jm().format(roster.startTime)} - ${DateFormat.jm().format(roster.finishTime)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: fontSizeLarge,
                          ),
                        ),
                      ],
                    ),
                    if (roster.shiftDescription.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          roster.shiftDescription,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSizeMedium,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: _buildHoursInfo(
                          title: 'Gross Hours',
                          hours: grossHours,
                          fontSize1: fontSizeMedium,
                          fontSize2: fontSizeSmall)),
                  SizedBox(height: 8),
                  Align(
                      alignment: Alignment.centerRight,
                      child: _buildHoursInfo(
                          title: 'Net Hours',
                          hours: netHours,
                          fontSize1: fontSizeMedium,
                          fontSize2: fontSizeSmall)),
                ],
              ),
              16.widthBox,
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
                        await _showReplacementRequestDialog(roster);
                      },
                      child: Text('Request Replacement',
                          style: TextStyle(
                              color: Colors.white, fontSize: fontSizeSmall)))
                  .pOnly(top: 60),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showReplacementRequestDialog(RosterModel roster) async {
    TextEditingController messageController = TextEditingController();
    EmployeeModel? selectedEmployee;
    final employees = controller.employees;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          title: "Request Replacement"
              .text
              .xl2
              .bold
              .isIntrinsic
              .color(Colors.white)
              .make(),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDialogRow('User', roster.userName),
                _buildDialogRow('Position', roster.position.name),
                _buildDialogRow('Store', roster.store.name),
                _buildDialogRow(
                    'Start Time', DateFormat.jm().format(roster.startTime)),
                _buildDialogRow(
                    'Finish Time', DateFormat.jm().format(roster.finishTime)),
                _buildDialogRow('Description', roster.shiftDescription),
                _buildDialogRow("Hours",
                    "${roster.finishTime.difference(roster.startTime).inHours.toDouble().toPrecision(2)} hrs"),
                DropdownButtonFormField<EmployeeModel>(
                  value: selectedEmployee,
                  hint: Text("Select Employee"),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text("ALL"),
                    ),
                    ...employees.map((employee) {
                      return DropdownMenuItem(
                        value: employee,
                        child: Text(employee.name),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    selectedEmployee = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Send To',
                    border: OutlineInputBorder(),
                  ),
                ).paddingSymmetric(vertical: 10),
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    hintText: 'Enter your message here',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.transparent,
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.transparent,
              ),
              child: Text('Send Request'),
              onPressed: () {
                final recipientId = selectedEmployee?.id ?? 'ALL';
                controller.sendReplacementRequest(
                  RequestModel(
                    id: controller.generateIdRequests(),
                    userName: roster.userName,
                    position: roster.position.name,
                    store: roster.store.name,
                    startTime: roster.startTime,
                    finishTime: roster.finishTime,
                    shiftDescription: roster.shiftDescription,
                    message: messageController.text,
                    senderId: roster.userId,
                    recipientId: recipientId,
                    recipientStatuses: {
                      recipientId: {
                        'status':
                            RequestStatus.Pending.toString().split('.').last,
                        'name': selectedEmployee?.name ?? 'ALL',
                      },
                    },
                    recipientMessages: {recipientId: messageController.text},
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursInfo(
      {required String title,
      required double hours,
      required double fontSize1,
      required double fontSize2}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize1,
            ),
          ),
        ),
        SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${hours.toStringAsFixed(2)} hrs',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDateTimeline extends StatelessWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final Rx<DateTime> focusDate;
  final ValueChanged<DateTime> onDateChange;
  final double width;
  final double height;
  final Color? activeColor;
  final Color? inactiveColor;

  CustomDateTimeline({
    required this.firstDate,
    required this.lastDate,
    required this.focusDate,
    required this.onDateChange,
    this.width = 64.0,
    this.height = 64.0,
    this.activeColor,
    this.inactiveColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> dateWidgets = [];
    DateTime currentDate = firstDate;

    while (!currentDate.isAfter(lastDate)) {
      dateWidgets.add(_buildDateItem(currentDate));
      currentDate = currentDate.add(Duration(days: 1));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dateWidgets,
      ),
    );
  }

  Widget _buildDateItem(DateTime date) {
    return Obx(() {
      bool isSelected = date == focusDate.value;
      return GestureDetector(
        onTap: () {
          focusDate.value = date;
          onDateChange(date); // Trigger the callback to fetch rosters
        },
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          child: CircleAvatar(
            backgroundColor:
                isSelected ? activeColor : inactiveColor?.withOpacity(0.1),
            radius: 32.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    DateFormat.E().format(date),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
