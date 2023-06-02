import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/constants/budgets.dart';

import '../../../core/app_export.dart';

class GoalsListWidget extends StatelessWidget {
  final Budget? budget;
  final Map<String, dynamic> goalData;

  const GoalsListWidget(
      {Key? key, required this.budget, required this.goalData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    final formattedGoalAmount = formatter.format(goalData['amount']);
    final necessaryExpenseAmount =
        budget?.necessaryExpense![goalData['category']];
    final debtExpenseAmount = budget?.debtExpense![goalData['category']];
    final discretionaryExpenseAmount =
        budget?.discretionaryExpense![goalData['category']];

    final budgetAmount = necessaryExpenseAmount ??
        debtExpenseAmount ??
        discretionaryExpenseAmount;
    final formattedBudgetAmount =
        budgetAmount != null ? formatter.format(budgetAmount) : '0.00';

    double? totalSpent = budget?.actualExpenses
        .where((expense) => expense['category'] == goalData['category'])
        .fold<double>(0, (prev, curr) => prev + curr['amount']);

    double? progress = totalSpent != null && goalData['amount'] != null
        ? totalSpent / goalData['amount']
        : 0.0; // or any other default value

    double? remaining = goalData['amount'] != null && totalSpent != null
        ? goalData['amount'] - totalSpent
        : 0.0; // or any other default value

    String formattedRemaining = formatter.format(remaining);

    DateTime calculateGoalEndDate(
        double remainingAmount, double paymentAmount, String paymentFrequency) {
      // Calculate the remaining number of payments
      int remainingPayments = (remainingAmount / paymentAmount).ceil();

      // Calculate the number of weeks to the end
      int weeksToGoal;
      switch (paymentFrequency) {
        case 'Monthly':
          weeksToGoal = remainingPayments * 4; // Assuming 4 weeks in a month
          break;
        case 'Bi-Weekly':
          weeksToGoal = remainingPayments * 2;
          break;
        case 'Weekly':
        default:
          weeksToGoal = remainingPayments;
          break;
      }

      // Calculate the end date
      DateTime currentDate = DateTime.now();
      DateTime goalEndDate = currentDate.add(Duration(days: weeksToGoal * 7));

      return goalEndDate;
    }

    DateTime goalEndDate;
    if (remaining != null && budgetAmount != null) {
      goalEndDate =
          calculateGoalEndDate(remaining, budgetAmount, goalData['frequency']);
    } else {
      goalEndDate = DateTime
          .now(); // set a default value or handle the situation differently
    }
    String goalEndDateStr = "${DateFormat.yMMMM().format(goalEndDate)}";

    String getGoalEndDateMessage(DateTime goalEndDate) {
      DateTime currentDate = DateTime.now();
      Duration remainingTime = goalEndDate.difference(currentDate);
      String formattedBudgetAmount =
          budget?.necessaryExpense![goalData['category']] != null
              ? formatter
                  .format(budget?.necessaryExpense![goalData['category']])
              : '0.00';

      if (remainingTime.isNegative) {
        return "Hats off to you! You've achieved your goal. This is what determination looks like. Your future self is thanking you, and so am I!";
      } else if (remainingTime.inDays == 0) {
        return "Today is a big day, the final day to reach your goal. I'm with you every step of the way. Together, we'll cross this finish line. I know you can do it!";
      } else if (remainingTime.inDays == 1) {
        return "Almost there, just one day left. Every penny saved is a step forward. You're doing great. Let's continue to save and achieve your goal together!";
      } else if (remainingTime.inDays < 7) {
        return 'Just a week to go! You\'ve been doing an awesome job! If you stick to saving "\$${formattedBudgetAmount}" each ${goalData['frequency']}, you\'ll reach your goal in no time!';
      } else {
        int remainingMonths = (remainingTime.inDays / 30).floor();
        int remainingYears = (remainingMonths / 12).floor();

        if (remainingYears > 0) {
          return 'You\'re on the right path, and it shows! You have around ${remainingYears} ${remainingYears > 1 ? 'years' : 'year'} and ${remainingMonths % 12} ${remainingMonths % 12 > 1 ? 'months' : 'month'} left to reach your goal, you\'re doing fantastic!';
        } else {
          return 'Just ${remainingMonths} ${remainingMonths > 1 ? 'months' : 'month'} left to reach your goal. You\'re making steady progress, let\'s keep the momentum going!';
        }
      }
    }
    // print('totalSpent: $totalSpent');
    // print('Total: ${goalData['amount']}');

    // print('goalData from Goals list Widget: $goalData');
    // print('budget from Goals list Widget: $budget');
    return Padding(
      padding: getPadding(bottom: 12),
      child: Neumorphic(
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
              margin: EdgeInsets.symmetric(vertical: 6),
              padding: getPadding(left: 16, right: 16, top: 8, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    goalData['category'],
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.txtHelveticaNowTextBold14
                        .copyWith(color: ColorConstant.gray900),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Text(
                      //   '\$$formattedGoalAmount',
                      //   style: AppStyle.txtHelveticaNowTextBold16
                      //       .copyWith(color: ColorConstant.gray900),
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${budget?.necessaryExpense![goalData['category']] != null ? formatter.format(budget?.necessaryExpense![goalData['category']]) : '0.00'}',
                            overflow: TextOverflow.ellipsis,
                            style: AppStyle.txtHelveticaNowTextBold14
                                .copyWith(color: ColorConstant.gray900),
                          ),
                          Text(
                            ' ${goalData['frequency']}',
                            style: AppStyle.txtManropeRegular12
                                .copyWith(color: ColorConstant.gray900),
                          ),
                        ],
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
                      '${formattedRemaining.startsWith('-') ? "+" : ""}\$${formattedRemaining.replaceAll('-', '')} / \$${formattedGoalAmount}',
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeBold12
                          .copyWith(color: Colors.grey.shade800),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: getPadding(left: 28, right: 20, top: 6, bottom: 8),
                child: Text(
                  getGoalEndDateMessage(goalEndDate),
                  textAlign: TextAlign.left,
                  style: AppStyle.txtManropeRegular12
                      .copyWith(color: ColorConstant.gray900),
                )),
          ],
        ),
      ),
    );
  }
}
