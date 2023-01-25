import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/expense_permonth_model.dart';
import 'package:myhoneypott/models/expenses_model.dart';
import 'package:myhoneypott/models/income_all_month.dart';
import 'package:myhoneypott/screens/scroll_up/scroll_up.dart';

import 'package:myhoneypott/widget/expenses.dart';
import 'package:myhoneypott/widget/income.dart';
import 'package:myhoneypott/widget/income_and_expense.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../constant/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:d_chart/d_chart.dart';
import 'dart:io' as client;

import '../custom_pie_cahrt/custom_pie_chart copy.dart';

class ScrollUp extends StatefulWidget {
  ScrollController sc;

  final List<ExpensesAllMonth> monthExpenses;
  ScrollUp({Key? key, required this.sc, required this.monthExpenses})
      : super(key: key);

  @override
  State<ScrollUp> createState() => _ScrollUpState();
}

class _ScrollUpState extends State<ScrollUp> {
  bool expenseVisibility = true;
  bool incomeVisibility = false;
  List<Expenses> expensesPerMonth = [];
  List<Category> categories = [];
  List<Map<String, dynamic>> chart = [];
  Map<String, double> res = {};
  bool isLoading = false;
  bool isEmpty = false;
  bool isGraph = true;

  static int expenseMonthSum = 0;
  static int totalIncome = 0;
  static int totalBalance = 0;
  // Map<String, dynamic> grapvalue = {};
  expenseApi(year, month) async {
    setState(() {
      isLoading = true;
    });

    String token = await ApiResponse().getToken();
    var response = await http.get(
        Uri.parse("https://www.myhoneypot.app/api/expense/${year}/${month}"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (this.mounted) {
        setState(() {
          isLoading = false;
          expenseMonthSum = data["totalExpenses"];
          totalBalance = data["totalBalance"];
          totalIncome = data["totalIncome"];
        });
      }

      if (data["expenses"].isEmpty) {
        setState(() {
          isEmpty = true;
        });
      } else {
        print("=====>>PPP");
        print(data["expenses"]);
        for (int i = 0; i < data["expenses"].length; i++) {
          Map obj = data["expenses"][i];
          Expenses pos = Expenses();
          pos = Expenses.fromJson(obj);
          expensesPerMonth.add(pos);
        }
      }
      if (data["categories"].isEmpty) {
        setState(() {
          isGraph = false;
        });
      } else {
        print("====>>>>>");
        print(data["categories"]);
        setState(() {
          // grapvalue = data["categories"];
        });
        // for (int i = 0; i < data["categories"].length; i++) {
        //   Map obj = data["categories"][i];
        //   Category pos = Category();
        //   pos = Category.fromJson(obj);
        //   categories.add(pos);
        // }
      }

      // for (int i = 0; i < categories.length; i++) {
      //   chart.add({
      //     'domain': categories[i].description,
      //     'measure': categories[i].percentage,
      //   });
      // }
    } else {
      setState(() {
        isLoading = false;
        setState(() {
          isEmpty = false;
        });
      });
    }
  }

  DateTime? selectedDate;

  selectDate(context) {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: selectedDate ?? DateTime.now(),
      locale: const Locale("en"),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          expensesPerMonth = [];
          categories = [];
          chart = [];
          isEmpty = false;
          isGraph = true;
        });
        expenseApi(selectedDate!.year, selectedDate!.month);
      }
    });
  }

  // deleteExpense(int id) async {
  //   String token = await ApiResponse().getToken();
  //   var serviceURL = expenseURL;
  //   var uri = Uri.parse("$serviceURL/$id");

  //   final http.Response response = await http.delete(
  //     uri,
  //     headers: {
  //       client.HttpHeaders.acceptHeader: "application/json",
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   Map data = jsonDecode(response.body);
  // }

  List<IncomeAllMonth> income = [];

  incomeApi() async {
    print("start income api call");
    print(incomeVisibility);
    String token = await ApiResponse().getToken();
    var response = await http.get(Uri.parse(dashboardURL), headers: {
      'Authorization': 'Bearer $token',
    });

    Map data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < data["incomeAllMonth"].length; i++) {
        Map obj = data["incomeAllMonth"][i];
        IncomeAllMonth pos = IncomeAllMonth();
        pos = IncomeAllMonth.fromJson(obj);
        income.add(pos);
      }
      setState(() {});
    } else {}
  }

  // deleteIncome(String id) async {
  //   String token = await ApiResponse().getToken();

  //   var uri = Uri.parse("https://www.myhoneypot.app/api/income/${id}");

  //   final http.Response response = await http.delete(
  //     uri,
  //     headers: {
  //       client.HttpHeaders.acceptHeader: "application/json",
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   Map data = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     print("Successfull deleted");
  //   } else {
  //     print("Error deleted");
  //   }
  // }
  @override
  void initState() {
    super.initState();
    print("call init of expense screen");

    selectedDate = DateTime.now();
    expenseApi(selectedDate!.year, selectedDate!.month);
    expenseVisibility = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6.0),
          height: MediaQuery.of(context).size.height,
          // width: width,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 34, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expenses for ${DateFormat.yMMMM().format(selectedDate!).toString()}",
                      style: robotoSemiBold.copyWith(
                        color: AppColors.blackSoftColor,
                        fontSize: 20.0,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        selectDate(context);
                      },
                      child: const Icon(
                        Icons.calendar_month,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: height * 0.016),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        expenseVisibility = true;
                        incomeVisibility = false;
                      });
                    },
                    child: Text(
                      "Expenses",
                      style: robotoSemiBold.copyWith(
                        color: expenseVisibility
                            ? AppColors.blackSoftColor
                            : AppColors.hintTextColor,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        expenseVisibility = false;
                        incomeVisibility = true;
                      });

                      incomeApi();
                    },
                    child: Text(
                      "Income",
                      style: robotoSemiBold.copyWith(
                        color: incomeVisibility
                            ? AppColors.blackSoftColor
                            : AppColors.hintTextColor,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: expenseVisibility,
                  child: isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset("assets/images/notfound.png",
                                height: 70,
                                width: 70,
                                color: Colors.grey.withOpacity(0.6)),
                          ),
                        )
                      : ExpensesPage(
                          // sc: widget.sc,
                          expensesPerMonth: expensesPerMonth,
                          monthExpenses: widget.monthExpenses,
                          selectedDate: selectedDate,
                        )),
              Visibility(
                visible: incomeVisibility,
                child: IncomePage(
                  income: income,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
