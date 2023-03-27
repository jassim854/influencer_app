import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/FirebaseServices/firebase_auth.dart';
import 'package:influencer/Modals/user_body_modal.dart';
import 'package:influencer/Modals/user_modal.dart';

import '../../FirebaseServices/firbase_collection.dart';

class AuthController extends GetxController {
  bool isLoading = false;
  bool obsecureVar = false;
  bool obsecureSignUpVar = false;
  AuthProvider authProvider = AuthProvider();
  // UserModelBody user = UserModelBody();
  late TextEditingController emailLoginController;
  late TextEditingController passwordLoginController;
  late TextEditingController nameController;
  late TextEditingController surNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmController;
  late TextEditingController fogetEmailController;
  @override
  void onInit() {
    emailLoginController = TextEditingController();
    passwordLoginController = TextEditingController();
    nameController = TextEditingController();
    surNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmController = TextEditingController();
    fogetEmailController = TextEditingController();

    super.onInit();
  }

  Future forgetPassword(context) async {
    isLoading = true;

    update();
    FocusScope.of(context).unfocus();

    try {
      await firebaseAuth.sendPasswordResetEmail(
        email: fogetEmailController.text.trim(),
      );

      isLoading = false;

      update();
      Get.snackbar('',
          'Password Reset Email Sent Has been sent to"${fogetEmailController.text.trim()}"');
      fogetEmailController.clear();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('', e.message.toString());
      
      isLoading = false;

      update();
    }
    isLoading = false;

    update();
  }

  changeObsecureValue() {
    obsecureVar = !obsecureVar;
    update();
  }

  changeObsecureSignUpValue() {
    obsecureSignUpVar = !obsecureSignUpVar;
    update();
  }

  createUser() async {
    isLoading = true;

    update();

    await authProvider.registerFireBaseUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        phone: phoneController.text,
        surname: surNameController.text);

    isLoading = false;
    update();
  }

  // login user

  Future signInUser() async {
    isLoading = true;
    update();
    final data = await authProvider.signInFireBaseUser(
      email: emailLoginController.text,
      password: passwordLoginController.text,
    );
    log('user controller data ${data!.uid}');
    isLoading = false;
    update();
  }
}
