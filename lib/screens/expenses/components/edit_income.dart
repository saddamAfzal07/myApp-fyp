import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/category_model.dart';
import 'package:myhoneypott/models/income_all_month.dart';

import 'package:myhoneypott/screens/bottom_nav_bar.dart';
import 'package:myhoneypott/services/category_service.dart';
import 'package:myhoneypott/widget/custom_button.dart';
import 'package:myhoneypott/widget/custom_field.dart';
import 'package:http/http.dart' as http;

class EditIncomeScreen extends StatefulWidget {
  String id, description, totalAmount, date, category;
  final monthlyExpense;

  EditIncomeScreen(
      {Key? key,
      required this.id,
      required this.description,
      required this.totalAmount,
      required this.date,
      required this.category,
      required this.monthlyExpense})
      : super(key: key);

  @override
  State<EditIncomeScreen> createState() => _EditIncomeScreenState();
}

class _EditIncomeScreenState extends State<EditIncomeScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    descriptionController.text = widget.description;

    dateController.text = widget.date;

    totalController.text = widget.totalAmount;

    value = widget.monthlyExpense.category!.description;
    super.initState();
    print(value);
    getCategories();

    print(descriptionController.text);
    print(dateController.text);
    print(totalController.text);
    print(value);
  }

  late List<String> categories = [];

  late List<CategoryDetails>? _categoryDetails = [];

  String? value;
  getCategories() async {
    print("enter into getcategory");
    var json = await fetchIncome();
    print("====>>>");
    print(json);

    setState(() {
      _categoryDetails = json;
      categories.addAll(json.map((e) => e.description!));
    });
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

  // List? currencyDropdownList;
  // String? mySelectedId;

  // getCategory() async {
  //   const categoryIncURL = '$baseURL/category-incomes';
  //   String token = await ApiResponse().getToken();
  //   await http.get(Uri.parse(categoryIncURL), headers: {
  //     'Content-type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   }).then((response) {
  //     var data = jsonDecode(response.body);

  //     setState(() {
  //       currencyDropdownList = data["categoryDetails"];
  //     });
  //   });
  // }

  updateincome() async {
    String token = await UserID.token;
    var response = await http.patch(
        Uri.parse("https://www.myhoneypot.app/api/income/${widget.id}"),
        body: {
          'description': descriptionController.text,
          'date': dateController.text,
          'total': totalController.text,
          'category': value.toString()
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Charset': 'utf-8'
        });
    print(response.body);

    if (response.statusCode == 200) {
      print("success");

      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => BottomNavBar()));
      // Navigator.pop(context);
    } else {
      print("Error");
    }
  }

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
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.borderColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ///Add Expense texts
            SizedBox(height: height * 0.1),
            Center(
              child: Text(
                'Edit Income',
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

            SizedBox(height: height * 0.024),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                              style: TextStyle(color: AppColors.hintTextColor),
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
                // Container(
                //   color: Colors.white,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       Expanded(
                //         child: DropdownButtonHideUnderline(
                //           child: ButtonTheme(
                //             alignedDropdown: true,
                //             child: DropdownButton<String>(
                //               value: mySelectedId,
                //               isExpanded: true,
                //               iconSize: 40,
                //               icon: (null),
                //               style: const TextStyle(
                //                 color: Colors.black54,
                //                 fontSize: 17,
                //               ),
                //               hint: Text(widget.category),
                //               onChanged: (String? newValue) {
                //                 setState(() {
                //                   mySelectedId = newValue.toString();

                //                   getCategory();
                //                   print(mySelectedId);
                //                 });
                //               },
                //               items: currencyDropdownList?.map((item) {
                //                     // setState(() {
                //                     //   widget.category = item["description"];
                //                     // });
                //                     // print("===>>>>>${widget.category}");
                //                     return DropdownMenuItem(
                //                       child: Text(
                //                         item["description"],
                //                       ),
                //                       value: item['id'].toString(),
                //                     );
                //                   }).toList() ??
                //                   [],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),

            SizedBox(height: height * 0.024),
            CustomButton(
              onTap: () {
                updateincome();
              },
              btnText: 'Save',
            ),
          ],
        ),
      ),
    );
  }
}
