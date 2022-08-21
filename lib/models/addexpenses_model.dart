// To parse this JSON data, do
//
//     final expense = expenseFromJson(jsonString);

import 'dart:convert';

Expense expenseFromJson(String str) => Expense.fromJson(json.decode(str));

String expenseToJson(Expense data) => json.encode(data.toJson());

class Expense {
  Expense({
    required this.singleExpense,
  });

  List<dynamic> singleExpense;

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        singleExpense: List<dynamic>.from(json["singleExpense"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "singleExpense": List<dynamic>.from(singleExpense.map((x) => x)),
      };
}
