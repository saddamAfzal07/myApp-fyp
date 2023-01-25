import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/budget_model.dart';
import 'package:myhoneypott/screens/budget/add_budget.dart';
import 'package:myhoneypott/screens/budget_details/budget_deatails.dart';
import 'package:myhoneypott/widget/income_and_expense.dart';
import 'package:http/http.dart' as http;

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  static int expenseMonthSum = 0;
  static int totalIncome = 0;
  static int totalBalance = 0;
  static String symbol = "";
  expenceCount() async {
    String token = await UserID.token;
    var response = await http.get(Uri.parse(dashboardURL), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> responsedata = jsonDecode(response.body);

      if (this.mounted) {
        setState(() {
          expenseMonthSum = responsedata["expenseMonthSum"];
          totalBalance = responsedata["totalBalance"];
          totalIncome = responsedata["totalIncome"];
        });
      }
    } else {}
  }

  List<Budgets> budget = [];
  bool isloading = false;
  budgetApi() async {
    setState(() {
      isloading = true;
    });

    String token = await UserID.token;
    var response = await http.get(
        Uri.parse("https://www.myhoneypot.app/api/budgets/48"),
        headers: {'Authorization': 'Bearer $token', 'Charset': 'utf-8'});

    Map data = jsonDecode(response.body);
    // print(response.body);
    Map<String, dynamic> responsedata = jsonDecode(response.body);

    setState(() {
      isloading = false;
      symbol = responsedata["symbol"]["symbol"];
    });
    print("===> ${symbol}");

    if (response.statusCode == 200) {
      for (int i = 0; i < data["budgets"].length; i++) {
        Map obj = data["budgets"][i];
        Budgets pos = Budgets();
        pos = Budgets.fromJson(obj);
        budget.add(pos);
      }
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expenceCount();
    budgetApi();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        IncomeAndExpense(
          expenseMonthSum: expenseMonthSum,
          totalBalance: totalBalance,
          totalIncome: totalIncome,
        ),
        SizedBox(height: height * 0.024),
        SingleChildScrollView(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Budget",
                        style: robotoSemiBold.copyWith(
                          color: AppColors.blackSoftColor,
                          fontSize: 20.0,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddBudget()));
                        },
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(7)),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.add,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(""),
                    SizedBox(width: width * 0.1),
                    Row(
                      children: [
                        Text(
                          "Income",
                          style: robotoSemiBold.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(width: width * 0.1),
                        Text(
                          "Expenses",
                          style: robotoSemiBold.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                isloading
                    ? const Center(
                        child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: CircularProgressIndicator(),
                      ))
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: budget.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 22,
                          ),
                          child: Divider(
                            height: 6,
                            color: Colors.grey,
                          ),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              print(budget[index].id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BudgetGraphs(
                                    id: budget[index].id.toString(),
                                    date: budget[index].date.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    budget[index].date.toString(),
                                    style: robotoSemiBold.copyWith(
                                      color: AppColors.blackSoftColor,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.03),
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: 100,
                                        child: Text(
                                            "$symbol ${budget[index].totalIncome}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey)),
                                      ),
                                      SizedBox(width: width * 0.03),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: 100,
                                        child: Text(
                                            "$symbol  ${budget[index].totalExpenses}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: AppColors.borderColor,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
