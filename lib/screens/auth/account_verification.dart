import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/screens/auth/login.dart';
import 'package:myhoneypott/widget/custom_button.dart';
import 'package:http/http.dart' as http;
// import 'package:myhoneypot/constant/app_colors.dart';
// import 'package:myhoneypot/constant/app_text_styles.dart';
// import 'package:myhoneypot/widget/custom_button.dart';

class AccountVerification extends StatefulWidget {
  String userEmail;
  AccountVerification({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<AccountVerification> createState() => _AccountVerificationState();
}

class _AccountVerificationState extends State<AccountVerification> {
  bool loading = false;

  bool emailsend = false;

  resendEmail() async {
    final response = await http.post(
        Uri.parse("https://www.myhoneypot.app/api/resend-verify-email?email"),
        headers: {
          'Accept': 'application/json'
        },
        body: {
          'email': widget.userEmail,
        });
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        emailsend = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong try again')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
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
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.greyColor,
              ),
            ),
          ),
          emailsend
              ? CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.greyDarkColor,
                  child: Container(
                      padding: const EdgeInsets.all(1),
                      child: const CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.email_outlined,
                          color: AppColors.primaryColor,
                          size: 40,
                        ),
                        //
                      )),
                )
              : CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.greyDarkColor,
                  child: Container(
                      padding: const EdgeInsets.all(1),
                      child: const CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          color: AppColors.primaryColor,
                          size: 40,
                        ),
                        //
                      )),
                ),
          const SizedBox(height: 10.0),
          emailsend
              ? Text(
                  'Email Sent',
                  style: robotoSemiBold.copyWith(
                    fontSize: 20.0,
                    color: AppColors.blackSoftColor,
                  ),
                )
              : Text(
                  'Account Verification',
                  style: robotoSemiBold.copyWith(
                    fontSize: 20.0,
                    color: AppColors.blackSoftColor,
                  ),
                ),
          const SizedBox(height: 3.0),
          emailsend
              ? Text(
                  'An email has been sent to you.Please \ncheck your account.',
                  textAlign: TextAlign.center,
                  style: robotoLight.copyWith(
                    fontSize: 14.0,
                    color: AppColors.greyDarkColor,
                  ),
                )
              : Text(
                  'We have sent you an email.Please verify \nyour account.',
                  textAlign: TextAlign.center,
                  style: robotoLight.copyWith(
                    fontSize: 14.0,
                    color: AppColors.greyDarkColor,
                  ),
                ),
          const SizedBox(height: 16.0),
          // loading
          //     ? const Center(child: CircularProgressIndicator())
          //     :
          emailsend
              ? CustomButton(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const Login()),
                        (route) => false);
                  },
                  btnText: 'ok',
                  btnPadding: const EdgeInsets.only(right: 16.0),
                )
              : CustomButton(
                  onTap: () {
                    resendEmail();
                  },
                  btnText: 'Resend email',
                  btnPadding: const EdgeInsets.only(right: 16.0),
                )
        ],
      ),
    );
  }
}
