import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';

import '../../constant/app_colors.dart';

class CustomProgressBar extends StatelessWidget {
  final String? text;
  final String? percentText;
  final double? progressBarWidth;

  const CustomProgressBar({
    Key? key,
    required this.text,
    required this.percentText,
    required this.progressBarWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text!,
                style: robotoLight.copyWith(
                  fontSize: 16.0,
                  color: AppColors.blackSoftColor,
                ),
              ),
              Text(
                " $percentText%",
                style: robotoLight.copyWith(
                  fontSize: 16.0,
                  color: AppColors.blackSoftColor,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.012),
          Stack(
            children: [
              Container(
                height: 11.0,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11.0),
                  color: AppColors.whiteOneColor,
                ),
              ),
              Container(
                height: 11.0,
                width: progressBarWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11.0),
                  color: AppColors.primaryOneColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
