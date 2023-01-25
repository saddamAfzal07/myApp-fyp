import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/screens/auth/login.dart';
import 'package:myhoneypott/screens/user_profile/user_profile.dart';
import 'package:myhoneypott/services/user_service.dart';
import 'package:myhoneypott/widget/custom_button.dart';

import '../../constant/app_colors.dart';
import 'package:http/http.dart' as http;

class UpdateProfileScreen extends StatefulWidget {
  String name, email, phone, currency, currencyId, passImage;
  UpdateProfileScreen(
      {Key? key,
      required this.name,
      required this.email,
      required this.phone,
      required this.currency,
      required this.currencyId,
      required this.passImage})
      : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  List? currencyDropdownList;
  String? mySelectedId;
  _getlistCurrency() async {
    print("Start Added");
    String token = await UserID.token;
    await http.get(Uri.parse("${profileURL}/${UserID.id}"), headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    }).then((response) {
      var data = jsonDecode(response.body);
      setState(() {
        print("Addedd");
        currencyDropdownList = data["currencies"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController.text = widget.name;
    emailController.text = widget.email;
    numberController.text = widget.phone;
    mySelectedId = widget.currencyId;

    _getlistCurrency();
  }

  uploadData() async {
    print("hit api for image upload");
    String token = UserID.token;
    print("${token}");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    // ignore: unnecessary_new
    final multipartRequest = new http.MultipartRequest("POST",
        Uri.parse("https://www.myhoneypot.app/api/member/${UserID.id}"));
    multipartRequest.headers.addAll(headers);

    multipartRequest.fields.addAll({
      'name': nameController.text,
      'email': emailController.text,
      'mobile': numberController.text,
      'currency': mySelectedId.toString(),
    });

    multipartRequest.files.add(
      await http.MultipartFile.fromPath('profile_image', image!.path),
    );
    http.StreamedResponse response = await multipartRequest.send();

    var responseString = await response.stream.bytesToString();
    print(response.statusCode);

    if (response.statusCode == 200) {
      print("success");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserProfile()));
    } else {}
  }

  File? image;

  final _picker = ImagePicker();
  Future getImage({required source}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    } else {}
  }

  // updateProfile() async {
  //   print("start update profile");
  //   print(nameController.text);
  //   print(emailController.text);
  //   print(numberController.text);
  //   print(mySelectedId);
  //   print("Enter into Api");
  //   String token = await UserID.token;
  //   var response = await http.post(
  //       Uri.parse("https://www.myhoneypot.app/api/member/${UserID.id}"),
  //       body: {
  //         'name': nameController.text,
  //         'email': emailController.text,
  //         'mobile': numberController.text,
  //         'currency': mySelectedId,
  //         "profile_image": widget.passImage,
  //       },
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Charset': 'utf-8'
  //       });

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> responsedata = jsonDecode(response.body);
  //     print("success");

  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => UserProfile()));
  //     // showDialog(
  //     //     barrierDismissible: false,
  //     //     context: context,
  //     //     builder: (BuildContext context) {
  //     //       return Dialog(
  //     //         insetPadding:
  //     //             const EdgeInsets.only(top: 100, left: 20, right: 20),
  //     //         shape: RoundedRectangleBorder(
  //     //             borderRadius: BorderRadius.circular(20.0)), //this right here
  //     //         child: Successdialogs(
  //     //           title: responsedata["title"] ?? "success",
  //     //           message: responsedata["message"] ??
  //     //               "Member details have been saved successfully.",
  //     //         ),
  //     //       );
  //     //     });
  //   } else {
  //     // showDialog(
  //     //     barrierDismissible: false,
  //     //     context: context,
  //     //     builder: (BuildContext context) {
  //     //       return Dialog(
  //     //         insetPadding: const EdgeInsets.all(16),
  //     //         shape: RoundedRectangleBorder(
  //     //             borderRadius: BorderRadius.circular(20.0)), //this right here
  //     //         child: ErrorAccountdialogue(
  //     //           title: responsedata["title"] ?? "Error",
  //     //           message: responsedata["message"] ?? "Something went wrong",
  //     //         ),
  //     //       );
  //     //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      /// appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 50.0,
        leading: IconButton(
          onPressed: () {
            Get.back();
            // Get.offAll(const BottomNavBar());
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.borderColor,
          ),
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Stack(clipBehavior: Clip.none, children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo, width: 5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: ClipOval(
                    child: image != null
                        ? Image.file(
                            image!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.passImage,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  right: 10,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),
                      );
                    },
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                      size: 28.0,
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 12.0),
            SizedBox(height: height * 0.02),
            Expanded(
              child: Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// Name field
                      SizedBox(height: height * 0.024),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: height * 0.032),
                        child: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          style: robotoLight.copyWith(
                            fontSize: 16.0,
                            color: AppColors.blackSoftColor,
                          ),
                          decoration: InputDecoration(
                            hintText: nameController.text,
                            hintStyle: robotoLight.copyWith(
                              fontSize: 16.0,
                              color: AppColors.blackSoftColor,
                            ),
                            labelText: "Enter name",
                            labelStyle: robotoRegular.copyWith(
                              fontSize: 14.0,
                              color: AppColors.greyColor,
                            ),
                          ),
                        ),
                      ),

                      /// email field
                      SizedBox(height: height * 0.008),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: height * 0.032),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: robotoLight.copyWith(
                            fontSize: 16.0,
                            color: AppColors.blackSoftColor,
                          ),
                          decoration: InputDecoration(
                            hintText: emailController.text,
                            hintStyle: robotoLight.copyWith(
                              fontSize: 16.0,
                              color: AppColors.blackSoftColor,
                            ),
                            labelText: "Enter Email",
                            labelStyle: robotoRegular.copyWith(
                              fontSize: 14.0,
                              color: AppColors.greyColor,
                            ),
                          ),
                        ),
                      ),

                      /// number field
                      SizedBox(height: height * 0.008),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: height * 0.032),
                        child: TextFormField(
                          controller: numberController,
                          keyboardType: TextInputType.phone,
                          style: robotoLight.copyWith(
                            fontSize: 16.0,
                            color: AppColors.blackSoftColor,
                          ),
                          decoration: InputDecoration(
                            hintText: numberController.text,
                            hintStyle: robotoLight.copyWith(
                              fontSize: 16.0,
                              color: AppColors.blackSoftColor,
                            ),
                            labelText: "Enter mobile no",
                            labelStyle: robotoRegular.copyWith(
                              fontSize: 14.0,
                              color: AppColors.greyColor,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.026),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: height * 0.032),
                        child: Text(
                          'Currency',
                          style: robotoRegular.copyWith(
                            color: AppColors.greyColor,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<String>(
                                    value: mySelectedId,
                                    isExpanded: true,
                                    iconSize: 40,
                                    icon: const Icon(Icons.arrow_back),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 17,
                                    ),
                                    hint: Text(widget.currency),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        mySelectedId = newValue.toString();

                                        _getlistCurrency();
                                        print(mySelectedId);
                                      });
                                    },
                                    items: currencyDropdownList?.map((item) {
                                          return DropdownMenuItem(
                                            child: Text(item['code']),
                                            value: item['id'].toString(),
                                          );
                                        }).toList() ??
                                        [],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.044),
                      CustomButton(
                        onTap: () {
                          // if (formkey.currentState!.validate()) {
                          print("null");
                          uploadData();
                          // } else {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text('Each Field are Required'),
                          //   ),
                          // );
                          // }
                        },
                        btnText: 'Save',
                        btnFontColor: AppColors.whiteColor,
                      ),
                      SizedBox(height: height * 0.024),
                      CustomButton(
                        btnColor: AppColors.greyColor,
                        onTap: () {
                          logout().then((value) => {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                    (route) => false)
                              });
                        },
                        btnText: 'Logout',
                        btnFontColor: AppColors.blackColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                Navigator.pop(context);
                getImage(source: ImageSource.camera);
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                getImage(source: ImageSource.gallery);
                Navigator.pop(context);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }
}
