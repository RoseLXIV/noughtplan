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
                getColorForSpendingType('Necessary Spender'),
                getColorForSpendingType('Balanced Spender'),
                getColorForSpendingType('Impulsive Spender'),
                getColorForSpendingType('Impulsive Spender'),
              ],
              stops: [
                0.0,
                0.35,
                0.5,
                0.65,
                1.0,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  String categorizeSpender() {
    if ((totalNecessaryExpense - totalDiscretionaryExpense).abs() < 300) {
      return 'Balanced Spender';
    }
    if (totalDiscretionaryExpense > totalNecessaryExpense) {
      return 'Impulsive Spender';
    }
    return 'Necessary Spender';
  }

  double _calculateArrowPosition(double progressBarWidth) {
    final spenderType = categorizeSpender();

    switch (spenderType) {
      case 'Necessary Spender':
        return (progressBarWidth * 0.35 / 2) - 12;
      case 'Balanced Spender':
        return progressBarWidth * 0.5 - 12;
      case 'Impulsive Spender':
        return progressBarWidth - (progressBarWidth * 0.35 / 2) - 12;
      default:
        return 0;
    }
  }

  Color getColorForSpendingType(String type) {
    switch (type) {
      case 'Balanced Spender':
        return Colors.green;
      case 'Impulsive Spender':
        return Colors.red;
      case 'Necessary Spender':
        return Colors.blue.shade400;
      default:
        return Colors.grey;
    }
  }
}
