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
    return Neumorphic(
      style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          depth: 0.5,
          intensity: 0.1,
          surfaceIntensity: 0.2,
          lightSource: LightSource.bottom,
          color: Colors.transparent),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        padding: getPadding(left: 16, right: 8, top: 8, bottom: 12),
        child: Text('Debts List Widget'),
      ),
    );
  }
}
