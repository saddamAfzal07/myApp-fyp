import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/user_id.dart';

import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class FeedbackSreen extends StatefulWidget {
  @override
  State<FeedbackSreen> createState() => _FeedbackSreenState();
}

class _FeedbackSreenState extends State<FeedbackSreen> {
  double valueRating = 0;
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _controller = TextEditingController();
  addFeedback() async {
    String token = await UserID.token;
    var response = await http
        .post(Uri.parse("https://www.myhoneypot.app/api/feedback"), body: {
      'description': _controller.text,
      'rating': valueRating.toString(),
    }, headers: {
      'Authorization': 'Bearer $token',
      'Charset': 'utf-8'
    });
    print(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Feedback sent successfully"),),);
      Navigator.pop(context);
      _controller.clear();
      print("success");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error when sending feedback"),),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                LucideIcons.chevronLeft,
                size: 30,
                color: AppColors.greyColor,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: height * 0.024),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text(
                        "Feedback",
                        style: robotoBold.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: 16.0.sp,
                        ),
                      ),
                    )),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: width * 0.020),
                        child: Center(
                            child: Text("How would you rate MyhoneyPot?",
                                style: robotoRegular.copyWith(
                                  fontSize: 13.sp,
                                  color: AppColors.blackSoftColor,
                                )))),
                    SizedBox(
                      height: height * 0.010,
                    ),
                    Center(
                      child: RatingBar.builder(
                        itemSize: 55,
                        // initialRating: valueRating,
                        // minRating: 1,
                        direction: Axis.horizontal,
                        // allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            EdgeInsets.symmetric(horizontal: height * 0.008),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            valueRating = rating;
                            print(valueRating);
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.010,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.020),
                        child: Center(
                            child: Text(
                                "Tell us what you feel about MyhoneyPot \n and how we can improve.",
                                style: robotoRegular.copyWith(
                                  fontSize: 13.0.sp,
                                  color: AppColors.blackSoftColor,
                                )))),
                    Container(
                      height: height * 0.200,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: 'Enter your feedback here',
                            filled: true,
                          ),
                          maxLines: 5,
                          maxLength: 1000,
                          textInputAction: TextInputAction.done,
                          validator: (String? text) {
                            if (text == null || text.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.010,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: height * 0.055,
                          width: 180.0,
                          child: ElevatedButton(
                              onPressed: () async {
                                // Only if the input form is valid (the user has entered text)
                                if (_formKey.currentState!.validate()) {
                                  // We will use this var to show the result
                                  // of this operation to the user
                                  String message;

                                  try {
                                    // Get a reference to the `feedback` collection
                                    // final collection =
                                    //     FirebaseFirestore.instance.collection('feedback');

                                    // // Write the server's timestamp and the user's feedback
                                    // await collection.doc().set({
                                    //   'timestamp': FieldValue.serverTimestamp(),
                                    //   'feedback': _controller.text,
                                    // });

                                    // message = 'Feedback sent successfully';
                                    addFeedback();
                                  } catch (e) {
                                    // message = 'Error when sending feedback';
                                  }

                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(content: Text(message)));
                                  // Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'Send',
                                style: robotoSemiBold.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 14.0.sp),
                              )),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: height * 0.055,
                          width: 180.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.greyColor),
                            ),
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text(
                              'Cancel',
                              style: robotoSemiBold.copyWith(
                                  color: AppColors.whiteColor,
                                  fontSize: 14.0.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ));
    });
  }
}
