import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';

// ignore: must_be_immutable
class ListchartItemWidget extends HookWidget {
  final String category;
  final String amount;
  final double totalAmount;
  final VoidCallback? onLoad;

  ListchartItemWidget({
    required this.category,
    required this.amount,
    required this.totalAmount,
    this.onLoad,
  });

  @override
  Widget build(BuildContext context) {
    print('totalAmount: $totalAmount');
    print('amount: $amount');
    useEffect(() {
      onLoad?.call();
      return () {}; // Clean-up function
    }, []);
    final formattedTotalAmount =
        NumberFormat.currency(symbol: '\$', decimalDigits: 2)
            .format(totalAmount);
    double amountDouble =
        double.parse(amount.replaceAll('\$', '').replaceAll(',', ''));
    // print('amountDouble: $amountDouble');
    double remainingAmount = amountDouble - totalAmount;
    Color progressBarColor =
        remainingAmount >= 0 ? Colors.green.shade300 : Colors.red.shade300;
    Color amountTextColor =
        remainingAmount >= 0 ? Colors.grey.shade800 : Colors.red;
    String formattedRemainingAmount =
        NumberFormat.currency(symbol: '\$', decimalDigits: 2)
            .format(remainingAmount);
    return Container(
      padding: getPadding(
        left: 20,
        top: 9,
        right: 20,
        bottom: 13,
      ),
      decoration: AppDecoration.outlineIndigo501.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 150,
                child: Padding(
                  padding: getPadding(bottom: 3),
                  child: Text(
                    category,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtHelveticaNowTextBold12.copyWith(
                        letterSpacing: 0.3, color: ColorConstant.black900),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: getPadding(bottom: 3),
                    child: Text(
                      "Total Spent",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeSemiBold10Bluegray300.copyWith(
                        letterSpacing: getHorizontalSize(
                          0.2,
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 132,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: LinearProgressIndicator(
                            value: totalAmount / amountDouble,
                            minHeight: 15,
                            backgroundColor: ColorConstant.gray100,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(progressBarColor),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0.1,
                        left: 4,
                        child: Text(
                          formattedTotalAmount,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtHelveticaNowTextBold12
                              .copyWith(color: Colors.grey.shade800),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: getPadding(top: 30),
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Remaining Amount",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppStyle.txtManropeSemiBold10Bluegray300.copyWith(
                      letterSpacing: getHorizontalSize(
                        0.2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      top: 1,
                    ),
                    child: Text(
                      formattedRemainingAmount,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtHelveticaNowTextBold16.copyWith(
                        letterSpacing: getHorizontalSize(
                          0.2,
                        ),
                        color: amountTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: getPadding(top: 5),
          // ),
        ],
      ),
    );
  }
}
