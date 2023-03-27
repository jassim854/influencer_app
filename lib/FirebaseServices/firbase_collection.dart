import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:influencer/Modals/user_modal.dart';

final firebaseInstance = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final uid = firebaseAuth.currentUser?.uid;
final userContacts =
    firebaseInstance.collection('users').doc('112233').collection('contacts');

abstract class FirebaseMethods {
  // add user data
  static Future<void> addUserCollection({
    uid,
    name,
    sureName,
    email,
    phone,
    password,
  }) {
    return firebaseInstance
        .collection('users')
        .doc(uid)
        .set({
          'uid': uid,
          'name': name,
          'surename': sureName,
          'email': email,
          'phone': phone,
          'password ': password,
          'photoUrl': '',
          'userRole': 'user',
          'status': 'offline',
          'lastSeen': '',
          'homeview': 'false',
          'time': Timestamp.now(),
          'gender': null,
          'interssi':null,
          'subadminstrationarea': null,
          'country': null,
          'dateBirth': null,
          'score': -1,
          'totalFollowers': -1
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // add user contacts

  static Future<void> addUserContacts(Map<String, dynamic> contacts) async {
    return userContacts
        .add({'': ''})
        .then((value) => print("contact added"))
        .catchError((error) => print("Failed to add contacts: $error"));
  }
}
