import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/expense_tracker/controller/debt_tracker_controller.dart';
import 'package:noughtplan/core/budget/expense_tracker/controller/goal_tracker_controller.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/widgets/custom_button_form.dart';

Future<void> showAddTrackerModal(
    BuildContext context, Budget? budget, WidgetRef ref) async {
  final categoryFocusNode = FocusNode();
  final frequencyFocusNode = FocusNode();
  final amountFocusNode = FocusNode();
  final amountOutstandingFocusNode = FocusNode();
  final interestFocusNode = FocusNode();
  final trackerFocusNode = FocusNode();

  final necessaryCategories = budget?.necessaryExpense ?? {};
  final discretionaryCategories = budget?.discretionaryExpense ?? {};
  final debtCategories = budget?.debtExpense ?? {};

  final goalState = ref.watch(goalTrackerProvider);
  final debtState = ref.watch(debtTrackerProvider);

  final showErrorCategoryGoal = goalState.category.error;
  final showErrorAmountGoal = goalState.amount.error;
  final showErrorFrequencyGoal = goalState.frequency.error;
  final showErrorTrackerGoal = goalState.tracker.error;

  final showErrorCategoryDebt = debtState.category.error;
  final showErrorAmountDebt = debtState.amount.error;
  final showErrorOutstandingDebt = debtState.outstanding.error;
  final showErrorInterestDebt = debtState.interest.error;
  final showErrorFrequencyDebt = debtState.frequency.error;
  final showErrorTrackerDebt = debtState.tracker.error;

  final goalController = ref.watch(goalTrackerProvider.notifier);
  final debtController = ref.watch(debtTrackerProvider.notifier);

  List<String> allCategories = [
    ...necessaryCategories.keys,
    ...discretionaryCategories.keys,
    ...debtCategories.keys,
  ];

  String? selectedCategory;
  String? frequencyType;
  String? trackerType;

  final amountController = TextEditingController(
    text: (budget?.debtExpense?[selectedCategory]?.toString() ??
        budget?.discretionaryExpense?[selectedCategory]?.toString() ??
        budget?.necessaryExpense?[selectedCategory]?.toString() ??
        ''),
  );
  TextEditingController amountOustandingController = TextEditingController();
  TextEditingController interestController = TextEditingController();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    clipBehavior: Clip.none,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void resetValues() {
            setState(() {
              selectedCategory = null;
              frequencyType = null;
              trackerType = null;
              amountController.text = '';
              amountOustandingController.text = '';
              interestController.text = '';
            });
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                      // color: Colors.grey.withOpacity(0.5),
                      ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.8,
                  minChildSize: 0.8,
                  maxChildSize: 1,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      padding: EdgeInsets.only(
                          top: 8, left: 32, right: 32, bottom: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[400],
                              ),
                              // margin: EdgeInsets.symmetric(vertical: 8),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: getPadding(top: 32, bottom: 4),
                                      child: Text(
                                        'Add Goal/Debt Tracker',
                                        style: AppStyle
                                            .txtHelveticaNowTextBold32
                                            .copyWith(
                                          color: ColorConstant.black900,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(top: 3, bottom: 8),
                                      child: Text(
                                        'Tracker your goals or debt by filling in the necessary fields below, including the goal/debt category, amount, monthly contribution, outstanding balance, and interest rate (if applicable).',
                                        style: AppStyle.txtManropeSemiBold12
                                            .copyWith(
                                          color: ColorConstant.blueGray500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                // Place this snippet between your TextField and SizedBox(height: 16)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: getPadding(left: 10),
                                      child: Text(
                                          'Tracker Type and Payment Frequency',
                                          textAlign: TextAlign.start,
                                          style: AppStyle
                                              .txtHelveticaNowTextBold12
                                              .copyWith(
                                            color: ColorConstant.blueGray300,
                                          )),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              errorText: trackerType == "Goal"
                                                  ? goalState.category.error !=
                                                              null &&
                                                          trackerFocusNode
                                                              .hasFocus
                                                      ? Tracker.showTrackerErrorMessage(
                                                              showErrorTrackerGoal)
                                                          .toString()
                                                      : null
                                                  : debtState.category.error !=
                                                              null &&
                                                          trackerFocusNode
                                                              .hasFocus
                                                      ? Tracker.showTrackerErrorMessage(
                                                              showErrorTrackerDebt)
                                                          .toString()
                                                      : null,
                                              errorStyle: AppStyle
                                                  .txtManropeRegular12
                                                  .copyWith(
                                                color: ColorConstant.redA700,
                                              ),
                                            ),
                                            hint: Text(
                                              "Tracker Type",
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold14
                                                  .copyWith(
                                                color:
                                                    ColorConstant.blueGray300,
                                              ),
                                            ),
                                            value: trackerType,
                                            items: <String>[
                                              'Goal',
                                              'Debt',
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold16
                                                      .copyWith(
                                                    color:
                                                        ColorConstant.black900,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                trackerType = newValue!;
                                              });
                                              goalController
                                                  .onTrackerTypeChange(
                                                      newValue ?? '');

                                              debtController
                                                  .onTrackerTypeChange(
                                                      newValue ?? '');
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              errorText: trackerType == "Goal"
                                                  ? goalState.category.error !=
                                                              null &&
                                                          frequencyFocusNode
                                                              .hasFocus
                                                      ? Frequency.showFrequencyErrorMessage(
                                                              showErrorFrequencyGoal)
                                                          .toString()
                                                      : null
                                                  : debtState.category.error !=
                                                              null &&
                                                          frequencyFocusNode
                                                              .hasFocus
                                                      ? Frequency.showFrequencyErrorMessage(
                                                              showErrorFrequencyDebt)
                                                          .toString()
                                                      : null,
                                              errorStyle: AppStyle
                                                  .txtManropeRegular12
                                                  .copyWith(
                                                color: ColorConstant.redA700,
                                              ),
                                            ),
                                            hint: Text(
                                              "Frequency",
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold14
                                                  .copyWith(
                                                color:
                                                    ColorConstant.blueGray300,
                                              ),
                                            ),
                                            value: frequencyType,
                                            items: <String>[
                                              'Monthly',
                                              'Bi-Weekly',
                                              'Weekly'
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold16
                                                      .copyWith(
                                                    color:
                                                        ColorConstant.black900,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                frequencyType = newValue!;
                                              });
                                              goalController.onFrequencyChange(
                                                  newValue ?? '');

                                              debtController.onFrequencyChange(
                                                  newValue ?? '');
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: ColorConstant
                                        .whiteA700, // Background color
                                  ),
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      final goalState =
                                          ref.watch(goalTrackerProvider);
                                      final debtState =
                                          ref.watch(debtTrackerProvider);
                                      final bool isValidatedGoal =
                                          goalState.status.isValidated;
                                      final bool isValidatedDebt = debtState
                                          .status.isValidated; // Add this line

                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: ColorConstant
                                                  .gray50, // Background color
                                            ),
                                            child: DropdownSearch<String>(
                                              focusNode: categoryFocusNode,
                                              mode: Mode.BOTTOM_SHEET,
                                              showSearchBox: true,
                                              selectedItem: selectedCategory,
                                              dropdownBuilder:
                                                  (context, selectedItem) {
                                                return Text(
                                                  selectedItem ??
                                                      "Select a category",
                                                  style: selectedItem == null
                                                      ? AppStyle
                                                          .txtHelveticaNowTextBold18
                                                          .copyWith(
                                                          color: ColorConstant
                                                              .blueGray300, // Your desired color for "Select a category"
                                                        )
                                                      : AppStyle
                                                          .txtHelveticaNowTextBold18
                                                          .copyWith(
                                                          color: ColorConstant
                                                              .black900,
                                                        ),
                                                );
                                              },
                                              items: allCategories,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedCategory = newValue;
                                                });

                                                // Fetch the category amount from the corresponding expense map
                                                final categoryAmount = budget
                                                            ?.debtExpense?[
                                                        newValue ?? ''] ??
                                                    budget?.discretionaryExpense?[
                                                        newValue ?? ''] ??
                                                    budget?.necessaryExpense?[
                                                        newValue ?? ''];

                                                goalController.onCategoryChange(
                                                    newValue ?? '');

                                                debtController.onCategoryChange(
                                                    newValue ?? '');

                                                // Set the category amount in the expense controller
                                                goalController.onAmountChange(
                                                    categoryAmount
                                                            ?.toString() ??
                                                        '');

                                                debtController.onAmountChange(
                                                    categoryAmount
                                                            ?.toString() ??
                                                        '');

                                                // Update the amount TextField value
                                                if (trackerType == 'Debt') {
                                                  amountController.text =
                                                      categoryAmount
                                                              ?.toString() ??
                                                          '';
                                                }

                                                print(
                                                    'selected category: $newValue');
                                              },
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                labelText: "Category",
                                                labelStyle: AppStyle
                                                    .txtHelveticaNowTextBold14
                                                    .copyWith(
                                                  color:
                                                      ColorConstant.blueGray300,
                                                ),
                                                fillColor: Colors.transparent,
                                                filled: true,
                                                border: InputBorder.none,
                                                errorText: trackerType == "Goal"
                                                    ? goalState.category
                                                                    .error !=
                                                                null &&
                                                            categoryFocusNode
                                                                .hasFocus
                                                        ? Category.showCategoryErrorMessage(
                                                                showErrorCategoryGoal)
                                                            .toString()
                                                        : null
                                                    : debtState.category
                                                                    .error !=
                                                                null &&
                                                            categoryFocusNode
                                                                .hasFocus
                                                        ? Category.showCategoryErrorMessage(
                                                                showErrorCategoryDebt)
                                                            .toString()
                                                        : null,
                                                errorStyle: AppStyle
                                                    .txtManropeRegular12
                                                    .copyWith(
                                                        color: ColorConstant
                                                            .redA700),
                                              ),
                                              popupItemBuilder:
                                                  (context, item, isSelected) {
                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item,
                                                        style: AppStyle
                                                            .txtHelveticaNowTextBold18
                                                            .copyWith(
                                                          color: ColorConstant
                                                              .black900,
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: ColorConstant
                                                            .blueGray100,
                                                        thickness: 0.5,
                                                        indent: 10,
                                                        endIndent: 10,
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          TextField(
                                            onSubmitted: (_) {},
                                            controller: amountController,
                                            focusNode: amountFocusNode,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            inputFormatters: [
                                              ThousandsFormatter(),
                                            ],
                                            textAlign: TextAlign.start,
                                            onChanged: (amount) {
                                              goalController
                                                  .onAmountChange(amount);
                                              debtController
                                                  .onAmountChange(amount);
                                              // print(amount);
                                            },
                                            decoration: InputDecoration(
                                              labelText: trackerType == 'Debt'
                                                  ? 'Monthly Payment'
                                                  : 'Total Amount of Goal',
                                              labelStyle: AppStyle
                                                  .txtHelveticaNowTextBold14
                                                  .copyWith(
                                                color:
                                                    ColorConstant.blueGray300,
                                              ),
                                              fillColor: Colors.transparent,
                                              filled: true,
                                              prefixText: '\$ ',
                                              prefixStyle: AppStyle
                                                  .txtHelveticaNowTextBold32
                                                  .copyWith(
                                                color: ColorConstant.blue90001,
                                              ),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              border: UnderlineInputBorder(),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                borderSide: BorderSide(
                                                  color:
                                                      ColorConstant.blueGray100,
                                                  width: 0.5,
                                                ),
                                              ),
                                              errorText: trackerType == "Goal"
                                                  ? goalState.category.error !=
                                                              null &&
                                                          amountFocusNode
                                                              .hasFocus
                                                      ? Amount.showAmountErrorMessage(
                                                              showErrorAmountGoal)
                                                          .toString()
                                                      : null
                                                  : debtState.category.error !=
                                                              null &&
                                                          amountFocusNode
                                                              .hasFocus
                                                      ? Amount.showAmountErrorMessage(
                                                              showErrorAmountDebt)
                                                          .toString()
                                                      : null,
                                              errorStyle: AppStyle
                                                  .txtManropeRegular12
                                                  .copyWith(
                                                      color: ColorConstant
                                                          .redA700),
                                            ),
                                            style: AppStyle
                                                .txtHelveticaNowTextBold40
                                                .copyWith(
                                              color: ColorConstant.blue90001,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          if (trackerType == 'Debt')
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        amountOustandingController,
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    inputFormatters: [
                                                      ThousandsFormatter(),
                                                    ],
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Outstanding Balance',
                                                      labelStyle: AppStyle
                                                          .txtHelveticaNowTextBold14
                                                          .copyWith(
                                                        color: ColorConstant
                                                            .blueGray300,
                                                      ),
                                                      fillColor:
                                                          Colors.transparent,
                                                      filled: true,
                                                      prefixText: '\$ ',
                                                      prefixStyle: AppStyle
                                                          .txtHelveticaNowTextBold24
                                                          .copyWith(
                                                        color: ColorConstant
                                                            .blue90001,
                                                      ),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      border:
                                                          UnderlineInputBorder(),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24),
                                                        borderSide: BorderSide(
                                                          color: ColorConstant
                                                              .blueGray100,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      errorText: debtState
                                                                      .amount
                                                                      .error !=
                                                                  null &&
                                                              amountOutstandingFocusNode
                                                                  .hasFocus
                                                          ? Amount.showAmountErrorMessage(
                                                              showErrorOutstandingDebt)
                                                          : null,
                                                      errorStyle: AppStyle
                                                          .txtManropeRegular12
                                                          .copyWith(
                                                              color:
                                                                  ColorConstant
                                                                      .redA700),
                                                    ),
                                                    style: AppStyle
                                                        .txtHelveticaNowTextBold24
                                                        .copyWith(
                                                      color: ColorConstant
                                                          .blue90001,
                                                    ),
                                                    onChanged: (amount) {
                                                      debtController
                                                          .onOutstandingChange(
                                                              amount);
                                                      // print(amount);
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: TextField(
                                                    controller:
                                                        interestController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Interest Rate',
                                                      labelStyle: AppStyle
                                                          .txtHelveticaNowTextBold14
                                                          .copyWith(
                                                        color: ColorConstant
                                                            .blueGray300,
                                                      ),
                                                      fillColor:
                                                          Colors.transparent,
                                                      filled: true,
                                                      suffixText: ' %',
                                                      suffixStyle: AppStyle
                                                          .txtHelveticaNowTextBold24
                                                          .copyWith(
                                                        color: ColorConstant
                                                            .blue90001,
                                                      ),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      border:
                                                          UnderlineInputBorder(),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24),
                                                        borderSide: BorderSide(
                                                          color: ColorConstant
                                                              .blueGray100,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      errorText: debtState
                                                                      .amount
                                                                      .error !=
                                                                  null &&
                                                              interestFocusNode
                                                                  .hasFocus
                                                          ? Amount.showAmountErrorMessage(
                                                              showErrorInterestDebt)
                                                          : null,
                                                      errorStyle: AppStyle
                                                          .txtManropeRegular12
                                                          .copyWith(
                                                              color:
                                                                  ColorConstant
                                                                      .redA700),
                                                    ),
                                                    style: AppStyle
                                                        .txtHelveticaNowTextBold24
                                                        .copyWith(
                                                      color: ColorConstant
                                                          .blue90001,
                                                    ),
                                                    onChanged: (amount) {
                                                      debtController
                                                          .onInterestChange(
                                                              amount);
                                                      // print(amount);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          SizedBox(height: 16),
                                          CustomButtonForm(
                                            onTap: () async {
                                              if (trackerType == 'Goal') {
                                                Map<String, dynamic> goalData =
                                                    {
                                                  'category': selectedCategory,
                                                  'frequency': frequencyType,
                                                  'amount': double.tryParse(
                                                          amountController.text
                                                              .replaceAll(
                                                                  ',', '')) ??
                                                      0.0,
                                                };

                                                String budgetId =
                                                    budget!.budgetId;
                                                print('budgetId: $budgetId');

                                                print('goalData: $goalData');

                                                await goalController
                                                    .addGoalToBudget(budgetId,
                                                        goalData, ref);
                                                Navigator.pop(context);
                                              } else if (trackerType ==
                                                  'Debt') {
                                                Map<String, dynamic> debtData =
                                                    {
                                                  'category': selectedCategory,
                                                  'frequency': frequencyType,
                                                  'amount': double.tryParse(
                                                          amountController.text
                                                              .replaceAll(
                                                                  ',', '')) ??
                                                      0.0,
                                                  'outstanding': double.tryParse(
                                                          amountOustandingController
                                                              .text
                                                              .replaceAll(
                                                                  ',', '')) ??
                                                      0.0,
                                                  'interest': double.tryParse(
                                                          interestController
                                                              .text
                                                              .replaceAll(
                                                                  ',', '')) ??
                                                      0.0,
                                                };
                                                String budgetId =
                                                    budget!.budgetId;
                                                print('budgetId: $budgetId');

                                                print('debtData: $debtData');

                                                await debtController
                                                    .addDebtToBudget(budgetId,
                                                        debtData, ref);
                                                Navigator.pop(context);
                                              }
                                            },
                                            alignment: Alignment.bottomCenter,
                                            height: getVerticalSize(56),
                                            text: "Create Tracker",
                                            enabled: trackerType == "Goal"
                                                ? isValidatedGoal
                                                : isValidatedDebt,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class ThousandsFormatter extends TextInputFormatter {
  final int maxLength;

  ThousandsFormatter({this.maxLength = 24});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text == '.') {
      return newValue.copyWith(text: '0.');
    } else if (newValue.text.contains('.') &&
        newValue.text.indexOf('.') != newValue.text.lastIndexOf('.')) {
      // if there are multiple dots
      return oldValue;
    } else {
      // remove all non-digit characters
      String value = newValue.text.replaceAll(RegExp(r'[^\d\.]'), '');

      // enforce max length
      if (value.length > maxLength) {
        value = value.substring(0, maxLength);
      }

      // split the value into integer and decimal parts
      List<String> parts = value.split('.');

      // format the integer part with commas
      parts[0] = NumberFormat.decimalPattern().format(int.parse(parts[0]));

      // recombine the integer and decimal parts
      String result = parts.join('.');

      // return the updated TextEditingValue
      return newValue.copyWith(
        text: result,
        selection: TextSelection.collapsed(offset: result.length),
      );
    }
  }
}
