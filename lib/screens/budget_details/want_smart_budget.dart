import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:http/http.dart' as http;

class WantsEditSmartBudget extends StatefulWidget {
  double want;
  String id;
  WantsEditSmartBudget({Key? key, required this.want, required this.id})
      : super(key: key);

  @override
  State<WantsEditSmartBudget> createState() => _WantsEditSmartBudgetState();
}

class _WantsEditSmartBudgetState extends State<WantsEditSmartBudget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.want);
  }

  TextEditingController dinningOutController = TextEditingController();
  TextEditingController entertainenmentController = TextEditingController();
  TextEditingController personalController = TextEditingController();
  TextEditingController othersController = TextEditingController();
  int dinningOUT = 0;
  int entertainment = 0;
  int personal = 0;
  int other = 0;
  getFunction() {
    if (dinningOutController.text.isEmpty ||
        entertainenmentController.text.isEmpty ||
        personalController.text.isEmpty ||
        othersController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Every Category % must be selected")));
    } else {
      print("Go for update");
      setState(() {
        dinningOUT = int.parse(dinningOutController.text);
        entertainment = int.parse(entertainenmentController.text);
        personal = int.parse(personalController.text);
        other = int.parse(othersController.text);
      });

      if (dinningOUT + entertainment + personal + other == 100) {
        print("Go for update");
        percentage();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Addition of every category mst be equal to 100% of Wants")));
      }
    }
  }

  double? dinPer = 0;
  double? entPer = 0;
  double? perPer = 0;
  double? otherPer = 0;
  percentage() async {
    setState(() {
      dinPer = (dinningOUT / 100) * widget.want;
      entPer = (entertainment / 100) * widget.want;
      perPer = (personal / 100) * widget.want;
      otherPer = (other / 100) * widget.want;
    });

    addBudget();
  }

  addBudget() async {
    print("Enter into want Api");
    String token = await ApiResponse().getToken();
    var response = await http.patch(
        Uri.parse("https://www.myhoneypot.app/api/smart-budget/W/${widget.id}"),
        body: {
          'diningOut': dinningOutController.text,
          'entertainment': entertainenmentController.text,
          'personal': personalController.text,
          'others': othersController.text
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
                  widget.want.toString().substring(0, 6),
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
                    "Dinning Out",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                  SizedBox(width: width * 0.09),
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
                          controller: dinningOutController,
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
                  SizedBox(width: width * 0.08),
                  Text(
                    "RM ${dinPer!.toStringAsFixed(2)}",
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
                    "Entertainment",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                  SizedBox(width: width * 0.04),
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
                        controller: entertainenmentController,
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
                  SizedBox(width: width * 0.08),
                  Text(
                    "RM ${entPer!.toStringAsFixed(2)}",
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
                    "Personal",
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
                        controller: personalController,
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
                  SizedBox(width: width * 0.08),
                  Text(
                    "RM ${perPer!.toStringAsFixed(2)}",
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
                    "Others",
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
                        controller: othersController,
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
                  SizedBox(width: width * 0.08),
                  Text(
                    "RM ${otherPer!.toStringAsFixed(2)}",
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
