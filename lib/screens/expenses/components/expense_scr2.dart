import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/screens/custom_chart_data.dart';

class ExpenceScreen2 extends StatelessWidget {
  const ExpenceScreen2({Key? key}) : super(key: key);

  @override
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
            Container(
              // color: Colors.green,
              alignment: Alignment.topCenter,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset("assets/images/notfound.png",
                    height: 50, width: 50, color: Colors.grey.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
