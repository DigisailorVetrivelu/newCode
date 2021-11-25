import 'package:flutter/material.dart';
import '../models/userModel.dart';
import '../widgets/customTextBox.dart';

class QuarantineDetails extends StatefulWidget {
  final UserModel user;
  final void Function() changeOccur;
  QuarantineDetails({Key? key, required this.user, required this.changeOccur}) : super(key: key);
  @override
  _QuarantineDetailsState createState() => _QuarantineDetailsState();
}

class _QuarantineDetailsState extends State<QuarantineDetails> {
  final buildingNameController = TextEditingController();
  final blockNameController = TextEditingController();
  final floorController = TextEditingController();
  final addressController = TextEditingController();
  final formDateController = TextEditingController();
  final toDateController = TextEditingController();
  // ignore: unused_field
  bool _inCampus = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    if (widget.user.quarantine != null) {
      buildingNameController.text = widget.user.quarantine!.location.place ?? '';
      blockNameController.text = widget.user.quarantine!.location.block ?? '';
      floorController.text = widget.user.quarantine!.location.floor.toString();
      addressController.text = widget.user.quarantine!.location.quarantineAddress ?? '';
      formDateController.text = widget.user.quarantine!.startDate.toString().substring(0, 10);
      toDateController.text = widget.user.quarantine!.endDate.toString().substring(0, 10);
      daysLeft = widget.user.quarantine!.endDate.difference(DateTime.now()).inDays;
      _inCampus = widget.user.quarantine!.location.inCampus;
    } else {
      widget.user.quarantine = Quarantine(startDate: DateTime.now(), endDate: DateTime.now(), location: Location(place: ''));
      formDateController.text = '';
      toDateController.text = '';
    }
  }

  int daysLeft = 0;
  changeBool(bool? value) {
    setState(() {
      _inCampus = !_inCampus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   backgroundColor: Color(0xFFEF4C43),
      //   automaticallyImplyLeading: true,
      //   title: Text(
      //     'Quarantine Details',
      //     style: TextStyle(
      //       fontFamily: 'Poppins',
      //       color: Colors.white,
      //       fontSize: 18,
      //     ),
      //   ),
      //   actions: [],
      //   centerTitle: true,
      //   elevation: 4,
      // ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // RadioButton(
                //   function: changeBool,
                // ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Color(0xFFEC4338),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset(
                          'assets/images/corona image.png',
                        ).image,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("$daysLeft", style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text("days left", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Quarantine Details',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF393939),
                      fontSize: 16,
                    ),
                  ),
                ),
                CustomTextBox(
                  controller: buildingNameController,
                  labelText: 'Building Name',
                  hintText: 'Building Name',
                  keyboardType: TextInputType.streetAddress,
                  onChanged: (text) {
                    widget.user.quarantine!.location.place = text;
                    widget.changeOccur();
                  },
                ),
                CustomTextBox(
                  controller: blockNameController,
                  labelText: 'Block',
                  hintText: 'B7',
                  keyboardType: TextInputType.streetAddress,
                  onChanged: (text) {
                    widget.user.quarantine!.location.block = text;
                    widget.changeOccur();
                  },
                ),
                CustomTextBox(
                  controller: addressController,
                  labelText: 'Address',
                  hintText: '123 1st Street',
                  keyboardType: TextInputType.streetAddress,
                  onChanged: (text) {
                    widget.user.quarantine!.location.quarantineAddress = text;
                    widget.changeOccur();
                  },
                ),

                Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Quarantine Duration',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF393939),
                      fontSize: 16,
                    ),
                  ),
                ),
                CustomTextBox(
                  controller: formDateController,
                  labelText: 'Starting Date',
                  hintText: '2012-02-27',
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    var date =
                        await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));
                    if (date != null) {
                      widget.user.quarantine!.startDate = date;
                      formDateController.text = date.toString().substring(0, 10);
                    }
                  },
                ),
                CustomTextBox(
                  controller: toDateController,
                  labelText: 'Ending Date',
                  hintText: '2012-02-27',
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    var date =
                        await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));
                    if (date != null) {
                      widget.user.quarantine!.endDate = date;
                      toDateController.text = date.toString().substring(0, 10);
                      setState(() {
                        // daysLeft = DateTime.now().difference(widget.user.quarantine!.endDate).inDays;
                        daysLeft = widget.user.quarantine!.endDate.difference(DateTime.now()).inDays;
                      });
                    }
                    widget.changeOccur();
                  },
                ),
                // CustomTextBox(controller: toDateController, labelText: 'Ending Date', hintText: '2012-02-27', keyboardType: TextInputType.datetime),
                // Align(
                //   alignment: AlignmentDirectional(0, 0),
                //   child: Padding(
                //       padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                //       child: ElevatedButton(
                //         child: Text('Submit'),
                //         onPressed: () {
                //           showDialog(
                //             context: context,
                //             builder: (context) {
                //               var future = widget.user.quarantineUser(Quarantine(
                //                   startDate: DateTime.parse(formDateController.text),
                //                   endDate: DateTime.parse(toDateController.text),
                //                   location: Location(
                //                     place: buildingNameController.text,
                //                     block: blockNameController.text,
                //                     quarantineAddress: addressController.text,
                //                   )));
                //               return FutureBuilder(
                //                 future: future,
                //                 builder: (context, snapshot) {
                //                   Widget title, content;
                //                   var textStyle = TextStyle(color: Colors.black);
                //                   if (snapshot.hasData) {
                //                     dynamic data = snapshot.data;
                //                     switch (data) {
                //                       case 0:
                //                         title = Text("User Added");
                //                         content = Text("User has been added successfully");
                //                         break;
                //                       default:
                //                         if (data["message"] != null || data["code"] != null) {
                //                           title = Text(data["code"]);
                //                           content = Text(data["message"]);
                //                         } else {
                //                           title = Text(data["message"]);
                //                           content = Text("Please try again");
                //                         }
                //                     }
                //                     return AlertDialog(title: title, titleTextStyle: textStyle, content: content, actions: [
                //                       TextButton(
                //                         onPressed: () {
                //                           buildingNameController.clear();
                //                           blockNameController.clear();
                //                           addressController.clear();
                //                           formDateController.clear();
                //                           toDateController.clear();
                //                           Navigator.pop(context, 'OK');
                //                         },
                //                         child: const Text('OK'),
                //                       ),
                //                     ]);
                //                   } else {
                //                     return Center(
                //                         child: SizedBox(
                //                       child: CircularProgressIndicator(),
                //                     ));
                //                   }
                //                 },
                //               );
                //             },
                //           );
                //         },
                //       )),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
