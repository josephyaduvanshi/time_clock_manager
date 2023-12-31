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
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Joseph'S Time Tactician",
              theme: ThemeData.dark().copyWith(
                useMaterial3: true,
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
