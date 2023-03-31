import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noughtplan/core/budget/allocate_funds/controller/remaining_funds_controller.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/discretionary_categories_with_amount_notifier.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/listdebt_item_widget.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/listdiscretionary_item_widget.dart';

import '../allocate_funds_screen/widgets/listnecessary_item_widget.dart';
import '../allocate_funds_screen/widgets/liststreamingservices_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:intl/intl.dart';

final executedOnceProvider = StateProvider<bool>((ref) => false);

class AllocateFundsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final Map<String, double> necessaryCategoriesWithAmount =
        args?['necessaryCategoriesWithAmount'] as Map<String, double>? ?? {};

    final Map<String, double> extractedDebtLoanCategories =
        args?['extractedDebtLoanCategories'] as Map<String, double>? ?? {};

    final Map<String, double> discretionaryCategoriesWithAmount =
        args?['discretionaryCategoriesWithAmount'] as Map<String, double>? ??
            {};

    Map<String, double> getIndividualAmounts(
        WidgetRef ref, List<String> categories) {
      Map<String, double> individualAmounts = {};

      for (String category in categories) {
        double amount =
            ref.read(enteredAmountsProvider.notifier).getAmount(category);
        individualAmounts[category] = amount;
      }

      return individualAmounts;
    }

    Map<String, double> getIndividualAmountsDiscretionary(
        WidgetRef ref, List<String> categories) {
      Map<String, double> individualAmounts = {};

      for (String category in categories) {
        double amount = ref
            .read(enteredAmountsDiscretionaryProvider.notifier)
            .getAmount(category);
        individualAmounts[category] = amount;
      }

      return individualAmounts;
    }

    Map<String, double> getIndividualAmountsDebt(
        WidgetRef ref, List<String> categories) {
      Map<String, double> individualAmounts = {};

      for (String category in categories) {
        double amount =
            ref.read(enteredAmountsDebtProvider.notifier).getAmount(category);
        individualAmounts[category] = amount;
      }

      return individualAmounts;
    }

    List<String> getAllCategories(
      Map<String, double> necessaryCategoriesWithAmount,
      Map<String, double> extractedDebtLoanCategories,
      Map<String, double> discretionaryCategoriesWithAmount,
    ) {
      Set<String> allCategories = {};

      allCategories.addAll(necessaryCategoriesWithAmount.keys);
      allCategories.addAll(extractedDebtLoanCategories.keys);
      allCategories.addAll(discretionaryCategoriesWithAmount.keys);

      return allCategories.toList();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if the callback has been executed once
      if (!ref.read(executedOnceProvider.notifier).state) {
        // Get the total amount of entered numbers for all categories
        List<String> allCategories = getAllCategories(
            necessaryCategoriesWithAmount,
            extractedDebtLoanCategories,
            discretionaryCategoriesWithAmount);
        Map<String, double> individualAmounts =
            getIndividualAmounts(ref, allCategories);
        Map<String, double> individualAmountsDiscretionary =
            getIndividualAmountsDiscretionary(ref, allCategories);
        Map<String, double> individualAmountsDebt =
            getIndividualAmountsDebt(ref, allCategories);

        double totalEnteredAmountNecessary =
            individualAmounts.values.fold(0, (a, b) => a + b);
        double totalEnteredAmountDiscretionary =
            individualAmountsDiscretionary.values.fold(0, (a, b) => a + b);
        double totalEnteredAmountDebt =
            individualAmountsDebt.values.fold(0, (a, b) => a + b);

        double allTotalEnteredAmount = totalEnteredAmountNecessary +
            totalEnteredAmountDiscretionary +
            totalEnteredAmountDebt;

        // Update the remainingFunds state
        double initialRemainingFunds = ref.watch(remainingFundsProvider);
        ref
            .read(remainingFundsProvider.notifier)
            .setInitialValue(initialRemainingFunds - allTotalEnteredAmount);

        // Set the executedOnce flag to true
        ref.read(executedOnceProvider.notifier).state = true;
      }
      // ref.read(executedOnceProvider.notifier).state = false;
    });

    final remainingFunds = ref.watch(remainingFundsProvider);
    final enteredAmounts = ref.watch(enteredAmountsDiscretionaryProvider);
    double unassignedFunds = 0.0;
    for (final amount in enteredAmounts.values) {
      unassignedFunds += amount;
    }
    final formattedRemainingFunds =
        NumberFormat("#,##0.00", "en_US").format(remainingFunds);
    final textColor =
        remainingFunds < 1 ? ColorConstant.redA20099 : ColorConstant.blue90001;

    Map<String, double> autoAssignRemainingFunds() {
      final _random = Random();
      double necessaryTotal = 0.0;

      necessaryCategoriesWithAmount.keys.forEach((category) {
        necessaryTotal +=
            ref.read(enteredAmountsProvider.notifier).getAmount(category);
      });

      double debtTotal = 0.0;

      extractedDebtLoanCategories.keys.forEach((category) {
        necessaryTotal +=
            ref.read(enteredAmountsDebtProvider.notifier).getAmount(category);
      });

      double editedTotal = ref
          .read(enteredAmountsDiscretionaryProvider.notifier)
          .getEditedAmounts(ref);
      print('editedTotal: $editedTotal');
      ref
          .read(remainingFundsProvider.notifier)
          .resetRemainingFunds(ref, necessaryTotal, editedTotal, debtTotal);
      double remaining = ref.read(remainingFundsProvider.notifier).state;
      final categoryKeys = discretionaryCategoriesWithAmount.keys.toList();

      final uneditedCategories = categoryKeys
          .toList()
          .where((category) =>
              (!ref
                      .read(enteredAmountsDiscretionaryProvider.notifier)
                      .state
                      .containsKey(category) ||
                  ref
                          .read(enteredAmountsDiscretionaryProvider.notifier)
                          .state[category] ==
                      0.0) &&
              !(ref.read(editedCategoriesDiscretionaryProvider)[category] ??
                  false))
          .toList();

      print('remaining BEFORE: $remaining');

      final allocatedAmount = discretionaryCategoriesWithAmount.values
          .where((value) => value != null)
          .fold<double>(0.0, (previous, current) => previous + current);

      final randomAmounts = <String, double>{};
      uneditedCategories.forEach((category) => randomAmounts[category] = 0);
      for (int i = 0; i < uneditedCategories.length - 1; i++) {
        final category = uneditedCategories[i];
        final amount = _random.nextDouble() *
            (remaining - (uneditedCategories.length - 1 - i));
        randomAmounts[category] = (amount > 0) ? amount : 0;
        remaining -= amount;
      }

      if (uneditedCategories.isNotEmpty) {
        randomAmounts[uneditedCategories.last] =
            (remaining > 0) ? remaining : 0;
      }
      double totalRandomAmounts =
          randomAmounts.values.fold(0, (sum, value) => sum + value);
      print('totalRandomAmounts: $totalRandomAmounts');

      uneditedCategories.forEach((category) {
        TextEditingController controller = ref
            .read(textEditingDiscretionaryControllerProvider(category).notifier)
            .state;
        double oldAmount = double.tryParse(controller.text) ?? 0.0;
        if (randomAmounts[category] != null) {
          controller.text = randomAmounts[category]!.toStringAsFixed(2);
          ref
              .read(enteredAmountsDiscretionaryProvider.notifier)
              .updateAmount(category, randomAmounts[category]!);
        }
        ref.read(remainingFundsProvider.notifier).updateFundsForAutoAssign(
            ref, totalRandomAmounts, necessaryTotal, editedTotal);
      });

      uneditedCategories.forEach((category) {
        if (!randomAmounts.containsKey(category)) {
          TextEditingController controller = ref
              .read(
                  textEditingDiscretionaryControllerProvider(category).notifier)
              .state;
          controller.clear();
          ref
              .read(enteredAmountsDiscretionaryProvider.notifier)
              .updateAmount(category, 0.0);
          double oldAmount = double.tryParse(controller.text) ?? 0.0;
          // ref
          //     .read(remainingFundsProvider.notifier)
          //     .updateFundsForAutoAssign(0.0, oldAmount, necessaryTotal);
        }
      });
      print('uneditedCategories: $uneditedCategories');
      print('randomAmounts: $randomAmounts');
      print('remaining: $remaining');

      uneditedCategories.forEach((category) {
        ref
            .read(editedCategoriesDiscretionaryProvider.notifier)
            .setEdited(category, false);
      });
      return randomAmounts;
    }

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          ref.read(executedOnceProvider.notifier).state = false;
          return true; // Allows the navigation to proceed
        },
        child: Scaffold(
          backgroundColor: ColorConstant.whiteA700,
          resizeToAvoidBottomInset: false,
          body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    // alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Transform(
                          transform: Matrix4.identity()..scale(1.0, 1.0, 0.1),
                          alignment: Alignment.center,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgTopographic8309x375,
                            height: MediaQuery.of(context).size.height *
                                0.5, // Set the height to 50% of the screen height
                            width: MediaQuery.of(context)
                                .size
                                .width, // Set the width to the full screen width
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Padding(
                        padding: getPadding(left: 24, top: 16, right: 24),
                        child: Container(
                          height: size.height,
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomAppBar(
                                  height: getVerticalSize(70),
                                  leadingWidth: 25,
                                  leading: AppbarImage(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    height: getSize(24),
                                    width: getSize(24),
                                    svgPath: ImageConstant.imgArrowleft,
                                    margin: getMargin(bottom: 1),
                                  ),
                                  centerTitle: true,
                                  title: AppbarTitle(
                                    text: "Allocate Funds",
                                  ),
                                  actions: [
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Please read the instructions below',
                                                textAlign: TextAlign.center,
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold16,
                                              ),
                                              content: Text(
                                                "In this step, you'll be able to add discretionary categories to your budget. Follow the instructions below:\n\n"
                                                "1. Browse through the available categories or use the search bar to find specific ones that match your interests and lifestyle.\n"
                                                "2. Tap on a category to add it to your chosen categories list. You can always tap again to remove it if needed.\n"
                                                "3. Once you've added all the discretionary categories you want, press the 'Next' button to move on to reviewing your budget.\n\n"
                                                "Remember, these discretionary categories represent your non-essential expenses, such as entertainment, hobbies, and dining out. Adding them thoughtfully will help you create a balanced budget, allowing for personal enjoyment while still managing your finances effectively.",
                                                textAlign: TextAlign.center,
                                                style: AppStyle
                                                    .txtManropeRegular14,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Close'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      // height: getSize(24),
                                      //     width: getSize(24),
                                      //     svgPath: ImageConstant.imgQuestion,
                                      //     margin: getMargin(bottom: 1)
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 7),
                                        child: SvgPicture.asset(
                                          ImageConstant.imgQuestion,
                                          height: 24,
                                          width: 24,
                                        ),
                                      ),
                                    )
                                  ]),
                              Padding(
                                padding: getPadding(
                                  top: 13,
                                ),
                                child: Text(
                                  "Remaining Funds",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtManropeRegular14.copyWith(
                                    letterSpacing: getHorizontalSize(0.3),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: getPadding(top: 8, bottom: 43),
                                child: Text(
                                  '\$${formattedRemainingFunds}',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtHelveticaNowTextBold40
                                      .copyWith(
                                    color: (remainingFunds < 1 &&
                                            remainingFunds >= 0)
                                        ? ColorConstant.greenA70001
                                        : ColorConstant.blue90001,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: getVerticalSize(200),
                        left: 0,
                        right: 0,
                        bottom: getVerticalSize(0),
                        child: SingleChildScrollView(
                          padding: getPadding(left: 22, right: 24, bottom: 150),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: getPadding(right: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: getPadding(top: 2),
                                        child: Text("Debt/Loan Expenses",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold18
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2)))),
                                    CustomButton(
                                        height: getVerticalSize(28),
                                        width: getHorizontalSize(49),
                                        text: "Reset",
                                        margin: getMargin(bottom: 1),
                                        variant:
                                            ButtonVariant.OutlineIndigoA100,
                                        shape: ButtonShape.RoundedBorder6,
                                        padding: ButtonPadding.PaddingAll4,
                                        onTap: () {
                                          double necessaryTotal = 0.0;
                                          double discretionaryTotal = 0.0;

                                          necessaryCategoriesWithAmount.keys
                                              .forEach((category) {
                                            necessaryTotal += ref
                                                .read(enteredAmountsProvider
                                                    .notifier)
                                                .getAmount(category);
                                          });

                                          discretionaryCategoriesWithAmount.keys
                                              .forEach((category) {
                                            discretionaryTotal += ref
                                                .read(
                                                    enteredAmountsDiscretionaryProvider
                                                        .notifier)
                                                .getAmount(category);

                                            ref
                                                .read(remainingFundsProvider
                                                    .notifier)
                                                .resetFundsDebt(necessaryTotal,
                                                    discretionaryTotal);
                                          });
                                          extractedDebtLoanCategories.keys
                                              .forEach((category) {
                                            ref
                                                .read(
                                                    textEditingDebtControllerProvider(
                                                            category)
                                                        .notifier)
                                                .state
                                                .clear();
                                          });

                                          ref
                                              .read(enteredAmountsDebtProvider
                                                  .notifier)
                                              .resetAmounts();
                                        },
                                        fontStyle: ButtonFontStyle
                                            .HelveticaNowTextBold12BlueA700),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: getPadding(top: 14, right: 2),
                                child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                          height: getVerticalSize(16));
                                    },
                                    itemCount:
                                        extractedDebtLoanCategories.keys.length,
                                    itemBuilder: (context, index) {
                                      String category =
                                          extractedDebtLoanCategories.keys
                                              .elementAt(index);
                                      double amount =
                                          extractedDebtLoanCategories[
                                                  category] ??
                                              0;
                                      return ListDebtItemWidget(
                                          category: category, amount: amount);
                                    }),
                              ),
                              // Spacer(),
                              Padding(
                                padding: getPadding(top: 25, right: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: getPadding(top: 2),
                                        child: Text("Necessary Expenses",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold18
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2)))),
                                    CustomButton(
                                        height: getVerticalSize(28),
                                        width: getHorizontalSize(49),
                                        text: "Reset",
                                        margin: getMargin(bottom: 1),
                                        variant:
                                            ButtonVariant.OutlineIndigoA100,
                                        shape: ButtonShape.RoundedBorder6,
                                        padding: ButtonPadding.PaddingAll4,
                                        onTap: () {
                                          double discretionaryTotal = 0.0;
                                          double debtLoanTotal = 0.0;

                                          discretionaryCategoriesWithAmount.keys
                                              .forEach((category) {
                                            discretionaryTotal += ref
                                                .read(
                                                    enteredAmountsDiscretionaryProvider
                                                        .notifier)
                                                .getAmount(category);
                                          });

                                          extractedDebtLoanCategories.keys
                                              .forEach((category) {
                                            debtLoanTotal += ref
                                                .read(enteredAmountsDebtProvider
                                                    .notifier)
                                                .getAmount(category);

                                            ref
                                                .read(remainingFundsProvider
                                                    .notifier)
                                                .resetFundsNecessary(
                                                    discretionaryTotal,
                                                    debtLoanTotal);
                                          });
                                          necessaryCategoriesWithAmount.keys
                                              .forEach((category) {
                                            ref
                                                .read(
                                                    textEditingControllerProvider(
                                                            category)
                                                        .notifier)
                                                .state
                                                .clear();
                                          });

                                          ref
                                              .read(enteredAmountsProvider
                                                  .notifier)
                                              .resetAmounts();
                                        },
                                        fontStyle: ButtonFontStyle
                                            .HelveticaNowTextBold12BlueA700),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: getPadding(top: 14, right: 2),
                                child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                          height: getVerticalSize(16));
                                    },
                                    itemCount: necessaryCategoriesWithAmount
                                        .keys.length,
                                    itemBuilder: (context, index) {
                                      String category =
                                          necessaryCategoriesWithAmount.keys
                                              .elementAt(index);
                                      double amount =
                                          necessaryCategoriesWithAmount[
                                                  category] ??
                                              0;
                                      return ListNecessaryItemWidget(
                                          category: category, amount: amount);
                                    }),
                              ),
                              Padding(
                                padding: getPadding(top: 25, right: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: getPadding(top: 2),
                                        child: Text("Discretionary Exps.",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold18
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2)))),
                                    Container(
                                      // width: getHorizontalSize(97),
                                      // margin: getMargin(bottom: 1),
                                      // padding: getPadding(
                                      //     left: 5, top: 2, right: 5, bottom: 2),
                                      // decoration: AppDecoration.txtOutlineIndigoA100
                                      //     .copyWith(
                                      //         borderRadius:
                                      //             BorderRadiusStyle.txtRoundedBorder10),

                                      child: Row(
                                        children: [
                                          CustomButton(
                                            height: getVerticalSize(28),
                                            width: getHorizontalSize(75),
                                            text: "Auto-Assign",
                                            margin: getMargin(bottom: 1),
                                            variant:
                                                ButtonVariant.OutlineIndigoA100,
                                            shape: ButtonShape.RoundedBorder6,
                                            padding: ButtonPadding.PaddingAll4,
                                            fontStyle: ButtonFontStyle
                                                .HelveticaNowTextBold12BlueA700,
                                            onTap: () {
                                              // Reset unedited amounts.
                                              ref
                                                  .read(
                                                      enteredAmountsDiscretionaryProvider
                                                          .notifier)
                                                  .resetUneditedAmounts(ref);

                                              // Get the new amounts for unedited categories.
                                              Map<String, double> newAmounts =
                                                  autoAssignRemainingFunds();

                                              // Update the amounts in EnteredAmountsNotifierDiscretionary.
                                              ref
                                                  .read(
                                                      enteredAmountsDiscretionaryProvider
                                                          .notifier)
                                                  .updateUneditedAmounts(
                                                      newAmounts);

                                              // Update the text fields with the new amounts.
                                              discretionaryCategoriesWithAmount
                                                  .keys
                                                  .forEach((category) {
                                                bool isEdited = ref.read(
                                                            editedCategoriesDiscretionaryProvider)[
                                                        category] ??
                                                    false;
                                                if (!isEdited) {
                                                  TextEditingController
                                                      controller = ref
                                                          .read(
                                                              textEditingDiscretionaryControllerProvider(
                                                                      category)
                                                                  .notifier)
                                                          .state;
                                                  controller.text =
                                                      newAmounts[category]
                                                              ?.toStringAsFixed(
                                                                  2) ??
                                                          '0.00';
                                                }
                                              });
                                            },
                                          ),
                                          Padding(
                                            padding: getPadding(left: 10),
                                            child: CustomButton(
                                                height: getVerticalSize(28),
                                                width: getHorizontalSize(49),
                                                text: "Reset",
                                                margin: getMargin(bottom: 1),
                                                variant: ButtonVariant
                                                    .OutlineIndigoA100,
                                                shape:
                                                    ButtonShape.RoundedBorder6,
                                                padding:
                                                    ButtonPadding.PaddingAll4,
                                                onTap: () {
                                                  double necessaryTotal = 0.0;
                                                  double debtLoanTotal = 0.0;

                                                  extractedDebtLoanCategories
                                                      .keys
                                                      .forEach((category) {
                                                    debtLoanTotal += ref
                                                        .read(
                                                            enteredAmountsDebtProvider
                                                                .notifier)
                                                        .getAmount(category);
                                                  });

                                                  necessaryCategoriesWithAmount
                                                      .keys
                                                      .forEach((category) {
                                                    necessaryTotal += ref
                                                        .read(
                                                            enteredAmountsProvider
                                                                .notifier)
                                                        .getAmount(category);

                                                    ref
                                                        .read(
                                                            remainingFundsProvider
                                                                .notifier)
                                                        .resetFundsDiscretionary(
                                                            necessaryTotal,
                                                            debtLoanTotal);
                                                  });

                                                  discretionaryCategoriesWithAmount
                                                      .keys
                                                      .forEach((category) {
                                                    ref
                                                        .read(
                                                            textEditingDiscretionaryControllerProvider(
                                                                    category)
                                                                .notifier)
                                                        .state
                                                        .clear();
                                                  });

                                                  ref
                                                      .read(
                                                          enteredAmountsDiscretionaryProvider
                                                              .notifier)
                                                      .resetAmounts();
                                                },
                                                fontStyle: ButtonFontStyle
                                                    .HelveticaNowTextBold12BlueA700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: getPadding(top: 14, right: 2),
                                child: ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                        height: getVerticalSize(16));
                                  },
                                  itemCount: discretionaryCategoriesWithAmount
                                      .keys.length,
                                  itemBuilder: (context, index) {
                                    String category =
                                        discretionaryCategoriesWithAmount.keys
                                            .elementAt(index);
                                    double amount =
                                        discretionaryCategoriesWithAmount[
                                                category] ??
                                            0;
                                    return ListDiscretionaryItemWidget(
                                        category: category, amount: amount);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding:
                        getPadding(left: 24, top: 12, right: 24, bottom: 12),
                    decoration: AppDecoration.outlineBluegray5000c,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomButton(
                          onTap: () async {
                            final budgetState =
                                ref.watch(budgetStateProvider.notifier);
                            print(
                                'Remaining Funds on Next Button: ${remainingFunds}');
                            List<String> allCategories = Set<String>.from(
                                    necessaryCategoriesWithAmount.keys)
                                .toList();

                            List<String> allCategoriesDiscretionary =
                                Set<String>.from(
                                        discretionaryCategoriesWithAmount.keys)
                                    .toList();

                            List<String> allCategoriesDebt = Set<String>.from(
                                    extractedDebtLoanCategories.keys)
                                .toList();

                            Map<String, double> individualAmountsNecessary =
                                getIndividualAmounts(ref, allCategories);

                            Map<String, double> individualAmountsDiscretionary =
                                getIndividualAmountsDiscretionary(
                                    ref, allCategoriesDiscretionary);

                            Map<String, double> individualAmountsDebt =
                                getIndividualAmountsDebt(
                                    ref, allCategoriesDebt);

                            print(
                                'getIndividualAmounts: $individualAmountsNecessary');
                            print(
                                'Discretionary Categories With Amount: $individualAmountsDiscretionary');
                            print(
                                'Extracted Debt Loan Categories: $individualAmountsDebt');

                            await budgetState.updateAmounts(
                              necessaryAmounts: individualAmountsNecessary,
                            );

                            await budgetState.updateDiscretionaryAmounts(
                              discretionaryAmounts:
                                  individualAmountsDiscretionary,
                            );

                            await budgetState.updateDebtAmounts(
                              debtAmounts: individualAmountsDebt,
                            );

                            if (budgetState.state.status ==
                                BudgetStatus.success) {
                              // Show SnackBar with success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Your budget has been created!',
                                    textAlign: TextAlign.center,
                                    style: AppStyle
                                        .txtHelveticaNowTextBold16WhiteA700
                                        .copyWith(
                                      letterSpacing: getHorizontalSize(0.3),
                                    ),
                                  ),
                                  backgroundColor: ColorConstant.greenA700,
                                ),
                              );
                              Navigator.pushNamed(
                                context,
                                '/budget_details_screen',
                                // arguments: {
                                //   'necessaryCategoriesWithAmount':
                                //       necessaryCategoriesWithAmount,
                                //   'extractedDebtLoanCategories':
                                //       extractedDebtLoanCategories,
                                //   'discretionaryCategoriesWithAmount':
                                //       allCategoriesWithAmount,
                                // },
                              );
                            } else if (budgetState.state.status ==
                                BudgetStatus.failure) {
                              // Show SnackBar with failure message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Something went wrong! Please try again later.',
                                    textAlign: TextAlign.center,
                                    style: AppStyle
                                        .txtHelveticaNowTextBold16WhiteA700
                                        .copyWith(
                                      letterSpacing: getHorizontalSize(0.3),
                                    ),
                                  ),
                                  backgroundColor: ColorConstant.redA700,
                                ),
                              );
                            }
                          },
                          height: getVerticalSize(56),
                          text: "Next",
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }
}
