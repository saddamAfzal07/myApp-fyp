import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/feedback/feedback_screen.dart';
import 'package:myhoneypott/models/transaction/expense_transaction.dart';
import 'package:myhoneypott/screens/custom_chart_data.dart';
import 'package:myhoneypott/screens/logindialogues/error_dialouge.dart';
import 'package:myhoneypott/screens/new_dashboard/add_goal_screen.dart';
import 'package:myhoneypott/screens/new_dashboard/dashboard_model.dart';
import 'package:myhoneypott/screens/new_dashboard/edit_goal.dart';
import 'package:myhoneypott/screens/savings/savings_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as client;

class NewDashBoardScreen extends StatefulWidget {
  const NewDashBoardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NewDashBoardScreen> createState() => _NewDashBoardScreenState();
}

class _NewDashBoardScreenState extends State<NewDashBoardScreen> {
  DateTime now = DateTime.now();
  List<Goals> goals = [];
  bool isLoading = false;
  String symbol = "RM";
  String name = "";

  Future<void> goalsApi() async {
    isLoading = true;
    goals = [];
    String token = UserID.token;
    var response = await http
        .get(Uri.parse("https://www.myhoneypot.app/api/dashboard"), headers: {
      'Authorization': 'Bearer $token',
    });
    Map data = jsonDecode(response.body.toString());
    if (response.statusCode == 400) {
    } else if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          symbol = data["symbol"]["symbol"];
          name = data["member"]["name"];
          isLoading = false;
        });
        for (int i = 0; i < data["goals"].length; i++) {
          Map obj = data["goals"][i];
          Goals pos = Goals();
          pos = Goals.fromJson(obj);
          goals.add(pos);
        }
      } else {}
    }
  }

  deleteExpense(int id) async {
    String token = UserID.token;
    var serviceURL = expenseURL;
    var uri = Uri.parse("https://www.myhoneypot.app/api/goal/$id");

    final http.Response response = await http.delete(
      uri,
      headers: {
        client.HttpHeaders.acceptHeader: "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    Map data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("Successfull");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully Delete"),
        ),
      );
    } else {
      print("not successful");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("dashboard screen");
    if (this.mounted) {
      setState(() {});
      goalsApi();

      selectedDate = DateTime.now();

      expenseApi(selectedDate!.year, selectedDate!.month);
    }
  }

  DateTime? selectedDate;
  List<Transactions> transaction = [];
  String categoryDescription = "";
  String description = "";
  int total = 0;
  String date = DateTime.now().toString();

  Future<void> expenseApi(year, month) async {
    print("Enter Expense Api");
    isLoading = true;

    String token = UserID.token;
    var response = await http.get(
        Uri.parse("https://www.myhoneypot.app/api/expense/$year/$month"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 400) {
    } else if (response.statusCode == 200) {
      if (data["transactions"].isEmpty) {
        setState(() {
          // transactionsText = true;
        });
      } else {
        if (this.mounted) {
          setState(() {
            // transactionsText = false;
          });
        }

        for (int i = 0; i < data["transactions"].length; i++) {
          Map obj = data["transactions"][i];
          Transactions pos = Transactions();
          pos = Transactions.fromJson(obj);
          transaction.add(pos);
        }
        categoryDescription =
            data["transactions"][0]["category"]["description"];
        description = data["transactions"][0]["description"];
        total = data["transactions"][0]["total"];
        date = data["transactions"][0]["date"];

        print("====>>>${categoryDescription}");
        print("====>>>${description}");

        print("====>>>${total}");

        print("====>>>${categoryDescription}");
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

        return
            // isLoading
            // ? const Padding(
            //     padding: EdgeInsets.only(top: 200),
            //     child: Center(
            //       child: CircularProgressIndicator(
            //         color: Colors.white,
            //       ),
            //     ),
            //   )
            // :
            SlidingUpPanel(
          minHeight: height / 2.5,
          maxHeight: height / 1.1,
          backdropOpacity: 0,
          boxShadow: const [],
          backdropEnabled: true,
          color: Colors.transparent,
          // panel: _panel(),
          panel: newPanel(),
          body: _body(),
        );
      },
    );
  }

  Widget newPanel() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(6.0),
      height: height,
      // width: width,
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 10),
          child: Container(
            width: width * 0.280,
            height: height * 0.009,
            decoration: BoxDecoration(
                color: Colors.purple,
                //  AppColors.pieColor8,
                borderRadius: BorderRadius.all(Radius.circular(10.0.sp))),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: height * 0.015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Goals",
                style: robotoSemiBold.copyWith(
                  color: AppColors.blackSoftColor,
                  fontSize: 14.0.sp,
                ),
              ),
              Container(
                height: height * 0.050,
                width: width * 0.250,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(builder: (context) => AddGoal()),
                    )
                        .then((_) {
                      setState(() {
                        goalsApi();
                      });
                    });
                  },
                  child: Icon(
                    LucideIcons.plusSquare,
                    color: AppColors.blackColor,
                    size: 15.0.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        isLoading
            ? const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 120, top: 10),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: AppColors.borderColor,
                      height: 10,
                    ),
                    shrinkWrap: true,
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      var percentage = goals[index].currentTotal! /
                          goals[index].targetTotal!.toInt() *
                          100;
                      int per = percentage.toInt();
                      int progress = 100 - percentage.toInt();
                      double progressIndicator = progress / 100;

                      return SwipeableTile.card(
                        horizontalPadding: 0,
                        shadow: const BoxShadow(),
                        verticalPadding: 0,
                        borderRadius: 0.0,
                        color: Colors.white,
                        swipeThreshold: 0.2,
                        direction: SwipeDirection.endToStart,
                        onSwiped: (direction) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Alert!"),
                                content: const Text(
                                    "Are you sure you want to delete it?"),
                                actions: [
                                  TextButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      deleteExpense(goals[index].id!);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        backgroundBuilder: (context, direction, progress) {
                          if (direction == SwipeDirection.endToStart) {
                            // return your widget
                          } else if (direction == SwipeDirection.startToEnd) {
                            // return your widget
                          }
                          return Container();
                        },
                        key: UniqueKey(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                    builder: (context) => EditGoal(
                                          id: goals[index].id!.toInt(),
                                          description: goals[index]
                                              .description
                                              .toString(),
                                          total: goals[index]
                                              .targetTotal
                                              .toString(),
                                        )),
                              )
                                  .then((_) {
                                setState(() {
                                  goalsApi();
                                });
                              });
                            },
                            child: Container(
                              height: height * 0.15,
                              // padding:
                              //     EdgeInsets.symmetric(horizontal: height * 0.010),
                              width: width,
                              decoration: const BoxDecoration(
                                color: AppColors.whiteColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: height * 0.005),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 13.0.sp),
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundColor: Colors.grey,
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.all(1.0.sp),
                                                    child: const CircleAvatar(
                                                      radius: 50,
                                                      backgroundColor:
                                                          AppColors.whiteColor,
                                                      child: Icon(
                                                        LucideIcons.trophy,
                                                        color: AppColors
                                                            .primaryColor,
                                                        size: 25,
                                                      ),
                                                      //
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5.0.sp,
                                                  right: 10.0.sp,
                                                  top: 12.0.sp),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    goals[index]
                                                        .description
                                                        .toString(),
                                                    style: robotoBold.copyWith(
                                                      fontSize: 14.0.sp,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    "$symbol${goals[index].targetTotal}",
                                                    style:
                                                        robotoRegular.copyWith(
                                                      fontSize: 14.0.sp,
                                                      color: AppColors
                                                          .blackSoftColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: height * 0.012),
                                            LinearPercentIndicator(
                                              barRadius: Radius.circular(8),
                                              animation: true,
                                              lineHeight: 12.0,
                                              animationDuration: 2500,
                                              percent: per == 0
                                                  ? 0.0
                                                  : goals[index]
                                                          .status!
                                                          .contains("Completed")
                                                      ? 1.0
                                                      : progressIndicator,
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                              progressColor:
                                                  AppColors.primaryColor,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0.sp,
                                                      right: 5.0.sp,
                                                      top: 8.0.sp),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        goals[index]
                                                                .status!
                                                                .contains(
                                                                    "Pending")
                                                            ? goals[index]
                                                                .daysDescription
                                                                .toString()
                                                            : goals[index]
                                                                .status
                                                                .toString(),
                                                        style: robotoRegular
                                                            .copyWith(
                                                          color: goals[index]
                                                                  .status!
                                                                  .contains(
                                                                      "Completed")
                                                              ? AppColors
                                                                  .primaryColor
                                                              : goals[index]
                                                                          .dayOverdue ==
                                                                      true
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,

                                                          // AppColors.greenColor,
                                                          fontSize: 12.0.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        "$symbol${goals[index].currentTotal}",
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: 12.0.sp,
                                                          color: AppColors
                                                              .blackSoftColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        goals[index]
                                                                .status!
                                                                .contains(
                                                                    "Completed")
                                                            ? '0% left'
                                                            : per == 0
                                                                ? "100% left"
                                                                : '$per% left',
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
      ]),
    );
  }

//body widget
  Widget _body() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const SavingsScreen()));
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FeedbackSreen()));
          },
          child: const Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.0.sp,
            ),
            child: Text(
              DateFormat.yMMMM().format(now).toString(),
              style: robotoMedium.copyWith(
                color: AppColors.whiteColor.withOpacity(0.50),
                fontSize: 14.0.sp,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.0.sp,
              // top: 10.0.sp,
            ),
            child: Text(
              "Hi $name ",
              style: robotoBold.copyWith(
                color: AppColors.whiteColor,
                fontSize: 20.0.sp,
              ),
            ),
          ),
        ),
        const CustomChartData(),

        // last transaction
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 17.0.sp, bottom: 5.0.sp),
            child: Text(
              "Your last transaction",
              style: robotoMedium.copyWith(
                color: AppColors.whiteColor.withOpacity(0.50),
                fontSize: 12.0.sp,
              ),
            ),
          ),
        ),

        Container(
          height: height * 0.125,
          margin: EdgeInsets.only(
            left: height * 0.025,
            right: height * 0.025,
          ),
          width: width,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.all(
              Radius.circular(7.0.sp),
            ),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.020),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0.sp),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 3.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: categoryDescription.contains("Utilities")
                              ? const Icon(
                                  LucideIcons.plug2,
                                  color: AppColors.primaryColor,
                                  size: 30,
                                )
                              : categoryDescription.contains("Transportation")
                                  ? const Icon(
                                      LucideIcons.car,
                                      color: AppColors.primaryColor,
                                      size: 30,
                                    )
                                  : categoryDescription.contains("Personal")
                                      ? const Icon(
                                          LucideIcons.user,
                                          color: AppColors.primaryColor,
                                          size: 25,
                                        )
                                      : categoryDescription.contains("Interest")
                                          ? const Icon(
                                              LucideIcons.percent,
                                              color: AppColors.primaryColor,
                                              size: 25,
                                            )
                                          : categoryDescription
                                                  .contains("Dining out")
                                              ? const Icon(
                                                  LucideIcons.utensils,
                                                  color: AppColors.primaryColor,
                                                  size: 25,
                                                )
                                              : categoryDescription
                                                      .contains("Housing")
                                                  ? const Icon(
                                                      LucideIcons.home,
                                                      color: AppColors
                                                          .primaryColor,
                                                      size: 25,
                                                    )
                                                  : categoryDescription
                                                          .contains(
                                                              "Commission")
                                                      ? const Icon(
                                                          LucideIcons.coins,
                                                          color: AppColors
                                                              .primaryColor,
                                                          size: 25,
                                                        )
                                                      : categoryDescription
                                                              .contains("Gifts")
                                                          ? const Icon(
                                                              LucideIcons.gift,
                                                              color: AppColors
                                                                  .primaryColor,
                                                              size: 25,
                                                            )
                                                          : categoryDescription
                                                                  .contains(
                                                                      "Groceries")
                                                              ? const Icon(
                                                                  LucideIcons
                                                                      .shoppingCart,
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                  size: 25,
                                                                )
                                                              : categoryDescription
                                                                      .contains(
                                                                          "Allowance")
                                                                  ? const Icon(
                                                                      LucideIcons
                                                                          .wallet,
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                      size: 25,
                                                                    )
                                                                  : const Icon(
                                                                      LucideIcons
                                                                          .archive,
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                      size: 25,
                                                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14.0.sp),
                      child: Text(
                        categoryDescription,
                        style: robotoSemiBold.copyWith(
                          fontSize: 12.0.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.003),
                    Text(
                      description,
                      style: robotoRegular.copyWith(
                        fontSize: 12.0.sp,
                        color: AppColors.blackSoftColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 14.0.sp, right: 15.0.sp),
                    child: Text(
                      "$symbol${total.toString()}.00",
                      style: robotoRegular.copyWith(
                        fontSize: 12.0.sp,
                        color: AppColors.blackSoftColor,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.003),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 8.0.sp,
                      right: 15.0.sp,
                      top: 5,
                    ),
                    child: Text(
                      "${date[8]}${date[9]} ${DateFormat.MMM().format(selectedDate!).toString()} ",
                      style: robotoRegular.copyWith(
                        fontSize: 12.0.sp,
                        color: AppColors.blackSoftColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
