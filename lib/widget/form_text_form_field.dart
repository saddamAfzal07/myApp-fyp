import 'package:flutter/material.dart';

import 'package:myhoneypott/constant/app_colors.dart';

class FormTextFormField extends StatelessWidget {
  const FormTextFormField({
    Key? key,
    required this.validationText,
    required this.hintText,
  }) : super(key: key);

  final String validationText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationText;
        }
        return null;
      },
      cursorColor: Colors.black26,
      style: const TextStyle(
        color: AppColors.blackColor,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        fillColor: AppColors.primaryColor,
        filled: false,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.greyDarkColor,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
