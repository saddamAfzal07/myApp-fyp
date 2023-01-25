import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:http/http.dart' as http;

class EditBudget extends StatefulWidget {
  int income;
  String id;
  EditBudget({Key? key, required this.income, required this.id})
      : super(key: key);

  @override
  State<EditBudget> createState() => _EditBudgetState();
}

class _EditBudgetState extends State<EditBudget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Each Category Percentage % must be selected")));
    } else {
      print("Go for update");
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
  }

  double? needsPer = 0;
  double? wantsPer = 0;
  double? savingsPer = 0;
  percentage() async {
    setState(() {
      needsPer = (need / 100) * widget.income;
      wantsPer = (want / 100) * widget.income;
      savingsPer = (saving / 100) * widget.income;
    });
    print("needs${needsPer}");
    print("wants${wantsPer}");
    print("savings ${savingsPer}");
    await Future.delayed(Duration(seconds: 2));
    addBudget();
  }

  addBudget() async {
    print("Enter into Api");
    String token = await ApiResponse().getToken();
    var response = await http.patch(
        Uri.parse("https://www.myhoneypot.app/api/smart-budget/${widget.id}"),
        body: {
          'needsPercentage': needsController.text,
          'wantsPercentage': wantsController.text,
          'savingsPercentage': savingsController.text
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Charset': 'utf-8'
        });
    print(response.body);
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      print("Successfully updated");
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.1),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Edit Budget",
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
                  widget.income.toString(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    "RM ${needsPer!.toStringAsFixed(2)}",
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
