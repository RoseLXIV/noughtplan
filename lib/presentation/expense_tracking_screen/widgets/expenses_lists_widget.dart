import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/constants/budgets.dart';

import '../../../core/app_export.dart';

class ExpenseListWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Budget? budget;
  final Map<String, dynamic> expenseData;

  const ExpenseListWidget(
      {Key? key,
      required this.selectedDate,
      required this.budget,
      required this.expenseData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String category = expenseData['category'] ?? '';
    double amountValue = (expenseData['amount'] as num).toDouble();
    String amount = NumberFormat.currency(symbol: '\$', decimalDigits: 2)
        .format(amountValue);
    final List<Map<String, dynamic>> actualExpenses =
        budget?.actualExpenses ?? [];
    // print('actualExpenses from Expense list Wodget: $expenseData');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      decoration: AppDecoration.outlineIndigo501.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(12),
                  ),
                  depth: 0.1,
                  intensity: 0.9,
                  surfaceIntensity: 0.2,
                  lightSource: LightSource.top,
                  color: Colors.grey.shade50,
                ),
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: AppDecoration.fillGray100.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Text(
                      category,
                      textAlign: TextAlign.center,
                      style: AppStyle.txtManropeSemiBold12.copyWith(
                          letterSpacing: 0.3, color: ColorConstant.black900),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Amount",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeSemiBold10Bluegray300.copyWith(
                        letterSpacing: getHorizontalSize(
                          0.2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Text(
                        amount,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold18.copyWith(
                          letterSpacing: getHorizontalSize(
                            0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
