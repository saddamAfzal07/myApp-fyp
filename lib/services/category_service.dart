import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/models/category_model.dart';

import '../models/api_response.dart';

// get all Categories
Future<List<CategoryDetails>> fetchCategory() async {
  String token = await ApiResponse().getToken();
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
