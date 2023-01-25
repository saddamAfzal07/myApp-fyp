import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/income_all_month.dart';
import 'package:myhoneypott/screens/custom_chart_data.dart';
import 'package:myhoneypott/screens/dashboard/dialogs/budget_dialog.dart';
import 'package:myhoneypott/screens/savings/savings_screen.dart';
import 'package:myhoneypott/widget/income_and_expense.dart';
import 'package:http/http.dart' as http;

final value = NumberFormat("#,##0.00", "en_US");

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen(
      {Key? key, required this.monthExpenses, required this.uniqueMonths})
      : super(key: key);

  //  final List<ExpensesAllMonth> monthExpenses;
  final List<dynamic> monthExpenses;

  final List<String> uniqueMonths;

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  // late List<ExpensesAllMonth>? _monthExpenses;
  late List<dynamic>? _monthExpenses;
  List<IncomeAllMonth> incomeAllmonths = [];

  late List<String> _uniqueMonths;
  bool expenseVisibility = true;
  bool incomeVisibility = false;

  @override
  void initState() {
    super.initState();

    _monthExpenses = widget.monthExpenses;
    _uniqueMonths = widget.uniqueMonths;
    expenceCount();
    // print("unique months");
    // print(_uniqueMonths);
  }

  static int expenseMonthSum = 0;
  static int totalIncome = 0;
  static int totalBalance = 0;
  expenceCount() async {
    String token = UserID.token;
    var response = await http.get(Uri.parse(dashboardURL), headers: {
      'Authorization': 'Bearer $token',
    });

    // print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> responsedata = jsonDecode(response.body);
      for (int i = 0; i < responsedata["incomeAllMonth"].length; i++) {
        Map obj = responsedata["incomeAllMonth"][i];
        IncomeAllMonth pos = IncomeAllMonth();
        pos = IncomeAllMonth.fromJson(obj);
        incomeAllmonths.add(pos);
      }
      // print("=====>>>>>>>");
      // print(incomeAllmonths);

      if (responsedata["totalIncome"] == 0) {
        Get.dialog(
          const BudgetDialog(),
        );
      } else {}
      if (this.mounted) {
        setState(() {
          expenseMonthSum = responsedata["expenseMonthSum"];
          totalBalance = responsedata["totalBalance"];
          totalIncome = responsedata["totalIncome"];
        });
      }
    } else {
      print("not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SavingsScreen()));
            },
            child: const Icon(
              Icons.home,
              size: 80,
              color: Colors.white,
            ),
          ),
          IncomeAndExpense(
            expenseMonthSum: expenseMonthSum.toInt(),
            totalBalance: totalBalance.toInt(),
            totalIncome: totalIncome.toInt(),
          ),
          SizedBox(height: height * 0.024),
          Container(
            // height: height,
            width: width,
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //// chart
                SizedBox(height: height * 0.024),
                const CustomChartData(),
                Column(
                  children: _uniqueMonths.map(
                    (monthName) {
                      Map<
                          String,
                          List<
                              dynamic
                              // ExpensesAllMonth

                              >> newList = {};

                      /// List sorted by recent date
                      _monthExpenses!.sort((a, b) =>
                          (b.formatted_date)!.compareTo(a.formatted_date!));

                      newList =
                          _monthExpenses!.groupBy((m) => m.formatted_date!);

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.016),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Text(
                                "Transaction for $monthName 2022",
                                style: robotoSemiBold.copyWith(
                                  color: AppColors.blackSoftColor,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.016),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            expenseVisibility = true;
                                            incomeVisibility = false;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: expenseVisibility
                                                  ? AppColors.primaryColor
                                                  : Colors.transparent,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10))),
                                          width: width * 0.45,
                                          alignment: Alignment.center,
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Expenses",
                                                style: robotoSemiBold.copyWith(
                                                  color: expenseVisibility
                                                      ? Colors.white
                                                      : AppColors.primaryColor,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 50),
                                                child: Divider(
                                                  height: 7.0,
                                                  thickness: 2,
                                                  color: expenseVisibility
                                                      ? Colors.white
                                                      : Colors.grey.shade300,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            expenseVisibility = false;
                                            incomeVisibility = true;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: incomeVisibility
                                                  ? AppColors.primaryColor
                                                  : Colors.transparent,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10))),
                                          alignment: Alignment.center,
                                          width: width * 0.45,
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Income",
                                                style: robotoSemiBold.copyWith(
                                                  color: incomeVisibility
                                                      ? Colors.white
                                                      : AppColors.primaryColor,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 50),
                                                child: Divider(
                                                  height: 7.0,
                                                  thickness: 2,
                                                  color: incomeVisibility
                                                      ? Colors.white
                                                      : Colors.grey.shade300,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //   /// chart data
                            SizedBox(height: height * 0.016),

                            //   /// step one
                            Visibility(
                              visible: expenseVisibility,
                              child: SingleChildScrollView(
                                // padding:
                                //     const EdgeInsets.only(bottom: 60.0),
                                child: newList.entries.isEmpty
                                    ? Container(
                                        // color: Colors.green,
                                        alignment: Alignment.topCenter,
                                        height: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                              "assets/images/notfound.png",
                                              height: 50,
                                              width: 50,
                                              color:
                                                  Colors.grey.withOpacity(0.6)),
                                        ),
                                      )
                                    : Column(
                                        children: newList.entries.map(
                                          (entry) {
                                            return SizedBox(
                                              height: height * 0.13,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: height * 0.032),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            height: 8.0,
                                                            width: 8.0,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: AppColors
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                          const Expanded(
                                                            child:
                                                                VerticalDivider(
                                                              thickness: 1.0,
                                                              width: 1.0,
                                                              color: AppColors
                                                                  .footerBorderColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Text(
                                                          //   monthName.toUpperCase(),
                                                          //   style: robotoRegular
                                                          //       .copyWith(
                                                          //     color: AppColors
                                                          //         .blackSoftColor,
                                                          //     fontSize:
                                                          //         height * 0.01,
                                                          //   ),
                                                          // ),
                                                          Text(
                                                            entry.key,
                                                            style:
                                                                robotoSemiBold
                                                                    .copyWith(
                                                              color: AppColors
                                                                  .blackSoftColor,
                                                              fontSize: height *
                                                                  0.016,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: entry.value
                                                              .map(
                                                                (e) => Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                e.category!.description.toString(),
                                                                                style: robotoRegular.copyWith(
                                                                                  fontSize: height * 0.014,
                                                                                  color: AppColors.blackSoftColor,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(height: 2.0),
                                                                              Text(
                                                                                e.description.toString(),
                                                                                style: robotoRegular.copyWith(
                                                                                  fontSize: height * 0.014,
                                                                                  color: AppColors.blackSoftColor.withOpacity(0.5),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "RM${e.total!.toStringAsFixed(2)}",
                                                                          style:
                                                                              robotoRegular.copyWith(
                                                                            fontSize:
                                                                                height * 0.016,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                AppColors.blackSoftColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                              .toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                              ),
                            ),

                            ///IncomeVisibility
                            Visibility(
                              visible: incomeVisibility,
                              child: SingleChildScrollView(
                                  // padding:
                                  //     const EdgeInsets.only(bottom: 60.0),
                                  child: incomeAllmonths.isEmpty
                                      ? Container(
                                          // color: Colors.green,
                                          alignment: Alignment.topCenter,
                                          height: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Image.asset(
                                                "assets/images/notfound.png",
                                                height: 50,
                                                width: 50,
                                                color: Colors.grey
                                                    .withOpacity(0.6)),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: incomeAllmonths.length,
                                          shrinkWrap: true,
                                          itemBuilder: ((context, index) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: height * 0.050,
                                                  vertical: height * 0.001),
                                              child: SingleChildScrollView(
                                                child: Column(children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            incomeAllmonths[
                                                                    index]
                                                                .formattedDate
                                                                .toString(),
                                                            style: robotoRegular
                                                                .copyWith(
                                                              fontSize: height *
                                                                  0.014,
                                                              color: AppColors
                                                                  .blackSoftColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  incomeAllmonths[
                                                                          index]
                                                                      .category!
                                                                      .description
                                                                      .toString(),
                                                                  style: robotoRegular
                                                                      .copyWith(
                                                                    fontSize:
                                                                        height *
                                                                            0.014,
                                                                    color: AppColors
                                                                        .blackSoftColor,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        2.0),
                                                                Text(
                                                                  incomeAllmonths[
                                                                          index]
                                                                      .description
                                                                      .toString(),
                                                                  style: robotoRegular
                                                                      .copyWith(
                                                                    fontSize:
                                                                        height *
                                                                            0.014,
                                                                    color: AppColors
                                                                        .blackSoftColor
                                                                        .withOpacity(
                                                                            0.5),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            "RM${incomeAllmonths[index].total}",
                                                            style: robotoRegular
                                                                .copyWith(
                                                              fontSize: height *
                                                                  0.016,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .blackSoftColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                              ),
                                            );
                                          }))
                                  // : Column(
                                  //     children: newList.entries.map(
                                  //       (entry) {
                                  //         return SizedBox(
                                  //           height: height * 0.13,
                                  //           child: Padding(
                                  //             padding: EdgeInsets.symmetric(
                                  //                 horizontal: height * 0.032),
                                  //             child: Row(
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.start,
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.start,
                                  //               children: [
                                  //                 Padding(
                                  //                   padding:
                                  //                       const EdgeInsets.only(
                                  //                           top: 8.0),
                                  //                   child: Column(
                                  //                     crossAxisAlignment:
                                  //                         CrossAxisAlignment
                                  //                             .center,
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .start,
                                  //                     mainAxisSize:
                                  //                         MainAxisSize.min,
                                  //                     children: [
                                  //                       Container(
                                  //                         height: 8.0,
                                  //                         width: 8.0,
                                  //                         decoration:
                                  //                             const BoxDecoration(
                                  //                           shape: BoxShape
                                  //                               .circle,
                                  //                           color: AppColors
                                  //                               .primaryColor,
                                  //                         ),
                                  //                       ),
                                  //                       const Expanded(
                                  //                         child:
                                  //                             VerticalDivider(
                                  //                           thickness: 1.0,
                                  //                           width: 1.0,
                                  //                           color: AppColors
                                  //                               .footerBorderColor,
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 Padding(
                                  //                   padding: const EdgeInsets
                                  //                           .symmetric(
                                  //                       horizontal: 12.0),
                                  //                   child: Column(
                                  //                     crossAxisAlignment:
                                  //                         CrossAxisAlignment
                                  //                             .center,
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .start,
                                  //                     children: [
                                  //                       // Text(
                                  //                       //   monthName.toUpperCase(),
                                  //                       //   style: robotoRegular
                                  //                       //       .copyWith(
                                  //                       //     color: AppColors
                                  //                       //         .blackSoftColor,
                                  //                       //     fontSize:
                                  //                       //         height * 0.01,
                                  //                       //   ),
                                  //                       // ),
                                  //                       Text(
                                  //                         entry.key,
                                  //                         style:
                                  //                             robotoSemiBold
                                  //                                 .copyWith(
                                  //                           color: AppColors
                                  //                               .blackSoftColor,
                                  //                           fontSize: height *
                                  //                               0.016,
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 Expanded(
                                  //                   child:
                                  //                       SingleChildScrollView(
                                  //                     child: Column(
                                  //                       children: entry.value
                                  //                           .map(
                                  //                             (e) => Column(
                                  //                               crossAxisAlignment:
                                  //                                   CrossAxisAlignment
                                  //                                       .start,
                                  //                               mainAxisAlignment:
                                  //                                   MainAxisAlignment
                                  //                                       .start,
                                  //                               children: [
                                  //                                 Row(
                                  //                                   crossAxisAlignment:
                                  //                                       CrossAxisAlignment
                                  //                                           .center,
                                  //                                   mainAxisAlignment:
                                  //                                       MainAxisAlignment
                                  //                                           .spaceBetween,
                                  //                                   children: [
                                  //                                     Expanded(
                                  //                                       child:
                                  //                                           Column(
                                  //                                         crossAxisAlignment:
                                  //                                             CrossAxisAlignment.start,
                                  //                                         mainAxisAlignment:
                                  //                                             MainAxisAlignment.start,
                                  //                                         children: [
                                  //                                           Text(
                                  //                                             e.category!.description.toString(),
                                  //                                             style: robotoRegular.copyWith(
                                  //                                               fontSize: height * 0.014,
                                  //                                               color: AppColors.blackSoftColor,
                                  //                                             ),
                                  //                                           ),
                                  //                                           const SizedBox(height: 2.0),
                                  //                                           Text(
                                  //                                             e.description.toString(),
                                  //                                             style: robotoRegular.copyWith(
                                  //                                               fontSize: height * 0.014,
                                  //                                               color: AppColors.blackSoftColor.withOpacity(0.5),
                                  //                                             ),
                                  //                                           ),
                                  //                                         ],
                                  //                                       ),
                                  //                                     ),
                                  //                                     Text(
                                  //                                       "RM${e.total!.toStringAsFixed(2)}",
                                  //                                       style:
                                  //                                           robotoRegular.copyWith(
                                  //                                         fontSize:
                                  //                                             height * 0.016,
                                  //                                         fontWeight:
                                  //                                             FontWeight.bold,
                                  //                                         color:
                                  //                                             AppColors.blackSoftColor,
                                  //                                       ),
                                  //                                     ),
                                  //                                   ],
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           )
                                  //                           .toList(),
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         );
                                  //       },
                                  //     ).toList(),
                                  //   ),
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
