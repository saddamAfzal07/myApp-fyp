// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:myhoneypott/models/api_response.dart';
// import 'package:myhoneypott/models/category_model.dart';

// import 'package:sizer/sizer.dart';

// class AddIncomeScreen extends StatefulWidget {
//   const AddIncomeScreen({Key? key}) : super(key: key);

//   @override
//   State<AddIncomeScreen> createState() => _AddIncomeScreenState();
// }

// class _AddIncomeScreenState extends State<AddIncomeScreen> {
//   TextEditingController descriptionController = TextEditingController();

//   TextEditingController dateController = TextEditingController();
//   TextEditingController totalController = TextEditingController();
//   TextEditingController categoryController = TextEditingController();
//   final GlobalKey<FormState> formkey = GlobalKey<FormState>();

//   bool loading = false;

//   late List<String> categories = [];

//   late List<CategoryDetails>? _categoryDetails = [];

//   String? _currentSelectedValue;

//   @override
//   void initState() {
//     super.initState();
//     getCategoriesIncme();
//   }

//   getCategoriesIncme() async {
//     var json = await fetchCategoryIncome();

//     setState(() {
//       _categoryDetails = json;
//       categories.addAll(json.map((e) => e.description!));
//       categories.insert(0, "Select Category");
//       _currentSelectedValue = categories.first;
//     });
//   }

//   bool isLoading = false;

//   Future<void> adddIncome() async {
//     isLoading = true;
//     String token = await ApiResponse().getToken();
//     var response = await http.post(Uri.parse(incomeURL), body: {
//       'description': descriptionController.text,
//       'date': dateController.text,
//       'total': totalController.text,
//       'category': _currentSelectedValue!,
//     }, headers: {
//       'Authorization': 'Bearer $token',
//       'Charset': 'utf-8'
//     });
//     print(response.body);
//     var data = jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       Map<String, dynamic> responsedata = jsonDecode(response.body);
//       showDialog(
//           barrierDismissible: false,
//           context: context,
//           builder: (BuildContext context) {
//             return Dialog(
//               insetPadding: EdgeInsets.all(16.0.sp),
//               shape: RoundedRectangleBorder(
//                   borderRadius:
//                       BorderRadius.circular(20.0.sp)), //this right here
//               child: AddExpensesDialogs(
//                 title: responsedata["title"] ?? "Successful",
//                 message: responsedata["message"] ??
//                     "Income has been successfully added.",
//               ),
//             );
//           });
//     } else if (response.statusCode == 400) {
//       print(response.statusCode);
//       Map<String, dynamic> responsedata = jsonDecode(response.body);

//       showDialog(
//           barrierDismissible: false,
//           context: context,
//           builder: (BuildContext context) {
//             return Dialog(
//               insetPadding: EdgeInsets.all(16.0.sp),
//               shape: RoundedRectangleBorder(
//                   borderRadius:
//                       BorderRadius.circular(20.0.sp)), //this right here
//               child: ErrorAccountdialogue(
//                 title: responsedata["title"],
//                 message: responsedata["message"],
//               ),
//             );
//           });
//     } else {
//       Map<String, dynamic> responsedata = jsonDecode(response.body);
//       showDialog(
//           barrierDismissible: false,
//           context: context,
//           builder: (BuildContext context) {
//             return Dialog(
//               insetPadding: EdgeInsets.all(16.0.sp),
//               shape: RoundedRectangleBorder(
//                   borderRadius:
//                       BorderRadius.circular(20.0.sp)), //this right here
//               child: ErrorAccountdialogue(
//                 title: responsedata["title"] ?? "Error",
//                 message: responsedata["message"] ?? "Something went wrong",
//               ),
//             );
//           });
//     }
//   }

//   // Date piker
//   selectDate(context) async {
//     DateTime? pickedDate = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2101));
//     locale:
//     const Locale("en");
//     if (pickedDate != null) {
//       // print(pickedDate);
//       String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//       // print(formattedDate);

//       dateController.text = formattedDate;
//     } else {
//       print("Date is not selected");
//     }
//   }

//   DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
//         value: item,
//         child: Padding(
//           padding: EdgeInsets.only(left: 10.0.sp, bottom: 5.0.sp, top: 10.0.sp),
//           child: Text(
//             item,
//             style: robotoRegular.copyWith(
//               fontSize: 12.0.sp,
//               color: AppColors.greyDarkColor1,
//             ),
//           ),
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, orientation, deviceType) {
//       double height = MediaQuery.of(context).size.height;
//       double width = MediaQuery.of(context).size.width;
//       return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0.0,
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 LucideIcons.chevronLeft,
//                 size: 25.sp,
//                 color: AppColors.greyColor,
//               ),
//             ),
//           ),
//           backgroundColor: AppColors.whiteColor,
//           body: _categoryDetails == null || _categoryDetails!.isEmpty
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : SingleChildScrollView(
//                   padding: EdgeInsets.only(bottom: 20.0.sp),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         ///Add Income texts
//                         SizedBox(height: height * 0.10),
//                         Center(
//                           child: Text(
//                             'Add Income',
//                             style: robotoSemiBold.copyWith(
//                               fontSize: 18.0.sp,
//                               color: AppColors.primaryColor,
//                             ),
//                           ),
//                         ),

//                         SizedBox(
//                           height: height * 0.040,
//                         ),

//                         Form(
//                           key: formkey,
//                           child: Column(
//                             children: [
//                               Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: height * 0.032),

//                                 /// description field
//                                 child: TextFormField(
//                                   controller: descriptionController,
//                                   keyboardType: TextInputType.text,
//                                   // inputFormatters: [
//                                   //   FilteringTextInputFormatter(
//                                   //       RegExp('^[a-zA-Z][a-zA-Z ]*'),
//                                   //       allow: true),
//                                   // ],
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return 'This field is required';
//                                     }
//                                     if (!RegExp(r'[a-zA-Z]*').hasMatch(value)) {
//                                       return 'Enter a stronger password';
//                                     }
//                                   },
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(5.0.sp),
//                                     ),
//                                     labelText: 'Description',
//                                     hintText: 'Add description',
//                                     hintStyle: robotoRegular.copyWith(
//                                       fontSize: 14.0.sp,
//                                       color: AppColors.hintTextColor,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: height * 0.024,
//                               ),

//                               /// date field
//                               Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: height * 0.032),
//                                 child: TextFormField(
//                                   controller: dateController,
//                                   keyboardType: TextInputType.number,
//                                   inputFormatters: [
//                                     FilteringTextInputFormatter.digitsOnly
//                                   ],
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return 'This field is required';
//                                     }

//                                     if (!RegExp(r'[0-9]*').hasMatch(value)) {
//                                       return 'Enter a number';
//                                     }
//                                   },
//                                   decoration: InputDecoration(
//                                       border: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0.sp),
//                                       ),
//                                       labelText: 'Date',
//                                       hintText: 'Select date',
//                                       hintStyle: robotoRegular.copyWith(
//                                         fontSize: 14.0.sp,
//                                         color: AppColors.hintTextColor,
//                                       ),
//                                       suffixIcon: const Icon(
//                                         LucideIcons.calendar,
//                                       )),
//                                   onTap: () {
//                                     selectDate(context);
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: height * 0.024,
//                               ),

//                               /// total field
//                               Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: height * 0.032),
//                                 child: TextFormField(
//                                     controller: totalController,
//                                     keyboardType: TextInputType.number,
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter(
//                                           RegExp(r'^(\d+)?\.?\d{0,2}'),
//                                           allow: true),
//                                     ],
//                                     validator: (value) {
//                                       if (value!.isEmpty) {
//                                         return 'This field is required';
//                                       }

//                                       if (!RegExp(r'[0-9]*').hasMatch(value)) {
//                                         return 'Enter a number';
//                                       }
//                                     },
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0.sp),
//                                       ),
//                                       labelText: 'Total',
//                                       hintText: 'Total Amount',
//                                       hintStyle: robotoRegular.copyWith(
//                                         fontSize: 14.0.sp,
//                                         color: AppColors.hintTextColor,
//                                       ),
//                                     )),
//                               ),
//                               SizedBox(
//                                 height: height * 0.024,
//                               ),
//                               Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   margin: EdgeInsets.symmetric(
//                                       horizontal: height * 0.032),
//                                   child: FormField<String>(
//                                     builder: (FormFieldState<String> state) {
//                                       return InputDecorator(
//                                         decoration: InputDecoration(
//                                             labelStyle: robotoRegular.copyWith(
//                                               fontSize: 14.0.sp,
//                                               color: AppColors.hintTextColor,
//                                             ),
//                                             errorStyle: robotoRegular.copyWith(
//                                               fontSize: 14.0.sp,
//                                               color: AppColors.redColor,
//                                             ),
//                                             hintText: 'Please select expense',
//                                             border: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0.sp),
//                                             )),
//                                         isEmpty: _currentSelectedValue == '',
//                                         child: DropdownButtonHideUnderline(
//                                           child: DropdownButton<String>(
//                                             value: _currentSelectedValue,
//                                             isDense: true,
//                                             onChanged: (value) => setState(() =>
//                                                 _currentSelectedValue = value!),
//                                             style: robotoRegular.copyWith(
//                                               fontSize: 12.0.sp,
//                                               color: AppColors.greyDarkColor1,
//                                             ),
//                                             items:
//                                                 categories.map((String value) {
//                                               return DropdownMenuItem<String>(
//                                                 value: value,
//                                                 child: Text(value),
//                                               );
//                                             }).toList(),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   )),
//                               SizedBox(
//                                 height: height * 0.030,
//                               ),

//                               loading
//                                   ? const Center(
//                                       child: CircularProgressIndicator(),
//                                     )

//                                   /// Save button
//                                   : CustomButton(
//                                       onTap: () {
//                                         if (formkey.currentState!.validate()) {
//                                           setState(() {
//                                             loading = false;
//                                           });
//                                         }
//                                         adddIncome();
//                                       },
//                                       btnText: 'Save',
//                                     ),
//                             ],
//                           ),
//                         ),
//                       ])));
//     });
//   }
// }