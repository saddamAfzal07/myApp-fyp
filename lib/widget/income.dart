import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_icons.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/income_all_month.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import '../../constant/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as client;

import '../screens/expenses/components/edit_income.dart';

class IncomePage extends StatefulWidget {
  List<IncomeAllMonth> income = [];
  IncomePage({Key? key, required this.income}) : super(key: key);

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  deleteIncome(String id) async {
    print(id);
    String token = await ApiResponse().getToken();

    var uri = Uri.parse("https://www.myhoneypot.app/api/income/${id}");

    final http.Response response = await http.delete(
      uri,
      headers: {
        client.HttpHeaders.acceptHeader: "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    Map data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("Successfull deleted");
    } else {
      print("Error deleted");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      // physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.income.length,
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        return SwipeableTile(
            color: Colors.white,
            swipeThreshold: 0.2,
            direction: SwipeDirection.endToStart,
            onSwiped: (direction) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Alert!"),
                    content: const Text("Are you sure you want to delete it?"),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          deleteIncome(widget.income[index].id.toString());
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            backgroundBuilder: (context, direction, progress) {
              if (direction == SwipeDirection.endToStart) {
                // return your widget
              } else if (direction == SwipeDirection.startToEnd) {
                // return your widget
              }
              return Container();
            },
            key: UniqueKey(),
            child: Container(
                margin: EdgeInsets.only(
                    left: height * 0.024, right: height * 0.024, top: 15.0),
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: AppColors.borderColor,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.income[index].formattedDate.toString(),
                            style: robotoRegular.copyWith(
                              color: AppColors.blackSoftColor,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.income[index].category!.description
                                .toString(),
                            style: robotoRegular.copyWith(
                              fontSize: 14.0,
                              color: AppColors.blackSoftColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            widget.income[index].description.toString(),
                            style: robotoRegular.copyWith(
                              fontSize: 14.0,
                              color: AppColors.blackSoftColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'RM ${widget.income[index].total.toString()}',
                      style: robotoRegular.copyWith(
                        fontSize: 14.0,
                        color: AppColors.blackSoftColor,
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    const SizedBox(
                      height: 50.0,
                      child: Expanded(
                        child: VerticalDivider(
                          width: 1.0,
                          thickness: 1.0,
                          color: AppColors.borderColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(EditIncomeScreen(
                          monthlyExpense: widget.income[index],
                          id: widget.income[index].id.toString(),
                          category: widget.income[index].category!.description
                              .toString(),
                          date: widget.income[index].formattedDate.toString(),
                          description:
                              widget.income[index].description.toString(),
                          totalAmount: widget.income[index].total.toString(),
                        ));
                      },
                      icon: SvgPicture.asset(AppIcons.editIcon),
                    ),
                  ],
                )));
      }),
    );
  }
}
