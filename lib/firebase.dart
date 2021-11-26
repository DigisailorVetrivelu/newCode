export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_functions/cloud_functions.dart';
export 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

final databaseRef = FirebaseDatabase.instance.reference();
final FirebaseFunctions functions = FirebaseFunctions.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

CollectionReference<Map<String, dynamic>> certs = firestore.collection('Certs');
CollectionReference<Map<String, dynamic>> users = firestore.collection('Users');
CollectionReference<Map<String, dynamic>> assessments = firestore.collection('Assessments');
CollectionReference<Map<String, dynamic>> announcements = firestore.collection('Announcements');

CollectionReference<Map<String, dynamic>> getAssesmentCollection(String uid) {
  return firestore.collection('Users/$uid/Assessments');
}
