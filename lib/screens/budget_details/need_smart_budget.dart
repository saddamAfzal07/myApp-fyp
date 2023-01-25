import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:http/http.dart' as http;

class NeedEditSmartBudget extends StatefulWidget {
  double need;
  String id;
  NeedEditSmartBudget({Key? key, required this.need, required this.id})
      : super(key: key);

  @override
  State<NeedEditSmartBudget> createState() => _NeedEditSmartBudgetState();
}

class _NeedEditSmartBudgetState extends State<NeedEditSmartBudget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.need);
  }

  TextEditingController housingController = TextEditingController();
  TextEditingController utilityController = TextEditingController();
  TextEditingController groceryController = TextEditingController();
  TextEditingController transportationController = TextEditingController();

  getFunction() {
    if (housingController.text.isEmpty ||
        utilityController.text.isEmpty ||
        groceryController.text.isEmpty ||
        transportationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Every Category % must be selected")));
    } else {
      print("Go for update");
      setState(() {
        housing = int.parse(housingController.text);
        utility = int.parse(utilityController.text);
        grocery = int.parse(groceryController.text);
        transporation = int.parse(transportationController.text);
      });

      if (housing + utility + grocery + transporation == 100) {
        print("Go for update");
        percentage();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Addition of every category mst be equal to 100% of Need")));
      }
    }
  }

  int housing = 0;
  int utility = 0;
  int grocery = 0;
  int transporation = 0;

  double? housingPer = 0;
  double? utilityPer = 0;
  double? groceryPer = 0;
  double? transporPer = 0;
  percentage() async {
    setState(() {
      housingPer = (housing / 100) * widget.need;
      utilityPer = (utility / 100) * widget.need;
      groceryPer = (grocery / 100) * widget.need;
      transporPer = (transporation / 100) * widget.need;
    });

    addBudget();
  }

  addBudget() async {
    print("Enter into need Api");
    String token = await ApiResponse().getToken();
    var response = await http.patch(
        Uri.parse("https://www.myhoneypot.app/api/smart-budget/N/${widget.id}"),
        body: {
          'housing': housingController.text,
          'utilities': utilityController.text,
          'groceries': groceryController.text,
          'transportation': transportationController.text
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Charset': 'utf-8'
        });

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("success");
      print(response.body);
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
                  "Smart Budget",
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
                  "Needs",
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
                  widget.need.toString().substring(0, 6),
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
                    "Housing",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                  SizedBox(width: width * 0.18),
                  Container(
                    alignment: Alignment.center,
                    height: height * 0.06,
                    width: width * 0.25,
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
                          controller: housingController,
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
                    "RM ${housingPer!.toStringAsFixed(2)}",
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
                    "Utilities",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                  SizedBox(width: width * 0.19),
                  Container(
                    alignment: Alignment.center,
                    height: height * 0.06,
                    width: width * 0.25,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        controller: utilityController,
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
                    "RM ${utilityPer!.toStringAsFixed(2)}",
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
                    "Groceries",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                  SizedBox(width: width * 0.15),
                  Container(
                    alignment: Alignment.center,
                    height: height * 0.06,
                    width: width * 0.25,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        controller: groceryController,
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
                    "RM ${groceryPer!.toStringAsFixed(2)}",
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
                    "Transportation",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                  SizedBox(width: width * 0.05),
                  Container(
                    alignment: Alignment.center,
                    height: height * 0.06,
                    width: width * 0.25,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        controller: transportationController,
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
                    "RM ${transporPer!.toStringAsFixed(2)}",
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
                  // addBudget();
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
