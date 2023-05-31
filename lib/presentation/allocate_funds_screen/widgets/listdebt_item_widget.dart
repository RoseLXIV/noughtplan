import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/allocate_funds/controller/remaining_funds_controller.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/widgets/custom_button.dart';

class EnteredAmountsNotifierDebt extends StateNotifier<Map<String, double>> {
  EnteredAmountsNotifierDebt() : super({});

  double getAmount(String category) {
    return state[category] ?? 0.0;
  }

  void updateAmount(String category, double amount) {
    if (amount == 0) {
      state = {...state}..remove(category);
      print('EnteredAmountsNotifierDebt - Removed amount for $category');
    } else {
      state = {...state, category: amount};
      print(
          'EnteredAmountsNotifierDebt - Updated amount for $category to $amount');
    }
  }

  void resetAmounts() {
    for (var key in state.keys) {
      state[key] = 0.0;
      print('EnteredAmountsNotifierDebt - Reset amount for $key to 0.0');
    }
    state =
        Map<String, double>.from(state); // This line triggers a state update.
    print('EnteredAmountsNotifier - Reset all amounts: $state');
  }
}

final enteredAmountsDebtProvider =
    StateNotifierProvider<EnteredAmountsNotifierDebt, Map<String, double>>(
        (ref) => EnteredAmountsNotifierDebt());

// add this line
class CustomTextEditingControllerDebt extends TextEditingController {
  CustomTextEditingControllerDebt({String initialText = ''})
      : super(text: initialText == '0.00' ? '' : _formatNumber(initialText));

  static String _formatNumber(String number) {
    if (number.isEmpty) {
      return '';
    }
    final formatter = NumberFormat('#,##0.00', 'en_US');
    double parsedNumber = double.tryParse(number) ?? 0;
    return formatter.format(parsedNumber);
  }
}

// add this line
final textEditingDebtControllerProvider = StateProvider.family
    .autoDispose<CustomTextEditingControllerDebt, String>((ref, category) {
  double initialAmount =
      ref.read(enteredAmountsDebtProvider.notifier).getAmount(category);
  print('Initial amount for $category: $initialAmount'); // Add this line
  return CustomTextEditingControllerDebt(
      initialText: initialAmount == 0 ? '' : initialAmount.toStringAsFixed(2));
});

final oldAmountsProviderDebt = StateNotifierProvider.autoDispose<
    OldAmountsControllerDebt, Map<String, double>>((ref) {
  return OldAmountsControllerDebt();
});

class OldAmountsControllerDebt extends StateNotifier<Map<String, double>> {
  OldAmountsControllerDebt() : super({});

  void setOldAmount(String category, double amount) {
    state = {...state, category: amount};
  }

  double getOldAmount(String category) {
    return state[category] ?? 0.0;
  }
}

final focusNodeProviderDebt =
    StateProvider.family.autoDispose<FocusNode, String>((ref, category) {
  return FocusNode();
});

// ignore: must_be_immutable
class ListDebtItemWidget extends ConsumerWidget {
  final String category;
  final double amount;

  ListDebtItemWidget({required this.category, required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enteredAmounts = ref.watch(enteredAmountsDebtProvider);
    final hasAmountEntered =
        enteredAmounts[category] != null && enteredAmounts[category]! > 0;

    final CustomTextEditingControllerDebt _controller =
        ref.watch(textEditingDebtControllerProvider(category));

    final FocusNode focusNode =
        ref.watch(focusNodeProviderDebt(category).notifier).state;
    final remainingFundsStateProvider = StateProvider<double>((ref) => 0.0);
    return Container(
      padding: getPadding(
        left: 10,
        top: 9,
        right: 10,
        bottom: 9,
      ),
      decoration: AppDecoration.outlineIndigo501.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            height: getVerticalSize(60),
            width: getSize(150),
            text: category,
            margin: getMargin(left: 6),
            variant: hasAmountEntered
                ? ButtonVariant.FillGreenOutlined
                : ButtonVariant.FillGray100,
            shape: ButtonShape.RoundedBorder6,
            padding: ButtonPadding.PaddingT12,
            fontStyle: ButtonFontStyle.ManropeSemiBold12Gray900,
            onTap: () {
              final FocusNode focusNode =
                  ref.read(focusNodeProviderDebt(category).notifier).state;
              FocusScope.of(context).requestFocus(focusNode);
            },
          ),
          Padding(
            padding: getPadding(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: getPadding(left: 5),
                  child: Text(
                    "Amount",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtManropeSemiBold10Bluegray300.copyWith(
                      letterSpacing: getHorizontalSize(0.2),
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(top: 3),
                  child: SizedBox(
                    width: 130, // adjust the width as needed
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left:
                                  4), // Adjust this value to position the prefix correctly
                          child: Text(
                            '\$',
                            style: AppStyle.txtManropeBold18,
                          ),
                        ),
                        TextField(
                          focusNode: focusNode,
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "${amount.toStringAsFixed(2)}",
                            hintStyle:
                                AppStyle.txtManropeBold18BlueGrey.copyWith(
                              letterSpacing: getHorizontalSize(0.3),
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 24,
                                top: 2,
                                bottom: 2), // Add left padding to avoid overlap
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            ThousandsFormatterDebt(),
                          ],
                          style: AppStyle.txtManropeBold18,
                          onChanged: (text) {
                            String cleanedText =
                                text.replaceAll(RegExp(','), '');
                            double amount = double.tryParse(cleanedText) ?? 0.0;
                            final previousAmount = ref
                                .read(enteredAmountsDebtProvider.notifier)
                                .getAmount(category);

                            print("RemainingFundsController - OnChanged:");
                            print("RemainingFundsController - Amount: $amount");
                            print(
                                "RemainingFundsController - Previous Amount: $previousAmount");

                            // Get the updated remaining funds
                            double remainingFunds =
                                ref.read(remainingFundsProvider.notifier).state;

                            if (amount != 0 &&
                                remainingFunds - amount + previousAmount < 0) {
                              FocusScope.of(context).unfocus();
                              // Show a SnackBar if remaining funds go below zero
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Remaining funds cannot be less than zero',
                                    textAlign: TextAlign.center,
                                    style: AppStyle
                                        .txtHelveticaNowTextBold16WhiteA700
                                        .copyWith(
                                      letterSpacing: getHorizontalSize(0.3),
                                    ),
                                  ),
                                  backgroundColor: ColorConstant.amber600,
                                  duration: Duration(seconds: 3),
                                ),
                              );

                              // Clear the TextField
                              amount = 0;
                              _controller.clear();
                              _controller.value =
                                  _controller.value.copyWith(text: '');
                              ref
                                  .read(remainingFundsProvider.notifier)
                                  .updateFunds(amount, previousAmount);

                              ref
                                  .read(enteredAmountsDebtProvider.notifier)
                                  .updateAmount(category, amount);
                              print(
                                  "RemainingFundsController - Amount: $amount");
                            } else {
                              ref
                                  .read(remainingFundsProvider.notifier)
                                  .updateFunds(amount, previousAmount);
                              ref
                                  .read(enteredAmountsDebtProvider.notifier)
                                  .updateAmount(category, amount);

                              ref
                                      .read(remainingFundsStateProvider.notifier)
                                      .state =
                                  remainingFunds - amount + previousAmount;

                              // Update the old amount after updating the remaining funds and entered amounts
                              ref
                                  .read(oldAmountsProviderDebt.notifier)
                                  .setOldAmount(category, amount);
                            }
                          },
                        ),
                      ],
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

class ThousandsFormatterDebt extends TextInputFormatter {
  final int maxLength;

  ThousandsFormatterDebt({this.maxLength = 12});

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

      // split the value into integer and decimal parts
      List<String> parts = value.split('.');

      // truncate the integer part if it exceeds maxLength
      if (parts[0].length > maxLength) {
        parts[0] = parts[0].substring(0, maxLength);
      }

      // truncate the decimal part if it exceeds 2 digits
      if (parts.length > 1 && parts[1].length > 2) {
        parts[1] = parts[1].substring(0, 2);
      }

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
