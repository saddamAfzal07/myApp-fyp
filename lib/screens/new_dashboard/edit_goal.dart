import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/screens/new_dashboard/new_dashbaord_screen.dart';
import 'package:myhoneypott/widget/custom_button.dart';

import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class EditGoal extends StatefulWidget {
  final int id;
  String description;

  String total;
  EditGoal(
      {Key? key,
      required this.id,
      required this.description,
      required this.total})
      : super(key: key);

  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.description;

    totalController.text = widget.total;
  }

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool loading = false;

  // Date piker
  selectDate(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    const Locale("en");
    if (pickedDate != null) {
      // print(pickedDate);
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      // print(formattedDate);

      dateController.text = formattedDate;
    } else {
      print("Date is not selected");
    }
  }

  editGoal() async {
    print(descriptionController.text);
    print(dateController.text);
    print(totalController.text);
    String token = await UserID.token;
    var response = await http.patch(
        Uri.parse("https://www.myhoneypot.app/api/goal/${widget.id}"),
        body: {
          'description': descriptionController.text,
          'date': dateController.text,
          'total': totalController.text,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Charset': 'utf-8'
        });
    print(response.body);

    if (response.statusCode == 200) {
      print("success");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Edit Successfully"),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );

      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.borderColor,
              ),
            ),
          ),
          body:
              //  goalURL.isEmpty
              //     ? const Center(
              //         child: CircularProgressIndicator(),
              //       )
              //     :

              SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20.0.sp),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Add Expense texts

                        Center(
                          child: Text(
                            'Edit Goal',
                            style: robotoSemiBold.copyWith(
                              fontSize: 18.0.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: height * 0.040,
                        ),

                        Form(
                          key: formkey,
                          child: Column(
                            children: [
                              Container(
                                height: height * 0.095,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(
                                    horizontal: height * 0.032),

                                /// Description field
                                child: TextFormField(
                                  controller: descriptionController,
                                  keyboardType: TextInputType.text,
                                  // inputFormatters: [
                                  //   FilteringTextInputFormatter(
                                  //       RegExp('^[a-zA-Z][a-zA-Z ]*'),
                                  //       allow: true),
                                  // ],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field is required';
                                    }
                                    if (!RegExp(r'[a-zA-Z]*').hasMatch(value)) {
                                      return 'Enter Description';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0.sp),
                                    ),
                                    labelText: 'Description',
                                    hintText: 'Add description',
                                    hintStyle: robotoRegular.copyWith(
                                      fontSize: 12.0.sp,
                                      color: AppColors.hintTextColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.024,
                              ),

                              /// date field
                              Container(
                                height: height * 0.095,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(
                                    horizontal: height * 0.032),
                                child: TextFormField(
                                  controller: dateController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field is required';
                                    }

                                    if (!RegExp(r'[0-9]*').hasMatch(value)) {
                                      return 'Enter a number';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0.sp),
                                      ),
                                      labelText: 'Target Date Achieve',
                                      hintText: 'Select date',
                                      hintStyle: robotoRegular.copyWith(
                                        fontSize: 12.0.sp,
                                        color: AppColors.hintTextColor,
                                      ),
                                      suffixIcon: const Icon(
                                        LucideIcons.calendar,
                                      )),
                                  onTap: () {
                                    selectDate(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: height * 0.024,
                              ),

                              /// total field
                              Container(
                                height: height * 0.095,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(
                                    horizontal: height * 0.032),
                                child: TextFormField(
                                    controller: totalController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }

                                      if (!RegExp(r'[0-9]*').hasMatch(value)) {
                                        return 'Enter a number';
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0.sp),
                                      ),
                                      labelText: 'Total',
                                      hintText: 'Total Amount',
                                      hintStyle: robotoRegular.copyWith(
                                        fontSize: 12.0.sp,
                                        color: AppColors.hintTextColor,
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: height * 0.024,
                              ),

                              SizedBox(
                                height: height * 0.030,
                              ),

                              loading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )

                                  /// Save button
                                  : CustomButton(
                                      onTap: () {
                                        if (formkey.currentState!.validate()) {
                                          editGoal();
                                        }
                                      },
                                      btnText: 'Save',
                                    ),
                            ],
                          ),
                        ),
                      ])));
    });
  }
}
