import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/apis_expense.dart';

import '../constant/app_colors.dart';
import '../constant/app_text_styles.dart';

class IncomeAndExpense extends StatefulWidget {
  int expenseMonthSum;
  int totalIncome;
  int totalBalance;
  IncomeAndExpense(
      {Key? key,
      required this.expenseMonthSum,
      required this.totalBalance,
      required this.totalIncome})
      : super(key: key);

  @override
  State<IncomeAndExpense> createState() => _IncomeAndExpenseState();
}

class _IncomeAndExpenseState extends State<IncomeAndExpense> {
  @override
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: height * 0.014),
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
              text: 'RM ',
              style: robotoBold.copyWith(
                fontSize: 20.0,
                color: Colors.lightGreen,
              ),
            ),
            TextSpan(
              text: widget.totalBalance.toString(),
              style: robotoBold.copyWith(
                fontSize: 40.0,
                color: Colors.lightGreen,
              ),
            )
          ])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        'RM ${widget.totalIncome}',
                        style: robotoBold.copyWith(
                          fontSize: 20.0,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        'RM ${int.parse(widget.totalIncome.toString()) + int.parse(widget.totalBalance.toString())}',
                        style: robotoBold.copyWith(
                          fontSize: 20.0,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
