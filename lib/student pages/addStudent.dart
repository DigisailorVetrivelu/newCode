import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:iukl_admin/models/userModel.dart';

import '../../widgets/customTextBox.dart';

class AddStudentOrStaff extends StatefulWidget {
  const AddStudentOrStaff({
    Key? key,
  }) : super(key: key);
  @override
  _AddStudentOrStaffState createState() => _AddStudentOrStaffState();
}

class _AddStudentOrStaffState extends State<AddStudentOrStaff> {
  String uploadedFileUrl = '';

  TextEditingController idController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController currentAddressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController icNumberController = TextEditingController();
  TextEditingController passportController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController deviceIDController = TextEditingController();
  TextEditingController groupIDController = TextEditingController();

  bool isStaff = false;
  bool isLocal = false;
  var slectedItem = "Computer Science";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<dynamic>> getItems() {
    List<DropdownMenuItem<dynamic>> returns = [
      DropdownMenuItem(value: "Computer Science", child: Text("Computer Science")),
      DropdownMenuItem(value: "Mechanical Engineering", child: Text("Mechanical Engineering")),
      DropdownMenuItem(value: "Civil Engineering", child: Text("Civil Engineering")),
      DropdownMenuItem(value: "Information Technology", child: Text("Information Technology")),
    ];

    // returns = ['Computer Science', 'Mechanical Engineering', 'Civil Engineering', 'Information Technology']
    //     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
    //     .toList();
    return returns;
  }

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
          'Add User',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Enter Student Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 22),
                        child: const Text("International Student", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 22, top: 4, bottom: 10),
                        child: SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              Text("Yes"),
                              Radio<bool>(
                                value: true,
                                groupValue: isLocal,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isLocal = value!;
                                  });
                                },
                              ),
                              Text("No"),
                              Radio<bool>(
                                value: false,
                                groupValue: isLocal,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isLocal = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 22),
                        child: const Text("Departmnet", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18, top: 4, bottom: 10),
                        child: DropdownButtonHideUnderline(
                          child: GFDropdown(
                              items: getItems(),
                              value: slectedItem,
                              onChanged: (dynamic value) {
                                setState(() {
                                  print(slectedItem);
                                  slectedItem = value;
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // GFDropdown<dynamic>(items: getItems(), onChanged: (widget) {}),
            Divider(),
            CustomTextBox(controller: idController, labelText: "ID", hintText: "Enter ID", keyboardType: TextInputType.text),
            CustomTextBox(controller: nameController, hintText: 'Enter your Name', labelText: 'Name', keyboardType: TextInputType.name),
            CustomTextBox(controller: emailController, hintText: 'Enter your email', labelText: 'Email', keyboardType: TextInputType.emailAddress),
            isLocal
                ? CustomTextBox(controller: icNumberController, labelText: "IC Number", hintText: "Enter IC", keyboardType: TextInputType.text)
                : CustomTextBox(
                    controller: passportController,
                    labelText: "Passport Number",
                    hintText: "Enter Passport number",
                    keyboardType: TextInputType.text),
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

            CustomTextBox(
              controller: permanentAddressController,
              hintText: 'Permanent Address',
              labelText: 'Permanent Address',
              keyboardType: TextInputType.streetAddress,
              maxLines: 5,
            ),
            CustomTextBox(
              controller: currentAddressController,
              hintText: 'Current Address',
              labelText: 'Current Address',
              keyboardType: TextInputType.streetAddress,
              maxLines: 5,
            ),
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  Expanded(
                      child: CustomTextBox(
                          controller: groupIDController,
                          labelText: "Group ID",
                          hintText: "Enter group ID",
                          keyboardType: TextInputType.number,
                          leftPad: 0),
                      flex: 9),
                  Expanded(
                      child: CustomTextBox(
                          controller: deviceIDController, labelText: "Device ID", hintText: "Enter device ID", keyboardType: TextInputType.number),
                      flex: 10),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.05),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      Profile bioData = Profile(
                          id: idController.text.toString(),
                          email: emailController.text.toString(),
                          name: nameController.text.toString(),
                          houseAddress: permanentAddressController.text.toString(),
                          residenceAddress: currentAddressController.text.toString(),
                          countryCode: zipController.text,
                          phoneNumber: phoneNumberController.text.toString(),
                          icNumber: icNumberController.text.toString(),
                          department: slectedItem,
                          passportNumber: passportController.text);

                      showDialog(
                        context: context,
                        builder: (context) {
                          var future = UserModel.addUser(
                              bioData, isStaff, Device(groupId: int.parse(groupIDController.text), deviceId: int.parse(deviceIDController.text)));
                          return FutureBuilder(
                            future: future,
                            builder: (context, snapshot) {
                              Widget title, content;
                              var textStyle = TextStyle(color: Colors.black);
                              if (snapshot.hasData) {
                                dynamic data = snapshot.data;
                                title = Text(data["code"]);
                                content = Text(data["message"]);
                                try {
                                  if (data["uid"] != null) {
                                    title = Text("Sucess");
                                    content = Text("User has been added successfully");
                                  }
                                } catch (e) {}
                                return AlertDialog(title: title, titleTextStyle: textStyle, content: content, actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                      idController.text = '';
                                      emailController.text = '';
                                      nameController.text = '';
                                      stateController.text = '';
                                      currentAddressController.text = '';
                                      permanentAddressController.text = '';
                                      zipController.text = '';
                                      icNumberController.text = '';
                                      phoneNumberController.text = '';
                                      deviceIDController.text = '';
                                      groupIDController.text = '';
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
