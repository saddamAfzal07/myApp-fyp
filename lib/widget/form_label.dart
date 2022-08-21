import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';

class FormLabel extends StatelessWidget {
  const FormLabel({Key? key, required this.labelText}) : super(key: key);

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        labelText,
        style: const TextStyle(fontSize: 13.0, color: AppColors.blackColor),
        textAlign: TextAlign.left,
      ),
    );
  }
}
