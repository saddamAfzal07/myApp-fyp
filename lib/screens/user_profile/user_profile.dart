import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/user_model.dart';
import 'package:myhoneypott/screens/auth/login.dart';
import 'package:myhoneypott/screens/user_profile/user_profile_update.dart';
import 'package:myhoneypott/services/user_service.dart';
import 'package:myhoneypott/widget/custom_button.dart';

import '../../constant/app_text_styles.dart';
import '../bottom_nav_bar.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  static String name = "";
  static String email = "";
  static String phone = "";
  static int? currencyID;
  static String currency = "";
  String? image;
  bool isLoading = false;

  getUserProfile() async {
    setState(() {
      isLoading = true;
    });
    String token = await UserID.token;
    var response =
        await http.get(Uri.parse("${profileURL}/${UserID.id}"), headers: {
      'Authorization': 'Bearer $token',
    });

    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      Map<String, dynamic> responsedata = jsonDecode(response.body);

      setState(() {
        name = responsedata["member"]["name"];
        email = responsedata["member"]["email"];
        phone = responsedata["member"]["mobile"];
        currencyID = responsedata["member"]["currency_id"];
        image = responsedata["member"]["profile_image"];

        if (currencyID == 17) {
          setState(() {
            currency = "AED";
          });
        } else if (currencyID == 5) {
          setState(() {
            currency = "AUD";
          });
        } else if (currencyID == 6) {
          setState(() {
            currency = "CAD";
          });
        } else if (currencyID == 7) {
          setState(() {
            currency = "CHF";
          });
        } else if (currencyID == 7) {
          setState(() {
            currency = "CNY";
          });
        } else if (currencyID == 2) {
          setState(() {
            currency = "EUR";
          });
        } else if (currencyID == 3) {
          setState(() {
            currency = "GBP";
          });
        } else if (currencyID == 9) {
          setState(() {
            currency = "HKD";
          });
        } else if (currencyID == 12) {
          setState(() {
            currency = "IDR";
          });
        } else if (currencyID == 11) {
          setState(() {
            currency = "INR";
          });
        } else if (currencyID == 4) {
          setState(() {
            currency = "JPY";
          });
        } else if (currencyID == 15) {
          setState(() {
            currency = "KRW";
          });
        } else if (currencyID == 13) {
          setState(() {
            currency = "MYR";
          });
        } else if (currencyID == 10) {
          setState(() {
            currency = "NZD";
          });
        } else if (currencyID == 14) {
          setState(() {
            currency = "SGD";
          });
        } else if (currencyID == 16) {
          setState(() {
            currency = "THB";
          });
        } else if (currencyID == 1) {
          setState(() {
            currency = "USD";
          });
        }
      });
    } else {
      isLoading = true;
      print("not found");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      /// appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 50.0,
        leading: IconButton(
          onPressed: () {
            ///Get.back();
            Get.offAll(const BottomNavBar());
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.borderColor,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  image != null
                      ? CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(image.toString()))
                      : const CircleAvatar(
                          radius: 60.0,
                          backgroundImage:
                              AssetImage("assets/images/user.png")),
                  const SizedBox(height: 12.0),
                  SizedBox(height: height * 0.02),
                  Expanded(
                    child: Container(
                      height: height,
                      width: width,
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.07),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        size: 30,
                                        color: AppColors.primaryColor,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Name      ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        name.toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.email,
                                        size: 30,
                                        color: AppColors.primaryColor,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Email       ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        email.toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.call,
                                        size: 30,
                                        color: AppColors.primaryColor,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Mobile #  ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        phone.toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.currency_exchange_outlined,
                                        size: 24,
                                        color: AppColors.primaryColor,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          " Currency         ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        currency.toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            SizedBox(height: height * 0.044),
                            CustomButton(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateProfileScreen(
                                              passImage: image.toString(),
                                              currency: currency,
                                              email: email,
                                              name: name,
                                              phone: phone,
                                              currencyId: currencyID.toString(),
                                            )));
                              },
                              btnText: 'Edit',
                              btnFontColor: AppColors.whiteColor,
                            ),
                            SizedBox(height: height * 0.024),
                            CustomButton(
                              btnColor: AppColors.greyColor,
                              onTap: () {
                                logout().then((value) => {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login()),
                                          (route) => false)
                                    });
                              },
                              btnText: 'Logout',
                              btnFontColor: AppColors.blackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
