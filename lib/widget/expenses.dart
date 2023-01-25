import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_icons.dart';
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/expense_permonth_model.dart';
import 'package:myhoneypott/models/expenses_model.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

import '../constant/app_text_styles.dart';
import '../screens/expenses/edit_expenses_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as client;

class ExpensesPage extends StatefulWidget {
  final List<ExpensesAllMonth> monthExpenses;
  List<Expenses> expensesPerMonth;
  DateTime? selectedDate;
  // ScrollController sc;

  ExpensesPage({
    Key? key,
    required this.expensesPerMonth,
    required this.monthExpenses,
    required this.selectedDate,
    // required this.sc
  }) : super(key: key);

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  deleteExpense(int id) async {
    print(id);
    String token = await ApiResponse().getToken();
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        // controller: widget.sc,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.expensesPerMonth.length,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return SwipeableTile(
              color: Colors.white,
              swipeThreshold: 0.2,
              direction: SwipeDirection.endToStart,
              onSwiped: (direction) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Alert!"),
                      content:
                          const Text("Are you sure you want to delete it?"),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            deleteExpense(widget.expensesPerMonth[index].id!);
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
                margin: EdgeInsets.only(
                    left: height * 0.024, right: height * 0.024, top: 15.0),
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.MMM()
                                .format(widget.selectedDate!)
                                .toString()
                                .split(" ")[0],
                            style: robotoRegular.copyWith(
                              color: AppColors.blackSoftColor,
                              fontSize: 10.0,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.expensesPerMonth[index].date![8],
                                style: robotoSemiBold.copyWith(
                                  color: AppColors.blackSoftColor,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                widget.expensesPerMonth[index].date![9],
                                style: robotoSemiBold.copyWith(
                                  color: AppColors.blackSoftColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.expensesPerMonth[index].category!.description
                                .toString(),
                            style: robotoRegular.copyWith(
                              fontSize: 14.0,
                              color: AppColors.blackSoftColor,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            widget.expensesPerMonth[index].description
                                .toString(),
                            style: robotoRegular.copyWith(
                              fontSize: 14.0,
                              color: AppColors.blackSoftColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'RM ${widget.expensesPerMonth[index].total.toString()}',
                      style: robotoRegular.copyWith(
                        fontSize: 14.0,
                        color: AppColors.blackSoftColor,
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    const SizedBox(
                      height: 50.0,
                      child: Expanded(
                        child: VerticalDivider(
                          width: 1.0,
                          thickness: 1.0,
                          color: AppColors.borderColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(EditExpense(
                          monthlyExpense: widget.monthExpenses[index],
                          id: widget.monthExpenses[index].id.toString(),
                          category: widget
                              .expensesPerMonth[index].category!.description
                              .toString(),
                          date: widget.expensesPerMonth[index].date.toString(),
                          description: widget
                              .expensesPerMonth[index].description
                              .toString(),
                          totalAmount:
                              widget.expensesPerMonth[index].total.toString(),
                        ));
                      },
                      icon: SvgPicture.asset(AppIcons.editIcon),
                    ),
                  ],
                ),
              ));
        }));
  }
}
