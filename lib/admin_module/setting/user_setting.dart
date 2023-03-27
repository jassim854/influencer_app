import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:influencer/FirebaseServices/firbase_collection.dart';
import 'package:influencer/FirebaseServices/firebase_auth.dart';
import 'package:influencer/Modals/user_modal.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/common_app.dart';
import 'package:influencer/util/string.dart';
import 'package:intl/intl.dart';

import '../auth/login/view/login.dart';
import '../two_way_channel/view/home_controller.dart';

class User_Setting extends StatefulWidget {
  const User_Setting({Key? key}) : super(key: key);

  @override
  State<User_Setting> createState() => _User_SettingState();
}

class _User_SettingState extends State<User_Setting> {
  final con = Get.put(CurrentUserController());

  bool status = false;
  bool status1 = false;
  bool status2 = false;
  int? groupValue;
  int? groupValue1;

  String? date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          Strings.mio_account,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      dialogbox(
                          context, "Male", "Female", "Transgender", false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sono',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Obx(() => Text(
                              con.currentUser?.gender == ''
                                  ? 'Donna/Uomo'
                                  : con.currentUser?.gender ?? '',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () =>
                        dialogbox(context, "Cibo ", "Lingerie", "Beauty", true),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Interssi',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Obx(() => Text(
                              con.currentUser?.interssi == ''
                                  ? 'Cibo,Lingerie,Beauty'
                                  : con.currentUser?.interssi ?? '',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Paths.setLocation);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Obx(() => Text(
                              "${con.currentUser?.subadminstrationarea == '' ? 'Versona' : con.currentUser?.subadminstrationarea.toString() ?? ''}, ${con.currentUser?.country == '' ? 'It' : con.currentUser?.country.toString() ?? ''}",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      final datepick = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now());
                      if (datepick != null) {
                        date = DateFormat('MMMM ,dd ,yyy').format(datepick);
                        await firebaseInstance
                            .collection('users')
                            .doc(uid)
                            .update({
                          'dateBirth': date,
                        });
                        con.updateModel();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Eta',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Obx(() => Text(
                              con.currentUser?.dateBirth == ''
                                  ? "Birthday"
                                  : con.currentUser?.dateBirth ?? 'Birthday',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                  // RangeSlider(
                  //   values: _currentRangeValues,
                  //   max: 100,
                  //   divisions: 100,
                  //   labels: RangeLabels(
                  //     _currentRangeValues.start.round().toString(),
                  //     _currentRangeValues.end.round().toString(),
                  //   ),
                  //   onChanged: (RangeValues values) {
                  //     setState(() {
                  //       _currentRangeValues = values;
                  //     });
                  //   },
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> dialogbox(
    BuildContext context,
    String title1,
    String title2,
    String title3,
    bool isInterssi,
  ) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          String? gender;
          String? interssi;
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<int>(
                          title: Text(title1),
                          value: 0,
                          groupValue: isInterssi ? groupValue1 : groupValue,
                          onChanged: (value) {
                            isInterssi
                                ? groupValue1 = value
                                : groupValue = value;
                            setState(() {
                              isInterssi ? interssi = title1 : gender = title1;
                            });
                          },
                        ),
                        RadioListTile<int>(
                          title: Text(title2),
                          value: 1,
                          groupValue: isInterssi ? groupValue1 : groupValue,
                          onChanged: (value) {
                            isInterssi
                                ? groupValue1 = value
                                : groupValue = value;
                            setState(() {
                              isInterssi ? interssi = title2 : gender = title2;
                            });
                          },
                        ),
                        RadioListTile<int>(
                          title: Text(title3),
                          value: 2,
                          groupValue: isInterssi ? groupValue1 : groupValue,
                          onChanged: (value) {
                            isInterssi
                                ? groupValue1 = value
                                : groupValue = value;
                            setState(() {
                              isInterssi ? interssi = title3 : gender = title3;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('Cancel')),
                            TextButton(
                                onPressed: () async {
                                  isInterssi
                                      ? await firebaseInstance
                                          .collection('users')
                                          .doc(uid)
                                          .update({
                                          'interssi': interssi,
                                        })
                                      : await firebaseInstance
                                          .collection('users')
                                          .doc(uid)
                                          .update({
                                          'gender': gender,
                                        });
                                  con.updateModel();

                                  Get.back();
                                },
                                child: Text('Ok')),
                          ],
                        )
                      ]),
                );
              },
            ),
          );
        });
  }
}
