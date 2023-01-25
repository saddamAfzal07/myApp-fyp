import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myhoneypott/constant/apis_expense.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/widget/custom_button.dart';

import '../../../constant/app_colors.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

class SavingsDialog extends StatefulWidget {
  const SavingsDialog({Key? key}) : super(key: key);

  @override
  State<SavingsDialog> createState() => _SavingsDialogState();
}

class _SavingsDialogState extends State<SavingsDialog> {
  TextEditingController controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool loading = false;
  addSaving() async {
    var token = await UserID.token;
    var response = await http.post(
        Uri.parse(
            "https://www.myhoneypot.app/api/savings-transfer?id=$mySelectedId&amount=${controller.text}"),
        headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> responsedata = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Budget Added Successfully"),
        ),
      );
      Navigator.pop(context);
    } else {
      setState(() {
        loading = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Something went wrong Try Again")));
        Navigator.pop(context);
      });
    }
  }

  sendData() {
    if (controller.text.isNotEmpty && mySelectedId != null) {
      addSaving();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade400,
          content: const Text(
            "Both Fields are required ",
          ),
        ),
      );
    }
  }

  List? savingDropdownList;
  String? mySelectedId;
  _getlistSavings() async {
    String token = await UserID.token;
    await http.get(Uri.parse("https://www.myhoneypot.app/api/goals"), headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    }).then((response) {
      var data = jsonDecode(response.body);
      setState(() {
        savingDropdownList = data["goals"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getlistSavings();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
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
              radius: 30,
              backgroundColor: AppColors.greyDarkColor,
              child: Container(
                  padding: const EdgeInsets.all(1.0),
                  child: const CircleAvatar(
                    radius: 70,

                    backgroundColor: Colors.white,
                    child: Icon(
                      LucideIcons.piggyBank,
                      color: AppColors.primaryColor,
                      size: 25,
                    ),
                    //
                  )),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Transfer Savings',
              style: robotoSemiBold.copyWith(
                fontSize: 16.0,
                color: AppColors.blackSoftColor,
              ),
            ),
            const SizedBox(height: 1.0),
            Text(
              'Select a goal to transfer you saving',
              textAlign: TextAlign.center,
              style: robotoLight.copyWith(
                fontSize: 12.0,
                color: AppColors.greyDarkColor,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              height: 46.0,
              margin: const EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: AppColors.greyColor,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          value: mySelectedId,
                          isExpanded: true,
                          iconSize: 30,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.greyColor,
                          ),
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                          ),
                          hint: const Text(""),
                          onChanged: (String? newValue) {
                            setState(() {
                              mySelectedId = newValue.toString();

                              _getlistSavings();
                              print(mySelectedId);
                            });
                          },
                          items: savingDropdownList?.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item['description']),
                                  value: item['id'].toString(),
                                );
                              }).toList() ??
                              [],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total Amount',
                style: robotoSemiBold.copyWith(
                  fontSize: 12.0,
                  color: AppColors.blackSoftColor,
                ),
              ),
            ),
            Container(
              height: 50.0,
              margin: const EdgeInsets.only(right: 16.0),
              child: Form(
                key: _formkey,
                child: TextFormField(
                  // validator:
                  //     RequiredValidator(errorText: 'This field is required'),
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '1500',
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
            const SizedBox(height: 10.0),
            CustomButton(
              onTap: () {
                sendData();
              },
              btnText: 'Ok',
              btnPadding: const EdgeInsets.only(right: 16.0),
            )
          ],
        ),
      ),
    );
  }
}
