import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/screens/auth/login.dart';
import 'package:myhoneypott/screens/bottom_nav_bar.dart';
import 'package:myhoneypott/widget/custom_button.dart';

class ErrorAccountdialogue extends StatefulWidget {
  String title;
  String message;
  ErrorAccountdialogue({Key? key, required this.title, required this.message})
      : super(key: key);

  @override
  State<ErrorAccountdialogue> createState() => _ErrorAccountdialogueState();
}

class _ErrorAccountdialogueState extends State<ErrorAccountdialogue> {
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("start dialoge");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: AppColors.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.greyColor,
              ),
            ),
          ),
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.greyDarkColor,
            child: Container(
                padding: const EdgeInsets.all(1),
                child: const CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.close,
                    color: AppColors.primaryColor,
                    size: 40,
                  ),
                  //
                )),
          ),
          const SizedBox(height: 10.0),
          Text(
            widget.title,
            style: robotoSemiBold.copyWith(
              fontSize: 20.0,
              color: AppColors.blackSoftColor,
            ),
          ),
          const SizedBox(height: 3.0),
          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: robotoLight.copyWith(
              fontSize: 14.0,
              color: AppColors.greyDarkColor,
            ),
          ),
          const SizedBox(height: 16.0),
          loading
              ? const Center(child: CircularProgressIndicator())
              : CustomButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  btnText: 'ok',
                  btnPadding: const EdgeInsets.only(right: 16.0),
                )
        ],
      ),
    );
  }
}
