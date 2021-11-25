import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iukl_admin/certPages/registerCert.dart';
import 'package:iukl_admin/constants/constants.dart';
import 'package:iukl_admin/firebase.dart';
import 'package:iukl_admin/models/cert.dart';
import 'package:iukl_admin/pages/announcement.dart';
import 'package:iukl_admin/pages/complaintlist.dart';
import 'package:iukl_admin/pages/profiled.dart';
import 'package:iukl_admin/student%20pages/student_list.dart';
import 'package:iukl_admin/student%20pages/student_list_covid.dart';
import 'package:iukl_admin/student%20pages/student_list_quarantined.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.cert}) : super(key: key);
  final Cert cert;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    firebaseMessaging.getInitialMessage().then((message) {
      if (message!.notification != null) {
        final routeFromMessage = message.data["route"];
        print(routeFromMessage);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      print(routeFromMessage);
    });

    firebaseMessaging.subscribeToTopic('Complaint');
  }

  double value = 0.43;

  @override
  Widget build(BuildContext context) {
    authController.auth.currentUser!.getIdTokenResult().then((result) {
      print(result.claims);
    });
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.black),
                ),
                content: const Text('Are you sure you want to Logout'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      authController.auth.logout();
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          icon: Icon(
            Icons.logout,
            color: Color(0xFFED392D),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Image.asset(
            'assets/images/iukl_logo.png',
            width: 300,
            height: 50,
            fit: BoxFit.fitHeight,
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        automaticallyImplyLeading: true,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Icon(
        //       Icons.notifications,
        //       color: Color(0xFFED392D),
        //       size: 24,
        //     ),
        //   )
        // ],
        centerTitle: true,
        elevation: 4,
      ),
      // backgroundColor: Image.asset('assets/images/background.png').color,
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: Cert.getProfile(authController.auth.currentUser!.uid),
          builder: (context, snapshot) {
            Cert cert;
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                cert = Cert.fromJson(snapshot.data!.data()!);
              }
              return SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: Image.asset(
                        'assets/images/upside down.png',
                      ).image,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Tile(
                            value: value,
                            asset: 'assets/images/addcert.png',
                            onTap: () {
                              Get.to(() => StudentStaffList());
                            },
                            name: 'USERS',
                          ),
                          Tile(
                            value: value,
                            asset: 'assets/images/addcert.png',
                            onTap: () {
                              Get.to(() => StudentStaffListCovid());
                            },
                            name: 'COVID USERS',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Tile(
                            value: value,
                            asset: 'assets/images/addcert.png',
                            onTap: () {
                              Get.to(() => StudentStaffListQuarantined());
                            },
                            name: 'QUARANTINE',
                          ),
                          Tile(
                            value: value,
                            asset: 'assets/images/addstaff.png',
                            onTap: () {
                              // Get.to(() => ProfileWidget(user: widget.cert));
                              Get.to(() => RegisterCert(uid: '', cert: widget.cert));
                            },
                            name: 'MY PROFILE',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Tile(
                            value: value,
                            asset: 'assets/images/whistle blower.png',
                            onTap: () {
                              Get.to(() => ComplaintList());
                            },
                            name: 'COMPLAINTS',
                          ),
                          Tile(
                            value: value,
                            asset: 'assets/images/announcement.png',
                            onTap: () {
                              Get.to(() => AnnouncmentWidget());
                            },
                            name: 'ANNOUNCEMENT',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Tile(
                            value: value,
                            asset: 'assets/images/smart suggestion.png',
                            onTap: () {
                              // Get.to(() => SmartsuggestionWidget());
                            },
                            name: 'SUGGESTION',
                          ),
                          Tile(
                            value: value,
                            asset: 'assets/images/addstaff.png',
                            onTap: () {
                              // Get.to(() => StudentStaffList());
                            },
                            name: 'CAROUSEL',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.value,
    required this.onTap,
    required this.asset,
    required this.name,
  }) : super(key: key);

  final double value;
  final void Function() onTap;
  final String asset;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          elevation: 5,
          // borderRadius: BorderRadius.circular(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Container(
            margin: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * value,
            height: MediaQuery.of(context).size.width * value,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                // BoxShadow(spreadRadius: 1, blurRadius: 1, color: Colors.grey.withOpacity(0.3)),
              ],
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    asset,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Tile1 extends StatelessWidget {
  const Tile1({
    Key? key,
    required this.height,
    required this.width,
    required this.onTap,
    required this.asset,
    required this.name,
  }) : super(key: key);

  final double height;
  final double width;
  final void Function() onTap;
  final String asset;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          elevation: 5,
          // borderRadius: BorderRadius.circular(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Container(
            margin: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * width,
            height: MediaQuery.of(context).size.height * height,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                // BoxShadow(spreadRadius: 1, blurRadius: 1, color: Colors.grey.withOpacity(0.3)),
              ],
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Image.asset(
                asset,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
