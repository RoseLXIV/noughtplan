import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/allocate_funds/controller/remaining_funds_controller.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/widgets/custom_button.dart';

class EnteredAmountsNotifier extends StateNotifier<Map<String, double>> {
  EnteredAmountsNotifier() : super({});

  double getAmount(String category) {
    return state[category] ?? 0.0;
  }

  void updateAmount(String category, double amount) {
    if (amount == 0) {
      state = {...state}..remove(category);
      print('EnteredAmountsNotifier - Removed amount for $category');
    } else {
      state = {...state, category: amount};
      print('EnteredAmountsNotifier - Updated amount for $category to $amount');
    }
  }

  void resetAmounts() {
    for (var key in state.keys) {
      state[key] = 0.0;
      print('EnteredAmountsNotifier - Reset amount for $key to 0.0');
    }
    state =
        Map<String, double>.from(state); // This line triggers a state update.
    print('EnteredAmountsNotifier - Reset all amounts: $state');
  }
}

final enteredAmountsProvider =
    StateNotifierProvider<EnteredAmountsNotifier, Map<String, double>>(
        (ref) => EnteredAmountsNotifier());

// final textValueProvider = StateProvider.autoDispose<String>((ref) {
//   return '0';
// });

final textEditingControllerProvider = StateProvider.family
    .autoDispose<CustomTextEditingController, String>((ref, category) {
  return CustomTextEditingController();
});

class CustomTextEditingController extends TextEditingController {}

final oldAmountsProvider = StateNotifierProvider.autoDispose<
    OldAmountsController, Map<String, double>>((ref) {
  return OldAmountsController();
});

class OldAmountsController extends StateNotifier<Map<String, double>> {
  OldAmountsController() : super({});

  void setOldAmount(String category, double amount) {
    state = {...state, category: amount};
  }

  double getOldAmount(String category) {
    return state[category] ?? 0.0;
  }
}

final focusNodeProvider =
    StateProvider.family.autoDispose<FocusNode, String>((ref, category) {
  return FocusNode();
});

// ignore: must_be_immutable
class ListNecessaryItemWidget extends ConsumerWidget {
  final String category;
  final double amount;

  ListNecessaryItemWidget({required this.category, required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enteredAmounts = ref.watch(enteredAmountsProvider);
    final hasAmountEntered =
        enteredAmounts[category] != null && enteredAmounts[category]! > 0;

    final CustomTextEditingController _controller =
        ref.watch(textEditingControllerProvider(category).notifier).state;

    final FocusNode focusNode =
        ref.watch(focusNodeProvider(category).notifier).state;
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
                  ref.read(focusNodeProvider(category).notifier).state;
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
                    width: 120, // adjust the width as needed
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
                            ThousandsFormatter(),
                          ],
                          style: AppStyle.txtManropeBold18,
                          onChanged: (text) {
                            String cleanedText =
                                text.replaceAll(RegExp(','), '');
                            double amount = double.tryParse(cleanedText) ?? 0.0;
                            final previousAmount = ref
                                .read(enteredAmountsProvider.notifier)
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
                              // Show a SnackBar if remaining funds go below zero
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Remaining funds cannot go below zero"),
                                  backgroundColor: Colors.red,
                                ),
                              );

                              // Clear the TextField
                              _controller.clear();
                              amount = 0;
                            } else {
                              ref
                                  .read(remainingFundsProvider.notifier)
                                  .updateFunds(amount, previousAmount);
                              ref
                                  .read(enteredAmountsProvider.notifier)
                                  .updateAmount(category, amount);

                              // Update the old amount after updating the remaining funds and entered amounts
                              ref
                                  .read(oldAmountsProvider.notifier)
                                  .setOldAmount(category, amount);
                            }

                            // if (amount != null) {
                            //   ref
                            //       .read(enteredAmountsProvider.notifier)
                            //       .updateAmount(
                            //         category,
                            //         amount,
                            //       );
                            // } else {
                            //   ref
                            //       .read(enteredAmountsProvider.notifier)
                            //       .updateAmount(category, 0);
                            // }
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
