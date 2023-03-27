import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/Controllers/auth_controller.dart/auth_controller.dart';
import 'package:influencer/FirebaseServices/firbase_collection.dart';
import 'package:influencer/admin_module/auth/forgor_password/component/forgot_appbar.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/commonText.dart';
import 'package:influencer/util/commonbutton.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/string.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../util/LoadingWidget.dart';

class ForgotPassword extends StatelessWidget {
  final controller = Get.find<AuthController>();

  // TextEditingController countryCode = TextEditingController();
  @override

  // Country country=
  String countryValue = "";

  String stateValue = "";

  String cityValue = "";

  String address = "";

  GlobalKey<FormState> _formKey = GlobalKey();

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: GetBuilder<AuthController>(builder: (controller) {
        return SafeArea(
          child: Scaffold(
              body: Form(
            key: _key,
            child: Align(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ForgotAppBar(),
                  Spacer(),
                  CommonText(
                    title: Strings.mail_address,
                    color: IColor.colorblack,
                    size: Dimensions.fontSize22,
                    fontWeight: FontWeight.w800,
                  ),
                  SizedBox(
                    height: Dimensions.height65,
                  ),
                  CommonText(
                    title: Strings.enter_email_address,
                    color: IColor.colorblack,
                    size: Dimensions.fontSize18,
                    fontWeight: FontWeight.w400,
                  ),
                  CommonText(
                    title: Strings.with_your_account,
                    color: IColor.colorblack,
                    size: Dimensions.fontSize18,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: Dimensions.fontSize18,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.border13),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: Get.size.width - 27,
                            child: TextFormField(
                              cursorColor: Color(0xff424242),
                              enableSuggestions: false,
                              controller: controller.fogetEmailController,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              decoration: InputDecoration(
                                  labelText: Strings.email,
                                  labelStyle: TextStyle(
                                    color: IColor.colorblack,
                                    fontSize: Dimensions.fontSize14,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.fontSize12),
                                    borderSide: BorderSide(
                                      color: IColor.colorWhite,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: IColor.mainBlueColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: Dimensions.fontSize18,
                                      horizontal: Dimensions.border13),

                                  // filled: true,
                                  fillColor: const Color(0xffF2F2F3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.fontSize20),
                                    gapPadding: 5.0,
                                  )),
                              style: const TextStyle(
                                  color: IColor.colorblack,
                                  fontFamily: 'productsan'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.size.height * 0.04,
                  ),
                  controller.isLoading == true
                      ? const LoaderWidget()
                      : Padding(
                          padding:
                              EdgeInsets.only(bottom: Dimensions.fontSize22),
                          child: CommonButton(
                              title: "Recover Password",
                              onpress: () async {
                                controller.forgetPassword(context);
                                //  Get.toNamed(Paths.verifyConfirmation);
                              }),
                        ),
                  Spacer(),
                ],
              ),
            ),
          )),
        );
      }),
    );
  }
}
