import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MonthlySavings {
  String? month;
  int? total;
  // Color colorValue = const Color(0xff4338CA);
  late charts.Color colorValue;

  MonthlySavings({this.month, this.total, required this.colorValue});

  MonthlySavings.fromJson(Map<dynamic, dynamic> json) {
    month = json['Month'];
    total = json['Total'];
    // colorValue = json["value"];
    colorValue = charts.ColorUtil.fromDartColor(AppColors.primaryColor);
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['Month'] = this.month;
    data['Total'] = this.total;
    return data;
  }
}
