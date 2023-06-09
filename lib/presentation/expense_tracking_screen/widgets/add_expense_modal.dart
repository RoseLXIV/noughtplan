import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/expense_tracker/controller/expense_tracker_controller.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/widgets/custom_button_form.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'calender_widget.dart';

String? selectedCategory;
String? recurringType;
int? duration;
TextEditingController amountController = TextEditingController();

void resetControllers() {
  selectedCategory = null;
  recurringType = null;
  duration = null;

  amountController.clear();
}

Future<Map<String, dynamic>> getSubscriptionInfo() async {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> subscriptionInfo = {
    'isSubscribed': false,
    'expiryDate': null
  };

  if (firebaseUser != null) {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      bool isSubscribed =
          customerInfo.entitlements.all['pro_features']?.isActive ?? false;

      // parse the String into a DateTime
      String? expiryDateString =
          customerInfo.entitlements.all['pro_features']?.expirationDate;

      String? managementUrl = customerInfo.managementURL;
      DateTime? expiryDate;
      if (expiryDateString != null) {
        expiryDate = DateTime.parse(expiryDateString);
      }

      subscriptionInfo['isSubscribed'] = isSubscribed;
      subscriptionInfo['expiryDate'] = expiryDate;
      subscriptionInfo['managementUrl'] = managementUrl;
    } catch (e) {
      print('Failed to get customer info: $e');
    }
  }
  return subscriptionInfo;
}

Future<int> getExpenseLimit() async {
  var subscriptionInfo = await getSubscriptionInfo();
  if (subscriptionInfo['isSubscribed']) {
    return 180;
  } else {
    return 90;
  }
}

Future<void> showAddExpenseModal(
    BuildContext context, Budget? budget, WidgetRef ref) async {
  var expenseLimit = await getExpenseLimit();
  final categoryFocusNode = FocusNode();
  final amountFocusNode = FocusNode();
  final necessaryCategories = budget?.necessaryExpense ?? {};
  final discretionaryCategories = budget?.discretionaryExpense ?? {};
  final debtCategories = budget?.debtExpense ?? {};
  DateTime? selectedDate = ref.watch(calendarProvider).selectedDay;
  final expenseState = ref.watch(expenseTrackerProvider);

  final showErrorCategory = expenseState.category.error;
  final showErrorAmount = expenseState.amount.error;
  final expenseController = ref.watch(expenseTrackerProvider.notifier);
  final bool isValidated = expenseState.status.isValidated;

  print('Length of Actual Expenses ${budget?.actualExpenses.length}');

  List<String> allCategories = [
    ...necessaryCategories.keys,
    ...discretionaryCategories.keys,
    ...debtCategories.keys,
  ];

  await showModalBottomSheet(
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
              recurringType = null;
              duration = null;
              amountController.text = '';
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
                  initialChildSize: 0.7,
                  minChildSize: 0.7,
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
                                      padding: getPadding(top: 32),
                                      child: Text(
                                        'Add Expense',
                                        style: AppStyle
                                            .txtHelveticaNowTextBold32
                                            .copyWith(
                                          color: ColorConstant.black900,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(
                                        top: 3,
                                      ),
                                      child: Text(
                                        'Track your spending by entering each expense into the appropriate category.',
                                        style: AppStyle.txtManropeSemiBold12
                                            .copyWith(
                                          color: ColorConstant.blueGray500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  initialValue: DateFormat('EEEE, MMMM dd, y')
                                      .format(selectedDate ?? DateTime.now()),
                                  readOnly: false,
                                  decoration: InputDecoration(
                                    labelText: 'Date',
                                    labelStyle: AppStyle
                                        .txtHelveticaNowTextBold14
                                        .copyWith(
                                      color: ColorConstant.blueGray300,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: AppStyle.txtHelveticaNowTextBold18
                                      .copyWith(
                                    color: ColorConstant.black900,
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          selectedDate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    if (pickedDate != null &&
                                        pickedDate != selectedDate) {
                                      setState(() {
                                        selectedDate = pickedDate;
                                      });
                                    }
                                  },
                                  enabled: false,
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
                                      final expenseState =
                                          ref.watch(expenseTrackerProvider);
                                      final bool isValidated =
                                          expenseState.status.isValidated;

                                      void submitForm() async {
                                        if (isValidated) {
                                          DateTime startDate =
                                              selectedDate ?? DateTime.now();
                                          List<DateTime> expenseDates = [];

                                          switch (recurringType) {
                                            case 'Monthly':
                                              for (int i = 0;
                                                  i < (duration ?? 0);
                                                  i++) {
                                                expenseDates.add(startDate.add(
                                                    Duration(days: 30 * i)));
                                              }
                                              break;
                                            case 'Bi-Weekly':
                                              for (int i = 0;
                                                  i < (duration ?? 0);
                                                  i++) {
                                                expenseDates.add(startDate.add(
                                                    Duration(days: 14 * i)));
                                              }
                                              break;
                                            case 'Weekly':
                                              for (int i = 0;
                                                  i < (duration ?? 0);
                                                  i++) {
                                                expenseDates.add(startDate.add(
                                                    Duration(days: 7 * i)));
                                              }
                                              break;
                                            default:
                                              expenseDates.add(startDate);
                                          }

                                          for (DateTime expenseDate
                                              in expenseDates) {
                                            Map<String, dynamic> expenseData = {
                                              'date': expenseDate.toString(),
                                              'category':
                                                  selectedCategory ?? '',
                                              'amount': amountController
                                                      .text.isNotEmpty
                                                  ? double.tryParse(
                                                      amountController.text
                                                          .replaceAll(',', ''))
                                                  : 0.0,
                                            };

                                            String budgetId = budget!.budgetId;
                                            print('budgetId: $budgetId');
                                            await expenseController
                                                .addActualExpenseToBudget(
                                                    budgetId, expenseData, ref);
                                          }

                                          Navigator.pop(context);
                                          // resetValues();
                                        }
                                      }

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
                                                expenseController
                                                    .onCategoryChange(
                                                        newValue ?? '');
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
                                                errorText: expenseState.category
                                                                .error !=
                                                            null &&
                                                        categoryFocusNode
                                                            .hasFocus
                                                    ? Category.showCategoryErrorMessage(
                                                            showErrorCategory)
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
                                          TextField(
                                            onSubmitted: (_) => submitForm(),
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
                                              expenseController
                                                  .onAmountChange(amount);
                                              // print(amount);
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Amount',
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
                                                  .txtHelveticaNowTextBold40
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
                                              errorText: expenseState
                                                              .amount.error !=
                                                          null &&
                                                      amountFocusNode.hasFocus
                                                  ? Amount
                                                      .showAmountErrorMessage(
                                                          showErrorAmount)
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
                                          // Place this snippet between your TextField and SizedBox(height: 16)
                                          Padding(
                                            padding: getPadding(top: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: getPadding(left: 10),
                                                  child: Text(
                                                      'Frequency (Optional)',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: AppStyle
                                                          .txtHelveticaNowTextBold12
                                                          .copyWith(
                                                        color: ColorConstant
                                                            .blueGray300,
                                                      )),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    DropdownButton<String>(
                                                      hint: Text(
                                                        "Recurring",
                                                        style: AppStyle
                                                            .txtHelveticaNowTextBold16
                                                            .copyWith(
                                                                color: ColorConstant
                                                                    .blueGray300),
                                                      ),
                                                      value: recurringType,
                                                      items: <String>[
                                                        'Monthly',
                                                        'Bi-Weekly',
                                                        'Weekly'
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value,
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold16
                                                                  .copyWith(
                                                                color:
                                                                    ColorConstant
                                                                        .black900,
                                                              )),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          recurringType =
                                                              newValue!;
                                                        });
                                                      },
                                                    ),
                                                    DropdownButton<int>(
                                                      hint: Text("Duration",
                                                          style: AppStyle
                                                              .txtHelveticaNowTextBold16
                                                              .copyWith(
                                                            color: ColorConstant
                                                                .blueGray300,
                                                          )),
                                                      value: duration,
                                                      items: List<int>.generate(
                                                          12, (i) => i + 1).map<
                                                              DropdownMenuItem<
                                                                  int>>(
                                                          (int value) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: value,
                                                          child: Text(
                                                              value.toString(),
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold16
                                                                  .copyWith(
                                                                color:
                                                                    ColorConstant
                                                                        .black900,
                                                              )),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (int? newValue) {
                                                        setState(() {
                                                          duration = newValue!;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          CustomButtonForm(
                                            onTap: () async {
                                              if ((budget?.actualExpenses
                                                          .length ??
                                                      0) <
                                                  expenseLimit) {
                                                submitForm();
                                              }
                                            },
                                            alignment: Alignment.bottomCenter,
                                            height: getVerticalSize(56),
                                            text: (budget?.actualExpenses
                                                            .length ??
                                                        0) >=
                                                    expenseLimit
                                                ? "Max Expenses Reached"
                                                : "Save",
                                            enabled: (budget?.actualExpenses
                                                            .length ??
                                                        0) <
                                                    expenseLimit &&
                                                isValidated,
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
  resetControllers();
  ref.read(expenseTrackerProvider.notifier).reset();
}

class ThousandsFormatter extends TextInputFormatter {
  final int maxLength;

  ThousandsFormatter({this.maxLength = 12});

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
