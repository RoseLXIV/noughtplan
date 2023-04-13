import 'package:flutter/material.dart';
import 'package:noughtplan/core/utils/color_constant.dart';
import 'package:noughtplan/core/utils/size_utils.dart';
import 'package:noughtplan/theme/app_style.dart';

class SpendingTypePill extends StatelessWidget {
  final String type;

  const SpendingTypePill({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// Updated SavingTypePill
class SavingTypePill extends StatelessWidget {
  final String type;

  const SavingTypePill({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// Updated DebtTypePill
class DebtTypePill extends StatelessWidget {
  final String type;

  const DebtTypePill({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
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

Color getColorForSavingType(String type) {
  switch (type) {
    case 'Non-Saver':
      return Colors.grey;
    case 'Overspender':
      return Colors.red;
    case 'Wealthy':
      return ColorConstant.deepPurpleA400;
    case 'Cautious':
      return Colors.orange;
    case 'Frugal':
      return Colors.green;
    case 'Prudent Saver':
      return ColorConstant.blue90001;
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

Color getColorForDebtType(String type) {
  switch (type) {
    case 'Debt Free':
      return Colors.green;
    case 'Minimal Debt':
      return Colors.greenAccent;
    case 'Moderate Debt':
      return Colors.blue.shade700;
    case 'Danger Zone':
      return Colors.orange;
    case 'High Debt':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
