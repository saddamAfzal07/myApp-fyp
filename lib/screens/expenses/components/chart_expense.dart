import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChart1 extends StatefulWidget {
  double percentage;
  String totalExpensesPercentage;
  PieChart1({
    Key? key,
    required this.percentage,
    required this.totalExpensesPercentage,
  }) : super(key: key);

  @override
  State<PieChart1> createState() => _PieChart1State();
}

class _PieChart1State extends State<PieChart1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 190.0,
          child: PieChart(
            dataMap: {
              "Consumed": double.parse(widget.totalExpensesPercentage),
              "Missed": 100.0 - double.parse(widget.totalExpensesPercentage),
            },
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 40,
            chartRadius: MediaQuery.of(context).size.width,
            colorList: [
              Colors.purple.shade200,
              AppColors.footerBorderColor,
            ],
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 16,
            totalValue: 100,
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: false,
              legendShape: BoxShape.rectangle,
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: false,
              showChartValues: false,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          ),
        ),
      ],
    );
  }
}
