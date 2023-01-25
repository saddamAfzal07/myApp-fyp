import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/screens/bottom_nav_bar.dart';
import 'package:myhoneypott/widget/custom_button.dart';

import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'constant/app_text_styles.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({Key? key}) : super(key: key);

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  TextEditingController monthlyIncome = TextEditingController();
  TextEditingController needs = TextEditingController();
  TextEditingController wants = TextEditingController();
  TextEditingController savings = TextEditingController();

  //Needs controller
  TextEditingController housing = TextEditingController();
  TextEditingController grocery = TextEditingController();
  TextEditingController utilities = TextEditingController();
  TextEditingController transportation = TextEditingController();
  //Wants controller
  TextEditingController dinningOut = TextEditingController();
  TextEditingController entertainment = TextEditingController();
  TextEditingController personal = TextEditingController();
  TextEditingController others = TextEditingController();
  String message = "All Set";
  bool visibilityDialouge = false;

  callFunction() {
    if (monthlyIncome.text == ".00") {
      message = "Income is Required";
      visibilityDialouge = true;
    } else if (monthlyIncome.text == ".") {
      message = "Income is Required ";
      visibilityDialouge = true;
    } else if (monthlyIncome.text == ".0") {
      message = "Income is Required ";
      visibilityDialouge = true;
    } else if (monthlyIncome.text.isNotEmpty) {
      getCategoriesPer();
    } else {
      message = "Income is Required ";
      visibilityDialouge = true;
    }
  }

  num monthlyIncomeValue = 0.0;
  //Percentage of Categories
  num needPercentage = 0.0;
  num wantsPercentage = 0.0;
  num savingsPercentage = 0.0;
//Values of Categories
  num needValue = 0.0;
  num wantsValue = 0.0;
  num savingsValue = 0.0;
  void getCategoriesPer() {
    if (monthlyIncome.text.contains(".")) {
      String mIncome =
          monthlyIncome.text.substring(0, monthlyIncome.text.indexOf('.'));

      monthlyIncomeValue = int.parse(mIncome);
    } else {
      monthlyIncomeValue = int.parse(monthlyIncome.text);
    }
    //needs
    if (needs.text.contains("%")) {
      String needCheck = needs.text.substring(0, needs.text.indexOf('%'));

      needPercentage = int.parse(needCheck.isEmpty ? "0" : needCheck);
    } else if (needs.text.contains(".")) {
      String needCheck = needs.text.substring(0, needs.text.indexOf('.'));

      needPercentage = int.parse(needCheck.isEmpty ? "0" : needCheck);
    } else {
      needPercentage = int.parse(needs.text.isEmpty ? "0" : needs.text);
    }
    //wants
    if (wants.text.contains("%")) {
      String wantsCheck = wants.text.substring(0, wants.text.indexOf('%'));

      wantsPercentage = int.parse(wantsCheck.isEmpty ? "0" : wantsCheck);
    } else if (wants.text.contains(".")) {
      String wantsCheck = wants.text.substring(0, wants.text.indexOf('.'));

      wantsPercentage = int.parse(wantsCheck.isEmpty ? "0" : wantsCheck);
    } else {
      wantsPercentage = int.parse(wants.text.isEmpty ? "0" : wants.text);
    }
    //Savings
    if (savings.text.contains("%")) {
      String savingsCheck =
          savings.text.substring(0, savings.text.indexOf('%'));
      savingsPercentage = int.parse(savingsCheck.isEmpty ? "0" : savingsCheck);
    } else if (savings.text.contains(".")) {
      String savingsCheck =
          savings.text.substring(0, savings.text.indexOf('.'));
      savingsPercentage = int.parse(savingsCheck.isEmpty ? "0" : savingsCheck);
    } else {
      savingsPercentage = int.parse(savings.text.isEmpty ? "0" : savings.text);
    }

    needValue = (needPercentage * monthlyIncomeValue) / 100;
    wantsValue = (wantsPercentage * monthlyIncomeValue) / 100;

    savingsValue = (savingsPercentage * monthlyIncomeValue) / 100;
    if (needs.text.isEmpty || wants.text.isEmpty || savings.text.isEmpty) {
      setState(() {
        visibilityDialouge = true;
        message = "Each category must be selected ";
      });
    } else {
      if (needPercentage + wantsPercentage + savingsPercentage == 100) {
        if (this.mounted) {
          setState(() {});
          getNeedSubCategories();
        }
      } else {
        setState(() {
          visibilityDialouge = true;
          message = "The total percentage of the section is not 100%";
        });
      }
    }
  }

//Needs Subcategories
//percentage of need categories
  num housingPercentage = 0.0;
  num utilityPercentage = 0.0;
  num groceryPercentage = 0.0;
  num transportationPercentage = 0.0;
  //value of need Categories
  num housingValue = 0.0;
  num utilityValue = 0.0;
  num groceryValue = 0.0;
  num transportationValue = 0.0;

  getNeedSubCategories() {
    setState(() {
//housing
      if (housing.text.contains("%")) {
        String housingCheck =
            housing.text.substring(0, housing.text.indexOf('%'));
        housingPercentage =
            int.parse(housingCheck.isEmpty ? "0" : housingCheck);
      } else if (housing.text.contains(".")) {
        String housingCheck =
            housing.text.substring(0, housing.text.indexOf('.'));
        housingPercentage =
            int.parse(housingCheck.isEmpty ? "0" : housingCheck);
      } else {
        housingPercentage =
            int.parse(housing.text.isEmpty ? "0" : housing.text);
      }

//utility
      if (utilities.text.contains("%")) {
        String utilityCheck =
            utilities.text.substring(0, utilities.text.indexOf('%'));
        utilityPercentage =
            int.parse(utilityCheck.isEmpty ? "0" : utilityCheck);
      } else if (utilities.text.contains(".")) {
        String utilityCheck =
            utilities.text.substring(0, utilities.text.indexOf('.'));
        utilityPercentage =
            int.parse(utilityCheck.isEmpty ? "0" : utilityCheck);
      } else {
        utilityPercentage =
            int.parse(utilities.text.isEmpty ? "0" : utilities.text);
      }
      //Grocery
      if (grocery.text.contains("%")) {
        String groceryCheck =
            grocery.text.substring(0, grocery.text.indexOf('%'));
        groceryPercentage =
            int.parse(groceryCheck.isEmpty ? "0" : groceryCheck);
      } else if (grocery.text.contains(".")) {
        String groceryCheck =
            grocery.text.substring(0, grocery.text.indexOf('.'));
        groceryPercentage =
            int.parse(groceryCheck.isEmpty ? "0" : groceryCheck);
      } else {
        groceryPercentage =
            int.parse(grocery.text.isEmpty ? "0" : grocery.text);
      }
//transportation
      if (transportation.text.contains("%")) {
        String transportationCheck =
            transportation.text.substring(0, transportation.text.indexOf('%'));
        transportationPercentage =
            int.parse(transportationCheck.isEmpty ? "0" : transportationCheck);
      } else if (transportation.text.contains(".")) {
        String transportationCheck =
            transportation.text.substring(0, transportation.text.indexOf('.'));
        transportationPercentage =
            int.parse(transportationCheck.isEmpty ? "0" : transportationCheck);
      } else {
        transportationPercentage =
            int.parse(transportation.text.isEmpty ? "0" : transportation.text);
      }

      housingValue = (housingPercentage * needValue) / 100;
      utilityValue = (utilityPercentage * needValue) / 100;
      groceryValue = (groceryPercentage * needValue) / 100;
      transportationValue = (transportationPercentage * needValue) / 100;
    });
    if (housing.text.isEmpty ||
        grocery.text.isEmpty ||
        utilities.text.isEmpty ||
        transportation.text.isEmpty) {
      visibilityDialouge = true;
      message = "All needs categories must be Selected";
      setState(() {});
    } else {
      if (housingPercentage +
              utilityPercentage +
              groceryPercentage +
              transportationPercentage ==
          100) {
        setState(() {});

        visibilityDialouge = false;
        getWantsSubCategories();
      } else {
        setState(() {
          visibilityDialouge = true;
          message = "The total percentage of the section needs is not 100%";
        });
      }
    }
  }

//Wants Subcategories
//percentage of Wants categories
  num diningOutPercentage = 0.0;
  num entertainmentPercentage = 0.0;
  num personalPercentage = 0.0;
  num othersPercentage = 0.0;
  //value of wants Categories
  num diningOutValue = 0.0;
  num entertainmentValue = 0.0;
  num personalValue = 0.0;
  num othersValue = 0.0;

  getWantsSubCategories() {
//diningOut
    if (dinningOut.text.contains("%")) {
      String diningOutCheck =
          dinningOut.text.substring(0, dinningOut.text.indexOf('%'));

      diningOutPercentage =
          int.parse(diningOutCheck.isEmpty ? "0" : diningOutCheck);
    } else if (transportation.text.contains(".")) {
      String diningOutCheck =
          dinningOut.text.substring(0, dinningOut.text.indexOf('.'));

      diningOutPercentage =
          int.parse(diningOutCheck.isEmpty ? "0" : diningOutCheck);
    } else {
      diningOutPercentage =
          int.parse(dinningOut.text.isEmpty ? "0" : dinningOut.text);
    }

//entertainment
    if (entertainment.text.contains("%")) {
      String entertainmentCheck =
          entertainment.text.substring(0, entertainment.text.indexOf('%'));

      entertainmentPercentage =
          int.parse(entertainmentCheck.isEmpty ? "0" : entertainmentCheck);
    } else if (entertainment.text.contains(".")) {
      String entertainmentCheck =
          entertainment.text.substring(0, entertainment.text.indexOf('.'));

      entertainmentPercentage =
          int.parse(entertainmentCheck.isEmpty ? "0" : entertainmentCheck);
    } else {
      entertainmentPercentage =
          int.parse(entertainment.text.isEmpty ? "0" : entertainment.text);
    }

    //personal
    if (personal.text.contains("%")) {
      String personalCheck =
          personal.text.substring(0, personal.text.indexOf('%'));

      personalPercentage =
          int.parse(personalCheck.isEmpty ? "0" : personalCheck);
    } else if (personal.text.contains(".")) {
      String personalCheck =
          personal.text.substring(0, personal.text.indexOf('.'));

      personalPercentage =
          int.parse(personalCheck.isEmpty ? "0" : personalCheck);
    } else {
      personalPercentage =
          int.parse(personal.text.isEmpty ? "0" : personal.text);
    }
    //other
    if (others.text.contains("%")) {
      String othersCheck = others.text.substring(0, others.text.indexOf('%'));

      othersPercentage = int.parse(othersCheck.isEmpty ? "0" : othersCheck);
    } else if (others.text.contains(".")) {
      String othersCheck = others.text.substring(0, others.text.indexOf('.'));

      othersPercentage = int.parse(othersCheck.isEmpty ? "0" : othersCheck);
    } else {
      othersPercentage = int.parse(others.text.isEmpty ? "0" : others.text);
    }

    diningOutValue = (diningOutPercentage * wantsValue) / 100;
    entertainmentValue = (entertainmentPercentage * wantsValue) / 100;
    personalValue = (personalPercentage * wantsValue) / 100;
    othersValue = (othersPercentage * wantsValue) / 100;
    setState(() {});
    if (dinningOut.text.isEmpty ||
        entertainment.text.isEmpty ||
        personal.text.isEmpty ||
        others.text.isEmpty) {
      visibilityDialouge = true;
      message = "All wants categories must be Selected";
      setState(() {});
    } else {
      if (diningOutPercentage +
              entertainmentPercentage +
              personalPercentage +
              othersPercentage ==
          100) {
        visibilityDialouge = false;
        setState(() {});
      } else {
        setState(() {
          visibilityDialouge = true;
          message = "The total percentage of the section wants is not 100%";
        });
      }
    }
  }

  completeSetup() async {
    print("into Api");
    String token = await UserID.token;
    var response = await http
        .post(Uri.parse("https://www.myhoneypot.app/api/initial-setup"), body: {
      'income': monthlyIncome.text.toString(),
      'housingPercentage': housingPercentage.toString(),
      'housingValue': housingValue.toString(),
      'utilitiesPercentage': utilityPercentage.toString(),
      'utilitiesValue': utilityValue.toString(),
      'groceriesPercentage': groceryPercentage.toString(),
      'groceriesValue': groceryValue.toString(),
      'transportationPercentage': transportationPercentage.toString(),
      'transportationValue': transportationValue.toString(),
      'diningOutPercentage': diningOutPercentage.toString(),
      'diningOutValue': diningOutValue.toString(),
      'entertainmentPercentage': entertainmentPercentage.toString(),
      'entertainmentValue': entertainmentValue.toString(),
      'personalValue': personalValue.toString(),
      'personalPercentage': personalPercentage.toString(),
      'othersPercentgage': othersPercentage.toString(),
      'othersValue': othersValue.toString(),
      'savingsPercentage': savingsPercentage.toString(),
      'savingsValue': savingsValue.toString(),
    }, headers: {
      'Authorization': 'Bearer $token',
      'Charset': 'utf-8'
    });
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      print("success");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false);
    } else {
      print("Error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => callFunction(),
    );

    monthlyIncome.text = "5000.00";

    needs.text = "50%";
    wants.text = "30%";
    savings.text = "20%";
    housing.text = "50%";
    utilities.text = "10%";
    grocery.text = "20%";
    transportation.text = "20%";
    dinningOut.text = "40%";
    entertainment.text = "30%";
    personal.text = "20%";
    others.text = "10%";
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;

      return Scaffold(
        backgroundColor: AppColors.whiteColor,

        /// appbar
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      // if (monthlyIncome.text.isEmpty) {
                      //   print("Add monthly first");
                      // } else {
                      //   getCategoriesPer();
                      // }
                    },
                    child: Text(
                      'Initial Setup',
                      style: robotoBold.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 24.0.sp,
                      ),
                    ),
                  ),
                ),

                /// description texts
                SizedBox(height: height * 0.020),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.020),
                  child: Text(
                    'Hello there,please take a moment to setup your account.Allocate amount for each section basedb on \nthe 50/30/20 rul.Ypu can adjust the percentage of \n each category in every section to have a clear idea on \nhow much you shloud spend in your expnses. ',
                    // 'we\'ll send you a link to reset your password!',
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      fontSize: height * 0.012.sp,
                      color: AppColors.blackSoftColor,
                    ),
                  ),
                ),

                //// email field
                SizedBox(height: height * 0.020),
                Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 10),
                    child: Text(
                      'Monthly Income',
                      style: robotoMedium.copyWith(
                        color: AppColors.blackSoftColor,
                        fontSize: height * 0.020,
                      ),
                    )),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                  child: Container(
                      height: height * 0.055,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.footerBorderColor),
                      ),
                      child: TextFormField(
                        controller: monthlyIncome,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '5000.00',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: height * 0.020,
                            horizontal: width * 0.020,
                          ),
                          hintStyle: robotoBold.copyWith(
                            color: AppColors.hintTextColor,
                            fontSize: height * 0.016,
                          ),
                        ),
                        textAlign: TextAlign.start,
                      )),
                ),
                SizedBox(height: height * 0.012),
                Visibility(
                  visible: visibilityDialouge,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: height * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(
                        6,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          message,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.012),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        height: height * 0.050,
                        color: AppColors.primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'CATEGORY',
                              style: robotoBold.copyWith(
                                  color: AppColors.whiteColor,
                                  fontSize: height * 0.018),
                            ),
                            Text(
                              'PERCENTAGE',
                              style: robotoBold.copyWith(
                                  color: AppColors.whiteColor,
                                  fontSize: height * 0.018),
                            ),
                            Text(
                              'TOTAL',
                              style: robotoBold.copyWith(
                                  color: AppColors.whiteColor,
                                  fontSize: height * 0.018),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        height: height * 0.050,
                        color: AppColors.primaryOneColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'NEEDS',
                                style: robotoBold.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: height * 0.018),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: height * 0.034,
                                color: AppColors.whiteColor,
                                child: TextFormField(
                                  controller: needs,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "0%",
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: height * 0.014,
                                    ),
                                    hintStyle: robotoBold.copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: height * 0.022,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${needValue}0',
                                  style: robotoBold.copyWith(
                                    color: AppColors.blackColor,
                                    fontSize: height * 0.018,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: height * 0.050,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.footerBorderColor))),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Housing',
                                      style: robotoRegular.copyWith(
                                          color: AppColors.blackSoftColor,
                                          fontSize: height * 0.018),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        height: height * 0.034,
                                        width: width * 0.200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  AppColors.footerBorderColor),
                                        ),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: housing,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '0%',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: height * 0.018),
                                              hintStyle: robotoRegular.copyWith(
                                                color: AppColors.blackSoftColor,
                                                fontSize: height * 0.016,
                                              )),
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${housingValue}0',
                                        style: robotoRegular.copyWith(
                                            color: AppColors.blackSoftColor,
                                            fontSize: height * 0.018),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: height * 0.050,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.footerBorderColor))),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Utilities',
                                      style: robotoRegular.copyWith(
                                          color: AppColors.blackSoftColor,
                                          fontSize: height * 0.018),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        height: height * 0.034,
                                        width: width * 0.200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  AppColors.footerBorderColor),
                                        ),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: utilities,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '0%',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: height * 0.018),
                                              hintStyle: robotoRegular.copyWith(
                                                color: AppColors.blackSoftColor,
                                                fontSize: height * 0.018,
                                              )),
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${utilityValue}0',
                                        style: robotoRegular.copyWith(
                                            color: AppColors.blackSoftColor,
                                            fontSize: height * 0.016),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: height * 0.050,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.footerBorderColor))),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Groceries',
                                      style: robotoRegular.copyWith(
                                          color: AppColors.blackSoftColor,
                                          fontSize: height * 0.018),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        height: height * 0.034,
                                        width: width * 0.200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  AppColors.footerBorderColor),
                                        ),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: grocery,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '0%',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: height * 0.018),
                                              hintStyle: robotoRegular.copyWith(
                                                color: AppColors.blackSoftColor,
                                                fontSize: height * 0.018,
                                              )),
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${groceryValue}0',
                                        style: robotoRegular.copyWith(
                                            color: AppColors.blackSoftColor,
                                            fontSize: height * 0.018),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: height * 0.050,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.footerBorderColor))),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Transportation',
                                      style: robotoRegular.copyWith(
                                          color: AppColors.blackSoftColor,
                                          fontSize: height * 0.018),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        height: height * 0.034,
                                        width: width * 0.200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  AppColors.footerBorderColor),
                                        ),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: transportation,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '0%',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: height * 0.018),
                                              hintStyle: robotoRegular.copyWith(
                                                color: AppColors.blackSoftColor,
                                                fontSize: height * 0.018,
                                              )),
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${transportationValue}0',
                                        style: robotoRegular.copyWith(
                                            color: AppColors.blackSoftColor,
                                            fontSize: height * 0.018),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: height * 0.050,
                            color: AppColors.primaryOneColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'WANTS',
                                    style: robotoBold.copyWith(
                                        color: AppColors.whiteColor,
                                        fontSize: height * 0.018),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: height * 0.034,
                                    color: AppColors.whiteColor,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: wants,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '0%',
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: height * 0.014,
                                          ),
                                          hintStyle: robotoBold.copyWith(
                                            color: AppColors.primaryColor,
                                            fontSize: height * 0.022,
                                          )),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${wantsValue}0',
                                      style: robotoBold.copyWith(
                                        color: AppColors.blackColor,
                                        fontSize: height * 0.018,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: height * 0.050,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.footerBorderColor))),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Dining Out',
                                      style: robotoRegular.copyWith(
                                          color: AppColors.blackSoftColor,
                                          fontSize: height * 0.018),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        height: height * 0.034,
                                        width: width * 0.200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  AppColors.footerBorderColor),
                                        ),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: dinningOut,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '0%',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: height * 0.018),
                                              hintStyle: robotoRegular.copyWith(
                                                color: AppColors.blackSoftColor,
                                                fontSize: height * 0.018,
                                              )),
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${diningOutValue}0',
                                        style: robotoRegular.copyWith(
                                            color: AppColors.blackSoftColor,
                                            fontSize: height * 0.018),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: height * 0.050,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.footerBorderColor))),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Entertainment',
                                      style: robotoRegular.copyWith(
                                          color: AppColors.blackSoftColor,
                                          fontSize: height * 0.018),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        height: height * 0.034,
                                        width: width * 0.200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  AppColors.footerBorderColor),
                                        ),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: entertainment,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '0%',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: height * 0.018),
                                              hintStyle: robotoRegular.copyWith(
                                                color: AppColors.blackSoftColor,
                                                fontSize: height * 0.018,
                                              )),
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${entertainmentValue}0',
                                        style: robotoRegular.copyWith(
                                            color: AppColors.blackSoftColor,
                                            fontSize: height * 0.018),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: height * 0.050,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.footerBorderColor))),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Personal',
                                      style: robotoRegular.copyWith(
                                          color: AppColors.blackSoftColor,
                                          fontSize: height * 0.018),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        height: height * 0.034,
                                        width: width * 0.200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  AppColors.footerBorderColor),
                                        ),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: personal,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '0%',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: height * 0.018),
                                              hintStyle: robotoRegular.copyWith(
                                                color: AppColors.blackSoftColor,
                                                fontSize: height * 0.018,
                                              )),
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${personalValue}0',
                                        style: robotoRegular.copyWith(
                                            color: AppColors.blackSoftColor,
                                            fontSize: height * 0.018),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: height * 0.050,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.footerBorderColor))),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Others',
                                      style: robotoRegular.copyWith(
                                          color: AppColors.blackSoftColor,
                                          fontSize: height * 0.018),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        height: height * 0.034,
                                        width: width * 0.200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  AppColors.footerBorderColor),
                                        ),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: others,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '0%',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: height * 0.018),
                                              hintStyle: robotoRegular.copyWith(
                                                color: AppColors.blackSoftColor,
                                                fontSize: height * 0.018,
                                              )),
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${othersValue}0',
                                        style: robotoRegular.copyWith(
                                            color: AppColors.blackSoftColor,
                                            fontSize: height * 0.018),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        height: height * 0.050,
                        color: AppColors.primaryOneColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'SAVINGS',
                                style: robotoBold.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: height * 0.018),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: height * 0.034,
                                color: AppColors.whiteColor,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: savings,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '0%',
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: height * 0.014,
                                      ),
                                      hintStyle: robotoBold.copyWith(
                                        color: AppColors.primaryColor,
                                        fontSize: height * 0.022,
                                      )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${savingsValue}0',
                                  style: robotoBold.copyWith(
                                    color: AppColors.blackColor,
                                    fontSize: height * 0.018,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// Reset Password button
                SizedBox(height: height * 0.024),
                CustomButton(
                  onTap: () {
                    if (monthlyIncome.text.isEmpty ||
                        visibilityDialouge == true) {
                    } else {
                      completeSetup();
                    }
                  },
                  btnText: 'Complete Setup',
                  btnPadding: const EdgeInsets.symmetric(horizontal: 15),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
