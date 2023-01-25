import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:myhoneypott/models/savings/savings_model.dart';
import 'package:myhoneypott/screens/savings/model.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/savings/savings_model.dart';
import 'package:myhoneypott/screens/dashboard/dialogs/savings_dialoge.dart';
import 'package:myhoneypott/screens/savings/bar_chart.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({Key? key}) : super(key: key);

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  List<MonthlySavings> monthlySavings = [];
  String saving = "";
  String goals = "";
  String balance = "";
  String symbol = "";

  monthlySaving() async {
    String token = UserID.token;
    print(UserID.token);
    var response = await http.get(
      Uri.parse("https://www.myhoneypot.app/api/savings"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      var responsedata = jsonDecode(response.body);
      setState(() {
        saving = responsedata["savings"].toString();
        goals = responsedata["goals"].toString();
        balance = responsedata["balance"].toString();
        symbol = responsedata["symbol"]["symbol"].toString();
      });

      for (int i = 0; i < responsedata["monthlySavings"].length; i++) {
        Map obj = responsedata["monthlySavings"][i];
        MonthlySavings pos = MonthlySavings(
            colorValue: charts.ColorUtil.fromDartColor(AppColors.primaryColor));
        pos = MonthlySavings.fromJson(obj);
        monthlySavings.add(pos);
      }

      print(monthlySavings);
    } else {
      print("not found");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    monthlySaving();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(builder: (c) => const BottomNavBar()),
              //     (route) => false);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.borderColor,
            ),
          ),
        ),
        body: Container(
          height: height,
          // width: width,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0.sp),
              topLeft: Radius.circular(20.0.sp),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.020),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Savings",
                        style: robotoBold.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: 16.0.sp,
                        ),
                      ),
                      Container(
                        height: height * 0.050,
                        width: width * 0.250,
                        decoration: const BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: InkWell(
                          onTap: () {
                            // selectDate(context);
                            showDialog(
                                // barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Dialog(
                                      // insetPadding: EdgeInsets.only(
                                      //     top: 100.sp,
                                      //     left: 16.0.sp,
                                      //     right: 16.0.sp,
                                      //     bottom: 50.0.sp),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0.sp)), //this right here
                                      child: const SavingsDialog(),
                                    ),
                                  );
                                });
                          },
                          child: Icon(
                            LucideIcons.trophy,
                            color: AppColors.blackColor,
                            size: 20.0.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                SizedBox(
                  width: width * 0.95,
                  height: height * 0.40,
                  child: BarChartScreen(
                    savebarChart: monthlySavings,
                  ),
                ),
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: height * 0.020,
                            right: height * 0.020,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Savings',
                                style: robotoMedium.copyWith(
                                    fontSize: 12.0.sp,
                                    color: AppColors.blackSoftColor),
                              ),
                              Text(
                                '$symbol $saving.00',
                                style: robotoSemiBold.copyWith(
                                  fontSize: 12.0.sp,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: height * 0.020,
                            right: height * 0.020,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Goals',
                                style: robotoMedium.copyWith(
                                    fontSize: 12.0.sp,
                                    color: AppColors.blackSoftColor),
                              ),
                              Text(
                                '$symbol $goals.00',
                                style: robotoBold.copyWith(
                                  fontSize: 12.0.sp,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        Column(
                          children: [
                            const Divider(
                              height: 6,
                              color: AppColors.greyColor,
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: height * 0.020,
                                      right: height * 0.020,
                                      top: height * 0.010),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Balance',
                                        style: robotoMedium.copyWith(
                                            fontSize: 12.0.sp,
                                            color: AppColors.blackSoftColor),
                                      ),
                                      Text(
                                        '$symbol $balance.00',
                                        style: robotoBold.copyWith(
                                          fontSize: 12.0.sp,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: monthlySavings.length,
                                  itemBuilder: ((context, index) {
                                    return monthlySavings[index].total! > 0
                                        ? Container(
                                            height: height * 0.12,
                                            margin: EdgeInsets.only(
                                              left: height * 0.010,
                                              right: height * 0.015,
                                            ),
                                            width: width,
                                            decoration: const BoxDecoration(
                                              color: AppColors.whiteColor,
                                              // borderRadius: BorderRadius.all(
                                              //   Radius.circular(7.0.sp),
                                              // ),
                                              // border: Border.all(
                                              //   color: AppColors.borderColor,
                                              //   width: 1.0,
                                              // ),
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: AppColors.borderColor,
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                height * 0.005),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5.0.sp,
                                                                  right: 10),
                                                          child: CircleAvatar(
                                                            radius: 30,
                                                            backgroundColor:
                                                                AppColors
                                                                    .greyDarkColor,
                                                            child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(1.0
                                                                            .sp),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 70,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child: Icon(
                                                                    LucideIcons
                                                                        .piggyBank,
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                    size: 20.sp,
                                                                  ),
                                                                  //
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${monthlySavings[index].month} 2022",
                                                          style: robotoBold
                                                              .copyWith(
                                                            fontSize: 12.0.sp,
                                                            color: AppColors
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          "$symbol ${monthlySavings[index].total}",
                                                          style: robotoRegular
                                                              .copyWith(
                                                            fontSize: 12.0.sp,
                                                            color: AppColors
                                                                .blackSoftColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container();
                                  }),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: height * 0.016),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
