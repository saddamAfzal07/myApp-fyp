import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:pie_chart/pie_chart.dart';

class CustomPieChart1 extends StatefulWidget {
  double percentage;
  CustomPieChart1({Key? key, required this.percentage}) : super(key: key);

  @override
  State<CustomPieChart1> createState() => _CustomPieChart1State();
}

class _CustomPieChart1State extends State<CustomPieChart1> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: PieChart(
        dataMap: {
          "Consumed": widget.percentage,
          "Missed": 100.0 - widget.percentage,
        },
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 40,
        chartRadius: MediaQuery.of(context).size.width,
        colorList: const [
          AppColors.primaryColor,
          AppColors.footerBorderColor,
        ],
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 12,
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
    );
  }
}
