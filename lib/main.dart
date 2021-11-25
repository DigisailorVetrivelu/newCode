import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iukl_admin/authPages/landing_page.dart';

import 'controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // FirebaseFunctions.instance.useFunctionsEmulator('192.168.29.132', 5001);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
          backgroundColor: MaterialStateProperty.all(
            Color(0xFFEF4C43),
          ),
        )),
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.white),
          bodyText1: TextStyle(fontSize: 14.0, color: Color(0xFFEF4C43)),
        ),
      ),
      home: LandingPage(),
    );
  }
}
