import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/models/expenses_model.dart';
import 'package:myhoneypott/screens/add_expenses/add_expenses.dart';
import 'package:myhoneypott/screens/budget/budget_scree.dart';
import 'package:myhoneypott/screens/dashboard/dash2.dart';

import 'package:myhoneypott/screens/dashboard/dashboard_screen.dart';
import 'package:myhoneypott/screens/expenses/components/expense_scr2.dart';
import 'package:myhoneypott/screens/expenses/expenses_screen.dart';
import 'package:myhoneypott/screens/new_dashboard/new_dashbaord_screen.dart';
import 'package:myhoneypott/screens/user_profile/user_profile.dart';
import 'package:myhoneypott/services/expenses_service.dart';
import 'package:myhoneypott/widget/drawer_screen.dart';

import '../constant/app_colors.dart';
import '../constant/app_icons.dart';
import 'package:http/http.dart' as http;

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  List<Widget> screens = [
    // const DashBoardScreen(),
    // const AddExpensesScreen(),
    // const SettingScreen(),
    // const SettingScreen(),
  ];

  void nextScreen(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late List<ExpensesAllMonth> _monthExpenses = [];
  late List<String> uniqueDates = [];
  late List<String> uniqueMonths = [];
  late String totalAmount = "";

  getExpenses() async {
    var json = await fetchMonthExpense();

    if (json.isEmpty) {
      print("enter into this part expense null");
      setState(() {
        _monthExpenses = [];
        screens = [
          // const Dash2(),
          // const ExpenceScreen2(),
          // const AddExpensesScreen(),
          // const BudgetScreen(),
          // const UserProfile(),
          const NewDashBoardScreen(),
          ExpensesScreen(
            _monthExpenses,
            uniqueMonths,
          ),
          const AddExpensesScreen(),
          const BudgetScreen(),
          const UserProfile(),
        ];
      });
    } else {
      print("Enter into new  dashboard part");
      uniqueDates.addAll(json.map((e) => e.formatted_date!));

      uniqueDates.toSet().toList();

      var uniques = <String, bool>{};
      List<String> keys = [];

      for (var s in uniqueDates) {
        uniques[s] = true;
      }

      keys.addAll(uniques.keys);

      List<int> total = [];

      total.addAll(json.map((e) => e.total!));

      int totalA = total.reduce((a, b) => a + b);

      setState(() {
        _monthExpenses = json;
        uniqueDates = keys;
        uniqueMonths = uniqueDates.map((e) => e.split(" ")[0]).toSet().toList();
        totalAmount = value.format(totalA);

        screens = [
          // DashBoardScreen(
          //   monthExpenses: _monthExpenses,
          //   uniqueMonths: uniqueMonths,
          // ),
          const NewDashBoardScreen(),

          ExpensesScreen(
            _monthExpenses,
            uniqueMonths,
          ),
          const AddExpensesScreen(),
          const BudgetScreen(),
          const UserProfile(),
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getExpenses();
    print("enter into get expenses");
    // expenceCount();
    // Count();
  }

  // static int expenseMonthSum = 0;
  // static int totalIncome = 0;
  // static int totalBalance = 0;
  // expenceCount() async {
  //   String token = await ApiResponse().getToken();
  //   var response = await http.get(Uri.parse(expenseURL), headers: {
  //     'Authorization': 'Bearer $token',
  //   });

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> responsedata = jsonDecode(response.body);
  //     if (responsedata["totalIncome"] == 0) {
  //       Get.dialog(
  //         const BudgetDialog(),
  //       );
  //     } else {}

  //     setState(() {
  //       // expenseMonthSum = responsedata["expenseMonthSum"];
  //       // totalBalance = responsedata["totalBalance"];
  //       // totalIncome = responsedata["totalIncome"];
  //       ExpenseCont.expenseMonthSum = responsedata["expenseMonthSum"];
  //       ExpenseCont.totalBalance = responsedata["totalBalance"];
  //       ExpenseCont.totalIncome = responsedata["totalIncome"];
  //     });
  //     print(ExpenseCont.expenseMonthSum);
  //     print(ExpenseCont.totalBalance);

  //     print(ExpenseCont.totalIncome);

  //     setState(() {});
  //   } else {
  //     print("not found");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      key: _key,
      drawer: const Drawer(
        child: DrawerScreen(),
      ),

      /// appbar
      appBar: currentIndex == 4
          ? null
          : AppBar(
              backgroundColor: AppColors.primaryColor,
              elevation: 0.0,
              toolbarHeight: 60.0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: AppColors.greyColor),
                onPressed: () {
                  _key.currentState!.openDrawer();
                },
              ),
              actions: const [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                    "https://www.reneechung.com/wp-content/themes/minimalist/images/me.jpg",
                  ),
                ),
                SizedBox(width: 16.0),
              ],
            ),
      extendBody: true,
      bottomNavigationBar: Container(
        height: isIOS ? 100.0 : 70.0,
        decoration: const BoxDecoration(
          color: AppColors.blackColor,
          border: Border(
            top: BorderSide(
              color: AppColors.footerBorderColor,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0.0,
          backgroundColor: AppColors.whiteColor,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.blackSoftColor,
          onTap: nextScreen,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppIcons.transcriptIcon),
              label: "",
              tooltip: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppIcons.productIcon),
              label: "",
              tooltip: "Expenses",
            ),
            const BottomNavigationBarItem(
              activeIcon: null,
              icon: Icon(null),
              label: "",
              tooltip: "Add Expenses",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppIcons.donutIcon),
              label: "",
              tooltip: "Product",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppIcons.settingIcon),
              label: "",
              tooltip: "Setting",
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: AppColors.primaryColor,
          tooltip: "Add Expenses",
          child: const Icon(Icons.add),
          onPressed: () {
            /*setState(() {
              currentIndex = 2;
            });*/
            Get.to(const AddExpensesScreen());
          },
        ),
      ),
      body: _monthExpenses.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : currentIndex == 4
              ? screens[currentIndex]
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.024),
                      // IncomeAndExpense(
                      // expenseMonthSum: expenseMonthSum,
                      // totalBalance: totalBalance,
                      // totalIncome: totalIncome,
                      // ),
                      // SizedBox(height: height * 0.024),
                      screens[currentIndex],
                    ],
                  ),
                ),
    );
  }
}
