import 'package:flutter/material.dart';
import 'package:myhoneypott/models/expenses_model.dart';
import 'package:myhoneypott/services/expenses_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<ExpenseData> _expenses = [];

  getExpenses() async {
    var json = await fetchExpenses();
    setState(() {
      _expenses = json;
    });
  }

  @override
  void initState() {
    super.initState();
    getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Data"),
      ),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_expenses[index].date.toString()),
            subtitle: Text(_expenses[index].total.toString()),
          );
        },
      ),
    );
  }
}
