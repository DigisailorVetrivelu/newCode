import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
CollectionReference<Map<String, dynamic>> complaints = firestore.collection('Complaints');

class Complaint {
  Complaint({
    this.attachementUrl,
    required this.title,
    required this.description,
    this.content,
    // required this.documentId,
    this.createdDate,
    this.raisedBy,
  });

  String? attachementUrl;
  String title;
  String description;
  String? content;
  // String documentId;
  DateTime? createdDate;
  String? raisedBy;

  static Future<QuerySnapshot<Map<String, dynamic>>> getComplaints(DocumentSnapshot? certUserSnapshot) {
    if (certUserSnapshot != null) {
      return complaints.orderBy("createdDate").startAfterDocument(certUserSnapshot).limit(15).get();
    } else {
      return complaints.orderBy("createdDate").limit(15).get();
    }
  }

  static createAnnouncement(String? attachementUrl, String title, String description, String? content, File? file, String raisedBy) {
    if (file != null) {
      try {
        return complaints.add({
          "attachementUrl": attachementUrl,
          "title": title,
          "description": "description",
          "content": content,
          "createdDate": DateTime.now(),
          "raisedBy": raisedBy
        }).then((docRef) {
          return storage.ref("announcements").child(docRef.id).putFile(file).whenComplete(() => 0);
        });
      } catch (e) {
        return e;
      }
    }
  }

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
        attachementUrl: json["attachementUrl"],
        title: json["title"],
        description: json["description"],
        content: json["content"],
        // documentId: json["documentID"],
        createdDate: json["createdDate"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "attachementUrl": attachementUrl,
        "title": title,
        "description": description,
        "content": content,
        // "documentID": documentId,
        "createdDate": createdDate
      };
}
