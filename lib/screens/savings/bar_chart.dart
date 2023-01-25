import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/models/savings/savings_model.dart';
import 'package:myhoneypott/screens/savings/model.dart';

// ignore: must_be_immutable
class BarChartScreen extends StatefulWidget {
  List<MonthlySavings> savebarChart;
  BarChartScreen({Key? key, required this.savebarChart}) : super(key: key);

  @override
  State<BarChartScreen> createState() => _BarChartScreenState();
}

class _BarChartScreenState extends State<BarChartScreen> {
  List<charts.Series<MonthlySavings, String>> _createSampleData() {
    return [
      charts.Series<MonthlySavings, String>(
        data: widget.savebarChart,
        id: 'id',
        // colorFn: (_, __) => charts.MaterialPalette.gray.shade400,
        domainFn: (MonthlySavings barModeel, _) => barModeel.month.toString(),
        measureFn: (MonthlySavings barModeel, _) => barModeel.total,
        colorFn: (MonthlySavings barModeel, _) => barModeel.colorValue,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(5),
        color: Colors.grey.shade100,
        height: 300,
        child: charts.BarChart(
          _createSampleData(),
          animate: true,
          animationDuration: const Duration(seconds: 2),
        ),
      ),
    );
  }
}
