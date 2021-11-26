import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
CollectionReference<Map<String, dynamic>> announcements = firestore.collection('Announcements');

class Announcement {
  Announcement({
    this.attachementUrl,
    required this.title,
    required this.description,
    this.content,
    required this.documentId,
    this.createdDate,
  });

  String? attachementUrl;
  String title;
  String description;
  String? content;
  String documentId;
  DateTime? createdDate;

  static Future<dynamic> createAnnouncement(String? attachementUrl, String title, String description, String? content, File? file) async {
    if (file != null) {
      try {
        return storage.ref("announcements").child(basename(file.path)).putFile(file).whenComplete(() {
          return {"code": "Success", "message": "Complaint Successfully Created"};
        }).then((snapshot) async {
          return await snapshot.ref.getDownloadURL().then((attachementUrl) {
            return announcements.add({
              "attachementUrl": attachementUrl,
              "title": title,
              "description": "description",
              "content": content,
              "createdDate": DateTime.now(),
            });
          });
        });
      } catch (e) {
        return {"code": "Failure", "message": "Complaint not created"};
      }
    } else {
      try {
        return announcements.add({
          "attachementUrl": attachementUrl,
          "title": title,
          "description": "description",
          "content": content,
          "createdDate": DateTime.now(),
        }).then((docRef) {
          return {"code": "Success", "message": "Complaint Successfully Created"};
        });
      } catch (e) {
        return e;
      }
    }
  }

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        attachementUrl: json["attachementUrl"],
        title: json["title"],
        description: json["description"],
        content: json["content"],
        documentId: json["documentID"],
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "attachementUrl": attachementUrl,
        "title": title,
        "description": description,
        "content": content,
        "documentID": documentId,
        "createdDate": createdDate
      };
}
