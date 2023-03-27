import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
  String? uid = '';
  String? name = '';
  String? surename = '';

  String? email = '';
  String? photoUrl = '';
  String? userRole = '';
  String? phone = '';
  dynamic time = '';
  String? status = '';
  String? lastSeen = '';

  String? gender = '';
  String? interssi = '';
  String? subadminstrationarea = '';
  String? country = '';
  String? dateBirth = '';
  int? score;
  int? totalFollowers;
  bool? messageNotification;
  UserModal(
      {this.email,
      this.name,
      this.surename,
      this.photoUrl,
      this.uid,
      this.userRole,
      this.phone,
      this.status,
      this.time,
      this.lastSeen,
      this.country,
      this.dateBirth,
      this.gender,
      this.interssi,
      this.score,
      this.totalFollowers,
      this.messageNotification,
      this.subadminstrationarea});

  factory UserModal.fromJson(Map<String, dynamic> json) {
    return UserModal(
        uid: json['uid'] ?? '',
        name: json['name'] ?? '',
        surename: json['surename'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        photoUrl: json['photoUrl'] ?? '',
        userRole: json['userRole'] ?? '',
        status: json['status'] ?? '',
        lastSeen: json['lastSeen'],
        country: json['country'] ?? '',
        dateBirth: json['dateBirth'] ?? '',
        gender: json['gender'] ?? '',
        interssi: json['interssi'] ?? '',
        subadminstrationarea: json['subadminstrationarea'] ?? '',
        score: json['score'] ?? -1,
        totalFollowers: json['totalFollowers'] ?? -1,
                messageNotification: json['messageNotification'] ?? false,
        time: (json['time'] as Timestamp).toDate());
  }
}
/*
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'surename': surename,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'userRole': userRole,
      'status': status,
      'time': time,
    };
  }
*/