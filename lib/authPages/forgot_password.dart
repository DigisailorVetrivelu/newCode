import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iukl_admin/constants/constants.dart';
import 'login_page.dart';

class Forgetpassword extends StatefulWidget {
  Forgetpassword({Key? key}) : super(key: key);

  @override
  _ForgetpasswordState createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  TextEditingController? emailController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFEF4C43),
        automaticallyImplyLeading: true,
        title: Text(
          'Forget Password?',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Align(
          alignment: AlignmentDirectional(0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 100, 10, 0),
                child: Image.asset(
                  'assets/images/iukl_logo.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.1,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Text(
                  'Enter the email address\nassociated with your account.\n\n',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              // Padding(
              //   padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
              //   child: Text(
              //     'We will email you a link to reset\n your password\n\n',
              //     textAlign: TextAlign.center,
              //     style: Theme.of(context).textTheme.subtitle1,
              //
              //   ),
              // ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Material(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: TextFormField(
                    controller: emailController,
                    // obscureText: _passwordVisible,

                    decoration: InputDecoration(
                      hintText: 'Enter Your Email',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 20,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 20,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF7F7F7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: ElevatedButton(
                    child: Text("Send"),
                    onPressed: () {
                      try {
                        authController.auth.resetPassword(email: emailController!.text);
                        showDialog(context: context, builder: (context) => Text("Password rest mail sent"));
                      } catch (exception) {}
                      Get.to(LoginPage());
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
            ],
          ),
        ),
      ),
    );
  }
}
