// To parse this JSON data, do
//
//     final expense = expenseFromJson(jsonString);

import 'dart:convert';

Expense expenseFromJson(String str) => Expense.fromJson(json.decode(str));

String expenseToJson(Expense data) => json.encode(data.toJson());

class Expense {
  Expense({
    required this.expenseMonthSum,
  });

  int expenseMonthSum;

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        expenseMonthSum: json["expenseMonthSum"],
      );

  Map<String, dynamic> toJson() => {
        "expenseMonthSum": expenseMonthSum,
      };
}
