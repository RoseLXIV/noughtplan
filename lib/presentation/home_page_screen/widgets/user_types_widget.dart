import 'package:flutter/material.dart';
import 'package:noughtplan/core/utils/color_constant.dart';

class SpendingTypeBox extends StatelessWidget {
  final String type;

  const SpendingTypeBox({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case 'Balanced Spender':
        color = Colors.green;
        break;
      case 'Impulsive Spender':
        color = Colors.red;
        break;
      case 'Necessary Spender':
        color = Colors.blue.shade400;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.all(4),
    );
  }
}

class SavingTypeBox extends StatelessWidget {
  final String type;

  const SavingTypeBox({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case 'Non-Saver':
        color = Colors.grey;
        break;
      case 'Overspender':
        color = Colors.red;
        break;
      case 'Wealthy':
        color = Colors.green;
        break;
      case 'Cautious':
        color = Colors.orange;
        break;
      case 'Frugal':
        color = ColorConstant.greenA700;
        break;
      case 'Prudent Saver':
        color = ColorConstant.blue900;
        break;
      case 'Limited Saver':
        color = Colors.yellow;
        break;
      case 'Strategic':
        color = Colors.blueGrey;
        break;
      case 'Balanced Saver':
        color = Colors.greenAccent;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      decoration: BoxDecoration(
        color: color,
        // borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(4),
    );
  }
}

class DebtTypeBox extends StatelessWidget {
  final String type;

  const DebtTypeBox({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case 'Debt Free':
        color = Colors.green;
        break;
      case 'Minimal Debt':
        color = Colors.greenAccent;
        break;
      case 'Moderate Debt':
        color = Colors.orange.shade500;
        break;
      case 'Danger Zone':
        color = Colors.red;
        break;
      case 'High Debt':
        color = Colors.deepPurple;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.all(4),
    );
  }
}
