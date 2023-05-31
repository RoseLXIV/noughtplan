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

    // Function to determine the goal end date message
    String getGoalEndDateMessage(DateTime goalEndDate) {
      DateTime currentDate = DateTime.now();
      Duration remainingTime = goalEndDate.difference(currentDate);

      if (remainingTime.isNegative) {
        return "Congratulations! You have successfully achieved your goal. You've demonstrated great determination and perseverance.";
      } else if (remainingTime.inDays == 0) {
        return "Today is the last day to reach your goal. Stay focused and give it your all. You're so close!";
      } else if (remainingTime.inDays == 1) {
        return 'Just one more day to go to achieve your goal. Keep pushing forward and remember that every step counts!';
      } else if (remainingTime.inDays < 7) {
        return 'You have ${remainingTime.inDays} days left to reach your goal. Keep up the good work, stay motivated, and make the most of every day!';
      } else {
        int remainingMonths = (remainingTime.inDays / 30).floor();
        int remainingYears = (remainingMonths / 12).floor();

        if (remainingYears > 0) {
          return 'You have ${remainingYears} ${remainingYears > 1 ? 'years' : 'year'} and ${remainingMonths % 12} ${remainingMonths % 12 > 1 ? 'months' : 'month'} left to reach your goal. Stay committed and motivated, and remember that consistency brings success!';
        } else {
          return 'You have ${remainingMonths} ${remainingMonths > 1 ? 'months' : 'month'} left to reach your goal. Stay focused, keep up the great work, and trust in your ability to achieve what you set out to do!';
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
              margin: EdgeInsets.symmetric(vertical: 12),
              padding: getPadding(left: 8, right: 8, top: 8, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    goalData['category'],
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
                      Row(
                        children: [
                          Text(
                            '\$${budget?.necessaryExpense![goalData['category']] != null ? formatter.format(budget?.necessaryExpense![goalData['category']]) : '0.00'}',
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
                      '${formattedRemaining.startsWith('-') ? "+" : ""}\$${formattedRemaining.replaceAll('-', '')} left',
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeBold12
                          .copyWith(color: Colors.grey.shade800),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: getPadding(left: 28, right: 16, top: 6, bottom: 8),
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
