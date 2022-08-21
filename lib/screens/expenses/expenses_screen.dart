import 'package:flutter/material.dart';
import 'package:myhoneypott/models/expenses_model.dart';
import 'package:myhoneypott/screens/custom_chart_data.dart';
import 'package:myhoneypott/widget/custom_month_dropdown.dart';

import '../../constant/app_colors.dart';

class ExpensesScreen extends StatefulWidget {
  final List<ExpensesAllMonth> monthExpenses;
  final List<String> uniqueMonths;

  const ExpensesScreen(
      {Key? key, required this.monthExpenses, required this.uniqueMonths})
      : super(key: key);

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
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
            //// chart
            SizedBox(height: height * 0.024),
            const CustomChartData(),

            /// month dropdown
            SizedBox(height: height * 0.016),
            CustomMonthDropDown(
              monthExpenses: widget.monthExpenses,
              uniqueMonths: widget.uniqueMonths,
              flag: true,
            ),
          ],
        ),
      ),
    );
  }
}
