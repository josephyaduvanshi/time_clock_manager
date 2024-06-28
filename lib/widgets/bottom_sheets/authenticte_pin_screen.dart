import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants.dart';
import '../../controllers/dashboard_clockin_controller.dart';

class AuthenticatePinSheet extends StatelessWidget {
  AuthenticatePinSheet({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = DashBoardClockInController.instance;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Enter Your Pin* (e.g. 1234)",
              label: Text("PIN *"),
              floatingLabelStyle: TextStyle(
                color: Color.fromRGBO(77, 77, 205, 1.0),
              ),
              contentPadding: EdgeInsets.all(15),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(77, 77, 205, 1.0),
                ),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              fillColor: secondaryColor,
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(71, 70, 79, 1.0)),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              filled: true,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter PIN';
              }
              return null;
            },
            controller: controller.authenticateTextController.value,
            onSaved: (newValue) {
              controller.authenticateTextController.value.text = newValue!;
            },
          ).px(30).py(20),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5,
                vertical: defaultPadding / 2,
              ),
            ),
            onPressed: () async {
              print("dddd");
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (controller.isClockedIn.isTrue) {
                  // Handle Clock Out
                  if (controller.authenticatePin(
                      controller.selectedEmployeeId.value,
                      controller.authenticateTextController.value.text)) {
                    await controller.clockOut(
                        controller.selectedEmployeeId.value,
                        controller.authenticateTextController.value.text);
                    controller.resetSelection();
                    Navigator.pop(context);
                  } else {
                    context.showToast(
                      position: VxToastPosition.top,
                      bgColor: Colors.red,
                      textColor: Colors.white,
                      msg: 'Invalid PIN',
                    );
                  }
                  controller.fetchAllTodaysTimeRecords();
                } else {
                  if (controller.authenticatePin(
                      controller.selectedEmployeeId.value,
                      controller.authenticateTextController.value.text)) {
                    await controller.clockIn(
                        controller.selectedEmployeeId.value,
                        controller.authenticateTextController.value.text);
                    controller.resetSelection();
                    Navigator.pop(context);
                  } else {
                    context.showToast(
                      position: VxToastPosition.top,
                      bgColor: Colors.red,
                      textColor: Colors.white,
                      msg: 'Invalid PIN',
                    );
                  }
                  controller.fetchAllTodaysTimeRecords();
                  controller.resetSelection();
                }
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

void showAuthenticatePinScreen(BuildContext context) {
  showModalBottomSheet<void>(
    isDismissible: true,
    isScrollControlled: true,
    // constraints: BoxConstraints(
    //   maxHeight: MediaQuery.of(context).size.height,
    // ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.8,
              shouldCloseOnMinExtent: false,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return AuthenticatePinSheet();
              }),
        ),
      );
    },
  );
}
