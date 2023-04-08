import 'dart:math';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    final pieChartData = _generatePieChartData(
        necessaryCategories, discretionaryCategories, debtCategories);

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
                    child: Padding(
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
                  ),
                ],
              ),
              Padding(
                padding: getPadding(
                  top: 95,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  child: SpendingTypePill(
                                      type: budget?.spendingType ?? ''),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                      child: SavingTypePill(
                                          type: budget?.savingType ?? ''))),
                              Expanded(
                                  child: Container(
                                      child: DebtTypePill(
                                          type: budget?.debtType ?? ''))),
                            ],
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          child: Container(
                            width: getHorizontalSize(
                              327,
                            ),
                            margin: getMargin(
                              top: 15,
                            ),
                            padding: getPadding(
                              left: 5,
                              top: 30,
                              right: 5,
                              bottom: 30,
                            ),
                            decoration: AppDecoration.outlineGray100.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder12,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Neumorphic(
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(320)),
                                    depth: 1,
                                    lightSource: LightSource.topLeft,
                                    color: ColorConstant.gray50,
                                  ),
                                  child: Container(
                                    height: getSize(320),
                                    width: getSize(320),
                                    // margin: getMargin(top: 9),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: PieChart(
                                            pieChartData,
                                            swapAnimationCurve: Curves.bounceIn,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(
                                                          195)),
                                              depth: -1,
                                              lightSource: LightSource.topLeft,
                                              color: Colors.white,
                                            ),
                                            child: Container(
                                              height: getSize(
                                                  195), // Adjust the size as needed
                                              width: getSize(
                                                  195), // Adjust the size as needed
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(
                                                    190), // Adjust the border radius as needed
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
                                    left: 6,
                                    top: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            top: 29,
                          ),
                          child: Text(
                            "Budget Details",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtHelveticaNowTextBold16.copyWith(
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
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: getVerticalSize(
                                  1,
                                ),
                              );
                            },
                            itemCount: 0,
                            itemBuilder: (context, index) {
                              return ListchartItemWidget();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: getVerticalSize(
                    65,
                  ),
                  width: double.maxFinite,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: getVerticalSize(
                            50,
                          ),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: ColorConstant.whiteA700,
                            boxShadow: [
                              BoxShadow(
                                color: ColorConstant.blueGray5000a,
                                spreadRadius: getHorizontalSize(
                                  2,
                                ),
                                blurRadius: getHorizontalSize(
                                  2,
                                ),
                                offset: Offset(
                                  0,
                                  -8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: getPadding(top: 10),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: CustomImageView(
                                          svgPath: ImageConstant.imgUser,
                                          height: getVerticalSize(
                                            24,
                                          ),
                                          width: getHorizontalSize(
                                            24,
                                          ),
                                        ), // Replace with your desired icon
                                        onPressed: () {
                                          // Your onPressed code goes here
                                          print("IconButton tapped");
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 0,
                                  child: Container(
                                    height: getVerticalSize(
                                      50,
                                    ),
                                    width: getHorizontalSize(
                                      100,
                                    ),
                                    decoration:
                                        AppDecoration.fillBlueA700.copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder12,
                                    ),
                                    child: IconButton(
                                      icon: CustomImageView(
                                        svgPath:
                                            ImageConstant.imgClockWhiteA700,
                                        height: getVerticalSize(
                                          24,
                                        ),
                                        width: getHorizontalSize(
                                          24,
                                        ),
                                      ), // Replace with your desired icon
                                      onPressed: () {
                                        // Your onPressed code goes here
                                        print("IconButton tapped");
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(top: 10, right: 0),
                                  child: Material(
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: CustomImageView(
                                          svgPath: ImageConstant
                                              .imgVolumeBlueGray300,
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
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  PieChartData _generatePieChartData(
      Map<String, double> necessaryCategories,
      Map<String, double> discretionaryCategories,
      Map<String, double> debtCategories) {
    final List<Color> colors = [
      Color(0xFF1A237E), // Indigo 900
      Color(0xFF1E90FF),
      // Indigo 200
      Color(0xFF1565C0), // Blue 800
      Color(0xFF0D47A1), // Light Blue 900
      Color(0xFF42A5F5), // Light Blue 400
      Color(0xFF8B1E9B), // Bright Purple
      Color(0xFF4A61DC), // Bright Indigo
      // Dodger Blue// Deep Sky Blue
      Color(0xFF40E0D0), // Turquoise
      Color(0xFF3CB371), // Medium Sea Green
      Color(0xFF32CD32), // Lime Green
      Color(0xFF9ACD32), // Yellow Green
      Color(0xFFFFD700), // Gold
      Color(0xFFFFA500), // Orange
      Color(0xFF7B68EE), // Medium Slate Blue
      Color(0xFF4682B4), // Steel Blue
      Color(0xFF00CED1), // Dark Turquoise
      Color(0xFF20B2AA), // Light Sea Green
      Color(0xFFADFF2F), // Green Yellow
      Color(0xFFFFD54F), // Light Yellow
      Color(0xFF8BC34A), // Light Green
      Color(0xFFCDDC39), // Lime
      Color(0xFFFFC107), // Amber
      Color(0xFFBA68C8), // Medium Orchid
      Color(0xFF7E57C2), // Deep Lavender
      Color(0xFF5C6BC0), // Light Blue
      Color(0xFF26A69A), // Medium Aquamarine
      Color(0xFF66BB6A), // Soft Green
      Color(0xFFD4E157), // Light Lime
      Color(0xFFFFB74D), // Light Orange
      Color(0xFF9575CD), // Light Purple
      Color(0xFF7986CB), // Soft Blue
      Color(0xFF4DB6AC), // Soft Green
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

    return PieChartData(
      sections: sections,
      sectionsSpace: 0,
      centerSpaceRadius: 100,
      borderData: FlBorderData(show: false),
    );
  }
}
