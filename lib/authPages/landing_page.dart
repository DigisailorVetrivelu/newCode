import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iukl_admin/certPages/home.dart';
import 'package:iukl_admin/certPages/registerCert.dart';
import 'package:iukl_admin/constants/constants.dart';
import 'package:iukl_admin/models/cert.dart';

import '../firebase.dart';
import 'login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authController.auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return LoginPage();
          } else {
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: Cert.getProfile(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData && snapshot.data!.exists) {
                    Cert cert = Cert.fromJson(snapshot.data!.data()!);
                    return HomePage(cert: cert);
                  } else {
                    return RegisterCert(uid: user.uid);
                  }
                });
          }
        }
        return Container(
          color: Colors.teal,
        );
      },
    );
  }
}
