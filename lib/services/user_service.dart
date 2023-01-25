import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/user.dart';
import 'package:myhoneypott/screens/auth/account_verification.dart';
import 'package:shared_preferences/shared_preferences.dart';

// login
// Future<dynamic> login(context, String email, String password) async {
//   ApiResponse apiResponse = ApiResponse();

//   // try {
//   final response = await http.post(
//       Uri.parse("https://www.myhoneypot.app/api/login"),
//       headers: {'Accept': 'application/json', 'Charset': 'utf-8'},
//       body: {'email': email, 'password': password});
//   // print(email + " " + password);
//   // print(response.body);

//   if (response.statusCode == 200) {
//     print("Enter");
//     apiResponse.data = User.fromJson(jsonDecode(response.body));
//     apiResponse.storeToken(jsonDecode(response.body)['token']);
//     return apiResponse;
//   } else if (response.statusCode == 422) {
//     final errors = jsonDecode(response.body)['errors'];

//     apiResponse.error = errors[errors.keys.elementAt(0)][0];
//     return apiResponse;
//   } else if (response.statusCode == 403) {
//     return showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             insetPadding: const EdgeInsets.only(top: 100, left: 20, right: 20),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0)), //this right here
//             child: AccountVerification(userEmail: email),
//           );
//         });
//   } else {
//     apiResponse.error = somethingWentWrong;

//     return apiResponse;
//   }
// }

// Register
Future<ApiResponse> register(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(registerURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'email': email,
      'password': password,
    });

    // this is how we can debug any api response
    //print(response.body);

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// User
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    //String token = await getToken();
    // String token = '';
    // print(token);
    String token = await getToken();
    final response = await http.get(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Update user
Future<ApiResponse> updateUser(String name, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image == null
            ? {
                'name': name,
              }
            : {'name': name, 'image': image});
    // user can update his/her name or name and image

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('memberId') ?? 0;
}

// get user id
Future<int> getUserExpense() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('memberId') ?? 0;
}

// logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
