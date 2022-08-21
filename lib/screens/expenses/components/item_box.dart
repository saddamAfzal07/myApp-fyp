import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/models/expenses_model.dart';
import 'package:myhoneypott/screens/expenses/edit_expenses_screen.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_icons.dart';
import '../../../constant/app_text_styles.dart';

class ItemBox extends StatelessWidget {
  final ExpensesAllMonth monthlyExpense;
  final String monthName;

  const ItemBox({
    Key? key,
    required this.monthlyExpense,
    required this.monthName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
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
                  monthName.split(" ")[0],
                  style: robotoRegular.copyWith(
                    color: AppColors.blackSoftColor,
                    fontSize: 10.0,
                  ),
                ),
                Text(
                  monthlyExpense.formatted_date!.split(" ")[1],
                  style: robotoSemiBold.copyWith(
                    color: AppColors.blackSoftColor,
                    fontSize: 16.0,
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
                  monthlyExpense.category!.description!,
                  style: robotoRegular.copyWith(
                    fontSize: 14.0,
                    color: AppColors.blackSoftColor,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  monthlyExpense.description!,
                  style: robotoRegular.copyWith(
                    fontSize: 14.0,
                    color: AppColors.blackSoftColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'RM ${monthlyExpense.total!.toStringAsFixed(2)}',
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
              Get.to(EditExpenseScreen(monthlyExpense: monthlyExpense));
            },
            icon: SvgPicture.asset(AppIcons.editIcon),
          ),
        ],
      ),
    );
  }
}
