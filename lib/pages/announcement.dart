import 'dart:io';
import 'package:iukl_admin/widgets/customTextBox.dart';
import 'package:path/path.dart';
import 'package:iukl_admin/models/announcements.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnnouncmentWidget extends StatefulWidget {
  AnnouncmentWidget({Key? key}) : super(key: key);

  @override
  _AnnouncmentWidgetState createState() => _AnnouncmentWidgetState();
}

class _AnnouncmentWidgetState extends State<AnnouncmentWidget> {
  String? _path;
  TextEditingController? titleController;
  TextEditingController? desriptionController;
  TextEditingController? contentController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    desriptionController = TextEditingController();
    contentController = TextEditingController();
  }

  Future chooseFile() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _path = file.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFEF4C43),
        automaticallyImplyLeading: true,
        title: Text(
          'Create Announcement',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/images/mega phone.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextBox(controller: titleController!, labelText: 'Title', hintText: 'Sample SOP', keyboardType: TextInputType.text),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                          child: TextFormField(
                            maxLines: 5,
                            controller: contentController,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Content',
                              labelStyle: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFFEF4C43),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: '------------------',
                              hintStyle: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF95A1AC),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFDBE2E7),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFDBE2E7),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                            ),
                            style: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        // CustomTextBox(
                        //     controller: desriptionController!, labelText: 'Description', hintText: '-------------', keyboardType: TextInputType.text),
                        GestureDetector(
                          onTap: () async {
                            await chooseFile();
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.all(12),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.22,
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEEEEEE),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.attach_file,
                                    // color: FlutterFlowTheme.primaryColor,
                                    size: 24,
                                  ),
                                ),
                              ),
                              _path != null ? Text(basename(_path.toString())) : Text(''),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Send'),
                    onPressed: () async {
                      print("_path");
                      var future;
                      if (_path != null)
                        future = Announcement.createAnnouncement(
                            null, titleController!.text, desriptionController!.text, contentController!.text, File(_path!));
                      else
                        future =
                            Announcement.createAnnouncement(null, titleController!.text, desriptionController!.text, contentController!.text, null);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return FutureBuilder(
                            future: future,
                            builder: (context, snapshot) {
                              Widget title, content;
                              var textStyle = TextStyle(color: Colors.black);
                              if (snapshot.hasData) {
                                title = Text("Complaint Registered");
                                content = Text("Complaint has been added successfully");
                                return AlertDialog(title: title, titleTextStyle: textStyle, content: content, actions: [
                                  TextButton(
                                    onPressed: () {
                                      titleController!.clear();
                                      desriptionController!.clear();
                                      contentController!.clear();
                                      _path = null;
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSucessDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Successfully Compliant Created", style: TextStyle(color: Colors.black)),
          );
        });
  }
}
