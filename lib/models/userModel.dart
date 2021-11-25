// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:iukl_admin/constants/constants.dart';
import 'package:path/path.dart';
import '../firebase.dart';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    required this.id,
    required this.icNumber,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.houseAddress,
    this.residenceAddress,
    this.imageUrl,
    required this.department,
    required this.passportNumber,
    this.isLocal = true,
    this.countryCode,
  });

  String id;
  String icNumber;
  String passportNumber;
  String email;
  String name;
  String department;
  String? houseAddress;
  String? residenceAddress;
  String? imageUrl;
  String? countryCode;
  String? phoneNumber;
  bool isLocal;

  static Future<dynamic> uploadPhoto() async {
    String? url;
    try {
      var xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (xfile != null) {
        var filePath = xfile.path;
        var file = File(filePath);
        await storage.ref("profiles").child(basename(file.path)).putFile(file).then((snapshot) async {
          url = await snapshot.ref.getDownloadURL();
        });
      }
      return url;
    } catch (e) {
      return e;
    }
  }

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        houseAddress: json["permanentAddress"],
        residenceAddress: json["currentAddress"],
        icNumber: json["icNumber"],
        phoneNumber: json["phoneNumber"],
        imageUrl: json["imageUrl"],
        passportNumber: json["passportNumber"] ?? '',
        department: json["department"] ?? '',
        isLocal: json["isLocal"] ?? true,
        countryCode: json["countryCode"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "permanentAddress": houseAddress,
        "currentAddress": residenceAddress,
        "icNumber": icNumber,
        "phoneNumber": phoneNumber,
        "imageUrl": imageUrl,
        "department": department,
        "passportNumber": passportNumber,
        "local": isLocal,
        "countryCode": countryCode,
      };
}

// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

CollectionReference<Map<String, dynamic>> users = firestore.collection('Users');

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.bioData,
    required this.uid,
    this.isStaff = false,
    this.device,
    this.quarantine,
    this.covidInfo,
    this.contactHistory,
    this.fcm,
    this.createdDate,
  });

  Profile bioData;
  String uid;
  bool isStaff;
  Device? device;
  Quarantine? quarantine;
  CovidInfo? covidInfo;
  List<CovidInfo>? covidInfohistory;
  List<ContactHistory>? contactHistory;
  String? fcm;
  DateTime? createdDate;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        bioData: Profile.fromJson(json["bioData"]),
        uid: json["uid"],
        isStaff: json["isStaff"],
        device: json["device"] != null ? Device.fromJson(json["device"]) : null,
        quarantine: json["quarantine"] != null ? Quarantine.fromJson(json["quarantine"]) : null,
        covidInfo: json["covidInfo"] != null ? CovidInfo.fromJson(json["covidInfo"]) : null,
        contactHistory:
            json["contactHistory"] != null ? List<ContactHistory>.from(json["contactHistory"].map((x) => ContactHistory.fromJson(x))) : null,
        fcm: json["fcm"],
        createdDate: json["createdDate"] != null ? json["createdDate"].toDate() : null,
      );

  Map<String, dynamic> toJson() => {
        "bioData": bioData.toJson(),
        "uid": uid,
        "isStaff": isStaff,
        "device": device != null ? device!.toJson() : null,
        "quarantine": quarantine != null ? quarantine!.toJson() : null,
        "covidInfo": covidInfo != null ? covidInfo!.toJson() : null,
        "contactHistory": contactHistory != null ? List<dynamic>.from(contactHistory!.map((x) => x.toJson())) : null,
        "fcm": fcm,
        "createdDate": createdDate,
        "search": searchString,
      };

  Map<String, dynamic> toRTDBJson() => {
        "bioData": bioData.name,
        "uid": uid,
        "isStaff": isStaff,
        "deviceID": device != null ? device!.deviceId : null,
        "groupID": device != null ? device!.groupId : null,
        "quarantine": quarantine != null ? quarantine!.location.quarantineAddress.toString() : null,
        "isCovid": covidInfo != null ? covidInfo!.result : false,
        "fcm": fcm,
        "createdDate": createdDate != null ? createdDate!.toIso8601String() : null,
      };

  static addUser(Profile profile, bool staff, Device device) async {
    final data = {"email": profile.email, "isStaff": staff, "device": device};
    try {
      var documents = await users.where('device', isEqualTo: device.toJson()).get().then((value) => value.docs);
      if (documents.length > 0) {
        documents.forEach((element) {
          print(element.data());
        });
        return {"code": "Failure", "message": "Device ID Already exists"};
      }
      documents = await users.where('device', isEqualTo: device.toJson()).get().then((value) => value.docs);
      if (documents.length > 0) {
        documents.forEach((element) {
          print(element.data());
        });
        return {"code": "Failure", "message": "Device ID Already exists"};
      }
      print("Triggered Add User HTTPs callables");
      return functions.httpsCallable('addStaff').call({"profile": profile.toJson(), "device": device.toJson(), "isStaff": staff}).then((userRecord) {
        if (userRecord.data == null) {
          print("Returning ErrorInfo in UserRecord ");
          return userRecord.data;
        } else {
          if (userRecord.data["errorInfo"] != null) {
            return userRecord.data["errorInfo"];
          }
          return authController.auth.resetPassword(email: userRecord.data["email"]).then((value) async {
            print("Triggered User Document Creation");
            return users
                .doc(userRecord.data["uid"])
                .set(
                  UserModel(bioData: profile, uid: userRecord.data["uid"], createdDate: DateTime.now(), device: device).toJson(),
                )
                .then((value) {
              return databaseRef
                  .child("users")
                  .child(userRecord.data["uid"])
                  .set(UserModel(bioData: profile, uid: userRecord.data["uid"], createdDate: DateTime.now(), device: device).toRTDBJson());
            }).then((value) {
              return {"code": "Success", "message": "User Successfully Created"};
            }).onError((error, stackTrace) {
              return {"code": "Failure", "message": "User has not been Created"};
            });
          });
        }
      });
    } catch (exception) {
      return exception;
    }
  }

  static getUserProfile(String uid) {
    return users.doc(uid).get().then((value) => UserModel.fromJson(value.data()!));
  }

  loadContacts() async {
    List<ContactHistory>? returns = [];
    var contacts = await databaseRef.child("contacts").child(uid).get().then((result) {
      return result.value ?? null;
    });
    if (contacts != null) {
      contacts.forEach((k, json) {
        print(json);
        returns.add(ContactHistory(
          contact: json["contact"],
          fcm: json["fcm"] ?? '',
          totalTimeinContact: json["totalTimeinContact"],
          groupId: json["groupId"],
          deviceId: json["deviceId"],
          gateWay: json["gateWay"],
          lastContact: DateTime.fromMillisecondsSinceEpoch(json["lastContact"] * 1000),
        ));
      });
    }
    this.contactHistory = returns;
    return returns;
  }

  Future<dynamic> updateUser() async {
    print("Hrllo");
    return await users.doc(this.uid).update(this.toJson()).then((value) {
      var json = this.toRTDBJson();
      return databaseRef.child("users").child(this.uid).set(json).then((value) {
        print(json["fcm"]);
        return databaseRef.child("users/$uid/fcm").set(json["fcm"]).then((value) {
          return {"code": "Success", "message": "User update successful"};
        });
      }).catchError((onError) {
        return {"code": "Failure", "message": "Unknown Error. Please try again"};
      });
    });
  }

  Future<dynamic> deleteUser() async {
    return await functions.httpsCallable('deleteStaff').call({uid: this.uid}).then((value) {
      users.doc(uid).delete().then((value) => print("deleted"));
    }).then((value) {
      print(value);
    });
  }

  Future<dynamic> quarantineUser(Quarantine quarantine) async {
    try {
      return users
          .doc(this.uid)
          .update({"quarantine": quarantine.toJson()}).then((value) => {"code": "Success", "message": "Quarantine Status Updated"});
    } catch (exception) {
      return exception;
    }
  }

  updateCovidInformation(CovidInfo covidInfo) async {
    try {
      await users.doc(this.uid).update({"quarantine": quarantine!.toJson()});
      return {"code": "Success", "message": "Covid Information Updated"};
    } catch (exception) {
      return exception;
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUsers(DocumentSnapshot? certUserSnapshot) {
    if (certUserSnapshot != null) {
      return users.orderBy("bioData.id").startAfterDocument(certUserSnapshot).limit(15).get();
    } else {
      return users.orderBy("bioData.id").limit(15).get();
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsersAsStream(String? searchtext) {
    if (searchtext != null && searchtext != "") {
      var count = users.where('search', arrayContains: searchtext).orderBy("bioData.id").snapshots();
      return count;
    }
    return users.orderBy("bioData.id").snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCovidUsersAsStream(String? searchtext) {
    if (searchtext != null && searchtext != "") {
      var count = users.where('covidInfo.result', isEqualTo: false).where('search', arrayContains: searchtext).orderBy("bioData.id").snapshots();
      return count;
    }
    return users.where('covidInfo.result', isEqualTo: false).orderBy("bioData.id").snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getQuarantineUsersAsStream(String? searchtext) {
    if (searchtext != null && searchtext != "") {
      var count = users.where('quarantine', isNull: false).where('search', arrayContains: searchtext).snapshots();
      return count;
    }
    return users.where('quarantine', isNull: false).snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getCovidUsers(DocumentSnapshot? certUserSnapshot) {
    if (certUserSnapshot != null) {
      return users
          .orderBy("bioData.id")
          .startAfterDocument(certUserSnapshot)
          .where('covidInfo', isNull: false)
          .where('covidInfo.result', isEqualTo: true)
          .limit(15)
          .get();
    } else {
      return users.orderBy("bioData.id").limit(15).where('covidInfo', isNull: false).where('covidInfo.result', isEqualTo: true).get();
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getQurantineUsers(DocumentSnapshot? certUserSnapshot) {
    if (certUserSnapshot != null) {
      return users.orderBy("bioData.id").startAfterDocument(certUserSnapshot).where('covidInfo', isNull: false).limit(15).get();
    } else {
      return users.orderBy("bioData.id").limit(15).where('covidInfo', isNull: false).get();
    }
  }

  loadDummyContacts() async {
    contactHistory = ContactHistory.getDummyContacts();
    await users.doc(this.uid).update(this.toJson());
  }

  List<String> get searchString => makeSearchString(this.bioData.name);
  makeSearchString(String text) {
    List<String> returns = [];
    var length = text.length;
    for (int i = 0; i < length; i++) {
      returns.add(text.substring(0, i));
    }
    return returns;
  }
}

class Device {
  Device({
    required this.groupId,
    required this.deviceId,
    this.dmac,
  });

  int groupId;
  int deviceId;
  String? dmac;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        groupId: json["groupID"],
        deviceId: json["deviceID"],
        dmac: json["dmac"],
      );

  Map<String, dynamic> toJson() => {
        "groupID": groupId,
        "deviceID": deviceId,
        "dmac": dmac,
      };
}

class Quarantine {
  Quarantine({
    required this.startDate,
    required this.endDate,
    required this.location,
  });

  DateTime startDate;
  DateTime endDate;
  Location location;

  factory Quarantine.fromJson(Map<String, dynamic> json) => Quarantine(
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "location": location.toJson(),
      };
}

class Location {
  Location({required this.place, this.floor, this.block, this.inCampus = true, this.quarantineAddress});

  String? place;
  int? floor;
  String? block;
  bool inCampus;
  String? quarantineAddress;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        place: json["place"],
        floor: json["floor"],
        block: json["block"],
        inCampus: json["inCampus"] ?? false,
        quarantineAddress: json["quarantineAddress"],
      );

  Map<String, dynamic> toJson() => {"place": place, "floor": floor, "block": block, "inCampus": inCampus, "quarantineAddress": quarantineAddress};
}

class CovidInfo {
  CovidInfo({
    this.result = false,
    this.method,
    this.type,
    this.date,
    this.vaccinated = false,
    this.vaccinatedOn,
    this.question1,
    this.question2,
    this.question3,
    this.question4,
  });

  bool result;
  String? method;
  String? type;
  DateTime? date;
  bool vaccinated;
  DateTime? vaccinatedOn;

  bool? question1;
  bool? question2;
  bool? question3;
  bool? question4;

  factory CovidInfo.fromJson(Map<String, dynamic> json) => CovidInfo(
        result: json["result"],
        method: json["method"],
        type: json["type"],
        // date: DateTime.parse(json["date"]),
        vaccinated: json["vaccinated"],
        // vaccinatedOn: DateTime.parse(json["vaccinatedOn"]),
        question1: json["question1"] ?? null,
        question2: json["question2"] ?? null,
        question3: json["question3"] ?? null,
        question4: json["question4"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "method": method,
        "type": type,
        "date": date,
        "vaccinated": vaccinated,
        "vaccinatedOn": vaccinatedOn,
        "question1": question1,
        "question2": question2,
        "question3": question4,
        "question4": question4,
      };
}

class ContactHistory {
  ContactHistory(
      {required this.contact,
      required this.fcm,
      required this.totalTimeinContact,
      this.deviceId,
      this.groupId,
      this.gateWay,
      this.lastContact,
      this.covidStatus = false});

  String contact;
  bool covidStatus;
  int? groupId;
  int? deviceId;
  String? fcm;
  int totalTimeinContact;
  String? gateWay;
  DateTime? lastContact;

  factory ContactHistory.fromJson(Map<String, dynamic> json) => ContactHistory(
        contact: json["contact"],
        fcm: json["fcm"],
        totalTimeinContact: json["totalTimeinContact"],
        groupId: json["groupId"],
        deviceId: json["deviceId"],
        gateWay: json["gateWay"],
        lastContact: DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "contact": contact,
        "fcm": fcm,
        "totalTimeinContact": totalTimeinContact,
        "deviceId": deviceId,
        "groupId": groupId,
        "gateWay": gateWay,
        "lastContact": lastContact,
      };

  Map<String, dynamic> toRTDBJson() => {
        "contact": contact,
        "fcm": fcm,
        "totalTimeinContact": totalTimeinContact,
        "deviceId": deviceId,
        "groupId": groupId,
        "gateWay": gateWay,
        "lastContact": lastContact != null ? lastContact!.toIso8601String() : null,
      };

  static getDummyContacts() {
    return [
      ContactHistory(contact: "user1", fcm: "fcm", totalTimeinContact: 50, deviceId: 1001, groupId: 1000),
      ContactHistory(contact: "user2", fcm: "fcm", totalTimeinContact: 15, deviceId: 2001, groupId: 2000),
      ContactHistory(contact: "user3", fcm: "fcm", totalTimeinContact: 10, deviceId: 3001, groupId: 3000),
    ];
  }
}
