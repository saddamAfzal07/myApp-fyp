import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/screens/auth/login.dart';
import 'package:myhoneypott/screens/dashboard/dialogs/budget_dialog.dart';
import 'package:myhoneypott/services/user_service.dart';

import '../constant/app_colors.dart';
import '../screens/bottom_nav_bar.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.08),
          Center(
            child: Text(
              'myhoneypot',
              style: robotoBold.copyWith(
                color: AppColors.primaryColor,
                fontSize: 32.0,
              ),
            ),
          ),
          SizedBox(height: height * 0.05),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              'ANALYTICS',
              style: robotoSemiBold.copyWith(
                fontSize: 12.0,
                color: AppColors.greyDarkColor,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.offAll(const BottomNavBar());
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 10.0, bottom: 10.0, right: 24.0),
              child: Text(
                'Dashboard',
                style: robotoLight.copyWith(
                  fontSize: 15.0,
                  color: AppColors.blackSoftColor,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.dialog(
                const BudgetDialog(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 10.0, bottom: 10.0, right: 24.0),
              child: Text(
                'Budget',
                style: robotoLight.copyWith(
                  fontSize: 15.0,
                  color: AppColors.blackSoftColor,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              logout().then((value) => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const Login()),
                        (route) => false)
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 10.0, bottom: 10.0, right: 24.0),
              child: Text(
                'Logout',
                style: robotoLight.copyWith(
                  fontSize: 15.0,
                  color: AppColors.blackSoftColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
