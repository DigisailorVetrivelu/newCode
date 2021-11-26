import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:iukl_admin/models/userModel.dart';

import '../../widgets/customTextBox.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({
    Key? key,
    required this.student,
  }) : super(key: key);
  @override
  _EditStudentState createState() => _EditStudentState();
  final UserModel student;
}

class _EditStudentState extends State<EditStudent> {
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
  String uploadedFileUrl = '';

  @override
  void initState() {
    super.initState();
    idController.text = widget.student.bioData.id;
    emailController.text = widget.student.bioData.email;
    nameController.text = widget.student.bioData.name;
    stateController.text = widget.student.bioData.department;
    currentAddressController.text = widget.student.bioData.residenceAddress ?? '';
    permanentAddressController.text = widget.student.bioData.houseAddress ?? '';
    zipController.text = widget.student.bioData.countryCode ?? '';
    icNumberController.text = widget.student.bioData.icNumber;
    passportController.text = widget.student.bioData.passportNumber;
    phoneNumberController.text = widget.student.bioData.phoneNumber ?? '';
    deviceIDController.text = widget.student.device != null ? widget.student.device!.deviceId.toString() : '';
    groupIDController.text = widget.student.device != null ? widget.student.device!.groupId.toString() : '';
  }

  bool isStaff = false;
  bool isLocal = false;
  var slectedItem = "Physical";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<dynamic>> getItems() {
    List<DropdownMenuItem<dynamic>> returns = [
      DropdownMenuItem(value: "Maths", child: Text("Maths")),
      DropdownMenuItem(value: "English", child: Text("English")),
      DropdownMenuItem(value: "Physical", child: Text("Physical")),
      DropdownMenuItem(value: "Science", child: Text("Science")),
    ];
    return returns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
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
                  flex: 1,
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
                  flex: 1,
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
                          onChanged: (value) {
                            widget.student.device!.deviceId = int.parse(value);
                          },
                          controller: groupIDController,
                          labelText: "Group ID",
                          hintText: "Enter group ID",
                          keyboardType: TextInputType.number,
                          leftPad: 0),
                      flex: 9),
                  Expanded(
                      child: CustomTextBox(
                          onChanged: (value) {
                            widget.student.device!.deviceId = int.parse(value);
                          },
                          controller: deviceIDController,
                          labelText: "Device ID",
                          hintText: "Enter device ID",
                          keyboardType: TextInputType.number),
                      flex: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
