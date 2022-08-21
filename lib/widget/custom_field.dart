import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';

class CustomField extends StatelessWidget {
  final String? headingText;
  final String? hintText;
  final Color? borderColor;
  final TextStyle? headingFontStyle;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final EdgeInsets? margin;
  final bool? obscureText;
  final int flag;

  const CustomField({
    Key? key,
    required this.controller,
    required this.flag,
    this.headingText = 'Head Text',
    this.hintText = 'Hint Text',
    this.borderColor = AppColors.borderColor,
    this.headingFontStyle,
    this.keyboardType,
    this.margin,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: margin ?? EdgeInsets.symmetric(horizontal: height * 0.032),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            headingText!,
            style: headingFontStyle ??
                robotoRegular.copyWith(
                  fontSize: 14.0,
                  color: AppColors.blackSoftColor,
                ),
          ),
          const SizedBox(height: 6.0),
          Container(
            height: 48.0,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: borderColor!,
                width: 1.0,
              ),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText!,
              readOnly: flag == 1 ? true : false,
              style: robotoLight.copyWith(
                fontSize: 16.0,
                color: AppColors.blackColor,
              ),
              decoration: InputDecoration(
                suffixIcon: flag == 1 ? const Icon(Icons.calendar_today) : null,
                border: InputBorder.none,
                contentPadding: flag == 1
                    ? const EdgeInsets.only(left: 8.0, top: 10.0)
                    : const EdgeInsets.only(left: 8.0, bottom: 5.0),
                hintText: hintText,
                hintStyle: robotoLight.copyWith(
                  fontSize: 14.0,
                  color: AppColors.hintTextColor,
                ),
              ),
              onTap: flag == 1
                  ? () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate);

                        controller?.text = formattedDate;
                      } else {
                        print("Date is not selected");
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
