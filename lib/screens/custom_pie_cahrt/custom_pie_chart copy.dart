import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:pie_chart/pie_chart.dart';

class CustomPieChart extends StatefulWidget {
  double Utilities,
      Commission,
      Others,
      Housing,
      Groceries,
      Transportation,
      Personal,
      Diningout,
      Entertainment;
  // Map<String, dynamic> data;
  CustomPieChart(
      {Key? key,
      //  required this.data
      required this.Commission,
      required this.Diningout,
      required this.Entertainment,
      required this.Groceries,
      required this.Housing,
      required this.Others,
      required this.Personal,
      required this.Transportation,
      required this.Utilities})
      : super(key: key);

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  // Map<String, double> res = {
  //   "Utilities": widget.Utilities,
  //   "Clothes": 17.70,
  //   "Technology": 4.25,
  //   "Cosmetics": 3.51,
  //   "Other": 2.83,
  // };

  int choiceIndex = 0;
  List<Color> colorList = [
    // const Color(0xffD95AF3),
    // const Color(0xff3EE094),
    // const Color(0xff3398F6),
    // const Color(0xffFA4A42),
    // const Color(0xffFE9539),
    const Color(0xffffffff),
    const Color(0xffb0a9ec),
    const Color(0xff8585f0),
    const Color(0xfffab4f0),
    const Color(0xffffb1d0),
    const Color(0xffffbda3),
    const Color(0xffffd87b),
    const Color(0xff7bd5ff),
    const Color(0xff23ecff),
    const Color(0xfffffaed),
  ];

  // final gradientList = <List<Color>>[
  //   [
  //     const Color.fromRGBO(223, 250, 92, 1),
  //     const Color.fromRGBO(129, 250, 112, 1),
  //   ],
  //   [
  //     const Color.fromRGBO(129, 182, 205, 1),
  //     const Color.fromRGBO(91, 253, 199, 1),
  //   ],
  //   [
  //     const Color.fromRGBO(175, 63, 62, 1.0),
  //     const Color.fromRGBO(254, 154, 92, 1),
  //   ]
  // ];

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: {
        "none": 0.0,
        "Utilities": widget.Utilities,
        "Commission": widget.Commission,
        "Housing": widget.Housing,
        "Groceries": widget.Groceries,
        "Transportation": widget.Transportation,
        "Personal": widget.Personal,
        "Dining out": widget.Diningout,
        "Entertainment": widget.Entertainment,
        "Other": widget.Others,
      },
      initialAngleInDegree: 280,
      colorList: colorList,
      chartRadius: MediaQuery.of(context).size.width / 2.8,
      chartType: ChartType.ring,
      chartValuesOptions: const ChartValuesOptions(
          showChartValues: true,
          showChartValuesOutside: true,
          showChartValuesInPercentage: true,
          showChartValueBackground: true),
      legendOptions: const LegendOptions(
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(fontSize: 12, color: AppColors.whiteColor),
          legendPosition: LegendPosition.bottom,
          showLegendsInRow: true),
      // gradientList: gradientList,
    );
  }
}
