import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:influencer/admin_module/FireBaseUsers/firebase_user_controller.dart';
import 'package:influencer/admin_module/archiviazione/view/contact_listAdmin_startchannel.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/routes/app_routes.dart';
import 'package:influencer/userModule/profile/view/widget/notification.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/string.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';
import '../../FirebaseServices/dynamic_link.dart';
import '../../FirebaseServices/firbase_collection.dart';
import '../../util/color.dart';
import '../admin_archived/view/component/googlemap.dart';
import '../auth/login/view/login.dart';

class Profile extends StatefulWidget {
  Profile({Key? key, this.city, this.country}) : super(key: key);
  double? country;
  double? city;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final controller = Get.put(CurrentUserController());

  getCity() async {
    List<Placemark> address = await placemarkFromCoordinates(
        double.parse(widget.country.toString()),
        double.parse(widget.city.toString()));

    await firebaseInstance.collection('users').doc(uid).update({
      'subadminstrationarea': address.last.administrativeArea.toString(),
      'country': address.last.country.toString(),
    });
    controller.updateModel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3));
    getCity();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onbackpress(context),
      child: Scaffold(
          backgroundColor: IColor.colorWhite,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.white,
            title: const Text(
              Strings.profile,
              style: TextStyle(color: IColor.colorblack),
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  print('data');
                  await FirebaseAuth.instance.signOut();

                  Get.offAllNamed(AppPages.INITIAL);
                },
                child: const SignOutWidget(),
              )
            ],
          ),
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: Get.size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 40.r,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => bottomsheet(context),
                              backgroundColor: Colors.white,
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 40.r,
                            child: CircleAvatar(
                              radius: Dimensions.height60,
                              child: Obx(() => ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.containerHeight65),
                                    child:
                                        controller.currentUser?.photoUrl == ''
                                            ? Image.asset(
                                                'assets/images/person1.png',
                                                width: Dimensions.height135,
                                                height: Dimensions.height135,
                                                fit: BoxFit.cover,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: controller
                                                    .currentUser!.photoUrl
                                                    .toString(),
                                                width: Dimensions.height135,
                                                height: Dimensions.height120,
                                                fit: BoxFit.cover,
                                              ),
                                  )),
                            ),
                          ),
                        ),
                      ),

                      Text(
                        controller.currentUser?.name.toString() ?? 'Name',
                        style: TextStyle(
                            fontFamily: 'Poppins-Bold.ttf',
                            fontSize: Dimensions.fontSize22,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        timeago.format(controller.currentUser?.time),
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins-Bold.ttf',
                          fontSize: Dimensions.textsize15,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      //  Text(subadminstrationarea),
                      GestureDetector(
                        onTap: () {
                          Get.offNamed(Paths.setLocation);
                        },
                        child: Container(
                          // width: 160.w,
                          // height: 30.h,
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(12),
                          //     border: Border.all(color:Colors.black.withOpacity(0.5), width: 0.2),
                          //     color: IColor.mainBlueColor.withOpacity(0.1)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(controller.currentUser
                                            ?.subadminstrationarea ==
                                        ''
                                    ? 'Versona'
                                    : controller
                                            .currentUser?.subadminstrationarea
                                            .toString() ??
                                        ''),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(controller.currentUser?.country == ''
                                    ? 'It'
                                    : controller.currentUser?.country
                                            .toString() ??
                                        ''),

                                SizedBox(
                                  width: 6.w,
                                ),
                                // Align(
                                //     alignment: Alignment.centerRight,
                                //     child: Icon(Icons.keyboard_arrow_down_rounded))
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        width: Get.size.width - 30.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: IColor.mainBlueColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(17.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: Dimensions.fontSize20,
                                  left: Dimensions.fontSize20),
                              child: Column(
                                children: [
                                  Obx(() => Text(
                                        controller.currentUser?.score
                                                .toString() ??
                                            '0',
                                        style: TextStyle(
                                            fontSize: Dimensions.fontSize20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                  SizedBox(
                                    height: Dimensions.fontSize20,
                                  ),
                                  const Text(
                                    'Punteggio',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: Dimensions.paddingLeft10,
                                  bottom: Dimensions.paddingLeft10,
                                  left: Dimensions.height30),
                              child: const VerticalDivider(
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: Dimensions.fontSize20,
                                  left: Dimensions.fontsize30),
                              child: Column(
                                children: [
                                  Text(
                                    controller.currentUser?.totalFollowers
                                            .toString() ??
                                        '0',
                                    style: TextStyle(
                                        fontSize: Dimensions.fontSize20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: Dimensions.fontSize20,
                                  ),
                                  const Text(
                                    'Followers totail',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 17.h,
                      ),
                      Container(
                        width: Get.size.width - 30.w,
                        height: Dimensions.height65,
                        decoration: BoxDecoration(
                          color: const Color(0xff7BD85A),
                          borderRadius: BorderRadius.all(
                            Radius.circular(Dimensions.paddingLeft10),
                          ),
                        ),
                        child: InkWell(
                          onTap: () async {
                            String generatedDynamicLink =
                                await CreateDynamicLink.createDynamicLink();
                            Share.share(generatedDynamicLink,
                                subject: 'Share with your Friends');
                          },
                          child: const Center(
                            child: Text(
                              'Condividi il tuo codice invito',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UserProfileSettingBtn(
                          title: "ii mio account",
                          icon: Icons.edit_note_outlined,
                          onpress: () {
                            Get.toNamed(Paths.user_Setting);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      UserProfileSettingBtn(
                          title: Strings.notifiche,
                          icon: Icons.notifications_none_outlined,
                          onpress: () {
                            // Get.toNamed(Paths.userNotification);
                            Get.to(const UserNotification());
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      UserProfileSettingBtn(
                          title: "Archiviazione",
                          icon: Icons.file_copy_outlined,
                          onpress: () {
                            Get.to(Archiviazione(),
                                transition: Transition.fadeIn);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      UserProfileSettingBtn(
                          title: "FAQ",
                          icon: Icons.question_answer_outlined,
                          onpress: () {}),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Future<bool> onbackpress(BuildContext context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('close app'),
            content: const Text('Do want to close app '),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes')),
            ],
          );
        });
    return exitApp ?? false;
  }

  Widget bottomsheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * .2,
      margin: EdgeInsets.symmetric(
          vertical: Dimensions.fontSize20,
          horizontal: Dimensions.paddingLeft10),
      child: Column(
        children: [
          Text(
            "Choose Profile Photo",
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.fontSize20),
          ),
          SizedBox(
            height: Dimensions.height50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: Dimensions.paddingvertical5,
                    ),
                    Text(
                      "Gallery",
                      style: TextStyle(
                          fontSize: Dimensions.fontSize20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )
                  ],
                ),
                onTap: () {
                  print("Gallery");
                  _getFromGallery();
                },
              ),
              SizedBox(
                width: Dimensions.containerwidth180,
              ),
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                    SizedBox(height: Dimensions.paddingvertical5),
                    Text(
                      "Camera",
                      style: TextStyle(
                          fontSize: Dimensions.fontSize20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )
                  ],
                ),
                onTap: () {
                  print("Camera");
                  // takePhoto(ImageSource.camera);
                  //takeFromCamera();
                  _getFromCamera();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: Dimensions.width190,
      maxHeight: Dimensions.height90 * 2,
    );
    if (pickedFile != null) {
      setState(() {
        File? imageFile = File(pickedFile.path);
        uploadImage(imageFile);
      });
    }
    Navigator.pop(context);
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: Dimensions.width190,
      maxHeight: Dimensions.height90 * 2,
    );
    if (pickedFile != null) {
      setState(() {
        File? imageFile = File(pickedFile.path);
        uploadImage(imageFile);
        Navigator.pop(context);
      });
    }
  }
}

uploadImage(File imageVar) async {
  String? imageUrl;

  String uniqueFilename = const Uuid().v1();

  Reference reference = FirebaseStorage.instance.ref();
  Reference referenceRootDir = reference.child('images');
  Reference referenceRootDirToUpload = referenceRootDir.child(uniqueFilename);
  try {
    await referenceRootDirToUpload.putFile(File(imageVar.path));
    await referenceRootDirToUpload
        .getDownloadURL()
        .then((value) => imageUrl = value);
    await firebaseInstance.collection('users').doc(uid).update({
      "photoUrl": imageUrl,
    });

    Get.find<CurrentUserController>().updateModel();
  } catch (e) {
    await firebaseInstance.collection('users').doc(uid).update({
      "photoUrl": '',
    });
    Get.find<CurrentUserController>().updateModel();
    return;
  }
}

class SignOutWidget extends StatelessWidget {
  const SignOutWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: IColor.mainBlueColor,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.all(10),
      child: const Center(
          child: Text(
        'disconnessione',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
    );
  }
}

class UserProfileSettingBtn extends StatelessWidget {
  UserProfileSettingBtn(
      {Key? key, required this.icon, required this.onpress, this.title})
      : super(key: key);
  IconData icon;
  String? title;
  Function() onpress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
          width: Get.size.width - 30.w,
          height: Dimensions.height60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.paddingLeft10),
            border: Border.all(color: Colors.white),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(4.0, 5.0),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 13.w),
                      child: Icon(
                        icon,
                        size: Dimensions.fontsize30,
                        color: const Color.fromARGB(224, 0, 70, 250),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.fontSize20),
                      child: Text(
                        title.toString(),
                        style: TextStyle(
                            fontSize: Dimensions.fontSize18,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: Dimensions.height65),
                child: const InkWell(
                  child: Icon(Icons.arrow_forward_ios,
                      color: Color.fromARGB(224, 0, 70, 250)),
                ),
              ),
            ],
          )),
    );
  }
}

class TextField {
  static textFormField({
    required String lable,
    hintText,
    TextEditingController? controller,
  }) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter your ${lable}';
        }
        return null;
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelStyle: const TextStyle(fontSize: 14, color: Colors.white),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        label: Text(lable),
        hintText: '',
      ),
    );
  }
}
