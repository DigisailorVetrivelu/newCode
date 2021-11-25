import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iukl_admin/models/complaint.dart';
import 'package:iukl_admin/models/userModel.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ComplaintList extends StatefulWidget {
  ComplaintList({Key? key, this.user}) : super(key: key);

  final UserModel? user;

  @override
  _ComplaintListState createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  int page = 1;
  List<Complaint> items = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots = [];
  @override
  @override
  void initState() {
    super.initState();
    _loadData(null);
  }

  bool isLoading = false;

  Future _loadData(DocumentSnapshot? snap) async {
    // perform fetching data delay
    snapshots = await Complaint.getComplaints(snap).then((value) => value.docs);
    print("load more");
    // if (snapshots.length != 0)
    // update data and loading status
    if (snapshots.length != 0) {
      setState(() {
        for (var snap in snapshots) {
          if (snap.exists) {
            items.add(Complaint.fromJson(snap.data()));
          }
        }
        print('items: ' + items.toString());
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Complaints',
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
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: FloatingActionButton(onPressed: (){},child: Icon(Icons.add),
      //   backgroundColor: Color(0xFFEF4C43),
      //   ),
      // ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (snapshots.length != 0) {
                  _loadData(snapshots.last);
                  setState(() {
                    isLoading = true;
                  });
                } else {
                  setState(() {
                    isLoading = false;
                  });
                }
                return true;
              },
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                    child: GestureDetector(
                      onTap: () async {
                        // await items[index].loadDummyContacts();
                        // Get.to(() => ContactHistoryDetails(
                        //       contactHistory: items[index].contactHistory != null ? items[index].contactHistory! : null,
                        //     ));
                      },
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.9,
                        // height: MediaQuery.of(context).size.height * 0.12,
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
                            padding: EdgeInsetsDirectional.fromSTEB(20, 20, 10, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Raised by : ${items[index].raisedBy}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Divider(),
                                Text(
                                  'Title : ${items[index].title}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Divider(),
                                Text(
                                  'Content : ${items[index].content}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Divider(),
                                Text(
                                  'Description : ${items[index].description}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Divider(),
                                ElevatedButton(
                                    onPressed: () async {
                                      await launcher.launch(items[index].attachementUrl!, enableDomStorage: true);
                                    },
                                    child: Icon(Icons.download)),
                              ],
                            )),
                      ),
                    ),
                  );
                },
              ),
            ),
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
