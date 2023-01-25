import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/widget/custom_button.dart';

import '../../../constant/app_colors.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

class IncomeDialog extends StatefulWidget {
  const IncomeDialog({Key? key}) : super(key: key);

  @override
  State<IncomeDialog> createState() => _IncomeDialogState();
}

class _IncomeDialogState extends State<IncomeDialog> {
  TextEditingController controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool loading = false;
  smartBudget() async {
    String token = await UserID.id;
    var response = await http.post(
        Uri.parse("https://www.myhoneypot.app/api/budget?income="),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'income': controller.text,
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });

      Map<String, dynamic> responsedata = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Budget Added Successfully")));
      Navigator.pop(context);
    } else if (response.statusCode == 305) {
      setState(() {
        loading = false;
      });
      Map<String, dynamic> responsedata = jsonDecode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(responsedata["message"])));
      Navigator.pop(context);
    } else {
      setState(() {
        loading = false;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong Try Again")));
        Navigator.pop(context);
      });
    }
  }

  sendData() {
    final isvalid = _formkey.currentState!.validate();
    if (isvalid) {
      setState(() {
        loading = true;
      });
      smartBudget();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: width,
          // height: 500,
          padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: AppColors.whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.greyColor,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.greyDarkColor,
                child: Container(
                    padding: const EdgeInsets.all(1),
                    child: const CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      child: Icon(
                        LucideIcons.banknote,
                        color: AppColors.primaryColor,
                        size: 40,
                      ),
                      //
                    )),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Salary',
                style: robotoSemiBold.copyWith(
                  fontSize: 20.0,
                  color: AppColors.blackSoftColor,
                ),
              ),
              const SizedBox(height: 3.0),
              Text(
                'Enter your income below.',
                textAlign: TextAlign.center,
                style: robotoLight.copyWith(
                  fontSize: 14.0,
                  color: AppColors.greyDarkColor,
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                height: 65.0,
                margin: const EdgeInsets.only(right: 16.0),
                child: Form(
                  key: _formkey,
                  child: TextFormField(
                    validator:
                        RequiredValidator(errorText: 'This field is required'),
                    controller: controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'e.g. 5000.00',
                      hintStyle: robotoLight.copyWith(
                        fontSize: 14.0,
                        color: AppColors.greyDarkColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: AppColors.greyColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      onTap: () {
                        sendData();
                      },
                      btnText: 'Yes',
                      btnPadding: const EdgeInsets.only(right: 16.0),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
