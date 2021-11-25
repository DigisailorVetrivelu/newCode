import 'package:flutter/material.dart';
import '../models/userModel.dart';

class ContactHistoryDetails extends StatefulWidget {
  ContactHistoryDetails({Key? key, this.title, this.contactHistory}) : super(key: key);

  final List<ContactHistory>? contactHistory;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _ContactHistoryDetailsState createState() => _ContactHistoryDetailsState();
}

class _ContactHistoryDetailsState extends State<ContactHistoryDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: widget.contactHistory != null ? widget.contactHistory!.length : 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                  child: Card(
                    elevation: 3,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.19,
                      decoration: BoxDecoration(
                        // color: Color(0xFFAF2922),
                        // image: DecorationImage(
                        //   fit: BoxFit.cover,
                        //   image: Image.asset(
                        //     'assets/images/corona image.png',
                        //   ).image,
                        // ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 10, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextForDetails(
                                data: 'Contacted Person Name : ${widget.contactHistory![index].contact}',
                              ),
                              TextForDetails(
                                data: 'Group ID : ${widget.contactHistory![index].groupId}',
                              ),
                              TextForDetails(
                                data: 'Device ID : ${widget.contactHistory![index].deviceId}',
                              ),
                              TextForDetails(
                                data: 'Date & Time : ' + widget.contactHistory![index].lastContact.toString().substring(0, 10),
                              ),
                              TextForDetails(data: 'Total Contact in minutes: ${widget.contactHistory![index].totalTimeinContact / 60}'),
                              TextForDetails(data: 'Gateway: ${widget.contactHistory![index].gateWay}'),
                              TextForDetails(data: 'IsCovid: ${widget.contactHistory![index].covidStatus}'),
                            ],
                          )),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TextForDetails extends StatelessWidget {
  const TextForDetails({
    Key? key,
    this.data,
  }) : super(key: key);
  final String? data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data!,
      style: TextStyle(
        fontFamily: 'Poppins',
        color: data == "false" ? Colors.red : Colors.black,
        fontSize: 15,
      ),
    );
  }
}
