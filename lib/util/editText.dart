import 'package:flutter/material.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/dimension.dart';

class EditText extends StatelessWidget {
  String? hint;
  bool? suggestion;
  bool? autocorrect;
  bool? obscure;
  TextInputType? type;
  FormFieldValidator? formvalidate;
  Widget? icon;
  TextEditingController? controller;
  Widget? suffixIcon;
  EditText(
      {Key? key,
      this.hint,
      this.suggestion,
      this.autocorrect,
      this.obscure,
      this.formvalidate,
      this.icon,
      this.type,
      this.suffixIcon,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.height85,
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: formvalidate,
        cursorColor: const Color(0xff424242),
        obscureText: obscure ?? false,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
            filled: true,
            hintText: hint,
            hintStyle: TextStyle(
              color: IColor.colorblack,
              fontSize: Dimensions.fontSize16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.paddingRight10),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.paddingRight10),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: Dimensions.fontSize18,
                horizontal: Dimensions.border13),
            prefixIcon: icon,
            suffixIcon: suffixIcon,
            // filled: true,
            fillColor: const Color(0xffF2F2F3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.fontSize20),
              gapPadding: 5.0,
            )),
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
