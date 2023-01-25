import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/user.dart';
import 'package:myhoneypott/screens/auth/account_created.dart';
import 'package:myhoneypott/screens/bottom_nav_bar.dart';
import 'package:myhoneypott/services/user_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/constant.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();

  void _registerUser() async {
    //ApiResponse response =
    ApiResponse response =
        await register(emailController.text, passwordController.text);

    // print(response);

    if (response.error == null) {
      // print('i should be here because something something');
      // print(User);
      // _saveAndRedirectToHome(response.data as User);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding:
                  const EdgeInsets.only(top: 100, left: 20, right: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: const AccountCreated(),
            );
          });
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Save and redirect to BottomNavBar
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
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
          SizedBox(height: height * 0.016),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Already sign up?',
                    style: robotoLight.copyWith(
                      fontSize: 16.0,
                      color: AppColors.blackSoftColor,
                    ),
                  ),
                  const WidgetSpan(
                    child: SizedBox(width: 6.0),
                  ),
                  TextSpan(
                    text: 'Login here',
                    style: robotoRegular.copyWith(
                      fontSize: 16.0,
                      color: AppColors.primaryColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(const Login()),
                  ),
                ],
              ),
            ),
          ),

          /// email field
          SizedBox(height: height * 0.032),
          Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        val!.isEmpty ? 'Invalid email address' : null,
                    decoration: kInputDecoration('Email'),
                  ),
                ),
                SizedBox(
                  height: height * 0.024,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (val) =>
                          val!.length < 6 ? 'Required at least 6 chars' : null,
                      decoration: kInputDecoration('Password'),
                    )),
                SizedBox(
                  height: height * 0.024,
                ),
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : kTextButton(
                        'Register',
                        () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              loading = !loading;
                              _registerUser();
                            });
                          }
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
