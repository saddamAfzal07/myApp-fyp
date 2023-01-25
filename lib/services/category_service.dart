import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/category_model.dart';

import '../models/api_response.dart';

// get all Categories
Future<List<CategoryDetails>> fetchCategory() async {
  String token = await UserID.token;
  final response = await http.get(Uri.parse(categoryURL), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });
  List<CategoryDetails> category = <CategoryDetails>[];
  if (response.statusCode == 200) {
    category = (json.decode(response.body)['categoryDetails'] as List)
        .map((data) => CategoryDetails.fromJson(data))
        .toList();

    return category;
  } else {
    throw Exception('Failed to load expenseData');
  }
}

Future<List<CategoryDetails>> fetchIncome() async {
  print("Enter category");
  String token = await UserID.token;
  print("token $token");
  const categoryIncURL = '$baseURL/category-incomes';
  final response = await http.get(Uri.parse(categoryIncURL), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });
  List<CategoryDetails> category = <CategoryDetails>[];
  if (response.statusCode == 200) {
    category = (json.decode(response.body)["categoryDetails"] as List)
        .map((data) => CategoryDetails.fromJson(data))
        .toList();

    return category;
  } else {
    throw Exception('Failed to load expenseData');
  }
}
