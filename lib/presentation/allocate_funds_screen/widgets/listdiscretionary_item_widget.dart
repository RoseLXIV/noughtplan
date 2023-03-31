import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/allocate_funds/controller/remaining_funds_controller.dart';
// import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/widgets/custom_button.dart';

class EnteredAmountsNotifierDiscretionary
    extends StateNotifier<Map<String, double>> {
  EnteredAmountsNotifierDiscretionary() : super({});

  double getAmount(String category) {
    return state[category] ?? 0.0;
  }

  double getTotalEnteredAmounts() {
    return state.values.fold(0.0, (a, b) => a + b);
  }

  void updateAmount(String category, double amount) {
    if (amount == 0) {
      state = {...state}..remove(category);
      print(
          'EnteredAmountsNotifierDiscretionary - Removed amount for $category');
    } else {
      state = {...state, category: amount};
      print(
          'EnteredAmountsNotifierDiscretionary - Updated amount for $category to $amount');
    }
  }

  void resetAmounts() {
    for (var key in state.keys) {
      state[key] = 0.0;
      print(
          'EnteredAmountsNotifierDiscretionary - Reset amount for $key to 0.0');
    }
    state =
        Map<String, double>.from(state); // This line triggers a state update.
    print('EnteredAmountsNotifierDiscretionary - Reset all amounts: $state');
  }

  void resetUneditedAmounts(WidgetRef ref) {
    Map<String, double> newState = {};
    for (var key in state.keys) {
      bool isEdited =
          ref.read(editedCategoriesDiscretionaryProvider)[key] ?? false;
      if (!isEdited) {
        newState[key] = 0.0;
        print(
            'EnteredAmountsNotifierDiscretionary - Reset amount for $key to 0.0');
      } else {
        newState[key] = state[key] ?? 0.0;
      }
    }
    state = newState;
    print(
        'EnteredAmountsNotifierDiscretionary - Reset unedited amounts: $state');
  }

  void updateUneditedAmounts(Map<String, double> newAmounts) {
    Map<String, double> newState = {...state};

    for (var key in newAmounts.keys) {
      newState[key] = newAmounts[key] ?? 0.0;
    }

    state = newState;
    print(
        'EnteredAmountsNotifierDiscretionary - Updated unedited amounts: $state');
  }

  double getEditedAmounts(WidgetRef ref) {
    double total = 0.0;

    state.entries.forEach((entry) {
      if (ref.read(editedCategoriesDiscretionaryProvider)[entry.key] ?? false) {
        total += entry.value;
      }
    });

    return total;
  }
}

final enteredAmountsDiscretionaryProvider = StateNotifierProvider<
    EnteredAmountsNotifierDiscretionary,
    Map<String, double>>((ref) => EnteredAmountsNotifierDiscretionary());

class CustomTextEditingControllerDiscretionary extends TextEditingController {
  CustomTextEditingControllerDiscretionary({String initialText = ''})
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
final textEditingDiscretionaryControllerProvider = StateProvider.family
    .autoDispose<CustomTextEditingControllerDiscretionary, String>(
        (ref, category) {
  double initialAmount = ref
      .read(enteredAmountsDiscretionaryProvider.notifier)
      .getAmount(category);
  return CustomTextEditingControllerDiscretionary(
      initialText: initialAmount == 0 ? '' : initialAmount.toStringAsFixed(2));
});

final oldAmountsProvider = StateNotifierProvider.autoDispose<
    OldAmountsControllerDiscretionary, Map<String, double>>((ref) {
  return OldAmountsControllerDiscretionary();
});

class OldAmountsControllerDiscretionary
    extends StateNotifier<Map<String, double>> {
  OldAmountsControllerDiscretionary() : super({});

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

class EditedCategoriesDiscretionaryController
    extends StateNotifier<Map<String, bool>> {
  EditedCategoriesDiscretionaryController() : super({});

  void setEdited(String category, bool edited) {
    state = {
      ...state,
      category: edited,
    };
  }
}

final editedCategoriesDiscretionaryProvider = StateNotifierProvider<
    EditedCategoriesDiscretionaryController, Map<String, bool>>((ref) {
  return EditedCategoriesDiscretionaryController();
});

class AutoAssignedCategoriesDiscretionary
    extends StateNotifier<Map<String, bool>> {
  AutoAssignedCategoriesDiscretionary()
      : super({}); // Initialize the state as an empty map

  void setAutoAssigned(String category, bool isAutoAssigned) {
    state = {...state, category: isAutoAssigned};
  }

  void reset() {
    Map<String, bool> newState = {...state};
    newState.keys.forEach((key) {
      newState[key] = false;
    });
    state = newState;
  }
}

final autoAssignedCategoriesDiscretionaryProvider = StateNotifierProvider<
    AutoAssignedCategoriesDiscretionary,
    Map<String, bool>>((ref) => AutoAssignedCategoriesDiscretionary());

class CategoryInfo {
  double amount;
  bool isEdited;
  bool isAutoAssigned;

  CategoryInfo(
      {required this.amount,
      this.isEdited = false,
      this.isAutoAssigned = false});
}

final categoryInfoDiscretionaryProvider =
    StateNotifierProvider.family<CategoryInfoController, CategoryInfo, String>(
        (ref, category) {
  return CategoryInfoController(category: category);
});

class CategoryInfoController extends StateNotifier<CategoryInfo> {
  CategoryInfoController({required String category})
      : super(
            CategoryInfo(amount: 0.0, isEdited: false, isAutoAssigned: false));

  void updateAmount(double amount,
      {bool edited = false, bool autoAssigned = false}) {
    state = CategoryInfo(
        amount: amount, isEdited: edited, isAutoAssigned: autoAssigned);
  }

  void resetAmount() {
    state = CategoryInfo(
        amount: 0.0,
        isEdited: state.isEdited,
        isAutoAssigned: state.isAutoAssigned);
  }
}

// ignore: must_be_immutable
class ListDiscretionaryItemWidget extends ConsumerWidget {
  final String category;
  final double amount;

  final autoAssignedValuesProvider =
      StateProvider.family<Map<String, double>, String>((ref, _) {
    return {};
  });

  ListDiscretionaryItemWidget({required this.category, required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enteredAmounts = ref.watch(enteredAmountsDiscretionaryProvider);
    final hasAmountEntered =
        enteredAmounts[category] != null && enteredAmounts[category]! > 0;

    final CustomTextEditingControllerDiscretionary _controller = ref
        .watch(textEditingDiscretionaryControllerProvider(category).notifier)
        .state;

    final FocusNode focusNode =
        ref.watch(focusNodeProvider(category).notifier).state;
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
                            ThousandsFormatterDiscretionary(),
                          ],
                          style: AppStyle.txtManropeBold18,
                          onChanged: (text) {
                            String cleanedText =
                                text.replaceAll(RegExp(','), '');
                            double amount = double.tryParse(cleanedText) ?? 0.0;
                            final previousAmount = ref
                                .read(enteredAmountsDiscretionaryProvider
                                    .notifier)
                                .getAmount(category);

                            print("RemainingFundsController - OnChanged:");
                            print("RemainingFundsController - Amount: $amount");
                            print(
                                "RemainingFundsController - Previous Amount: $previousAmount");

                            // Get the updated remaining funds
                            double remainingFunds =
                                ref.read(remainingFundsProvider.notifier).state;
                            print(
                                "Remaining funds before update: $remainingFunds");
                            // ref
                            //     .read(remainingFundsProvider.notifier)
                            //     .updateFunds(amount, previousAmount);
                            remainingFunds =
                                ref.read(remainingFundsProvider.notifier).state;
                            print(
                                "Remaining funds after update: $remainingFunds");

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
                                  backgroundColor: ColorConstant.redA700,
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
                                  .read(enteredAmountsDiscretionaryProvider
                                      .notifier)
                                  .updateAmount(category, amount);
                            } else {
                              ref
                                  .read(remainingFundsProvider.notifier)
                                  .updateFunds(amount, previousAmount);
                              ref
                                  .read(enteredAmountsDiscretionaryProvider
                                      .notifier)
                                  .updateAmount(category, amount);

                              ref
                                      .read(remainingFundsStateProvider.notifier)
                                      .state =
                                  remainingFunds - amount + previousAmount;

                              // Update the old amount after updating the remaining funds and entered amounts
                              ref
                                  .read(oldAmountsProvider.notifier)
                                  .setOldAmount(category, amount);
                              ref
                                  .read(editedCategoriesDiscretionaryProvider
                                      .notifier)
                                  .setEdited(category, true);
                              ref
                                  .read(
                                      autoAssignedCategoriesDiscretionaryProvider
                                          .notifier)
                                  .setAutoAssigned(category, false);
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

class ThousandsFormatterDiscretionary extends TextInputFormatter {
  final int maxLength;

  ThousandsFormatterDiscretionary({this.maxLength = 12});

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

      // calculate the new selection range
      int offset =
          newValue.selection.start + result.length - oldValue.text.length;

      // Clamp the offset to avoid index out of bounds error
      offset = _clampOffset(offset, 0, result.length);

      // return the updated TextEditingValue
      return newValue.copyWith(
        text: result,
        selection: TextSelection.collapsed(offset: offset),
      );
    }
  }

  int _clampOffset(int offset, int min, int max) {
    return offset.clamp(min, max);
  }
}
