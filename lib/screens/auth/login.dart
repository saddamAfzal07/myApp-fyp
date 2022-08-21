import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/user.dart';
import 'package:myhoneypott/screens/auth/forgot/forgot_password_screen.dart';
import 'package:myhoneypott/screens/bottom_nav_bar.dart';
import 'package:myhoneypott/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/app_colors.dart';
import '../../constant/constant.dart';
import 'signup_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController txtEmail = TextEditingController(),
      txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response =
        await login(context, txtEmail.text, txtPassword.text);

    if (response.error == null) {
      _saveAndRedirectToBottomNavBar(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToBottomNavBar(User user) async {
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
      backgroundColor: Colors.white,
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
          SizedBox(height: height * 0.032),
          Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: txtEmail,
                      validator: (val) =>
                          val!.isEmpty ? 'Invalid email address' : null,
                      decoration: kInputDecoration('Email')),
                ),
                SizedBox(
                  height: height * 0.024,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: txtPassword,
                      obscureText: true,
                      validator: (val) =>
                          val!.length < 6 ? 'Required at least 6 chars' : null,
                      decoration: kInputDecoration('Password'),
                    )),
                SizedBox(
                  height: height * 0.024,
                ),
                loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : kTextButton('Login', () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                            _loginUser();
                          });
                        }
                      }),

                /// forgot password and crate an account button
                SizedBox(height: height * 0.008),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.to(const ForgotPasswordScreen());
                        },
                        child: Text(
                          'Forgot Password?',
                          style: robotoRegular.copyWith(
                            fontSize: 14.0,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(const SignupScreen());
                        },
                        child: Text(
                          'Create an account',
                          style: robotoRegular.copyWith(
                            fontSize: 14.0,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
