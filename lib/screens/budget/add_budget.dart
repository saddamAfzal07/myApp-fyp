import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:http/http.dart' as http;

class AddBudget extends StatefulWidget {
  const AddBudget({Key? key}) : super(key: key);

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  static int expenseMonthSum = 0;
  static int totalIncome = 0;
  static int totalBalance = 0;

  expenseApi(year, month) async {
    setState(() {
      // isLoading = true;
    });

    String token = await UserID.token;
    var response = await http.get(
        Uri.parse("https://www.myhoneypot.app/api/expense/${year}/${month}"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    // print(response.body);
    Map data = jsonDecode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      if (this.mounted) {
        setState(() {
          // isLoading = false;
          expenseMonthSum = data["totalExpenses"];
          totalBalance = data["totalBalance"];
          totalIncome = data["totalIncome"];
        });
      }
    } else {
      // setState(() {
      //   isLoading = false;
      //   setState(() {
      //     isEmpty = false;
      //   });
      // });
    }
  }

  DateTime? selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedDate = DateTime.now();
    expenseApi(selectedDate!.year, selectedDate!.month);
  }

  selectDate(context) {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: selectedDate ?? DateTime.now(),
      locale: const Locale("en"),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          // expensesPerMonth = [];
          // categories = [];
          // chart = [];
          // isEmpty = false;
          // isGraph = true;
        });
        expenseApi(selectedDate!.year, selectedDate!.month);
      }
    });
  }

  TextEditingController needsController = TextEditingController();
  TextEditingController wantsController = TextEditingController();
  TextEditingController savingsController = TextEditingController();
  int need = 0;
  int want = 0;
  int saving = 0;

  getFunction() {
    if (needsController.text.isEmpty ||
        wantsController.text.isEmpty ||
        savingsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(" Percentage % must be selected")));
    } else {
      print("Go for edit budget");
      setState(() {
        need = int.parse(needsController.text);
        want = int.parse(wantsController.text);
        saving = int.parse(savingsController.text);
      });

      if (need + want + saving == 100) {
        print("Go for update");
        percentage();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Addition of every category mst be equal to 100% of Income")));
      }
    }
    // } else {
    //   if (needsController.text.isEmpty && wantsController.text.isEmpty) {
    //     need = 0;
    //     want = 0;
    //     saving = int.parse(savingsController.text);
    //     percentage();
    //   } else if (needsController.text.isEmpty &&
    //       savingsController.text.isEmpty) {
    //     need = 0;
    //     want = int.parse(wantsController.text);
    //     saving = 0;
    //     percentage();
    //   }
    //   if (needsController.text.isEmpty) {
    //     need = 0;
    //     want = int.parse(wantsController.text);
    //     saving = int.parse(savingsController.text);
    //     percentage();
    //   } else if (wantsController.text.isEmpty && needsController.text.isEmpty) {
    //     want = 0;
    //     need = 0;
    //     saving = int.parse(savingsController.text);
    //     percentage();
    //   } else if (wantsController.text.isEmpty &&
    //       savingsController.text.isEmpty) {
    //     want = 0;
    //     need = int.parse(needsController.text);
    //     saving = 0;
    //     percentage();
    //   } else if (wantsController.text.isEmpty) {
    //     want = 0;
    //     need = int.parse(needsController.text);
    //     saving = int.parse(savingsController.text);
    //     percentage();
    //   } else if (savingsController.text.isEmpty &&
    //       needsController.text.isEmpty) {
    //     saving = 0;
    //     need = 0;
    //     want = int.parse(wantsController.text);
    //     percentage();
    //   } else if (savingsController.text.isEmpty &&
    //       wantsController.text.isEmpty) {
    //     saving = 0;
    //     need = int.parse(needsController.text);

    //     want = 0;
    //     percentage();
    //   } else if (savingsController.text.isEmpty) {
    //     saving = 0;
    //     need = int.parse(needsController.text);
    //     want = int.parse(wantsController.text);
    //     percentage();
    //   } else if (savingsController.text.isNotEmpty &&
    //       wantsController.text.isNotEmpty &&
    //       needsController.text.isNotEmpty) {
    //     print("Enter");

    //     saving = int.parse(savingsController.text);
    //     need = int.parse(needsController.text);
    //     want = int.parse(wantsController.text);
    //     percentage();
    //   }
    // }
  }

  double? needsPer = 0;
  double? wantsPer = 0;
  double? savingsPer = 0;
  percentage() async {
    setState(() {
      needsPer = (need / 100) * totalIncome;
      wantsPer = (want / 100) * totalIncome;
      savingsPer = (saving / 100) * totalIncome;
    });
    print("needs${needsPer}");
    print("wants${wantsPer}");
    print("savings ${savingsPer}");
    await Future.delayed(Duration(seconds: 2));
    addBudget();
  }

  addBudget() async {
    print("Enter into Edit budget Api");
    String token = await UserID.id;
    var response = await http
        .post(Uri.parse("https://www.myhoneypot.app/api/smart-budget"), body: {
      'date': "0${selectedDate!.month}${selectedDate!.year}",
      'needsPercentage': needsController.text,
      'wantsPercentage': wantsController.text,
      'savingsPercentage': savingsController.text,
    }, headers: {
      'Authorization': 'Bearer $token',
      'Charset': 'utf-8'
    });
    // print(response.body);
    // print("0${selectedDate!.month}${selectedDate!.year}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("success");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data["message"])));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.borderColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.1),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Add Budget",
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              const Text(
                "Find the right allocation for your particular financial situation",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.borderColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.03),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Income",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: height * 0.001),
              Align(
                alignment: Alignment.center,
                child: Text(
                  totalIncome.toString(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  Text(
                    "Select Month",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Income for ${DateFormat.yMMMM().format(selectedDate!).toString()}",
                    style: robotoSemiBold.copyWith(
                      color: AppColors.blackSoftColor,
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: () {
                        selectDate(context);
                      },
                      child: const Icon(
                        Icons.calendar_month,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Needs",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                  SizedBox(width: width * 0.1),
                  Container(
                    alignment: Alignment.center,
                    height: height * 0.06,
                    width: width * 0.35,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextField(
                          controller: needsController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "%",
                            hintStyle: TextStyle(
                              fontSize: 25.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.05),
                  Text(
                    // "RM ${needsPer!.toStringAsFixed(2)}",
                    "RM1000",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Wants",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                  SizedBox(width: width * 0.1),
                  Container(
                    alignment: Alignment.center,
                    height: height * 0.06,
                    width: width * 0.35,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        controller: wantsController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "%",
                          hintStyle: TextStyle(
                            fontSize: 25.0,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.05),
                  Text(
                    "RM ${wantsPer!.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Savings",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                  SizedBox(width: width * 0.07),
                  Container(
                    alignment: Alignment.center,
                    height: height * 0.06,
                    width: width * 0.35,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        controller: savingsController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "%",
                          hintStyle: TextStyle(
                            fontSize: 25.0,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.05),
                  Text(
                    "RM ${savingsPer!.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),
              InkWell(
                onTap: () {
                  getFunction();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  height: 50,
                  width: double.infinity,
                  child: const Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
