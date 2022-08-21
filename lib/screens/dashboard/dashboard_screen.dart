import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/constant/app_text_styles.dart';
import 'package:myhoneypott/models/expenses_model.dart';
import 'package:myhoneypott/screens/custom_chart_data.dart';

final value = NumberFormat("#,##0.00", "en_US");

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen(
      {Key? key, required this.monthExpenses, required this.uniqueMonths})
      : super(key: key);

  final List<ExpensesAllMonth> monthExpenses;
  final List<String> uniqueMonths;

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late List<ExpensesAllMonth>? _monthExpenses;
  late List<String> _uniqueMonths;
  bool expenseVisibility = true;
  bool incomeVisibility = false;

  @override
  void initState() {
    super.initState();

    _monthExpenses = widget.monthExpenses;
    _uniqueMonths = widget.uniqueMonths;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      // height: height,
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //// chart
          SizedBox(height: height * 0.024),
          const CustomChartData(),
          Column(
            children: _uniqueMonths.map(
              (monthName) {
                Map<String, List<ExpensesAllMonth>> newList = {};

                /// List sorted by recent date
                _monthExpenses!.sort(
                    (a, b) => (b.formatted_date)!.compareTo(a.formatted_date!));

                newList = _monthExpenses!.groupBy((m) => m.formatted_date!);

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.016),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          "Transaction for $monthName 2022",
                          style: robotoSemiBold.copyWith(
                            color: AppColors.blackSoftColor,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.016),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expenseVisibility = true;
                                incomeVisibility = false;
                              });
                            },
                            child: Text(
                              "Expenses",
                              style: robotoSemiBold.copyWith(
                                color: expenseVisibility
                                    ? AppColors.blackSoftColor
                                    : AppColors.hintTextColor,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expenseVisibility = false;
                                incomeVisibility = true;
                              });
                            },
                            child: Text(
                              "Income",
                              style: robotoSemiBold.copyWith(
                                color: incomeVisibility
                                    ? AppColors.blackSoftColor
                                    : AppColors.hintTextColor,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //   /// chart data
                      SizedBox(height: height * 0.016),

                      //   /// step one
                      Visibility(
                        visible: expenseVisibility,
                        child: SingleChildScrollView(
                          // padding:
                          //     const EdgeInsets.only(bottom: 60.0),
                          child: Column(
                            children: newList.entries.map(
                              (entry) {
                                return SizedBox(
                                  height: height * 0.13,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: height * 0.032),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 8.0,
                                                width: 8.0,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                              const Expanded(
                                                child: VerticalDivider(
                                                  thickness: 1.0,
                                                  width: 1.0,
                                                  color: AppColors
                                                      .footerBorderColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   monthName.toUpperCase(),
                                              //   style: robotoRegular
                                              //       .copyWith(
                                              //     color: AppColors
                                              //         .blackSoftColor,
                                              //     fontSize:
                                              //         height * 0.01,
                                              //   ),
                                              // ),
                                              Text(
                                                entry.key,
                                                style: robotoSemiBold.copyWith(
                                                  color:
                                                      AppColors.blackSoftColor,
                                                  fontSize: height * 0.016,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: entry.value
                                                  .map(
                                                    (e) => Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    e.category!
                                                                        .description
                                                                        .toString(),
                                                                    style: robotoRegular
                                                                        .copyWith(
                                                                      fontSize:
                                                                          height *
                                                                              0.014,
                                                                      color: AppColors
                                                                          .blackSoftColor,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          2.0),
                                                                  Text(
                                                                    e.description
                                                                        .toString(),
                                                                    style: robotoRegular
                                                                        .copyWith(
                                                                      fontSize:
                                                                          height *
                                                                              0.014,
                                                                      color: AppColors
                                                                          .blackSoftColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text(
                                                              "RM${e.total!.toStringAsFixed(2)}",
                                                              style:
                                                                  robotoRegular
                                                                      .copyWith(
                                                                fontSize:
                                                                    height *
                                                                        0.016,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .blackSoftColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),

                      ///IncomeVisibility
                      Visibility(
                        visible: incomeVisibility,
                        child: SingleChildScrollView(
                          // padding:
                          //     const EdgeInsets.only(bottom: 60.0),
                          child: Column(
                            children: newList.entries.map(
                              (entry) {
                                return SizedBox(
                                  height: height * 0.13,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: height * 0.032),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 8.0,
                                                width: 8.0,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                              const Expanded(
                                                child: VerticalDivider(
                                                  thickness: 1.0,
                                                  width: 1.0,
                                                  color: AppColors
                                                      .footerBorderColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Text(" Income Api call Here")
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 12.0),
                                        //   child: Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.start,
                                        //     children: [

                                        //       Text(
                                        //         entry.key,
                                        //         style: robotoSemiBold.copyWith(
                                        //           color:
                                        //               AppColors.blackSoftColor,
                                        //           fontSize: height * 0.016,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
