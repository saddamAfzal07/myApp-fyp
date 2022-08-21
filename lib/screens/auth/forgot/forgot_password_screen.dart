import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/widget/custom_button.dart';
import 'package:myhoneypott/widget/custom_field.dart';

import '../../../constant/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      /// appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.borderColor,
          ),
        ),
      ),

      /// body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'myhoneypot',
              style: robotoBold.copyWith(
                color: AppColors.primaryColor,
                fontSize: 32.0,
              ),
            ),
          ),

          /// description texts
          SizedBox(height: height * 0.024),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: height * 0.06),
            child: Text(
              'We get it, stuff happens. Just enter your email address below and '
              'we\'ll send you a link to reset your password!',
              textAlign: TextAlign.center,
              style: robotoLight.copyWith(
                fontSize: 16.0,
                color: AppColors.blackSoftColor,
                height: 1.5,
              ),
            ),
          ),

          //// email field
          SizedBox(height: height * 0.032),
          CustomField(
            controller: emailController,
            headingText: 'Email',
            hintText: 'example@example.com',
            flag: 0,
          ),

          /// Reset Password button
          SizedBox(height: height * 0.024),
          CustomButton(
            onTap: () {},
            btnText: 'Reset Password',
          ),
        ],
      ),
    );
  }
}
