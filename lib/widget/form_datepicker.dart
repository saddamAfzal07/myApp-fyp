import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';


class FormDatepicker extends StatelessWidget {
  const FormDatepicker({
    Key? key,
    required TextEditingController expenseDate,
    required this.hintText,
  })  : _expenseDate = expenseDate,
        super(key: key);

  final TextEditingController _expenseDate;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _expenseDate,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      cursorColor: AppColors.primaryColor,
      style: const TextStyle(color: AppColors.blackColor),
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.greyDarkColor,
            width: 1.0,
          ),
        ),
        hintText: 'Select date',
        hintStyle: const TextStyle(fontSize: 14),
        suffixIcon: const Icon(
          Icons.calendar_today,
          size: 17.0,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
