// To parse this JSON data, do
//
//     final cert = certFromJson(jsonString);

import 'dart:convert';

import '../firebase.dart';

Cert certFromJson(String str) => Cert.fromJson(json.decode(str));

String certToJson(Cert data) => json.encode(data.toJson());

class Cert {
  Cert({
    required this.uid,
    required this.countryCode,
    required this.phoneNumber,
    required this.name,
    required this.certId,
    required this.email,
  });

  String uid;
  String phoneNumber;
  String countryCode;
  String name;
  String certId;
  String email;

  factory Cert.fromJson(Map<String, dynamic> json) => Cert(
        uid: json["uid"],
        phoneNumber: json["phoneNumber"],
        name: json["name"],
        certId: json["certID"],
        email: json["email"],
        countryCode: json["countryCode"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "phoneNumber": phoneNumber,
        "name": name,
        "certID": certId,
        "email": email,
        "countryCode": countryCode,
        "searchString": getSearchStrings(name),
      };

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProfile(String uid) {
    return certs.doc(uid).snapshots();
  }

  static addCertProfile(
      {required String uid, required String phoneNumber, required String countryCode, required String name, required String email}) {
    int id = 0;
    return databaseRef.child("globalData/certs").runTransaction((mutableData) {
      id = (mutableData.value != null) ? mutableData.value++ : 0;
      // print(mutableData.value);
      return mutableData;
    }).then((result) {
      return certs
          .doc(uid)
          .set(Cert(uid: uid, countryCode: countryCode, phoneNumber: phoneNumber, name: name, certId: "C" + "$id", email: email).toJson())
          .then((value) {
        return {"code": "success", "message": "Cert Profile has been added"};
      });
    }).catchError((error) {
      return {"code": "Failure", "message": "Cert Profile has not been added"};
    });
  }

  List<String> getSearchStrings(String searchText) {
    List<String> result = [];
    var length = searchText.length;
    for (int i = 0; i < length; i++) {
      result.add(searchText.substring(0, i));
    }
    result.add(searchText);
    result.add(this.certId);
    return result;
  }
}
