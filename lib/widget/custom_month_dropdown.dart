import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myhoneypott/constant/app_icons.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/models/expenses_model.dart';
import 'package:myhoneypott/screens/expenses/components/item_box.dart';

import 'package:swipeable_tile/swipeable_tile.dart';
import '../constant/app_colors.dart';

class CustomMonthDropDown extends StatefulWidget {
  final List<ExpensesAllMonth> monthExpenses;
  final List<String> uniqueMonths;
  final bool flag;

  const CustomMonthDropDown(
      {Key? key,
      required this.uniqueMonths,
      required this.monthExpenses,
      required this.flag})
      : super(key: key);

  @override
  State<CustomMonthDropDown> createState() => _CustomMonthDropDownState();
}

class _CustomMonthDropDownState extends State<CustomMonthDropDown> {
  /// month dropdown items
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Jan 2022", child: Text("Jan 2022")),
      const DropdownMenuItem(value: "Feb 2022", child: Text("Feb 2022")),
      const DropdownMenuItem(value: "Mar 2022", child: Text("Mar 2022")),
      const DropdownMenuItem(value: "Apr 2022", child: Text("Apr 2022")),
      const DropdownMenuItem(value: "May 2022", child: Text("May 2022")),
      const DropdownMenuItem(value: "Jun 2022", child: Text("Jun 2022")),
      const DropdownMenuItem(value: "Jul 2022", child: Text("Jul 2022")),
      const DropdownMenuItem(value: "Aug 2022", child: Text("Aug 2022")),
      const DropdownMenuItem(value: "Sep 2022", child: Text("Sep 2022")),
      const DropdownMenuItem(value: "Oct 2022", child: Text("Oct 2022")),
      const DropdownMenuItem(value: "Nov 2022", child: Text("Nov 2022")),
      const DropdownMenuItem(value: "Dec 2022", child: Text("Dec 2022")),
    ];
    return menuItems;
  }

  String selectedValue = 'Jun 2022';

  @override
  void initState() {
    selectedValue = "${widget.uniqueMonths.first} 2022";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: height * 0.024),
          height: 40.0,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1.0,
            ),
          ),
          child: DropdownButton(
            value: selectedValue,
            items: widget.uniqueMonths
                .map(
                  (month) => DropdownMenuItem(
                    value: "$month 2022",
                    child: Text("$month 2022"),
                  ),
                )
                .toList(),
            hint: Text(
              selectedValue,
              style: robotoSemiBold.copyWith(
                fontSize: 16.0,
                color: AppColors.blackSoftColor,
              ),
            ),
            style: robotoSemiBold.copyWith(
              fontSize: 16.0,
              color: AppColors.blackSoftColor,
            ),
            underline: const SizedBox(),
            icon: SvgPicture.asset(AppIcons.dropDownIcon),
            isExpanded: true,
            onChanged: (String? value) {
              selectedValue = value!;
              setState(() {});
            },
          ),
        ),

        /// items list
        widget.flag
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.monthExpenses.length,
                itemBuilder: (context, index) {
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
                            content: const Text(
                                "Are you sure you want to delete it?"),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
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
                    child: ItemBox(
                      monthlyExpense: widget.monthExpenses[index],
                      monthName: selectedValue,
                    ),
                  );
                },
              )
            : Container(),
      ],
    );
  }
}
