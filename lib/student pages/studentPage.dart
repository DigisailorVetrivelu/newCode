import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase.dart';
import '../models/userModel.dart';
import 'contactHistory.dart';
import 'editCovidInfo.dart';
import 'editStudent.dart';
import 'quarantineDetails.dart';

class StaffPage extends StatefulWidget {
  StaffPage({
    Key? key,
    required this.user,
    this.initalIndex = 0,
  }) : super(key: key);
  final UserModel user;
  final int initalIndex;
  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  bool quarntineChange = false;
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initalIndex;
    widget.user.loadContacts();
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void changeQuarantine() {
    quarntineChange = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFFEF4C43),
            automaticallyImplyLeading: true,
            title: Text('${widget.user.bioData.name}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            centerTitle: true,
            elevation: 0),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.person),
                  color: _selectedIndex == 0 ? Colors.red : Colors.black,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.home_work_outlined),
                  color: _selectedIndex == 1 ? Colors.red : Colors.black,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.medication),
                  color: _selectedIndex == 2 ? Colors.red : Colors.black,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.people),
                  color: _selectedIndex == 3 ? Colors.red : Colors.black,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        body: getWidget(_selectedIndex),
        floatingActionButton: FloatingActionButton(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 0,
          backgroundColor: Colors.red,
          child: Icon(Icons.save),
          onPressed: () {
            if (quarntineChange) {
              functions.httpsCallable('sendNotification').call({"fcm": widget.user.fcm}).then((value) => print("called")).catchError((error) {
                    print(error);
                  });
              quarntineChange = false;
            }
            showDialog(
              context: context,
              builder: (context) {
                var future = widget.user.updateUser();
                return FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    Widget title, content;
                    var textStyle = TextStyle(color: Colors.black);
                    if (snapshot.hasData) {
                      dynamic data = snapshot.data;
                      switch (data) {
                        case 0:
                          title = Text("User Added");
                          content = Text("User has been Modified successfully");
                          break;
                        default:
                          if (data["message"] != null || data["code"] != null) {
                            title = Text(data["code"]);
                            content = Text(data["message"]);
                          } else {
                            title = Text(data["message"]);
                            content = Text("Please try again");
                          }
                      }
                      return AlertDialog(title: title, titleTextStyle: textStyle, content: content, actions: [
                        TextButton(
                          onPressed: () {
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
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked);
  }

  getWidget(int index) {
    switch (index) {
      case 0:
        return EditStudent(student: widget.user);
      case 1:
        return QuarantineDetails(user: widget.user, changeOccur: changeQuarantine);
      case 2:
        return CovidInformation(user: widget.user);
      case 3:
        return ContactHistoryDetails(contactHistory: widget.user.contactHistory);
    }
  }
}
