import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/models/add_expense.dart';
import 'package:myhoneypott/models/category_model.dart';
import 'package:myhoneypott/services/category_service.dart';
import 'package:myhoneypott/services/http_client.dart';
import 'package:myhoneypott/widget/custom_button.dart';
import 'package:myhoneypott/widget/custom_field.dart';

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({Key? key}) : super(key: key);

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  TextEditingController descriptionController = TextEditingController();

  TextEditingController dateController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  late List<String> categories = [];

  late List<CategoryDetails>? _categoryDetails = [];

  String? value;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  getCategories() async {
    var json = await fetchCategory();

    setState(() {
      _categoryDetails = json;
      categories.addAll(json.map((e) => e.description!));
      // categories.insert(0, "Select Category");
      // value = categories.first;
    });
  }

  Future<AddExpense> addExpenseAPI(Map<String, String> params) async {
    String response = await HttpClient().postHttpRequest(params);

    Map<String, dynamic> addExpense = jsonDecode(response.toString());

    AddExpense addedExpense = AddExpense.fromJson(addExpense);
    return addedExpense;
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.borderColor,
          ),
        ),
      ),
      body: _categoryDetails == null || _categoryDetails!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///Add Expense texts
                  SizedBox(height: height * 0.1),
                  Center(
                    child: Text(
                      'Add Expense',
                      style: robotoSemiBold.copyWith(
                        fontSize: 20.0,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),

                  /// description field
                  SizedBox(height: height * 0.036),
                  CustomField(
                    controller: descriptionController,
                    headingText: 'Description',
                    hintText: 'Add description',
                    flag: 0,
                  ),

                  /// date field
                  SizedBox(height: height * 0.024),
                  CustomField(
                    controller: dateController,
                    headingText: 'Date',
                    hintText: 'Select date',
                    flag: 1,
                  ),

                  /// total field
                  SizedBox(height: height * 0.024),
                  CustomField(
                    controller: totalController,
                    headingText: 'Total',
                    hintText: 'Total Amount',
                    flag: 0,
                    keyboardType: TextInputType.number,
                  ),

                  /// total field
                  SizedBox(height: height * 0.024),
                  // CustomField(
                  //   controller: categoryController,
                  //   headingText: 'Category',
                  //   hintText: 'Select Category',
                  //   flag: 3,
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: height * 0.032),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Category',
                          style: robotoRegular.copyWith(
                            fontSize: 14.0,
                            color: AppColors.blackSoftColor,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Container(
                          height: 48.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1.0,
                            ),
                          ),
                          child: DropdownButton<String>(
                            underline: const SizedBox(),
                            value: value,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.expand_more,
                              color: Colors.white,
                            ),
                            hint: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Select Category',
                                style:
                                    TextStyle(color: AppColors.hintTextColor),
                              ),
                            ),
                            items: categories.map(buildMenuItem).toList(),
                            onChanged: (value) =>
                                setState(() => this.value = value!),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Save button
                  SizedBox(height: height * 0.024),
                  CustomButton(
                    onTap: () async {
                      Map<String, String> requiredParams = {
                        'description': descriptionController.text,
                        'date': dateController.text,
                        'total': totalController.text,
                        'category': value!,
                      };
                      AddExpense addExpense =
                          await addExpenseAPI(requiredParams);

                      if (addExpense.messageExpense ==
                          "Expense has been successfully added") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Record Added'),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ));
                      }
                    },
                    btnText: 'Save',
                  ),
                ],
              ),
            ),
    );
  }
}
