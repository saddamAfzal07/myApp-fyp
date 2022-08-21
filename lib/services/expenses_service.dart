import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/models/expenses_model.dart';
import 'package:myhoneypott/models/user.dart';

import '../models/api_response.dart';

// get all Expense
Future<List<ExpenseData>> fetchExpenses() async {
  String token = await ApiResponse().getToken();
  final response = await http.get(Uri.parse(expenseURL), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });
  var expenses = <ExpenseData>[];
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    expenses = (json.decode(response.body)['expense'] as List)
        .map((data) => ExpenseData.fromJson(data))
        .toList();
    return expenses;
    // we get list of posts, so we need to map each item to post model
    //apiResponse.data as List<dynamic>;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load expenseData');
  }
}

// get all Expense
Future<ExpensesModel> fetchExpense() async {
  String token = await ApiResponse().getToken();

  final response = await http.get(Uri.parse(expenseURL), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ExpensesModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load expenseData');
  }
}

// get all Expense all month dashboard table
Future<List<ExpensesAllMonth>> fetchMonthExpense() async {
  String token = await ApiResponse().getToken();
  final response = await http.get(Uri.parse(expenseURL), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });

  var expenses = <ExpensesAllMonth>[];
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    expenses = (json.decode(response.body)['expensesAllMonth'] as List)
        .map((data) => ExpensesAllMonth.fromJson(data))
        .toList();
    return expenses;
    // we get list of posts, so we need to map each item to post model
    //apiResponse.data as List<dynamic>;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load expenseData');
  }
}

// add Expenses
Future<ApiResponse> addExpenses(String email, String password) async {
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
