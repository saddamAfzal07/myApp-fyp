import 'dart:async';
import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/controller/expense_controller.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/expense_permonth_model.dart';
import 'package:myhoneypott/models/expenses_model.dart';
import 'package:myhoneypott/models/income_all_month.dart';
import 'package:myhoneypott/models/transaction/expense_transaction.dart';
import 'package:myhoneypott/my_loading.dart';
import 'package:myhoneypott/screens/budget_details/custom_pie_chart.dart';
import 'package:myhoneypott/screens/expenses/components/chart_expense.dart';
import 'package:myhoneypott/screens/expenses/components/edit_income.dart';
import 'package:myhoneypott/screens/expenses/edit_expenses_screen.dart';
import 'package:myhoneypott/screens/logindialogues/error_dialouge.dart';

import 'package:myhoneypott/widget/expenses.dart';
import 'package:myhoneypott/widget/income.dart';
import 'package:myhoneypott/widget/income_and_expense.dart';
import 'package:myhoneypott/widget/income_dialogue.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import '../../constant/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:d_chart/d_chart.dart';
import 'dart:io' as client;
import 'package:myhoneypott/constant/user_id.dart';

import '../custom_pie_cahrt/custom_pie_chart copy.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ExpensesScreen extends StatefulWidget {
  final List<ExpensesAllMonth> monthExpenses;
  final List<String> uniqueMonths;

  const ExpensesScreen(this.monthExpenses, this.uniqueMonths);

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  // DateTime? selectedDate;

  // selectDate(context) {
  //   showMonthPicker(
  //     context: context,
  //     firstDate: DateTime(DateTime.now().year - 1, 5),
  //     lastDate: DateTime(DateTime.now().year + 1, 9),
  //     initialDate: selectedDate ?? DateTime.now(),
  //     locale: const Locale("en"),
  //   ).then((date) {
  //     if (date != null) {
  //       setState(() {
  //         selectedDate = date;
  //         transaction = [];
  //       });
  //       expenseApi(selectedDate!.year, selectedDate!.month);
  //     }
  //   });
  // }

  ///Updated Features
  // List<Transactions> transaction = [];
  // static int expenseMonthSum = 0;
  // static int totalIncome = 0;
  // static int totalBalance = 0;
  // bool isLoading = false;
  // bool transactionsText = false;
  // String symbol = "RM";
  // String totalExpensesPercentage = "0";
  // // ignore: non_constant_identifier_names
  // double Utilities = 0.0;
  // double Commission = 0.0;
  // double Others = 0.0;
  // double Housing = 0.0;
  // double Groceries = 0.0;
  // double Transportation = 0.0;
  // double Personal = 0.0;
  // double Diningout = 0.0;
  // double Entertainment = 0.0;
  // @override
  // void initState() {
  //   super.initState();
  //   print("call init of expense screen");

  // selectedDate = DateTime.now();

  // expenseApi(selectedDate!.year, selectedDate!.month);
  // }
  DateTime? selectedDate;
  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final state = Provider.of<ExpenseController>(context, listen: false);

      state.expenseApi(selectedDate!.year, selectedDate!.month, context);
      print("call expense api");
    });
  }

  // Future<void> expenseApi(year, month) async {
  //   isLoading = true;
  //   transaction = [];
  //   print(UserID.id);
  //   String token = UserID.token;
  //   print(token);
  //   var response = await http.get(
  //       Uri.parse("https://www.myhoneypot.app/api/expense/$year/$month"),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       });
  //   Map data = jsonDecode(response.body.toString());
  //   if (response.statusCode == 400) {
  //     print("get 400");
  //     print("internal server error");
  //     showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (BuildContext context) {
  //           return Dialog(
  //             insetPadding:
  //                 const EdgeInsets.only(top: 100, left: 20, right: 20),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20.0)), //this right here
  //             child: ErrorAccountdialogue(
  //                 title: data["title"], message: data["message"]),
  //           );
  //         });
  //     setState(
  //       () {
  //         isLoading = false;
  //         transactionsText = true;
  //       },
  //     );
  //     //Income Dialogue
  //     if (totalIncome == 0) {
  //       print(" income is equal zero");
  //       showDialog(
  //           barrierDismissible: false,
  //           context: context,
  //           builder: (BuildContext context) {
  //             return Dialog(
  //               insetPadding: const EdgeInsets.only(
  //                   top: 150, left: 20, right: 20, bottom: 150),
  //               shape: RoundedRectangleBorder(
  //                   borderRadius:
  //                       BorderRadius.circular(20.0)), //this right here
  //               child: const IncomeDialog(),
  //             );
  //           });
  //     } else {
  //       print("No income zero");
  //     }
  //   } else if (response.statusCode == 200) {
  //     if (mounted) {
  //       setState(() {
  //         transactionsText = false;
  //         isLoading = false;
  //         expenseMonthSum = data["totalExpenses"];
  //         totalBalance = data["totalBalance"];
  //         totalIncome = data["totalIncome"];
  //         symbol = data["symbol"]["symbol"];
  //         totalExpensesPercentage = data["totalExpensesPercentage"].toString();
  //       });
  //     }
  //     print(Commission);
  //     if (data["transactions"].isEmpty) {
  //       setState(() {
  //         transactionsText = true;
  //       });
  //     } else {
  //       if (this.mounted) {
  //         setState(() {
  //           isLoading = false;
  //           transactionsText = false;
  //         });
  //       }

  //       for (int i = 0; i < data["transactions"].length; i++) {
  //         Map obj = data["transactions"][i];
  //         Transactions pos = Transactions();
  //         pos = Transactions.fromJson(obj);
  //         transaction.add(pos);
  //       }
  //       refreshController.refreshCompleted();
  //     }
  //     if (data["categories"].isEmpty) {
  //       print("category emptyyy");
  //       setState(() {
  //         Utilities = 0.0;
  //         Commission = 0.0;
  //         Others = 0.0;
  //         Housing = 0.0;
  //         Groceries = 0.0;
  //         Transportation = 0.0;
  //         Personal = 0.0;
  //         Diningout = 0.0;
  //         Entertainment = 0.0;
  //       });
  //     } else {
  //       setState(() {
  //         Utilities = data["categories"]["Utilities"] == null
  //             ? double.parse("0.0")
  //             : double.parse(data["categories"]["Utilities"]);
  //         Commission = data["categories"]["Commission"] == null
  //             ? double.parse("0.0")
  //             : double.parse(data["categories"]["Commission"]);

  //         Others = data["categories"]["Others"] == null
  //             ? double.parse("0.0")
  //             : double.parse(data["categories"]["Others"]);

  //         Housing = data["categories"]["Housing"] == null
  //             ? double.parse("0.0")
  //             : double.parse(data["categories"]["Housing"]);
  //         Groceries = data["categories"]["Groceries"] == null
  //             ? double.parse("0.0")
  //             : double.parse(data["categories"]["Groceries"]);
  //         Transportation = data["categories"]["Transportation"] == null
  //             ? double.parse("0.0")
  //             : double.parse(data["categories"]["Transportation"]);
  //         Personal = data["categories"]["Personal"] == null
  //             ? double.parse("0.0")
  //             : double.parse(data["categories"]["Personal"]);
  //         Diningout = data["categories"]["Dining out"] == null
  //             ? double.parse("0.0")
  //             : double.parse(data["categories"]["Dining out"]);
  //         Entertainment = data["categories"]["Entertainment"] == null
  //             ? double.parse("0.0")
  //             : double.parse(data["categories"]["Entertainment"]);
  //       });
  //     }
  //     if (totalIncome == 0) {
  //       showDialog(
  //           barrierDismissible: false,
  //           context: context,
  //           builder: (BuildContext context) {
  //             return Dialog(
  //               insetPadding:
  //                   const EdgeInsets.only(top: 100, left: 20, right: 20),
  //               shape: RoundedRectangleBorder(
  //                   borderRadius:
  //                       BorderRadius.circular(20.0)), //this right here
  //               child: const IncomeDialog(),
  //             );
  //           });
  //     }
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  int currentIndex = 0;
  deleteExpense(int id) async {
    print(id);
    String token = UserID.token;
    var serviceURL = expenseURL;
    var uri = Uri.parse("$serviceURL/$id");

    final http.Response response = await http.delete(
      uri,
      headers: {
        client.HttpHeaders.acceptHeader: "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    Map data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("expense delete successfull");
    } else {
      print("not successful");
    }
  }

  RefreshController refreshController = RefreshController(initialRefresh: true);
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ExpenseController>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SlidingUpPanel(
      minHeight: height / 2,
      maxHeight: height / 1.18,
      backdropOpacity: 0,
      backdropEnabled: true,
      color: Colors.transparent,
      panel: Container(
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
              padding: const EdgeInsets.all(4),
              child: Container(
                width: 130,
                height: 6,
                decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 34, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat.yMMMM().format(selectedDate!).toString(),
                    style: robotoSemiBold.copyWith(
                      color: AppColors.blackSoftColor,
                      fontSize: 16.0,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      state.selectDate(context);
                    },
                    child: const Icon(
                      Icons.calendar_month,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.016),
            state.isLoading
                ? const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SmartRefresher(
                        controller: state.refreshController,
                        header: WaterDropHeader(
                          waterDropColor: AppColors.primaryColor,
                          refresh: MyLoading(),
                          complete: Container(),
                          completeDuration: Duration.zero,
                        ),
                        onRefresh: () => state.expenseApi(
                            selectedDate!.year, selectedDate!.month, context),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.transaction.length,
                            itemBuilder: (context, index) {
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
                                              deleteExpense(
                                                  state.transaction[index].id!);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text(
                                              "Cancel",
                                              style:
                                                  TextStyle(color: Colors.red),
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
                                backgroundBuilder:
                                    (context, direction, progress) {
                                  if (direction == SwipeDirection.endToStart) {
                                    // return your widget
                                  } else if (direction ==
                                      SwipeDirection.startToEnd) {
                                    // return your widget
                                  }
                                  return Text("");
                                },
                                key: UniqueKey(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        state.transaction[index].category!
                                                    .type ==
                                                "E"
                                            ? Navigator.of(context)
                                                .push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditExpense(
                                                          monthlyExpense:
                                                              state.transaction[
                                                                  index],
                                                          category: state
                                                              .transaction[
                                                                  index]
                                                              .category!
                                                              .description
                                                              .toString(),
                                                          date: state
                                                              .transaction[
                                                                  index]
                                                              .date
                                                              .toString(),
                                                          description: state
                                                              .transaction[
                                                                  index]
                                                              .description
                                                              .toString(),
                                                          id: state
                                                              .transaction[
                                                                  index]
                                                              .id
                                                              .toString(),
                                                          totalAmount: state
                                                              .transaction[
                                                                  index]
                                                              .total
                                                              .toString(),
                                                        )),
                                              )
                                                .then((_) {
                                                setState(() {
                                                  print("call setstate");
                                                  state.selectedDate =
                                                      DateTime.now();

                                                  state.expenseApi(
                                                      state.selectedDate!.year,
                                                      state.selectedDate!.month,
                                                      context);
                                                });
                                              })
                                            : Navigator.of(context)
                                                .push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditIncomeScreen(
                                                          monthlyExpense:
                                                              state.transaction[
                                                                  index],
                                                          category: state
                                                              .transaction[
                                                                  index]
                                                              .category!
                                                              .description
                                                              .toString(),
                                                          date: state
                                                              .transaction[
                                                                  index]
                                                              .date
                                                              .toString(),
                                                          description: state
                                                              .transaction[
                                                                  index]
                                                              .description
                                                              .toString(),
                                                          id: state
                                                              .transaction[
                                                                  index]
                                                              .id
                                                              .toString(),
                                                          totalAmount: state
                                                              .transaction[
                                                                  index]
                                                              .total
                                                              .toString(),
                                                        )),
                                              )
                                                .then((_) {
                                                setState(() {
                                                  print("call  income");
                                                  state.selectedDate =
                                                      DateTime.now();

                                                  state.expenseApi(
                                                      state.selectedDate!.year,
                                                      state.selectedDate!.month,
                                                      context);
                                                });
                                              });
                                      },
                                      child: ListTile(
                                        minVerticalPadding: 0,
                                        contentPadding: const EdgeInsets.only(
                                            left: 0, right: 10),
                                        horizontalTitleGap: 0,
                                        dense: true,
                                        // visualDensity: const VisualDensity(
                                        //     horizontal: 0, vertical: 1.0),
                                        leading: Transform.translate(
                                          offset: const Offset(-20, 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 3.0,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius: 60,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: state.transaction[index]
                                                      .category!.description!
                                                      .contains("Utilities")
                                                  ? const Icon(
                                                      LucideIcons.plug2,
                                                      color: AppColors
                                                          .primaryColor,
                                                      size: 30,
                                                    )
                                                  : state
                                                          .transaction[index]
                                                          .category!
                                                          .description!
                                                          .contains(
                                                              "Transportation")
                                                      ? const Icon(
                                                          LucideIcons.car,
                                                          color: AppColors
                                                              .primaryColor,
                                                          size: 30,
                                                        )
                                                      : state.transaction[index]
                                                              .category!.description!
                                                              .contains(
                                                                  "Personal")
                                                          ? const Icon(
                                                              LucideIcons.user,
                                                              color: AppColors
                                                                  .primaryColor,
                                                              size: 25,
                                                            )
                                                          : state
                                                                  .transaction[
                                                                      index]
                                                                  .category!
                                                                  .description!
                                                                  .contains(
                                                                      "Interest")
                                                              ? const Icon(
                                                                  LucideIcons
                                                                      .percent,
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                  size: 25,
                                                                )
                                                              : state
                                                                      .transaction[index]
                                                                      .category!
                                                                      .description!
                                                                      .contains("Dining out")
                                                                  ? const Icon(
                                                                      LucideIcons
                                                                          .utensils,
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                      size: 25,
                                                                    )
                                                                  : state.transaction[index].category!.description!.contains("Housing")
                                                                      ? const Icon(
                                                                          LucideIcons
                                                                              .home,
                                                                          color:
                                                                              AppColors.primaryColor,
                                                                          size:
                                                                              25,
                                                                        )
                                                                      : state.transaction[index].category!.description!.contains("Commission")
                                                                          ? const Icon(
                                                                              LucideIcons.coins,
                                                                              color: AppColors.primaryColor,
                                                                              size: 25,
                                                                            )
                                                                          : state.transaction[index].category!.description!.contains("Gifts")
                                                                              ? const Icon(
                                                                                  LucideIcons.gift,
                                                                                  color: AppColors.primaryColor,
                                                                                  size: 25,
                                                                                )
                                                                              : state.transaction[index].category!.description!.contains("Groceries")
                                                                                  ? const Icon(
                                                                                      LucideIcons.shoppingCart,
                                                                                      color: AppColors.primaryColor,
                                                                                      size: 25,
                                                                                    )
                                                                                  : state.transaction[index].category!.description!.contains("Allowance")
                                                                                      ? const Icon(
                                                                                          LucideIcons.wallet,
                                                                                          color: AppColors.primaryColor,
                                                                                          size: 25,
                                                                                        )
                                                                                      : const Icon(
                                                                                          LucideIcons.archive,
                                                                                          color: AppColors.primaryColor,
                                                                                          size: 25,
                                                                                        ),
                                            ),
                                          ),
                                        ),
                                        title: Transform.translate(
                                          offset: const Offset(-40, 0),
                                          child: Text(
                                            state.transaction[index].category!
                                                .description
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor),
                                          ),
                                        ),
                                        subtitle: Transform.translate(
                                          offset: const Offset(-38, 0),
                                          child: Text(
                                            state.transaction[index].description
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        trailing: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 2),
                                              child: Text(
                                                "${state.symbol}${state.transaction[index].total.toString()}.00",
                                                style: robotoRegular.copyWith(
                                                    color: state
                                                                .transaction[
                                                                    index]
                                                                .category!
                                                                .type ==
                                                            "E"
                                                        ? Colors.red
                                                        : Colors.green,
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "${state.transaction[index].date![8]}${state.transaction[index].date![9]} ${DateFormat.MMM().format(selectedDate!).toString()} ",
                                              style: robotoRegular.copyWith(
                                                color: AppColors.blackSoftColor,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  )
          ])),
      body: Column(
        children: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: IncomeAndExpense(
                expenseMonthSum: state.expenseMonthSum.toInt(),
                totalBalance: state.totalBalance.toInt(),
                totalIncome: state.totalIncome.toInt(),
              ),
            ),
          ),

          SizedBox(
            height: height / 2.41,
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
                print(currentIndex);
              },
              children: [
                CustomPieChart(
                  Commission: state.Commission,
                  Diningout: state.Diningout,
                  Entertainment: state.Entertainment,
                  Groceries: state.Groceries,
                  Housing: state.Housing,
                  Others: state.Others,
                  Personal: state.Personal,
                  Transportation: state.Transportation,
                  Utilities: state.Utilities,
                ),
                PieChart1(
                  percentage: (state.expenseMonthSum / state.totalIncome) * 100,
                  totalExpensesPercentage: state.totalExpensesPercentage,
                ),
              ],
            ),
          ),
          DotsIndicator(
            dotsCount: 2,
            position: currentIndex.toDouble(),
            decorator: DotsDecorator(
                color: Colors.grey.shade100,
                activeColor: Colors.yellow,
                spacing: EdgeInsets.all(4)),
          ),

          // PieChart1(
          //   percentage: (expenseMonthSum / totalIncome) * 100,
          // )
          // CustomPieChart(
          //   Commission: Commission,
          //   Diningout: Diningout,
          //   Entertainment: Entertainment,
          //   Groceries: Groceries,
          //   Housing: Housing,
          //   Others: Others,
          //   Personal: Personal,
          //   Transportation: Transportation,
          //   Utilities: Utilities,
          //   // data: grapvalue
          // ),
        ],
      ),
    );
  }
}
