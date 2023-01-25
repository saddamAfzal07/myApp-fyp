import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/controller/expense_controller.dart';
import 'package:myhoneypott/models/add_expense.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/category_model.dart';
import 'package:myhoneypott/models/expense_permonth_model.dart';
import 'package:myhoneypott/screens/expenses/expenses_screen.dart';
import 'package:myhoneypott/screens/logindialogues/error_dialouge.dart';
import 'package:myhoneypott/screens/logindialogues/login_dialogue.dart';
import 'package:myhoneypott/services/category_service.dart';
import 'package:myhoneypott/services/http_client.dart';
import 'package:myhoneypott/widget/custom_button.dart';
import 'package:myhoneypott/widget/custom_field.dart';
import 'package:http/http.dart' as http;
import 'package:d_chart/d_chart.dart';
import 'package:provider/provider.dart';

class AddExpensesScreen extends StatefulWidget {
  // final BuildContext context;
  const AddExpensesScreen({
    Key? key,
  }) : super(key: key);

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
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    getCategories();

    selectedDate = DateTime.now();
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
    final state = Provider.of<ExpenseController>(context);

    double height = MediaQuery.of(context).size.height;
    addExpenses() async {
      print("Enter into Api");
      String token = await UserID.token;
      var response = await http.post(Uri.parse("$baseURL/expense"), body: {
        'description': descriptionController.text,
        'date': dateController.text,
        'total': totalController.text,
        'category': value!,
      }, headers: {
        'Authorization': 'Bearer $token',
        'Charset': 'utf-8'
      });
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        print("Successfully updated");
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding:
                    const EdgeInsets.only(top: 100, left: 20, right: 20),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: Container(
                  width: double.infinity,
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
                            Navigator.pop(context);
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
                                Icons.done,
                                color: AppColors.primaryColor,
                                size: 40,
                              ),
                              //
                            )),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Done",
                        style: robotoSemiBold.copyWith(
                          fontSize: 20.0,
                          color: AppColors.blackSoftColor,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Text(
                        "Successfully Completed",
                        textAlign: TextAlign.center,
                        style: robotoLight.copyWith(
                          fontSize: 14.0,
                          color: AppColors.greyDarkColor,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      CustomButton(
                        onTap: () {
                          print("back");
                          // Navigator.pop(context);
                          Get.back();
                          state.expenseApi(
                              selectedDate!.year, selectedDate!.month, context);
                        },
                        btnText: 'ok',
                        btnPadding: const EdgeInsets.only(right: 16.0),
                      )
                    ],
                  ),
                ),
              );
            });
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding:
                    const EdgeInsets.only(top: 100, left: 20, right: 20),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: ErrorAccountdialogue(
                    title: "Error", message: "Something went wrong"),
              );
            });
      }
    }

    return Scaffold(
      // backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () async {
            Get.back();
            state.expenseApi(selectedDate!.year, selectedDate!.month, context);
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
                            onChanged: (value) => setState(() {
                              this.value = value!;
                              print(value);
                            }),
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
                    onTap: () {
                      if (descriptionController.text.isNotEmpty &&
                          dateController.text.isNotEmpty &&
                          totalController.text.isNotEmpty &&
                          value != null) {
                        print("not null");
                        addExpenses();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Each details are required'),
                          duration: Duration(seconds: 5),
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
