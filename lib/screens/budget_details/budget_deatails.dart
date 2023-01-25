// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/budget_categories/need_category.dart';
import 'package:myhoneypott/models/budget_categories/savings_categories.dart';
import 'package:myhoneypott/models/budget_categories/want_category.dart';
import 'package:myhoneypott/screens/budget_details/custom_progress.dart';
import 'package:myhoneypott/screens/budget_details/custom_pie_chart.dart';
import 'package:myhoneypott/screens/budget_details/edit_budget.dart';
import 'package:myhoneypott/screens/budget_details/need_smart_budget.dart';
import 'package:myhoneypott/screens/budget_details/want_smart_budget.dart';

import '../../constant/app_colors.dart';
import 'package:http/http.dart' as http;

class BudgetGraphs extends StatefulWidget {
  String id;
  String date;
  BudgetGraphs({Key? key, required this.id, required this.date})
      : super(key: key);

  @override
  State<BudgetGraphs> createState() => _BudgetGraphsState();
}

class _BudgetGraphsState extends State<BudgetGraphs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    budgetDetails();
  }

  bool isLoading = false;
  int balance = 0;
  int income = 0;
  int expenses = 0;
  String symbol = "RM";
  String needPercentage = "";
  String wantPercentage = "";
  String savingPercentage = "";
  List<NeedCategories> needs = [];
  List<WantCategories> wants = [];
  List<SavingsCategories> saving = [];
  bool error = false;
  budgetDetails() async {
    setState(() {
      isLoading = true;
    });
    String token = await UserID.token;
    var response = await http.get(
        Uri.parse("https://www.myhoneypot.app/api/smart-budget/${widget.id}"),
        headers: {
          'Authorization': 'Bearer $token',
        });

    // print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> responsedata = jsonDecode(response.body);
      setState(() {
        isLoading = false;

        expenses = responsedata["totalExpenses"];
        balance = responsedata["totalBalance"];
        income = responsedata["totalIncome"];
        symbol = responsedata["symbol"]["symbol"];
        needPercentage = responsedata["needsPercentage"].toString();
        wantPercentage = responsedata["wantsPercentage"].toString();
        savingPercentage = responsedata["savingsPercentage"].toString();
      });
      print(needPercentage.runtimeType);
      print(wantPercentage.runtimeType);
      print(savingPercentage.runtimeType);

      for (int i = 0; i < responsedata["needCategories"].length; i++) {
        Map obj = responsedata["needCategories"][i];
        NeedCategories pos = NeedCategories();
        pos = NeedCategories.fromJson(obj);
        needs.add(pos);
      }
      for (int i = 0; i < responsedata["wantCategories"].length; i++) {
        Map obj = responsedata["wantCategories"][i];
        WantCategories pos = WantCategories();
        pos = WantCategories.fromJson(obj);
        wants.add(pos);
      }
      for (int i = 0; i < responsedata["savingsCategories"].length; i++) {
        Map obj = responsedata["savingsCategories"][i];
        SavingsCategories pos = SavingsCategories();
        pos = SavingsCategories.fromJson(obj);
        saving.add(pos);
      }
      // print("=====>>>>>>>");
      // print(incomeAllmonths);

    } else if (response.statusCode == 400) {
      print("not found");
      setState(() {
        isLoading = false;
        error = true;
      });
    } else {
      print("not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0.0,
        toolbarHeight: 60.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.borderColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          SizedBox(width: 16.0),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error
              ? Center(
                  child: Image.asset(
                    "assets/images/notfound.png",
                    height: 120,
                    width: 120,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 23,
                        top: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Budget Details",
                            style: robotoSemiBold.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          Container(
                            height: 35,
                            width: 80,
                            decoration: const BoxDecoration(
                                // color: AppColors.yellowColor,
                                color: Colors.yellow,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditBudget(
                                      income: income,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(
                                // LucideIcons.pencil,
                                Icons.edit,
                                color: AppColors.blackColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    SizedBox(
                      height: 200,
                      width: width,
                      child: Stack(
                        // clipBehavior: Clip.antiAliasWithSaveLayer,
                        // overflow: Overflow.visible,

                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.only(top: 40),
                              height: 200,
                              width: 350,
                              decoration: BoxDecoration(
                                  // color: AppColors.yellowColor,
                                  // color: Colors.yellow,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  border: Border.all(color: Colors.grey)),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: height * 0.014),
                                  child: Column(children: [
                                    Text(
                                      'Total Balance',
                                      style: robotoRegular.copyWith(
                                        fontSize: 13.0,
                                        color: AppColors.greyColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text.rich(TextSpan(children: [
                                      TextSpan(
                                        text: symbol,
                                        style: robotoBold.copyWith(
                                            fontSize: 32.0,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: balance.toString(),
                                        style: robotoBold.copyWith(
                                            fontSize: 32.0,
                                            color: Colors.black),
                                      )
                                    ])),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Income',
                                                  style: robotoRegular.copyWith(
                                                    fontSize: 13.0,
                                                    color: AppColors.greyColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  '${symbol} ${income}',
                                                  style: robotoBold.copyWith(
                                                      fontSize: 20.0,
                                                      color: Colors.black
                                                      // color: AppColors.whiteColor,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Expenses',
                                                  style: robotoRegular.copyWith(
                                                    fontSize: 13.0,
                                                    color: AppColors.greyColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  '${symbol} ${int.parse(income.toString()) + int.parse(balance.toString())}',
                                                  style: robotoBold.copyWith(
                                                    fontSize: 20.0,
                                                    // color: AppColors.whiteColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])),
                            ),
                          ),
                          Positioned(
                            bottom: 150,
                            right: 0,
                            left: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 100,
                              backgroundColor: AppColors.primaryColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.date.substring(0, 3),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.date.substring(4, 8),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              // height: height,
                              // width: width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /// needs wants savings graph
                                  SizedBox(height: height * 0.03),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: height * 0.024),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        /// needs chart
                                        Column(
                                          children: [
                                            needPercentage == "0"
                                                ? Text(
                                                    'Needs (0%)',
                                                    style:
                                                        robotoSemiBold.copyWith(
                                                            fontSize: 14.0,
                                                            color: AppColors
                                                                .blackSoftColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  )
                                                : Text(
                                                    'Needs (${needPercentage.substring(0, 2).replaceAll(".", "")}%)',
                                                    style:
                                                        robotoSemiBold.copyWith(
                                                            fontSize: 14.0,
                                                            color: AppColors
                                                                .blackSoftColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                            const SizedBox(height: 8.0),
                                            CustomPieChart1(
                                                percentage: double.parse(
                                                    needPercentage)),
                                          ],
                                        ),

                                        /// wants chart
                                        Expanded(
                                          child: Column(
                                            children: [
                                              wantPercentage == "0"
                                                  ? Text(
                                                      'Wants (0%)',
                                                      style: robotoSemiBold
                                                          .copyWith(
                                                              fontSize: 14.0,
                                                              color: AppColors
                                                                  .blackSoftColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    )
                                                  : Text(
                                                      'Wants (${wantPercentage.substring(0, 2).replaceAll(".", "")}%)',
                                                      style: robotoSemiBold
                                                          .copyWith(
                                                              fontSize: 14.0,
                                                              color: AppColors
                                                                  .blackSoftColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                              const SizedBox(height: 8.0),
                                              CustomPieChart1(
                                                  percentage: double.parse(
                                                wantPercentage,
                                              )),
                                            ],
                                          ),
                                        ),

                                        /// savings chart
                                        Expanded(
                                          child: Column(
                                            children: [
                                              savingPercentage == "0"
                                                  ? Text(
                                                      'Savings (0%)',
                                                      style: robotoSemiBold
                                                          .copyWith(
                                                              fontSize: 14.0,
                                                              color: AppColors
                                                                  .blackSoftColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    )
                                                  : Text(
                                                      'Savings (${savingPercentage.substring(0, 2).replaceAll(".", "")}%)',
                                                      style: robotoSemiBold
                                                          .copyWith(
                                                              fontSize: 14.0,
                                                              color: AppColors
                                                                  .blackSoftColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                              const SizedBox(height: 8.0),
                                              CustomPieChart1(
                                                  percentage: double.parse(
                                                wantPercentage,
                                              )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// needs chart data
                                  SizedBox(height: height * 0.036),
                                  needs.isEmpty
                                      ? Text("")
                                      : needChartDate(height, width),

                                  /// wants chart data
                                  SizedBox(height: height * 0.036),
                                  wants.isEmpty
                                      ? Text("")
                                      : wantsChartDate(height, width),

                                  /// savings chart data
                                  SizedBox(height: height * 0.036),
                                  saving.isEmpty
                                      ? Text("")
                                      : savingsChartDate(height, width),

                                  SizedBox(height: height * 0.1),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
    );
  }

  Widget needChartDate(height, width) => Padding(
        padding: EdgeInsets.symmetric(horizontal: height * 0.032),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  needPercentage == "0"
                      ? Text(
                          'Needs (0%)',
                          style: robotoSemiBold.copyWith(
                            color: AppColors.blackSoftColor,
                            fontSize: 18.0,
                          ),
                        )
                      : Text(
                          'Needs (${needPercentage.substring(0, 2).replaceAll(".", "")}%)',
                          style: robotoSemiBold.copyWith(
                            color: AppColors.blackSoftColor,
                            fontSize: 18.0,
                          ),
                        ),
                  Container(
                    height: 35,
                    width: 80,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 252, 211, 76),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: InkWell(
                      onTap: () {
                        print(income);
                        print(needPercentage.substring(0, 4));
                        print(double.parse(needPercentage.substring(0, 4)) /
                            100 *
                            income);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NeedEditSmartBudget(
                              id: widget.id,
                              need:
                                  double.parse(needPercentage.substring(0, 4)) /
                                      100 *
                                      income,
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        // LucideIcons.pencil,
                        Icons.edit,
                        color: AppColors.blackColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: needs.length,
              itemBuilder: ((context, index) {
                return CustomProgressBar(
                    text: needs[index].description,
                    percentText: needs[index].percentage.toString(),
                    progressBarWidth: needs[index].assigned!.toDouble());
              }),
            )
          ],
        ),
      );

  Widget wantsChartDate(height, width) => Padding(
        padding: EdgeInsets.symmetric(horizontal: height * 0.032),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  wantPercentage == "0"
                      ? Text(
                          'Wants (0%)',
                          style: robotoSemiBold.copyWith(
                            color: AppColors.blackSoftColor,
                            fontSize: 18.0,
                          ),
                        )
                      : Text(
                          'Wants (${wantPercentage.substring(0, 2).replaceAll(".", "")}%)',
                          style: robotoSemiBold.copyWith(
                            color: AppColors.blackSoftColor,
                            fontSize: 18.0,
                          ),
                        ),
                  Container(
                    height: 35,
                    width: 80,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 252, 211, 76),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: InkWell(
                      onTap: () {
                        print("wants id ${widget.id}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WantsEditSmartBudget(
                              id: widget.id,
                              want:
                                  double.parse(wantPercentage.substring(0, 4)) /
                                      100 *
                                      income,
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        // LucideIcons.pencil,
                        Icons.edit,
                        color: AppColors.blackColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: wants.length,
              itemBuilder: ((context, index) {
                return CustomProgressBar(
                    text: wants[index].description,
                    percentText: wants[index].percentage.toString(),
                    progressBarWidth: wants[index].assigned!.toDouble());
              }),
            )
          ],
        ),
      );

  Widget savingsChartDate(height, width) => Padding(
        padding: EdgeInsets.symmetric(horizontal: height * 0.032),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  savingPercentage == "0"
                      ? Text(
                          'Savings (0%)',
                          style: robotoSemiBold.copyWith(
                            color: AppColors.blackSoftColor,
                            fontSize: 18.0,
                          ),
                        )
                      : Text(
                          'Savings (${savingPercentage.substring(0, 2).replaceAll(".", "")}%)',
                          style: robotoSemiBold.copyWith(
                            color: AppColors.blackSoftColor,
                            fontSize: 18.0,
                          ),
                        ),
                  // Container(
                  //   height: 35,
                  //   width: 80,
                  //   decoration: const BoxDecoration(
                  //       color: Color.fromARGB(255, 252, 211, 76),
                  //       borderRadius: BorderRadius.all(Radius.circular(5))),
                  //   child: InkWell(
                  //     onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => EditSmartBudget(
                  //       id: widget.id,
                  //       need: (int.parse(needPercentage) / 100) * income,
                  //     ),
                  //   ),
                  // );
                  //     },
                  //     child: const Icon(
                  //       // LucideIcons.pencil,
                  //       Icons.edit,
                  //       color: AppColors.blackColor,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: saving.length,
              itemBuilder: ((context, index) {
                return CustomProgressBar(
                    text: saving[index].description,
                    percentText: saving[index].percentage.toString(),
                    progressBarWidth: saving[index].assigned!.toDouble());
              }),
            )
          ],
        ),
      );
}
