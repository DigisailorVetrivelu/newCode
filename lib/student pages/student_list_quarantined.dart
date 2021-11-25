import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/userModel.dart';

import '../../widgets/studentcustomTile.dart';
import 'addStudent.dart';
import 'studentPage.dart';

class StudentStaffListQuarantined extends StatefulWidget {
  StudentStaffListQuarantined({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _StudentStaffListQuarantinedState createState() => _StudentStaffListQuarantinedState();
}

class _StudentStaffListQuarantinedState extends State<StudentStaffListQuarantined> {
  List<UserModel> items = [];

  @override
  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;
  String? searchText;
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEF4C43),
        bottom: PreferredSize(
          preferredSize: Size(double.maxFinite, 70),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              if (controller.text.isEmpty) {
                                searchText = null;
                              }
                              searchText = controller.text;
                            });
                          },
                        ),
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
              ),
            ],
          ),
        ),
        title: Text(
          'Quarantined Users',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            Get.to(() => AddStudentOrStaff());
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFFEF4C43),
        ),
      ),
      body: Column(
        children: <Widget>[
          // Expanded(child: Container(height: 2)),
          Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: UserModel.getQuarantineUsersAsStream(searchText),
                initialData: null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error!');
                  }
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var student = UserModel.fromJson(snapshot.data!.docs.elementAt(index).data());

                      return Column(
                        children: [
                          CustomTile(
                            user: student,
                            onTap: () {
                              // Get.to(() => AddStudentOrStaff(
                              //       user: student,
                              //     ));
                            },
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: IconButton(
                                  onPressed: () {
                                    print("============");
                                    Get.to(() => StaffPage(user: student, initalIndex: 0));
                                  },
                                  icon: const Icon(Icons.person),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: IconButton(
                                  onPressed: () {
                                    Get.to(() => StaffPage(user: student, initalIndex: 1));
                                  },
                                  icon: const Icon(Icons.home_work),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: IconButton(
                                  onPressed: () {
                                    Get.to(() => StaffPage(user: student));
                                  },
                                  icon: Icon(Icons.medication),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: IconButton(
                                  onPressed: () {
                                    print("object");
                                    Get.to(() => StaffPage(user: student, initalIndex: 3));
                                  },
                                  icon: const Icon(Icons.people),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: IconButton(
                                  onPressed: () {
                                    student.deleteUser();
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 10,
                            color: Colors.black,
                          ),
                        ],
                      );
                    },
                  );
                }),
          ),
          Container(
            height: isLoading ? 50.0 : 0,
            color: Colors.transparent,
            child: Center(
              child: new CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  CustomListTile({
    required this.user,
    this.onTap,
  });

  final UserModel user;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontFamily: 'Poppins',
      color: Colors.white,
      fontSize: 15,
    );
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          color: Color(0xFF5C5C5C),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/images/corona image.png',
            ).image,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AspectRatio(
                aspectRatio: 0.7,
                child: Container(
                  // color: Colors.amber,
                  height: double.maxFinite,
                  child: Center(child: Image.asset('assets/images/addstaff.png', fit: BoxFit.contain)),
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                                // color: Colors.yellow,
                                height: double.maxFinite,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Name : ${user.bioData.name}",
                                          textAlign: TextAlign.left,
                                          style: textStyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "ID : ${user.bioData.id}",
                                          textAlign: TextAlign.left,
                                          style: textStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              // color: Colors.amberAccent.withOpacity(0.5),
                              height: double.maxFinite,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "GROUP ID : ${user.device!.groupId}",
                                        textAlign: TextAlign.left,
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Device ID : ${user.device!.deviceId}",
                                        textAlign: TextAlign.left,
                                        style: textStyle,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Phone    : ${user.bioData.phoneNumber}",
                            style: textStyle,
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email ID : ${user.bioData.email}",
                            style: textStyle,
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
