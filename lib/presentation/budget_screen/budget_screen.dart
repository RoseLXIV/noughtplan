import 'dart:math';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/user_types_bugdet_widget.dart';

import '../budget_screen/widgets/listchart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:fl_chart/fl_chart.dart';

class BudgetScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ModalRoute.of(context)?.settings.arguments as Budget?;

    print('Budget ID: ${budget?.budgetId}');
    print('Budget Name: ${budget?.budgetName}');
    print('Budget Type: ${budget?.budgetType}');
    // print('Budget Necessary Categories: ${budget?.necessaryExpense}');
    // print('Budget Discretionary Categories: ${budget?.discretionaryExpense}');
    // print('Budget Debt Categories: ${budget?.debtExpense}');

    final Map<String, double> necessaryCategories =
        budget?.necessaryExpense ?? {};
    final Map<String, double> discretionaryCategories =
        budget?.discretionaryExpense ?? {};
    final Map<String, double> debtCategories = budget?.debtExpense ?? {};

    final double necessaryTotal =
        necessaryCategories.values.fold(0, (a, b) => a + b);
    final double discretionaryTotal =
        discretionaryCategories.values.fold(0, (a, b) => a + b);
    final double debtTotal = debtCategories.values.fold(0, (a, b) => a + b);

    final totalExpenses = necessaryTotal + discretionaryTotal + debtTotal;

    final numberFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    final String necessaryTotalFormatted = numberFormat.format(necessaryTotal);
    final String discretionaryTotalFormatted =
        numberFormat.format(discretionaryTotal);
    final String debtTotalFormatted = numberFormat.format(debtTotal);
    final String totalExpensesFormatted = numberFormat.format(totalExpenses);

    final pieChartDataResult = _generatePieChartData(
        necessaryCategories, discretionaryCategories, debtCategories);
    final PieChartData pieChartData = pieChartDataResult['pieChartData'];
    final percentages = pieChartDataResult['percentages'];

    List<Map<String, String>> necessaryBudgetItems = [];
    List<Map<String, String>> discretionaryBudgetItems = [];
    List<Map<String, String>> debtBudgetItems = [];

    necessaryCategories.forEach((key, value) {
      necessaryBudgetItems.add({
        'category': key,
        'amount': numberFormat.format(value),
      });
    });

    discretionaryCategories.forEach((key, value) {
      discretionaryBudgetItems.add({
        'category': key,
        'amount': numberFormat.format(value),
      });
    });

    debtCategories.forEach((key, value) {
      debtBudgetItems.add({
        'category': key,
        'amount': numberFormat.format(value),
      });
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        body: Container(
          height: getVerticalSize(
            812,
          ),
          width: double.maxFinite,
          child: Stack(
            // alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Transform(
                  transform: Matrix4.identity()..scale(1.0, 1.0, 0.1),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgTopographic7,
                    height: MediaQuery.of(context).size.height *
                        1, // Set the height to 50% of the screen height
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set the width to the full screen width
                    // alignment: Alignment.,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: getPadding(bottom: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgGroup183001,
                            height: getVerticalSize(
                              53,
                            ),
                            width: getHorizontalSize(
                              161,
                            ),
                            alignment: Alignment.topLeft,
                            margin: getMargin(
                              left: 17,
                              top: 25,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              children: [
                                Padding(
                                  padding: getPadding(
                                    right: 17,
                                    top: 28,
                                  ),
                                  child: IconButton(
                                    icon: CustomImageView(
                                      svgPath: ImageConstant.imgEdit1,
                                      height: getSize(
                                        24,
                                      ),
                                      width: getSize(
                                        24,
                                      ),
                                    ), // Replace with your desired icon
                                    onPressed: () {
                                      // Your onPressed code goes here
                                      print("IconButton tapped");
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(
                                    right: 17,
                                    top: 34,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Please read the instructions below',
                                              textAlign: TextAlign.center,
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold16,
                                            ),
                                            content: Text(
                                              "In this step, you'll be able to add discretionary categories to your budget. Follow the instructions below:\n\n"
                                              "1. Browse through the available categories or use the search bar to find specific ones that match your interests and lifestyle.\n"
                                              "2. Tap on a category to add it to your chosen categories list. You can always tap again to remove it if needed.\n"
                                              "3. Once you've added all the discretionary categories you want, press the 'Next' button to move on to reviewing your budget.\n\n"
                                              "Remember, these discretionary categories represent your non-essential expenses, such as entertainment, hobbies, and dining out. Adding them thoughtfully will help you create a balanced budget, allowing for personal enjoyment while still managing your finances effectively.",
                                              textAlign: TextAlign.center,
                                              style:
                                                  AppStyle.txtManropeRegular14,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 7),
                                      child: SvgPicture.asset(
                                        ImageConstant.imgQuestion,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Padding(
                          padding: getPadding(
                            top: 20,
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: getPadding(
                                left: 30,
                                right: 30,
                                bottom: 1,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: getPadding(
                                      left: 0,
                                      right: 0,
                                    ),
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.circular(20)),
                                        depth: 0.5,
                                        intensity: 2,
                                        surfaceIntensity: 0.8,
                                        lightSource: LightSource.top,
                                        color: ColorConstant.gray50,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: [
                                              getColorForSpendingType(
                                                  budget?.spendingType ?? ''),
                                              getColorForSavingType(
                                                  budget?.savingType ?? ''),
                                              getColorForDebtType(
                                                  budget?.debtType ?? ''),
                                            ],
                                            stops: [0.0, 0.5, 1.0],
                                          ),
                                        ),
                                        height: 13,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: SpendingTypePill(
                                                  type: budget?.spendingType ??
                                                      '',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: SavingTypePill(
                                                  type:
                                                      budget?.savingType ?? '',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: DebtTypePill(
                                                  type: budget?.debtType ?? '',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(top: 7),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(budget?.spendingType ?? '',
                                            style: AppStyle.txtManropeSemiBold12
                                                .copyWith(
                                              color: getColorForSpendingType(
                                                  budget?.spendingType ?? ''),
                                            )),
                                        Text(budget?.savingType ?? '',
                                            style: AppStyle.txtManropeSemiBold12
                                                .copyWith(
                                              color: getColorForSavingType(
                                                  budget?.savingType ?? ''),
                                            )),
                                        Text(budget?.debtType ?? '',
                                            style: AppStyle.txtManropeSemiBold12
                                                .copyWith(
                                              color: getColorForDebtType(
                                                  budget?.debtType ?? ''),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: getPadding(
                                      top: 20,
                                    ),
                                    width: double.maxFinite,
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.circular(20)),
                                        depth: 3,
                                        intensity: 0.5,
                                        lightSource: LightSource.topLeft,
                                        color: ColorConstant.gray50,
                                      ),
                                      child: Container(
                                        width: getHorizontalSize(
                                          327,
                                        ),
                                        // margin: getMargin(
                                        //   top: 15,
                                        // ),
                                        padding: getPadding(
                                          left: 5,
                                          top: 30,
                                          right: 5,
                                          bottom: 30,
                                        ),
                                        decoration: AppDecoration.outlineGray100
                                            .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.roundedBorder12,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Neumorphic(
                                              style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            320)),
                                                depth: 1,
                                                intensity: 0.7,
                                                lightSource:
                                                    LightSource.topLeft,
                                                color: ColorConstant.gray50,
                                              ),
                                              child: Container(
                                                height: getSize(320),
                                                width: getSize(320),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Neumorphic(
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .concave,
                                                          boxShape: NeumorphicBoxShape
                                                              .roundRect(
                                                                  BorderRadius
                                                                      .circular(
                                                                          195)),
                                                          depth: 20,
                                                          intensity: 0.5,
                                                          surfaceIntensity: 0.1,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft,
                                                          color: ColorConstant
                                                              .gray100,
                                                        ),
                                                        child: Container(
                                                          child: PieChart(
                                                            pieChartData,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Neumorphic(
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .concave,
                                                          boxShape: NeumorphicBoxShape
                                                              .roundRect(
                                                                  BorderRadius
                                                                      .circular(
                                                                          195)),
                                                          depth: -1.5,
                                                          intensity: 0.70,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft,
                                                          color: ColorConstant
                                                              .blue50,
                                                        ),
                                                        child: Container(
                                                          height: getSize(
                                                              195), // Adjust the size as needed
                                                          width: getSize(
                                                              195), // Adjust the size as needed
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        190), // Adjust the border radius as needed
                                                          ),
                                                          child: Padding(
                                                            padding: getPadding(
                                                                top: 10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      getPadding(
                                                                    bottom: 8,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        '${percentages['necessary'].toStringAsFixed(0)} / ${percentages['discretionary'].toStringAsFixed(0)} / ${percentages['debt'].toStringAsFixed(0)}',
                                                                        style: AppStyle
                                                                            .txtHelveticaNowTextBold12
                                                                            .copyWith(
                                                                          color:
                                                                              ColorConstant.blueGray300,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${totalExpensesFormatted}',
                                                                  style: AppStyle
                                                                      .txtHelveticaNowTextBold24
                                                                      .copyWith(
                                                                    color: ColorConstant
                                                                        .gray90001,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      getPadding(
                                                                          top:
                                                                              8),
                                                                ),
                                                                Text(
                                                                  'Created: ${DateFormat('MM/dd/yyyy').format(budget!.budgetDate)}',
                                                                  style: AppStyle
                                                                      .txtManropeSemiBold12
                                                                      .copyWith(
                                                                    color: ColorConstant
                                                                        .blueGray300,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // Add your content or child widget here
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: getPadding(
                                                // left: 6,
                                                top: 22,
                                              ),
                                            ),
                                            SingleChildScrollView(
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Neumorphic(
                                                      style: NeumorphicStyle(
                                                        shape: NeumorphicShape
                                                            .convex,
                                                        boxShape:
                                                            NeumorphicBoxShape
                                                                .roundRect(
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                        depth: 1,
                                                        intensity: 0.7,
                                                        surfaceIntensity: 0.2,
                                                        lightSource:
                                                            LightSource.top,
                                                        color: ColorConstant
                                                            .whiteA700,
                                                      ),
                                                      child: Container(
                                                        width:
                                                            getHorizontalSize(
                                                          110,
                                                        ),
                                                        height: getSize(
                                                          40,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Neumorphic(
                                                              style:
                                                                  NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .convex,
                                                                boxShape: NeumorphicBoxShape.roundRect(
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                                depth: 1,
                                                                intensity: 0.7,
                                                                surfaceIntensity:
                                                                    0.6,
                                                                lightSource:
                                                                    LightSource
                                                                        .top,
                                                                color:
                                                                    ColorConstant
                                                                        .gray50,
                                                              ),
                                                              child: Container(
                                                                height: getSize(
                                                                  18,
                                                                ),
                                                                width: getSize(
                                                                  18,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFF1A237E),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    getHorizontalSize(
                                                                      2,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  getPadding(
                                                                left: 6,
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Necessary",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppStyle
                                                                        .txtManropeBold11
                                                                        .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray9007f,
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                        0.3,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${necessaryTotalFormatted}",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppStyle
                                                                        .txtHelveticaNowTextBold12
                                                                        .copyWith(
                                                                      color: Color(
                                                                          0xFF1A237E),
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                        0.2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Neumorphic(
                                                      style: NeumorphicStyle(
                                                        shape: NeumorphicShape
                                                            .convex,
                                                        boxShape:
                                                            NeumorphicBoxShape
                                                                .roundRect(
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                        depth: 1,
                                                        intensity: 0.7,
                                                        surfaceIntensity: 0.2,
                                                        lightSource:
                                                            LightSource.top,
                                                        color: ColorConstant
                                                            .whiteA700,
                                                      ),
                                                      child: Container(
                                                        width:
                                                            getHorizontalSize(
                                                          110,
                                                        ),
                                                        height: getSize(
                                                          40,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Neumorphic(
                                                              style:
                                                                  NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .convex,
                                                                boxShape: NeumorphicBoxShape.roundRect(
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                                depth: 1,
                                                                intensity: 0.7,
                                                                surfaceIntensity:
                                                                    0.6,
                                                                lightSource:
                                                                    LightSource
                                                                        .top,
                                                                color:
                                                                    ColorConstant
                                                                        .gray50,
                                                              ),
                                                              child: Container(
                                                                height: getSize(
                                                                  18,
                                                                ),
                                                                width: getSize(
                                                                  18,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFF1E90FF),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    getHorizontalSize(
                                                                      2,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  getPadding(
                                                                left: 6,
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Discretionary",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppStyle
                                                                        .txtManropeBold11
                                                                        .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray9007f,
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                        0.3,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${discretionaryTotalFormatted}",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppStyle
                                                                        .txtHelveticaNowTextBold12
                                                                        .copyWith(
                                                                      color: Color(
                                                                          0xFF1E90FF),
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                        0.2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Neumorphic(
                                                      style: NeumorphicStyle(
                                                        shape: NeumorphicShape
                                                            .convex,
                                                        boxShape:
                                                            NeumorphicBoxShape
                                                                .roundRect(
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                        depth: 1,
                                                        intensity: 0.7,
                                                        surfaceIntensity: 0.2,
                                                        lightSource:
                                                            LightSource.top,
                                                        color: ColorConstant
                                                            .whiteA700,
                                                      ),
                                                      child: Container(
                                                        width:
                                                            getHorizontalSize(
                                                          110,
                                                        ),
                                                        height: getSize(
                                                          40,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Neumorphic(
                                                              style:
                                                                  NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .convex,
                                                                boxShape: NeumorphicBoxShape.roundRect(
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                                depth: 1,
                                                                intensity: 0.7,
                                                                surfaceIntensity:
                                                                    0.6,
                                                                lightSource:
                                                                    LightSource
                                                                        .top,
                                                                color:
                                                                    ColorConstant
                                                                        .gray50,
                                                              ),
                                                              child: Container(
                                                                height: getSize(
                                                                  18,
                                                                ),
                                                                width: getSize(
                                                                  18,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: ColorConstant
                                                                      .blueA700,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    getHorizontalSize(
                                                                      2,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  getPadding(
                                                                left: 6,
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Debt/Loans",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppStyle
                                                                        .txtManropeBold11
                                                                        .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray9007f,
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                        0.3,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${debtTotalFormatted}",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppStyle
                                                                        .txtHelveticaNowTextBold12
                                                                        .copyWith(
                                                                      color: ColorConstant
                                                                          .blueA700,
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                        0.2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 29,
                                    ),
                                    child: Text(
                                      "Debt Amounts",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtHelveticaNowTextBold16
                                          .copyWith(
                                        letterSpacing: getHorizontalSize(
                                          0.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 8,
                                    ),
                                    child: Padding(
                                      padding:
                                          getPadding(top: 8, left: 8, right: 8),
                                      child: ListView.separated(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: getVerticalSize(
                                              16,
                                            ),
                                          );
                                        },
                                        itemCount: debtBudgetItems.length,
                                        itemBuilder: (context, index) {
                                          return ListchartItemWidget(
                                            category: debtBudgetItems[index]
                                                ['category']!,
                                            amount: debtBudgetItems[index]
                                                ['amount']!,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 29,
                                    ),
                                    child: Text(
                                      "Necessary Amounts",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtHelveticaNowTextBold16
                                          .copyWith(
                                        letterSpacing: getHorizontalSize(
                                          0.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 8,
                                    ),
                                    child: Padding(
                                      padding:
                                          getPadding(top: 8, left: 8, right: 8),
                                      child: ListView.separated(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: getVerticalSize(
                                              16,
                                            ),
                                          );
                                        },
                                        itemCount: necessaryBudgetItems.length,
                                        itemBuilder: (context, index) {
                                          return ListchartItemWidget(
                                            category:
                                                necessaryBudgetItems[index]
                                                    ['category']!,
                                            amount: necessaryBudgetItems[index]
                                                ['amount']!,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 29,
                                    ),
                                    child: Text(
                                      "Discretionary Amounts",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtHelveticaNowTextBold16
                                          .copyWith(
                                        letterSpacing: getHorizontalSize(
                                          0.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 8,
                                    ),
                                    child: Padding(
                                      padding:
                                          getPadding(top: 8, left: 8, right: 8),
                                      child: ListView.separated(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: getVerticalSize(
                                              16,
                                            ),
                                          );
                                        },
                                        itemCount:
                                            discretionaryBudgetItems.length,
                                        itemBuilder: (context, index) {
                                          return ListchartItemWidget(
                                            category:
                                                discretionaryBudgetItems[index]
                                                    ['category']!,
                                            amount:
                                                discretionaryBudgetItems[index]
                                                    ['amount']!,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _generatePieChartData(
    Map<String, double> necessaryCategories,
    Map<String, double> discretionaryCategories,
    Map<String, double> debtCategories,
  ) {
    final List<Color> colors = [
      Color(0xFF1A237E), // Indigo 900
      Color(0xFF1E90FF), // Indigo 200
      ColorConstant.blueA700, // Blue 800
    ];

    final double necessaryTotal =
        necessaryCategories.values.fold(0, (a, b) => a + b);
    final double discretionaryTotal =
        discretionaryCategories.values.fold(0, (a, b) => a + b);
    final double debtTotal = debtCategories.values.fold(0, (a, b) => a + b);

    final mainSections = {
      "Necessary": necessaryTotal,
      "Discretionary": discretionaryTotal,
      "Debt": debtTotal,
    };

    final double totalBudget = necessaryTotal + discretionaryTotal + debtTotal;

    final double necessaryPercentage = necessaryTotal / totalBudget * 100;
    final double discretionaryPercentage =
        discretionaryTotal / totalBudget * 100;
    final double debtPercentage = debtTotal / totalBudget * 100;

    int colorIndex = 0;

    final sections = mainSections.entries.map((entry) {
      final categoryColor = colors[colorIndex % colors.length];
      colorIndex++;

      return PieChartSectionData(
        color: categoryColor,
        value: entry.value,
        title: '',
        radius: 40,
        titleStyle: TextStyle(color: Colors.white, fontSize: 12),
      );
    }).toList();

    return {
      'pieChartData': PieChartData(
        sections: sections,
        sectionsSpace: 0,
        centerSpaceRadius: 100,
        borderData: FlBorderData(show: true),
      ),
      'percentages': {
        'necessary': necessaryPercentage,
        'discretionary': discretionaryPercentage,
        'debt': debtPercentage,
      },
    };
  }
}
 //

  // Color(0xFF0D47A1), // Light Blue 900
      // Color(0xFF42A5F5), // Light Blue 400
      // Color(0xFF8B1E9B), // Bright Purple
      // Color(0xFF4A61DC), // Bright Indigo
      // Color.fromARGB(255, 28, 89, 83), // Turquoise
      // Color(0xFF3CB371), // Medium Sea Green
      // Color(0xFF32CD32), // Lime Green
      // Color(0xFF9ACD32), // Yellow Green
      // Color(0xFFFFD700), // Gold
      // Color(0xFFFFA500), // Orange
      // Color(0xFF7B68EE), // Medium Slate Blue
      // Color(0xFF4682B4), // Steel Blue
      // Color(0xFF00CED1), // Dark Turquoise
      // Color(0xFF20B2AA), // Light Sea Green
      // Color(0xFFADFF2F), // Green Yellow
      // Color(0xFFFFD54F), // Light Yellow
      // Color(0xFF8BC34A), // Light Green
      // Color(0xFFCDDC39), // Lime
      // Color(0xFFFFC107), // Amber
      // Color(0xFFBA68C8), // Medium Orchid
      // Color(0xFF7E57C2), // Deep Lavender
      // Color(0xFF5C6BC0), // Light Blue
      // Color(0xFF26A69A), // Medium Aquamarine
      // Color(0xFF66BB6A), // Soft Green
      // Color(0xFFD4E157), // Light Lime
      // Color(0xFFFFB74D), // Light Orange
      // Color(0xFF9575CD), // Light Purple
      // Color(0xFF7986CB), // Soft Blue
      // Color(0xFF4DB6AC), // Soft Green