import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/screens/custom_chart_data.dart';

class Dash2 extends StatefulWidget {
  const Dash2({Key? key}) : super(key: key);

  @override
  State<Dash2> createState() => _Dash2State();
}

class _Dash2State extends State<Dash2> {
  bool expenseVisibility = true;
  bool incomeVisibility = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ENTER dashboard 2");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //// chart
          SizedBox(height: height * 0.024),
          const CustomChartData(),
          // Container(
          //   // color: Colors.green,
          //   alignment: Alignment.topCenter,
          //   height: 200,
          //   child: Padding(
          //     padding: const EdgeInsets.all(12.0),
          //     child: Image.asset("assets/images/notfound.png",
          //         height: 50, width: 50, color: Colors.grey.withOpacity(0.6)),
          //   ),
          // ),
          SizedBox(height: height * 0.016),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    expenseVisibility = true;
                    incomeVisibility = false;
                  });
                },
                child: Text(
                  "Expenses",
                  style: robotoSemiBold.copyWith(
                    color: expenseVisibility
                        ? AppColors.blackSoftColor
                        : AppColors.hintTextColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    expenseVisibility = false;
                    incomeVisibility = true;
                  });
                },
                child: Text(
                  "Income",
                  style: robotoSemiBold.copyWith(
                    color: incomeVisibility
                        ? AppColors.blackSoftColor
                        : AppColors.hintTextColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          //   /// chart data
          SizedBox(height: height * 0.016),
          Visibility(
            visible: expenseVisibility,
            child: Container(
              // color: Colors.green,
              alignment: Alignment.topLeft,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(left: 100),
                child: Image.asset("assets/images/notfound.png",
                    height: 50, width: 50, color: Colors.grey.withOpacity(0.6)),
              ),
            ),
          ),

          Visibility(
            visible: incomeVisibility,
            child: Container(
              // color: Colors.green,
              alignment: Alignment.topRight,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(right: 100),
                child: Image.asset("assets/images/notfound.png",
                    height: 50, width: 50, color: Colors.grey.withOpacity(0.6)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
