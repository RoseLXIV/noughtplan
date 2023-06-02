import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/constants/budgets.dart';

import '../../../core/app_export.dart';

class DebtsListWidget extends StatelessWidget {
  final Budget? budget;
  final Map<String, dynamic> debtData;

  const DebtsListWidget(
      {Key? key, required this.budget, required this.debtData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    final formattedDebtAmount = formatter.format(debtData['amount']);
    final necessaryExpenseAmount =
        budget?.necessaryExpense![debtData['category']];
    final debtExpenseAmount = budget?.debtExpense![debtData['category']];
    final discretionaryExpenseAmount =
        budget?.discretionaryExpense![debtData['category']];

    final budgetAmount = necessaryExpenseAmount ??
        debtExpenseAmount ??
        discretionaryExpenseAmount;
    final formattedBudgetAmount =
        budgetAmount != null ? formatter.format(budgetAmount) : '0.00';

    double? totalSpent = budget?.actualExpenses
        .where((expense) => expense['category'] == debtData['category'])
        .fold<double>(0, (prev, curr) => prev + curr['amount']);

    double? progress = totalSpent != null && debtData['amount'] != null
        ? totalSpent / debtData['outstanding']
        : 0.0; // or any other default value

    double? remaining = debtData['amount'] != null && totalSpent != null
        ? debtData['outstanding'] - totalSpent
        : 0.0; // or any other default value
    // print('totalSpent: $totalSpent');
    // print('Total: ${goalData['amount']}');

    String formattedRemaining = formatter.format(remaining);

    double calculateTotalPayments(
        double loanBalance, double monthlyPayment, double annualInterestRate) {
      if (annualInterestRate == 0.0) {
        // If interest rate is 0, total payments is simply loan amount divided by payment amount
        // Using ceil to round up to nearest whole number
        return (loanBalance / monthlyPayment).ceilToDouble();
      } else {
        // Existing code when interest rate is not zero
        double monthlyInterestRate = annualInterestRate / 12 / 100;

        // Calculate the total number of payments (months)
        double numerator = log(monthlyPayment) -
            log(monthlyPayment - loanBalance * monthlyInterestRate);
        double denominator = log(1 + monthlyInterestRate);

        return numerator / denominator;
      }
    }

    double loanBalance = debtData['outstanding'];
    double monthlyPayment = debtData['amount'];
    double annualInterestRate = debtData['interest'];

    double totalPayments =
        calculateTotalPayments(loanBalance, monthlyPayment, annualInterestRate);

    double totalInterest;
    if (annualInterestRate == 0.0) {
      totalInterest = 0.0; // No interest if interest rate is 0%
    } else {
      totalInterest = (monthlyPayment * totalPayments) - loanBalance;
    }

    DateTime calculateEndDate(
        DateTime startDate, double totalPayments, String paymentFrequency) {
      DateTime endDate;

      switch (paymentFrequency) {
        case 'Monthly':
          endDate = startDate.add(Duration(days: (totalPayments * 30).round()));
          break;
        case 'Bi-Weekly':
          endDate = startDate.add(Duration(days: (totalPayments * 14).round()));
          break;
        case 'Weekly':
        default:
          endDate = startDate.add(Duration(days: (totalPayments * 7).round()));
          break;
      }

      return endDate;
    }

    DateTime startDate = DateTime.now(); // or whenever the loan starts
    String paymentFrequency = debtData['frequency'];

    DateTime endDate =
        calculateEndDate(startDate, totalPayments, paymentFrequency);

    DateTime roundUpDate(DateTime date) {
      int year = date.year;
      int month = date.month;

      if (date.day > 15) {
        // add one month
        month++;
        // if month overflow, reset month and increment year
        if (month > 12) {
          month = 1;
          year++;
        }
      }

      return DateTime(year, month);
    }

// use this function to round up endDate
    DateTime roundedEndDate = roundUpDate(endDate);

    // For a 5% increase
    double monthlyPaymentIncreased5 = monthlyPayment * 1.05;
    double totalPaymentsIncreased5 = calculateTotalPayments(
        loanBalance, monthlyPaymentIncreased5, annualInterestRate);
    double totalInterestIncreased5;
    if (annualInterestRate == 0.0) {
      totalInterestIncreased5 = 0.0; // No interest if interest rate is 0%
    } else {
      totalInterestIncreased5 =
          (monthlyPaymentIncreased5 * totalPaymentsIncreased5) - loanBalance;
    }
    DateTime endDateIncreased5 =
        calculateEndDate(startDate, totalPaymentsIncreased5, paymentFrequency);
    DateTime roundedEndDateIncreased5 = roundUpDate(endDateIncreased5);

// For a 10% increase
    double monthlyPaymentIncreased10 = monthlyPayment * 1.10;
    double totalPaymentsIncreased10 = calculateTotalPayments(
        loanBalance, monthlyPaymentIncreased10, annualInterestRate);
    double totalInterestIncreased10;
    if (annualInterestRate == 0.0) {
      totalInterestIncreased10 = 0.0; // No interest if interest rate is 0%
    } else {
      totalInterestIncreased10 =
          (monthlyPaymentIncreased10 * totalPaymentsIncreased10) - loanBalance;
    }
    DateTime endDateIncreased10 =
        calculateEndDate(startDate, totalPaymentsIncreased10, paymentFrequency);
    DateTime roundedEndDateIncreased10 = roundUpDate(endDateIncreased10);

// For a 20% increase
    double monthlyPaymentIncreased20 = monthlyPayment * 1.20;
    double totalPaymentsIncreased20 = calculateTotalPayments(
        loanBalance, monthlyPaymentIncreased20, annualInterestRate);
    double totalInterestIncreased20;
    if (annualInterestRate == 0.0) {
      totalInterestIncreased20 = 0.0; // No interest if interest rate is 0%
    } else {
      totalInterestIncreased20 =
          (monthlyPaymentIncreased20 * totalPaymentsIncreased20) - loanBalance;
    }
    DateTime endDateIncreased20 =
        calculateEndDate(startDate, totalPaymentsIncreased20, paymentFrequency);
    DateTime roundedEndDateIncreased20 = roundUpDate(endDateIncreased20);

    String formatMillions(double number) {
      if (number >= 1000000) {
        return "${(number / 1000000).toStringAsFixed(1)}M";
      } else if (number >= 1000) {
        return "${(number / 1000).toStringAsFixed(1)}K";
      } else {
        return number.toStringAsFixed(2);
      }
    }

    return Neumorphic(
      style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          depth: 0.5,
          intensity: 0.1,
          surfaceIntensity: 0.2,
          lightSource: LightSource.bottom,
          color: Colors.transparent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: getPadding(left: 16, right: 16, top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  debtData['category'],
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: AppStyle.txtHelveticaNowTextBold14
                      .copyWith(color: ColorConstant.gray900),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: getPadding(left: 4, right: 4, top: 2, bottom: 2),
                      decoration: BoxDecoration(
                        color: ColorConstant.blueA700,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Text(
                        '${debtData['interest'].toString()} %',
                        textAlign: TextAlign.center,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.whiteA700),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 3, bottom: 0),
                      child: Row(
                        children: [
                          Text(
                            '\$$formattedDebtAmount',
                            style: AppStyle.txtHelveticaNowTextBold14
                                .copyWith(color: ColorConstant.gray900),
                          ),
                          Text(
                            ' ${debtData['frequency']}',
                            style: AppStyle.txtManropeRegular12
                                .copyWith(color: ColorConstant.gray900),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: getPadding(left: 24, right: 24, top: 0, bottom: 0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 16,
                    backgroundColor: ColorConstant.gray100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1
                          ? Colors.green.shade300
                          : Colors.blue.shade300,
                    ),
                  ),
                ),
                Positioned(
                  top: 0.1,
                  right: 4,
                  child: Text(
                    '${formattedRemaining} left',
                    textAlign: TextAlign.left,
                    style: AppStyle.txtManropeBold12
                        .copyWith(color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: getPadding(left: 12, right: 12, top: 12, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Increased\nPayment',
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeRegular12
                          .copyWith(color: ColorConstant.blueGray800),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '0%',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '5%',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '10%',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '20%',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blue90001),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 65,
                  child: VerticalDivider(
                    color: ColorConstant.blueGray300,
                    thickness: 0.5,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly\nPayment',
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeRegular12
                          .copyWith(color: ColorConstant.blueGray800),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '\$${formatter.format(monthlyPayment)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '\$${formatter.format(monthlyPaymentIncreased5)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '\$${formatter.format(monthlyPaymentIncreased10)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '\$${formatter.format(monthlyPaymentIncreased20)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blue90001),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 65,
                  child: VerticalDivider(
                    color: ColorConstant.blueGray300,
                    thickness: 0.5,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total\nInterest',
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeRegular12
                          .copyWith(color: ColorConstant.blueGray800),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '\$${formatMillions(totalInterest)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '\$${formatMillions(totalInterestIncreased5)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '\$${formatMillions(totalInterestIncreased10)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '\$${formatMillions(totalInterestIncreased20)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blue90001),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 65,
                  child: VerticalDivider(
                    color: ColorConstant.blueGray300,
                    thickness: 0.5,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loan\nEnd Date',
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeRegular12
                          .copyWith(color: ColorConstant.blueGray800),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '${DateFormat.yMMMM().format(roundedEndDate)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '${DateFormat.yMMMM().format(roundedEndDateIncreased5)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '${DateFormat.yMMMM().format(roundedEndDateIncreased10)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blueGray800),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 0, right: 0, top: 4, bottom: 0),
                      child: Text(
                        '${DateFormat.yMMMM().format(roundedEndDateIncreased20)}',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12
                            .copyWith(color: ColorConstant.blue90001),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
