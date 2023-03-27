import 'dart:developer';

import 'package:get/get.dart';

import 'package:influencer/Modals/user_modal.dart';

import '../../../FirebaseServices/firbase_collection.dart';

 class CurrentUserController extends GetxController {
  Rx<UserModal>? userModal;

  UserModal? get currentUser => userModal?.value;

  @override
  void onInit() {
    userModal = UserModal().obs;

    log('user modal from init data ${userModal?.value}');
    super.onInit();
  }

  updateModel() async {
    final userDocData =
        await firebaseInstance.collection('users').doc(uid).get();
    final udoc = userDocData.data();
    userModal!.value = UserModal.fromJson(udoc!);
    update();
    // void updatedModel() async {
    //   userModal?.refresh();
    //   update();
    // }
  }
}
