import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../constant/app_colors.dart';

class CustomPieChart extends StatefulWidget {
  const CustomPieChart({Key? key}) : super(key: key);

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  Map<String, double> dataMap = {
    "Consumed": 2,
    "Missed": 1,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: PieChart(
        dataMap: dataMap,
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
        totalValue: 3,
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
