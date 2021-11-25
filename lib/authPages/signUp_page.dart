// import '../flutter_flow/flutter_flow_theme.dart';
// import '../flutter_flow/flutter_flow_util.dart';
// import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iukl_admin/constants/constants.dart';
import 'package:iukl_admin/widgets/customTextBox.dart';

import 'landing_page.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? confirmPasswordController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFEBEBEB),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
        )),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
              child: Image.asset(
                'assets/images/iukl_logo.png',
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.1,
                fit: BoxFit.contain,
              ),
            ),
            CustomTextBox(controller: emailController!, labelText: "Email", hintText: "Email", keyboardType: TextInputType.emailAddress),
            CustomTextBox(controller: passwordController!, labelText: "Password", hintText: "Password", keyboardType: TextInputType.emailAddress),
            CustomTextBox(
                controller: confirmPasswordController!,
                labelText: "Confirm Password",
                hintText: "Re-enter password..",
                keyboardType: TextInputType.emailAddress),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  child: Text("SignUp"),
                  onPressed: () async {
                    if (confirmPasswordController!.text != passwordController!.text) {
                      final snackBar = SnackBar(content: const Text('Passwords did not match'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (confirmPasswordController!.text.isEmpty || emailController!.text.isEmpty || passwordController!.text.isEmpty) {
                      final snackBar = SnackBar(content: const Text('Please fill out all the fields'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      await authController.auth
                          .signUpWithEmailAndPassword(email: emailController!.text, password: passwordController!.text)
                          .then((value) {
                        if (value!.startsWith("uid")) {
                          Get.to(() => LandingPage());
                        } else {
                          final snackBar = SnackBar(content: Text(value));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    }
                  },

                  // onPressed: () {
                  //  authController.auth.signUpWithEmailAndPassword(email: emailController!.text,
                  //      password: passwordController!.text);
                  //
                  //   Get.to(LoginPage());
                  // },
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
          ],
        ),
      ),
    );
  }
}
