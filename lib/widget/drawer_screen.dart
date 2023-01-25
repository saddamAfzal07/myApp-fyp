import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/controller/theme_changer.dart';
import 'package:myhoneypott/screens/auth/login.dart';
import 'package:myhoneypott/screens/dashboard/dialogs/budget_dialog.dart';
import 'package:myhoneypott/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/app_colors.dart';
import '../screens/bottom_nav_bar.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final state = Provider.of<ThemeChanger>(context);

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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dark Mode"),
                FlutterSwitch(
                  height: 27.0,
                  width: 55.0,
                  padding: 5.0,
                  toggleSize: 20.0,
                  borderRadius: 15.0,
                  activeColor: AppColors.primaryColor,
                  value: state.radiovalue,
                  onToggle: (value) {
                    // setState(() {
                    state.radiovalue = value;
                    state.checkTheme(value);
                    // });
                  },
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("login", true);
              logout().then((value) => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const Login()),
                        (route) => false)
                  });

              print("ggggg$prefs");
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
