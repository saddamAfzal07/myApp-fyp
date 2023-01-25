import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:myhoneypott/constant/user_id.dart';
import 'package:myhoneypott/models/transaction/expense_transaction.dart';
import 'package:http/http.dart' as http;
import 'package:myhoneypott/screens/logindialogues/error_dialouge.dart';
import 'package:myhoneypott/widget/income_dialogue.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ExpenseController extends ChangeNotifier {
  List<Transactions> transaction = [];
  int expenseMonthSum = 0;
  int totalIncome = 0;
  int totalBalance = 0;
  bool isLoading = false;
  bool transactionsText = false;
  String symbol = "RM";
  String totalExpensesPercentage = "0";
  // ignore: non_constant_identifier_names
  double Utilities = 0.0;
  double Commission = 0.0;
  double Others = 0.0;
  double Housing = 0.0;
  double Groceries = 0.0;
  double Transportation = 0.0;
  double Personal = 0.0;
  double Diningout = 0.0;
  double Entertainment = 0.0;
  DateTime? selectedDate;
  RefreshController refreshController = RefreshController(initialRefresh: true);
  selectDate(context) {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: selectedDate ?? DateTime.now(),
      locale: const Locale("en"),
    ).then((date) {
      if (date != null) {
        selectedDate = date;
        transaction = [];

        expenseApi(selectedDate!.year, selectedDate!.month, context);
      }
    });
    notifyListeners();
  }

  Future<void> expenseApi(year, month, context) async {
    print("Enter into Expense api");
    isLoading = true;
    transaction = [];
    String token = UserID.token;
    print(token);
    var response = await http.get(
        Uri.parse("https://www.myhoneypot.app/api/expense/$year/$month"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    Map data = jsonDecode(response.body.toString());
    if (response.statusCode == 400) {
      print("get 400");
      print("internal server error");
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding:
                  const EdgeInsets.only(top: 100, left: 20, right: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: ErrorAccountdialogue(
                  title: data["title"], message: data["message"]),
            );
          });

      isLoading = false;
      transactionsText = true;

      //Income Dialogue
      if (totalIncome == 0) {
        print(" income is equal zero");
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: const EdgeInsets.only(
                    top: 150, left: 20, right: 20, bottom: 150),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: const IncomeDialog(),
              );
            });
      } else {
        print("No income zero");
      }
    } else if (response.statusCode == 200) {
      transactionsText = false;
      isLoading = false;
      expenseMonthSum = data["totalExpenses"];
      totalBalance = data["totalBalance"];
      totalIncome = data["totalIncome"];
      symbol = data["symbol"]["symbol"];
      totalExpensesPercentage = data["totalExpensesPercentage"].toString();

      print(Commission);
      if (data["transactions"].isEmpty) {
        transactionsText = true;
      } else {
        isLoading = false;
        transactionsText = false;

        for (int i = 0; i < data["transactions"].length; i++) {
          Map obj = data["transactions"][i];
          Transactions pos = Transactions();
          pos = Transactions.fromJson(obj);
          transaction.add(pos);
        }
        print(transaction);
        refreshController.refreshCompleted();
      }
      if (data["categories"].isEmpty) {
        print("category emptyyy");

        Utilities = 0.0;
        Commission = 0.0;
        Others = 0.0;
        Housing = 0.0;
        Groceries = 0.0;
        Transportation = 0.0;
        Personal = 0.0;
        Diningout = 0.0;
        Entertainment = 0.0;
      } else {
        Utilities = data["categories"]["Utilities"] == null
            ? double.parse("0.0")
            : double.parse(data["categories"]["Utilities"]);
        Commission = data["categories"]["Commission"] == null
            ? double.parse("0.0")
            : double.parse(data["categories"]["Commission"]);

        Others = data["categories"]["Others"] == null
            ? double.parse("0.0")
            : double.parse(data["categories"]["Others"]);

        Housing = data["categories"]["Housing"] == null
            ? double.parse("0.0")
            : double.parse(data["categories"]["Housing"]);
        Groceries = data["categories"]["Groceries"] == null
            ? double.parse("0.0")
            : double.parse(data["categories"]["Groceries"]);
        Transportation = data["categories"]["Transportation"] == null
            ? double.parse("0.0")
            : double.parse(data["categories"]["Transportation"]);
        Personal = data["categories"]["Personal"] == null
            ? double.parse("0.0")
            : double.parse(data["categories"]["Personal"]);
        Diningout = data["categories"]["Dining out"] == null
            ? double.parse("0.0")
            : double.parse(data["categories"]["Dining out"]);
        Entertainment = data["categories"]["Entertainment"] == null
            ? double.parse("0.0")
            : double.parse(data["categories"]["Entertainment"]);
      }
      if (totalIncome == 0) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding:
                    const EdgeInsets.only(top: 100, left: 20, right: 20),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: const IncomeDialog(),
              );
            });
      }
    } else {
      isLoading = false;
    }
    notifyListeners();
  }
}
