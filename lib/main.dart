import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:influencer/FirebaseMessage/single_chat_history_controller.dart';
import 'package:influencer/FirebaseServices/dynamic_link.dart';
import 'package:influencer/Firebase_notification/notification_services.dart';
import 'package:influencer/admin_module/btm_nav_profile/model/profiel_model.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_chat_controller.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/routes/app_routes.dart';
import 'package:influencer/userModule/user_contactti/view/contactlsit.dart';

Future<void> background(RemoteMessage remotevent) async {
  if (remotevent.notification != null) {
    log('Notification body from outside of App: ${remotevent.notification!.body}');
    log('Notification title from outside of App: ${remotevent.notification!.title}');
  }
}
 final controller= Get.put(CurrentUserController());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationServices.initialize();
controller.currentUser?.messageNotification == true
      ? FirebaseMessaging.onBackgroundMessage(background)
      : null;
  await CreateDynamicLink.initDynamicLinks();

  runApp(Influencer());
  Get.put(CurrentUserController());
  Get.put(MessageController());
  Get.put(AdminGroupChatController);
}

class Influencer extends StatefulWidget {
  Influencer({Key? key}) : super(key: key);

  @override
  State<Influencer> createState() => _InfluencerState();
}

class _InfluencerState extends State<Influencer> {
  final controller = Get.find<CurrentUserController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (controller.currentUser?.messageNotification == true) {

      FirebaseMessaging.instance.getInitialMessage().then((event) {
        if (event != null) {
          final routefromNotification = event.data['route'];
          log('Notification route data when app is Closed:  ${routefromNotification}');
        }
      });

      // forground work

      FirebaseMessaging.onMessage.listen((message) {
        if (message != null) {
          LocalNotificationServices.display(message);
        }
      });

      // when app is in bacground but not closed

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        final routefromNotification = event.data['route'];
        // Navigator.pushNamed(context, routefromNotification);

        log('Notification route data when app is minimized:  ${routefromNotification}');
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Poppins'),
          title: 'Influencer',
          initialRoute: AppPages.INITIAL,
          // // initialRoute: Paths.fireBaseUsersView,
          getPages: AppPages.routes,

          // home: UserSideContactList(),
        );
      },
    );
  }
}
