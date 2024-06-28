import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_clock_manager/navigation/route_link.dart';
import 'package:time_clock_manager/navigation/route_strings.dart';

import 'constants.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(MyApp());
  Get.put(AuthController());
}

RxString uid = FirebaseAuth.instance.currentUser!.uid.obs;
final RxBool isAdmin = false.obs;
final RxBool isStaff = false.obs;
final RxBool isGreenway = false.obs;
final Map<String, Map<String, String>> det = {
  "Admin": {
    "Greenway": "pKdC7Y0CSLSIrUvxJNaaTDVE9Nn1",
    "Weston": "4fLLXdC6HjRHtq4iJm5U9TPqeB93",
    "Joseph": "dBV9qJhCgbfQKdIIvF5l3yaOEgu1",
  },
  "Clockin": {
    "Greenway": "F5LSW85sSRhRfcttWUcpUFLQ2mA3",
    "Weston": "muMgv3rD26asc6jj04josNanYIa2",
  }
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    log(AuthController.instance.loggedIn.toString());
    return StreamBuilder<User?>(
        stream: AuthController.instance.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (snapshot.hasData) {
              log("User is logged in");
              uid = snapshot.data!.uid.obs;
              // isStaff if it neither contains clockin and admin uids
              isStaff.value = !det["Admin"]!.containsValue(uid.value) &&
                  !det["Clockin"]!.containsValue(uid.value);
              isAdmin.value = det["Admin"]!.containsValue(uid.value);

              log("isAdmin: ${isAdmin.value}");
              log("greenway uid ${det["Admin"]!["Greenway"]} uid: ${uid.value}");
              log("isGreenway: ${isGreenway.value}");
            }
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Joseph'S Time Tactician",
              theme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: bgColor,
                textTheme:
                    GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                        .apply(bodyColor: Colors.white),
                canvasColor: secondaryColor,
              ),
              initialRoute:
                  user == null ? RouteStrings.login : RouteStrings.home,
              getPages: RouteLink.routes,
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
