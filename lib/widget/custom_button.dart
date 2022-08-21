import 'package:flutter/material.dart';

import '../constant/app_colors.dart';
import '../constant/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final double? btnHeight;
  final double? radius;
  final double? fontSize;
  final String? btnText;
  final Color? btnColor;
  final Color? btnFontColor;
  final VoidCallback? onTap;
  final EdgeInsets? btnPadding;

  const CustomButton({
    Key? key,
    this.width,
    this.btnHeight = 45.0,
    this.radius = 5.0,
    this.fontSize = 16.0,
    this.btnText = 'Button Text',
    this.btnColor = AppColors.primaryColor,
    this.btnFontColor = AppColors.whiteColor,
    this.btnPadding,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: btnPadding ?? EdgeInsets.symmetric(horizontal: height * 0.032),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize:
              Size(width ?? MediaQuery.of(context).size.width, btnHeight!),
          primary: btnColor,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius!),
          ),
        ),
        onPressed: onTap,
        child: Center(
          child: Text(
            btnText!,
            style: robotoSemiBold.copyWith(
              fontSize: fontSize,
              color: btnFontColor,
            ),
          ),
        ),
      ),
    );
  }
}
