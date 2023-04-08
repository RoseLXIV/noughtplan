import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/presentation/home_page_screen/widgets/user_types_widget.dart';

// ignore: must_be_immutable
class ListItemWidget extends ConsumerWidget {
  final String budgetName;
  final String budgetType;
  final double totalExpenses;
  final String spendingType;
  final String savingType;
  final String debtType;

  ListItemWidget({
    required this.budgetName,
    required this.budgetType,
    required this.totalExpenses,
    required this.spendingType,
    required this.savingType,
    required this.debtType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalExpensesFormatted =
        NumberFormat.currency(decimalDigits: 2, symbol: '')
            .format(totalExpenses);
    // final budgetState = ref.watch(budgetStateProvider.notifier);
    return Container(
      margin: getMargin(
        right: 0,
      ),
      padding: getPadding(
        all: 16,
      ),
      decoration: AppDecoration.fillBlue90002
          .copyWith(borderRadius: BorderRadiusStyle.roundedBorder12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: getPadding(
              top: 2,
            ),
            child: Text(
              budgetName,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtHelveticaNowTextBold28WhiteA700.copyWith(
                letterSpacing: getHorizontalSize(
                  0.3,
                ),
              ),
            ),
          ),
          Padding(
            padding: getPadding(top: 10, left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: SpendingTypeBox(type: spendingType),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: SavingTypeBox(type: savingType),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: DebtTypeBox(type: debtType),
                  ),
                ),
              ],
            ),
          ),

          // child: Text(
          //   "$spendingType",
          //   overflow: TextOverflow.ellipsis,
          //   textAlign: TextAlign.right,
          //   style: AppStyle.txtManropeSemiBold12WhiteA700.copyWith(
          //     letterSpacing: getHorizontalSize(
          //       0.2,
          //     ),
          //   ),
          // ),
          // ),
          Padding(
            padding: getPadding(
              top: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Spacer(),
                Text(
                  "\$$totalExpensesFormatted",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtHelveticaNowTextBold20.copyWith(
                    letterSpacing: getHorizontalSize(
                      0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
