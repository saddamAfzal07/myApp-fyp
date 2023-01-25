import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/initial_setup_screen.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/user.dart';
import 'package:myhoneypott/screens/auth/forgot/forgot_password_screen.dart';
import 'package:myhoneypott/screens/bottom_nav_bar.dart';
import 'package:myhoneypott/screens/logindialogues/error_dialouge.dart';
import 'package:myhoneypott/screens/logindialogues/login_dialogue.dart';
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
  SharedPreferences? loginData;
  String? initialSetup = "1";
  void login(email, password) async {
    loginData = await SharedPreferences.getInstance();
    print("call api");
    print(email + password);
    final response = await http
        .post(Uri.parse("https://www.myhoneypot.app/api/login"), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8'
    }, body: {
      'email': email,
      'password': password,
    });

    setState(() {
      loading = false;
    });
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print("response===>>>>" + response.body);

      UserID.id = responseData["member"]["id"].toString();
      UserID.token = responseData["token"].toString();

      initialSetup = responseData["member"]["initial_setup"].toString();
      print("initial Setup" + initialSetup.toString());

      if (initialSetup == "0") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const InitialSetupScreen()),
            (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false);
      }

      loginData!.setBool("login", false);
      loginData!.setString("username", email);
      loginData!.setString("password", password);
    } else if (response.statusCode == 422) {
      print(response.statusCode);
      Map<String, dynamic> responsedata = jsonDecode(response.body);

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding:
                  const EdgeInsets.only(top: 100, left: 20, right: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: ErrorAccountdialogue(
                  title: responsedata["title"],
                  message: responsedata["message"]),
            );
          });
    } else if (response.statusCode == 403) {
      print(response.statusCode);
      Map<String, dynamic> responsedata = jsonDecode(response.body);

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding:
                  const EdgeInsets.only(top: 100, left: 20, right: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: ErrorAccountdialogue(
                title: responsedata["title"],
                message: responsedata["message"],
              ),
            );
          });
    } else {
      // _saveAndRedirectToBottomNavBar(response as User);
      print("Else Condition");
      Map<String, dynamic> responsedata = jsonDecode(response.body);
      print(responsedata["title"]);
      print(responsedata["message"]);
      print(response.statusCode);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.only(top: 100, left: 20, right: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: ErrorAccountdialogue(
              title: responsedata["title"] == null
                  ? "Error"
                  : responsedata["title"],
              message: responsedata["message"] == null
                  ? "Something went wrong"
                  : responsedata["message"],
            ),
          );
        },
      );
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
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
                            login(txtEmail.text, txtPassword.text);
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
