import 'package:flutter/material.dart';
import 'package:iukl_admin/models/userModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    Key? key,
    required this.user,
    this.onTap,
  }) : super(key: key);
  final UserModel user;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        subtitle: Text(
          user.device != null
              ? '${user.bioData.id} \nGroup ID : ${user.device!.groupId} \t Device ID : ${user.device!.deviceId}'
              : "Device not assigned",
          style: TextStyle(color: Colors.black38),
        ),
        title: Text(
          '${user.bioData.name}',
          style: TextStyle(color: Colors.black),
        ),
        // trailing: Row(children: [Icon(Icons.copy), Icon(Icons.expand_less_rounded)]),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            "https://cdn.pixabay"
            ".com/photo/2013/07/13/10/07/man-156584_960_720.png",
          ),
        ),
        children: [
          CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                disableCenter: true,
                height: 155,
              ),
              items: [MyInfoTile(user: user), QuarantineInfo(user: user), CovidStatus(user: user)]),
        ],
      ),
    );
  }
}

class MyInfoTile extends StatelessWidget {
  const MyInfoTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 0,
        shadowColor: Colors.grey,
        // color: Color(0xFF373737),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.all(0),
              child: Container(
                width: MediaQuery.of(context).size.width * 100,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'GROUPID   :  ${user.device != null ? user.device!.groupId : "NOT FOUND"}\t                        DEVICEID   :  '
                        '${user.device != null ? user.device!.deviceId : "NOT FOUND"}\nEMAIL        '
                        ' :  ${user.bioData.email}'
                        '\nPHONE NO :  ${user.bioData.phoneNumber}',
                        style: TextStyle(color: Colors.black, height: 2.5),
                        textAlign: TextAlign.left),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class QuarantineInfo extends StatelessWidget {
  const QuarantineInfo({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 0,
        shadowColor: Colors.grey,
        // color: Color(0xFF373737),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.all(0),
              child: Container(
                width: MediaQuery.of(context).size.width * 100,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: user.quarantine == null
                        ? Center(child: Text("QUARANTINE DETAILS\nNo Quarantine deetails found"))
                        : Text(
                            "FROM DATE : "
                            "${user.quarantine!.startDate.toString().substring(0, 10)}\t\t\t|\t\t\t"
                            "DAYS LEFT : "
                            "${user.quarantine!.endDate.difference(DateTime.now()).inDays}\n"
                            "TO DATE : "
                            "${user.quarantine!.endDate.toString().substring(0, 10)}\n"
                            "Location : "
                            "${user.quarantine!.location.quarantineAddress}\n",
                            style: TextStyle(color: Colors.black, height: 2.5),
                            textAlign: TextAlign.left),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class CovidStatus extends StatelessWidget {
  CovidStatus({
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 0,
        shadowColor: Colors.grey,
        // color: Color(0xFF373737),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.all(0),
              child: Container(
                width: MediaQuery.of(context).size.width * 100,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: user.covidInfo == null
                        ? Center(child: Text("COVID DETAILS\nNo Covid details found"))
                        : Text(
                            "RESULT : "
                            "${user.covidInfo!.result ? "NEGATIVE" : "POSITIVE"}\t\t\t\t\t\t",
                            style: TextStyle(color: Colors.black, height: 2.5),
                            textAlign: TextAlign.left),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
