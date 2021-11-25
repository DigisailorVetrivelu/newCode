import 'package:iukl_admin/constants/constants.dart';
import 'package:iukl_admin/firebase.dart';
import 'package:iukl_admin/models/cert.dart';
import 'package:iukl_admin/widgets/customTextBox.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class RegisterCert extends StatefulWidget {
  RegisterCert({Key? key, required this.uid, this.cert}) : super(key: key);
  @override
  _RegisterCertState createState() => _RegisterCertState();
  final String uid;
  final Cert? cert;
}

class _RegisterCertState extends State<RegisterCert> {
  String uploadedFileUrl = '';

  TextEditingController idController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController currentAddressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController icNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    emailController.text = authController.auth.currentUser!.email!;
    if (widget.cert != null) {
      canEmailEdit = false;
      idController.text = widget.cert!.certId;
      emailController.text = widget.cert!.email;
      nameController.text = widget.cert!.name;
      phoneNumberController.text = widget.cert!.phoneNumber;
      zipController.text = widget.cert!.countryCode;
    }
  }

  bool canEmailEdit = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFEF4C43),
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 24,
          ),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Lexend Deca',
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 16),
              child: Divider(),
            ),
            CustomTextBox(controller: nameController, hintText: 'Enter your Name', labelText: 'Name', keyboardType: TextInputType.name),
            CustomTextBox(
                controller: emailController, hintText: 'Enter email', labelText: 'Email', keyboardType: TextInputType.number, enabled: canEmailEdit),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: CustomTextBox(
                          onTap: () {}, controller: zipController, hintText: '+65', labelText: 'Code', keyboardType: TextInputType.phone, leftPad: 0),
                      flex: 3),
                  Expanded(
                      child: CustomTextBox(
                        controller: phoneNumberController,
                        hintText: 'Enter Phone Number',
                        labelText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      ),
                      flex: 8),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.05),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      showDialog(
                        context: context,
                        builder: (context) {
                          var future;
                          if (canEmailEdit) {
                            future = Cert.addCertProfile(
                                uid: widget.uid,
                                name: nameController.text,
                                email: emailController.text,
                                countryCode: zipController.text,
                                phoneNumber: phoneNumberController.text);
                          } else {
                            widget.cert!.name = nameController.text;
                            widget.cert!.phoneNumber = phoneNumberController.text;
                            widget.cert!.countryCode = zipController.text;
                            future = certs
                                .doc(widget.cert!.uid)
                                .update(widget.cert!.toJson())
                                .then((value) => {"code": "success", "message": "Successfully Updated"});
                          }

                          return FutureBuilder(
                            future: future,
                            builder: (context, snapshot) {
                              Widget title, content;
                              var textStyle = TextStyle(color: Colors.black);
                              if (snapshot.hasData) {
                                dynamic data = snapshot.data;
                                title = Text(data["code"]);
                                content = Text(data["message"]);
                                return AlertDialog(title: title, titleTextStyle: textStyle, content: content, actions: [
                                  TextButton(
                                    onPressed: () {
                                      idController.clear();
                                      emailController.clear();
                                      Navigator.pop(context, 'OK');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ]);
                              } else {
                                return Center(
                                    child: SizedBox(
                                  child: CircularProgressIndicator(),
                                ));
                              }
                            },
                          );
                        },
                      );
                    } catch (e) {}
                  },
                  child: Text('Save Changes'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
