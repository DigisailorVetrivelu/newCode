import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iukl_admin/constants/constants.dart';
import 'package:iukl_admin/widgets/customTextBox.dart';
import 'forgot_password.dart';
import 'landing_page.dart';
import 'signUp_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailcontroller;
  TextEditingController? passwordcontroller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    print("");
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFEBEBEB),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/background.png'), fit: BoxFit.cover, alignment: Alignment.topCenter)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
              child: Image.asset(
                'assets/images/iukl_logo.png',
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.1,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
              child: CustomTextBox(controller: emailcontroller!, labelText: "Email", hintText: "Email", keyboardType: TextInputType.emailAddress),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
              child: CustomTextBox(
                  controller: passwordcontroller!, labelText: "Password", hintText: "Password", keyboardType: TextInputType.visiblePassword),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ElevatedButton(
                  child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  onPressed: () async {
                    var result;
                    try {
                      result = await authController.auth.signInWithEmailAndPassword(email: emailcontroller!.text, password: passwordcontroller!.text);
                      if (result != null) {
                        throw Exception(result);
                      } else {
                        Get.to(() => LandingPage());
                      }
                      // print(await authController.auth.currentUser!.getIdTokenResult());
                    } catch (exception) {
                      final snackBar = SnackBar(
                        content: Text(
                          result.toString(),
                        ),
                        action: SnackBarAction(
                          label: '',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color(0xFFEF4C43),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8, 10, 10, 10),
              child: GestureDetector(
                onTap: () {
                  Get.to(Forgetpassword());
                },
                child: Text(
                  'Forget Password?',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: GestureDetector(
                onTap: () {
                  Get.to(SignUp());
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 10, 10, 10),
                  child: Text(
                    'SignUp',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
