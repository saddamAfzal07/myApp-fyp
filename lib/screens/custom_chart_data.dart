import 'package:flutter/material.dart';
import 'package:myhoneypott/models/expenses_model.dart';
import 'package:myhoneypott/services/expenses_service.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../constant/app_colors.dart';

class CustomChartData extends StatefulWidget {
  const CustomChartData({Key? key}) : super(key: key);

  @override
  State<CustomChartData> createState() => _CustomChartDataState();
}

class _CustomChartDataState extends State<CustomChartData> {
  TooltipBehavior? _tooltipBehavior;

  bool loading = false;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      color: AppColors.primaryColor,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: fetchExpense(),
        builder: (BuildContext context,
            AsyncSnapshot<ExpensesModel> expenseSnapshot) {
          List<ExpenseData>? expenses = expenseSnapshot.data?.expense;

          // print(expenses);
          return expenses != null
              ? SizedBox(
                  child: SizedBox(
                    width: width * 0.95,
                    height: height * 0.35,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      legend: Legend(isVisible: false),
                      tooltipBehavior: _tooltipBehavior,
                      series: <LineSeries<ExpenseData, String>>[
                        LineSeries<ExpenseData, String>(
                          dataSource: expenses
                              .map<ExpenseData>(
                                (e) =>
                                    ExpenseData(date: e.date!, total: e.total!),
                              )
                              .toList(),
                          color: AppColors.primaryColor,
                          xValueMapper: (ExpenseData sales, _) => sales.date,
                          yValueMapper: (ExpenseData sales, _) => sales.total,
                          markerSettings: const MarkerSettings(isVisible: true),
                        )
                      ],
                    ),
                  ),
                )
              : Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Retrieving JSON data',
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                );
        });
  }
}
