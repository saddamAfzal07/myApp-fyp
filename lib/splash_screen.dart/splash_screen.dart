import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/initial_setup_screen.dart';
import 'package:myhoneypott/screens/auth/login.dart';
import 'package:myhoneypott/screens/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIflLogin();
    // Future.delayed(const Duration(seconds: 3), () {
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => const Login()));
    // });
  }

  bool? newUser;
  late SharedPreferences loginData;
  late String userName;
  late String pass;

  void checkIflLogin() async {
    loginData = await SharedPreferences.getInstance();

    newUser = (loginData.getBool("login") ?? true);
    print("new user $newUser");
    if (newUser == false) {
      print("Enter into dashboard");

      loginData = await SharedPreferences.getInstance();
      setState(() {
        userName = loginData.getString("username").toString();
        pass = loginData.getString("password").toString();
      });
      login(
        userName,
        pass,
      );
    } else {
      print("Enter into login");

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      });
    }
  }

  String? initialSetup = "1";
  void login(email, password) async {
    final response = await http
        .post(Uri.parse("https://www.myhoneypot.app/api/login"), headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8'
    }, body: {
      'email': email,
      'password': password,
    });

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
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'M Y H O N E Y P O T',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            if (Platform.isIOS)
              const CupertinoActivityIndicator(
                radius: 20,
                color: AppColors.whiteColor,
              )
            else
              const CircularProgressIndicator(
                color: AppColors.whiteColor,
              )
          ],
        ),
      ),
    );
  }
}
