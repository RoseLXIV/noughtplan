import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/user_types_bugdet_widget.dart';

class SpendingTypeProgressBar extends StatelessWidget {
  final double totalNecessaryExpense;
  final double totalDiscretionaryExpense;

  SpendingTypeProgressBar({
    required this.totalNecessaryExpense,
    required this.totalDiscretionaryExpense,
  });

  @override
  Widget build(BuildContext context) {
    final double progressBarWidth = MediaQuery.of(context).size.width * 0.8;
    final double arrowPosition = _calculateArrowPosition(progressBarWidth);

    return Column(
      children: [
        SizedBox(
          height: 20, // Height of the arrow icon
          width: progressBarWidth,
          child: Stack(
            children: [
              Positioned(
                left: arrowPosition,
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 10,
          width: progressBarWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              colors: [
                getColorForSpendingType('Necessary Spender'),
                getColorForSpendingType('Balanced Spender'),
                getColorForSpendingType('Impulsive Spender'),
              ],
              stops: [
                0.35,
                0.5,
                0.65,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  double _calculateArrowPosition(double progressBarWidth) {
    final double spendingRatio = totalDiscretionaryExpense /
        (totalNecessaryExpense + totalDiscretionaryExpense);

    return progressBarWidth * spendingRatio -
        36; // Subtract half the width of the arrow icon
  }

  Color getColorForSpendingType(String type) {
    switch (type) {
      case 'Balanced Spender':
        return Colors.green;
      case 'Impulsive Spender':
        return Colors.red.shade400;
      case 'Necessary Spender':
        return Colors.blue.shade400;
      default:
        return Colors.grey;
    }
  }
}

class DebtTypeProgressBar extends StatelessWidget {
  final double debt;
  final double income;

  DebtTypeProgressBar({
    required this.debt,
    required this.income,
  });

  @override
  Widget build(BuildContext context) {
    final double progressBarWidth = MediaQuery.of(context).size.width * 0.8;
    final double arrowPosition = _calculateArrowPosition(progressBarWidth);

    return Column(
      children: [
        SizedBox(
          height: 20, // Height of the arrow icon
          width: progressBarWidth,
          child: Stack(
            children: [
              Positioned(
                left: arrowPosition,
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 10,
          width: progressBarWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              colors: [
                getColorForDebtType("Debt Free"),
                getColorForDebtType("Minimal Debt"),
                getColorForDebtType("Moderate Debt"),
                getColorForDebtType("Danger Zone"),
                getColorForDebtType("High Debt"),
              ],
              stops: [
                0.0,
                0.2,
                0.4,
                0.6,
                0.8,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  String assignDebtType() {
    double debtToIncomeRatio = debt / income;
    if (debtToIncomeRatio == 0) {
      return "Debt Free";
    } else if (debtToIncomeRatio < 0.1) {
      return "Minimal Debt";
    } else if (debtToIncomeRatio >= 0.1 && debtToIncomeRatio <= 0.35) {
      return "Moderate Debt";
    } else if (debtToIncomeRatio > 0.35 && debtToIncomeRatio <= 0.42) {
      return "Danger Zone";
    } else {
      return "High Debt";
    }
  }

  double _calculateArrowPosition(double progressBarWidth) {
    final debtType = assignDebtType();

    switch (debtType) {
      case 'Debt Free':
        return 0;
      case 'Minimal Debt':
        return (progressBarWidth * 0.25) - 12;
      case 'Moderate Debt':
        return (progressBarWidth * 0.5) - 12;
      case 'Danger Zone':
        return (progressBarWidth * 0.75) - 12;
      case 'High Debt':
        return progressBarWidth - 24;
      default:
        return 0;
    }
  }

  Color getColorForDebtType(String type) {
    switch (type) {
      case "Debt Free":
        return Colors.green;
      case "Minimal Debt":
        return Colors.blue.shade400;
      case "Moderate Debt":
        return Colors.yellow.shade700;
      case "Danger Zone":
        return Colors.orange.shade700;
      case "High Debt":
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }
}

class SaverTypeProgressBar extends StatelessWidget {
  final String spendingType;
  final double savings;
  final double salary;

  SaverTypeProgressBar({
    required this.spendingType,
    required this.savings,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    final double progressBarWidth = MediaQuery.of(context).size.width * 0.8;
    final double arrowPosition = _calculateArrowPosition(progressBarWidth);

    return Column(
      children: [
        SizedBox(
          height: 20,
          width: progressBarWidth,
          child: Stack(
            children: [
              Positioned(
                left: arrowPosition,
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 10,
          width: progressBarWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              colors: _getColorsForProgressBar(),
              stops: [0.3, 0.5, 0.7],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  double _calculateArrowPosition(double progressBarWidth) {
    double savingsRatio = savings / salary;

    if (savingsRatio <= 0.1) {
      return progressBarWidth * 0.3 * savingsRatio - 12;
    } else if (savingsRatio <= 0.2) {
      return progressBarWidth * 0.3 +
          (progressBarWidth * 0.2 * (savingsRatio - 0.1) / 0.1) -
          12;
    } else {
      return progressBarWidth * 0.5 +
          (progressBarWidth * 0.5 * (savingsRatio - 0.2) / 0.8) -
          12;
    }
  }

  List<Color> _getColorsForProgressBar() {
    if (spendingType == 'Impulsive Spender') {
      return [
        getColorForSavingType('Overspender'),
        getColorForSavingType('Moderate Saver'),
        getColorForSavingType('Wealthy'),
      ];
    } else if (spendingType == 'Necessary Spender') {
      return [
        getColorForSavingType('Cautious'),
        getColorForSavingType('Prudent Saver'),
        getColorForSavingType('Frugal'),
      ];
    } else if (spendingType == 'Balanced Spender') {
      return [
        getColorForSavingType('Limited Saver'),
        getColorForSavingType('Balanced Saver'),
        getColorForSavingType('Strategic'),
      ];
    } else {
      return [Colors.grey, Colors.grey, Colors.grey];
    }
  }

  Color getColorForSavingType(String type) {
    switch (type) {
      case 'Non-Saver':
        return Colors.grey;
      case 'Overspender':
        return Colors.red.shade500;
      case 'Wealthy':
        return Colors.deepPurpleAccent.shade400;
      case 'Cautious':
        return Colors.orange;
      case 'Frugal':
        return Colors.green.shade700;
      case 'Prudent Saver':
        return Colors.blue.shade900;
      case 'Limited Saver':
        return Colors.yellow.shade300;
      case 'Strategic':
        return Colors.green.shade300;
      case 'Balanced Saver':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }
}
