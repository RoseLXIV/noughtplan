import 'dart:math';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/budget/allocate_funds/controller/allocate_funds_controller.dart';
import 'package:noughtplan/core/budget/allocate_funds/controller/remaining_funds_controller.dart';
import 'package:noughtplan/core/budget/allocate_funds/controller/remaining_funds_controller_edit.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:noughtplan/core/providers/first_time_provider.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/discretionary_categories_with_amount_notifier.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/listdebt_item_widget.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/listdiscretionary_item_widget.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/loading_dialog_controller.dart';
import 'package:noughtplan/presentation/allocate_funds_screen_edit/widgets/edit_loading_dialog_controller.dart';
import 'package:noughtplan/presentation/allocate_funds_screen_edit/widgets/listdiscretionary_item_widget_edit.dart';
import 'package:noughtplan/presentation/allocate_funds_screen_edit/widgets/listnecessary_item_widget_edit.dart';
import 'package:noughtplan/widgets/custom_button_allocate.dart';
import 'package:uuid/uuid.dart';

import '../allocate_funds_screen/widgets/listnecessary_item_widget.dart';
import '../allocate_funds_screen/widgets/liststreamingservices_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'widgets/listdebt_item_widget_edit.dart';

final executedOnceProviderEdit = StateProvider<bool>((ref) => false);

// String generateNewBudgetId() {
//   var uuid = Uuid();
//   String newBudgetId = uuid.v4();
//   return newBudgetId;
// }

final isAllAmountsEnteredProvider = StateProvider<bool>((ref) {
  return false;
});

class AllocateFundsScreenEdit extends HookConsumerWidget {
  final Budget selectedBudget;

  AllocateFundsScreenEdit({required this.selectedBudget});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _animationController =
        useAnimationController(duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);

    final firstTime = ref.watch(firstTimeProvider);

    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final Map<String, double> necessaryCategoriesWithAmount =
        (args?['necessaryCategoriesWithAmount'] as Map<String, double>?) ??
            selectedBudget.necessaryExpense ??
            {};

    final Map<String, double> extractedDebtLoanCategories =
        (args?['extractedDebtLoanCategories'] as Map<String, double>?) ??
            selectedBudget.debtExpense ??
            {};

    final Map<String, double> discretionaryCategoriesWithAmount =
        (args?['discretionaryCategoriesWithAmount'] as Map<String, double>?) ??
            selectedBudget.discretionaryExpense ??
            {};

    List<String> combinedCategories = [
      ...necessaryCategoriesWithAmount.keys,
      ...extractedDebtLoanCategories.keys,
      ...discretionaryCategoriesWithAmount.keys,
    ];

    // final Budget selectedBudget = args?['selectedBudget'];

    // print('necessaryCategoriesWithAmount: $necessaryCategoriesWithAmount');
    // print('extractedDebtLoanCategories: $extractedDebtLoanCategories');
    // print(
    //     'discretionaryCategoriesWithAmount: $discretionaryCategoriesWithAmount');

    Map<String, double> getIndividualAmounts(
        WidgetRef ref, List<String> categories) {
      Map<String, double> individualAmounts = {};

      for (String category in categories) {
        double amount =
            ref.read(enteredAmountsProviderEdit.notifier).getAmount(category);
        individualAmounts[category] = amount;
      }

      return individualAmounts;
    }

    Map<String, double> getIndividualAmountsDiscretionary(
        WidgetRef ref, List<String> categories) {
      Map<String, double> individualAmounts = {};

      for (String category in categories) {
        double amount = ref
            .read(enteredAmountsDiscretionaryProviderEdit.notifier)
            .getAmount(category);
        individualAmounts[category] = amount;
      }

      return individualAmounts;
    }

    Map<String, double> getIndividualAmountsDebt(
        WidgetRef ref, List<String> categories) {
      Map<String, double> individualAmounts = {};

      for (String category in categories) {
        double amount = ref
            .read(enteredAmountsDebtProviderEdit.notifier)
            .getAmount(category);
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

    // Get the total amount of entered numbers for all categories
    List<String> allCategories = getAllCategories(necessaryCategoriesWithAmount,
        extractedDebtLoanCategories, discretionaryCategoriesWithAmount);
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

    bool isAllTotalEnteredAmountNonZero = allTotalEnteredAmount != 0;

    // Update the remainingFunds state
    double initialRemainingFunds =
        ref.watch(remainingFundsProviderEdit.notifier).initialValue;

    ref
        .read(remainingFundsProviderEdit.notifier)
        .updateInitialValue(initialRemainingFunds - allTotalEnteredAmount);

    // Set the executedOnce flag to true

    final remainingFunds = ref.watch(remainingFundsProviderEdit);
    final enteredAmounts = ref.watch(enteredAmountsDiscretionaryProviderEdit);
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
            ref.read(enteredAmountsProviderEdit.notifier).getAmount(category);
      });

      double debtTotal = 0.0;

      extractedDebtLoanCategories.keys.forEach((category) {
        necessaryTotal += ref
            .read(enteredAmountsDebtProviderEdit.notifier)
            .getAmount(category);
      });

      double editedTotal = ref
          .read(enteredAmountsDiscretionaryProviderEdit.notifier)
          .getEditedAmounts(ref);
      print('editedTotal: $editedTotal');
      ref
          .read(remainingFundsProviderEdit.notifier)
          .resetRemainingFunds(ref, necessaryTotal, editedTotal, debtTotal);
      double remaining = ref.read(remainingFundsProviderEdit.notifier).state;
      final categoryKeys = discretionaryCategoriesWithAmount.keys.toList();

      final uneditedCategories = categoryKeys
          .toList()
          .where((category) =>
              (!ref
                      .read(enteredAmountsDiscretionaryProviderEdit.notifier)
                      .state
                      .containsKey(category) ||
                  ref
                          .read(
                              enteredAmountsDiscretionaryProviderEdit.notifier)
                          .state[category] ==
                      0.0) &&
              !(ref.read(editedCategoriesDiscretionaryProviderEdit)[category] ??
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
            .read(textEditingDiscretionaryControllerProviderEdit(category)
                .notifier)
            .state;
        double oldAmount = double.tryParse(controller.text) ?? 0.0;
        if (randomAmounts[category] != null) {
          controller.text = randomAmounts[category]!.toStringAsFixed(2);
          ref
              .read(enteredAmountsDiscretionaryProviderEdit.notifier)
              .updateAmount(category, randomAmounts[category]!);
        }
        ref.read(remainingFundsProviderEdit.notifier).updateFundsForAutoAssign(
            ref, totalRandomAmounts, necessaryTotal, editedTotal);
      });

      uneditedCategories.forEach((category) {
        if (!randomAmounts.containsKey(category)) {
          TextEditingController controller = ref
              .read(textEditingDiscretionaryControllerProviderEdit(category)
                  .notifier)
              .state;
          controller.clear();
          ref
              .read(enteredAmountsDiscretionaryProviderEdit.notifier)
              .updateAmount(category, 0.0);
          double oldAmount = double.tryParse(controller.text) ?? 0.0;
          // ref
          //     .read(remainingFundsProviderEdit.notifier)
          //     .updateFundsForAutoAssign(0.0, oldAmount, necessaryTotal);
        }
      });
      print('uneditedCategories: $uneditedCategories');
      print('randomAmounts: $randomAmounts');
      print('remaining: $remaining');

      uneditedCategories.forEach((category) {
        ref
            .read(editedCategoriesDiscretionaryProviderEdit.notifier)
            .setEdited(category, false);
      });
      return randomAmounts;
    }

    // final allocateFundsState = ref.watch(allocateFundsProvider);
    // final bool isValidated = allocateFundsState.status.isValidated;
    // final allocateFundsController = ref.watch(allocateFundsProvider.notifier);

    final editLoadingDialogController = EditLoadingDialogController();

    // Define variables for error messages

    String combinedCategoriesErrorMessage =
        'Please select and save at least one (1) category';
    String remainingFundsErrorMessage = 'Remaining funds cannot be negative';
    String totalAmountErrorMessage = 'Please enter at least one (1) amount';

// Check conditions for error messages

    bool showCombinedCategoriesError = combinedCategories.isEmpty;
    bool showRemainingFundsError = remainingFunds < 0;
    bool showTotalAmountError = !isAllTotalEnteredAmountNonZero;

// Build the error message widget
    Widget errorMessageWidget(String errorMessage) {
      return Padding(
        padding: getPadding(bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImageView(
              svgPath: ImageConstant.imgAlertcircle,
              height: getSize(16),
              width: getSize(16),
              color: ColorConstant.redA700,
            ),
            Padding(
              padding: getPadding(left: 6),
              child: Text(errorMessage,
                  style: AppStyle.txtManropeSemiBold12
                      .copyWith(color: ColorConstant.redA700)),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          ref.read(executedOnceProviderEdit.notifier).state = false;
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
                        left: 10,
                        right: 0,
                        child: Transform(
                          transform: Matrix4.identity()..scale(1.0, -1.0, 0.1),
                          alignment: Alignment.center,
                          child: CustomImageView(
                            imagePath: ImageConstant.expenseTop,
                            height: MediaQuery.of(context).size.height *
                                0.6, // Set the height to 50% of the screen height
                            width: MediaQuery.of(context)
                                .size
                                .width, // Set the width to the full screen width
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover,
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
                                  leading: CustomImageView(
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
                                    Padding(
                                      padding: getPadding(right: 20),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/home_page_screen');
                                        },
                                        child: Container(
                                          // width: 70,
                                          child: SvgPicture.asset(
                                            ImageConstant.imgHome2,
                                            height: 24,
                                            width: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Edit Allocated Expenses',
                                                textAlign: TextAlign.center,
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold16,
                                              ),
                                              content: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: Container(
                                                  child: RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                      style: AppStyle
                                                          .txtManropeRegular14
                                                          .copyWith(
                                                              color: ColorConstant
                                                                  .blueGray800),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                "In this section, you can adjust the allocation of your funds. Here's how:\n\n"),
                                                        TextSpan(
                                                            text:
                                                                '1. Adjust Amounts:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' Change the amounts for each category as per your current requirements. If you wish to retain the current allocation for certain categories, simply leave them unchanged, and the original values will be automatically maintained.\n\n'),
                                                        TextSpan(
                                                            text:
                                                                '2. Auto-Assign Discretionary Funds:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' You can use the auto-assign discretionary button to distribute funds evenly across categories. However, this function will be disabled if you manually edit a field afterward.\n\n'),
                                                        TextSpan(
                                                            text:
                                                                '3. Confirm Changes:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' Ensure to confirm changes for all categories. Any leftover funds will not be included in the final budget results.\n\n'),
                                                        TextSpan(
                                                            text:
                                                                "Remember, adjusting the allocation of funds helps maintain a balanced plan that suits your lifestyle and manages your finances effectively. You can always return to this section for further modifications based on your evolving financial needs."),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text(
                                                    'Close',
                                                    style: AppStyle
                                                        .txtHelveticaNowTextBold14
                                                        .copyWith(
                                                            letterSpacing:
                                                                getHorizontalSize(
                                                                    0.2),
                                                            color: ColorConstant
                                                                .blueA700),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              child: Neumorphic(
                                                style: NeumorphicStyle(
                                                  shape: NeumorphicShape.convex,
                                                  boxShape: NeumorphicBoxShape
                                                      .circle(),
                                                  depth: 0.9,
                                                  intensity: 8,
                                                  surfaceIntensity: 0.7,
                                                  shadowLightColor:
                                                      Colors.white,
                                                  lightSource: LightSource.top,
                                                  color: firstTime
                                                      ? ColorConstant.blueA700
                                                      : Colors.white,
                                                ),
                                                child: SvgPicture.asset(
                                                  ImageConstant.imgQuestion,
                                                  height: 24,
                                                  width: 24,
                                                  color: firstTime
                                                      ? ColorConstant.whiteA700
                                                      : ColorConstant
                                                          .blueGray500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: AnimatedBuilder(
                                              animation: _animationController,
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                if (!firstTime ||
                                                    _animationController
                                                        .isCompleted)
                                                  return SizedBox
                                                      .shrink(); // This line ensures that the arrow disappears after the animation has completed

                                                return Transform.translate(
                                                  offset: Offset(
                                                      0,
                                                      -5 *
                                                          _animationController
                                                              .value),
                                                  child: Padding(
                                                    padding:
                                                        getPadding(top: 16),
                                                    child: SvgPicture.asset(
                                                      ImageConstant
                                                          .imgArrowUp, // path to your arrow SVG image
                                                      height: 24,
                                                      width: 24,
                                                      color: ColorConstant
                                                          .blueA700,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
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
                          physics: BouncingScrollPhysics(),
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
                                                .read(enteredAmountsProviderEdit
                                                    .notifier)
                                                .getAmount(category);
                                          });

                                          discretionaryCategoriesWithAmount.keys
                                              .forEach((category) {
                                            discretionaryTotal += ref
                                                .read(
                                                    enteredAmountsDiscretionaryProviderEdit
                                                        .notifier)
                                                .getAmount(category);

                                            ref
                                                .read(remainingFundsProviderEdit
                                                    .notifier)
                                                .resetFundsDebt(necessaryTotal,
                                                    discretionaryTotal);
                                          });
                                          extractedDebtLoanCategories.keys
                                              .forEach((category) {
                                            ref
                                                .read(
                                                    textEditingDebtControllerProviderEdit(
                                                            category)
                                                        .notifier)
                                                .state
                                                .clear();
                                          });

                                          ref
                                              .read(
                                                  enteredAmountsDebtProviderEdit
                                                      .notifier)
                                              .resetAmounts();
                                          ref
                                              .read(allocateFundsProvider
                                                  .notifier)
                                              .resetValidationDebt();
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
                                      return ListDebtItemWidgetEdit(
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
                                                    enteredAmountsDiscretionaryProviderEdit
                                                        .notifier)
                                                .getAmount(category);
                                          });

                                          extractedDebtLoanCategories.keys
                                              .forEach((category) {
                                            debtLoanTotal += ref
                                                .read(
                                                    enteredAmountsDebtProviderEdit
                                                        .notifier)
                                                .getAmount(category);

                                            ref
                                                .read(remainingFundsProviderEdit
                                                    .notifier)
                                                .resetFundsNecessary(
                                                    discretionaryTotal,
                                                    debtLoanTotal);
                                          });
                                          necessaryCategoriesWithAmount.keys
                                              .forEach((category) {
                                            ref
                                                .read(
                                                    textEditingControllerProviderEdit(
                                                            category)
                                                        .notifier)
                                                .state
                                                .clear();
                                          });

                                          ref
                                              .read(enteredAmountsProviderEdit
                                                  .notifier)
                                              .resetAmounts();

                                          ref
                                              .read(allocateFundsProvider
                                                  .notifier)
                                              .resetValidationNecessary();
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
                                      return ListNecessaryItemWidgetEdit(
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
                                                      enteredAmountsDiscretionaryProviderEdit
                                                          .notifier)
                                                  .resetUneditedAmounts(ref);

                                              // Get the new amounts for unedited categories.
                                              Map<String, double> newAmounts =
                                                  autoAssignRemainingFunds();

                                              // Update the amounts in EnteredAmountsNotifierDiscretionary.
                                              ref
                                                  .read(
                                                      enteredAmountsDiscretionaryProviderEdit
                                                          .notifier)
                                                  .updateUneditedAmounts(
                                                      newAmounts);

                                              // Update the text fields with the new amounts.
                                              discretionaryCategoriesWithAmount
                                                  .keys
                                                  .forEach((category) {
                                                bool isEdited = ref.read(
                                                            editedCategoriesDiscretionaryProviderEdit)[
                                                        category] ??
                                                    false;
                                                if (!isEdited) {
                                                  TextEditingController
                                                      controller = ref
                                                          .read(
                                                              textEditingDiscretionaryControllerProviderEdit(
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
                                                            enteredAmountsDebtProviderEdit
                                                                .notifier)
                                                        .getAmount(category);
                                                  });

                                                  necessaryCategoriesWithAmount
                                                      .keys
                                                      .forEach((category) {
                                                    necessaryTotal += ref
                                                        .read(
                                                            enteredAmountsProviderEdit
                                                                .notifier)
                                                        .getAmount(category);

                                                    ref
                                                        .read(
                                                            remainingFundsProviderEdit
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
                                                            textEditingDiscretionaryControllerProviderEdit(
                                                                    category)
                                                                .notifier)
                                                        .state
                                                        .clear();
                                                  });

                                                  ref
                                                      .read(
                                                          enteredAmountsDiscretionaryProviderEdit
                                                              .notifier)
                                                      .resetAmounts();
                                                  ref
                                                      .read(
                                                          allocateFundsProvider
                                                              .notifier)
                                                      .resetValidationDiscretionary();
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
                                padding:
                                    getPadding(top: 14, right: 2, bottom: 50),
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
                                    return ListDiscretionaryItemWidgetEdit(
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
                KeyboardVisibilityBuilder(builder: (context, visible) {
                  return Visibility(
                    visible: !visible,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding:
                            getPadding(left: 24, top: 6, right: 24, bottom: 12),
                        decoration: AppDecoration.outlineBluegray5000c,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Visibility(
                                  visible: showCombinedCategoriesError,
                                  child: errorMessageWidget(
                                      combinedCategoriesErrorMessage),
                                ),
                                Visibility(
                                  visible: showRemainingFundsError,
                                  child: errorMessageWidget(
                                      remainingFundsErrorMessage),
                                ),
                                Visibility(
                                  visible: showTotalAmountError,
                                  child: errorMessageWidget(
                                      totalAmountErrorMessage),
                                ),
                              ],
                            ),
                            CustomButtonAllocate(
                              enabled: combinedCategories.isNotEmpty &&
                                  remainingFunds >= 0 &&
                                  isAllTotalEnteredAmountNonZero,
                              onTap: () async {
                                TextEditingController budgetNameController =
                                    TextEditingController();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return AlertDialog(
                                          title: Text('Confirm Budget',
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold18
                                                  .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.2))),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Please review your budget information. You can always make changes later.',
                                                style: AppStyle
                                                    .txtManropeRegular14
                                                    .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2),
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel',
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold14
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2),
                                                          color: ColorConstant
                                                              .blueA700)),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                // Move the original onTap code inside this onPressed callback
                                                // ...
                                                FocusScope.of(context)
                                                    .unfocus();

                                                final budgetState = ref.watch(
                                                    budgetStateProvider
                                                        .notifier);
                                                print(
                                                    'Remaining Funds on Next Button: ${remainingFunds}');
                                                List<
                                                    String> allCategories = Set<
                                                            String>.from(
                                                        necessaryCategoriesWithAmount
                                                            .keys)
                                                    .toList();

                                                List<String>
                                                    allCategoriesDiscretionary =
                                                    Set<String>.from(
                                                            discretionaryCategoriesWithAmount
                                                                .keys)
                                                        .toList();

                                                List<String> allCategoriesDebt =
                                                    Set<String>.from(
                                                            extractedDebtLoanCategories
                                                                .keys)
                                                        .toList();

                                                final Map<String, double>
                                                    savingsCategories = {
                                                  "Emergency Fund": 0,
                                                  "Retirement Savings": 0,
                                                  "Investments": 0,
                                                  "Education Savings": 0,
                                                  "Vacation Fund": 0,
                                                  "Down Payment": 0,
                                                  "Home Improvement Fund": 0,
                                                  "Home Equity Loan": 0,
                                                  "Debt Payoff": 0,
                                                  "Wedding Fund": 0,
                                                  "Vehicle Savings": 0,
                                                  "General Savings": 0,
                                                };

                                                Map<String, double>
                                                    individualAmountsNecessary =
                                                    getIndividualAmounts(
                                                        ref, allCategories);

                                                Map<String, double>
                                                    individualAmountsDiscretionary =
                                                    getIndividualAmountsDiscretionary(
                                                        ref,
                                                        allCategoriesDiscretionary);

                                                double totalSavings = 0;

                                                individualAmountsNecessary
                                                    .forEach((key, value) {
                                                  RegExp regex = RegExp(
                                                      r'savings|saving|investment',
                                                      caseSensitive: false);
                                                  if (regex.hasMatch(key)) {
                                                    totalSavings += value;
                                                  } else if (savingsCategories
                                                      .containsKey(key)) {
                                                    totalSavings += value;
                                                  }
                                                });

                                                individualAmountsDiscretionary
                                                    .forEach((key, value) {
                                                  RegExp regex = RegExp(
                                                      r'savings|saving|investment',
                                                      caseSensitive: false);
                                                  if (regex.hasMatch(key)) {
                                                    totalSavings += value;
                                                  } else if (savingsCategories
                                                      .containsKey(key)) {
                                                    totalSavings += value;
                                                  }
                                                });

                                                double totalSavingsAndSurplus =
                                                    totalSavings +
                                                        remainingFunds;

                                                print(
                                                    'Total Savings: $totalSavingsAndSurplus');

                                                Map<String, double>
                                                    individualAmountsDebt =
                                                    getIndividualAmountsDebt(
                                                        ref, allCategoriesDebt);

                                                // final generateSalaryController =
                                                //     ref.watch(generateSalaryProvider
                                                //         .notifier);
                                                final String? budgetId =
                                                    selectedBudget.budgetId;

                                                double exchangeRate = 1.0;
                                                String currency =
                                                    await budgetState
                                                        .getCurrency(
                                                            budgetId: budgetId);

                                                print('Budget ID: $budgetId');
                                                print(
                                                    'Currency for the current Budget: $currency');

                                                if (currency == 'JMD') {
                                                  exchangeRate =
                                                      await fetchExchangeRate(
                                                          'JMD', 'USD');
                                                }

                                                double
                                                    totalEnteredAmountNecessary =
                                                    individualAmountsNecessary
                                                        .values
                                                        .fold(
                                                            0, (a, b) => a + b);
                                                double
                                                    totalEnteredAmountDiscretionary =
                                                    individualAmountsDiscretionary
                                                        .values
                                                        .fold(
                                                            0, (a, b) => a + b);
                                                double totalEnteredAmountDebt =
                                                    individualAmountsDebt.values
                                                        .fold(
                                                            0, (a, b) => a + b);

                                                double
                                                    totalEnteredAmountNecessaryUSD =
                                                    totalEnteredAmountNecessary *
                                                        exchangeRate;

                                                final remainingFundsController =
                                                    ref.read(
                                                        remainingFundsProviderEdit
                                                            .notifier);
                                                double salary =
                                                    remainingFundsController
                                                        .initialValue;

                                                print('Salary: $salary');

                                                print(
                                                    'Total Necessary Expense USD: $totalEnteredAmountNecessaryUSD');

                                                double
                                                    totalEnteredAmountDiscretionaryUSD =
                                                    totalEnteredAmountDiscretionary *
                                                        exchangeRate;

                                                print(
                                                    'Total Discretionary Expense USD: $totalEnteredAmountDiscretionaryUSD');

                                                String? spendingType =
                                                    await budgetState
                                                        .updateSpendingType(
                                                  budgetId: budgetId,
                                                  totalNecessaryExpense:
                                                      totalEnteredAmountNecessaryUSD,
                                                  totalDiscretionaryExpense:
                                                      totalEnteredAmountDiscretionaryUSD,
                                                );

                                                if (spendingType != null) {
                                                  print(
                                                      'Spending type updated to $spendingType');

                                                  String? savingType =
                                                      await budgetState
                                                          .updateSavingType(
                                                    budgetId: budgetId,
                                                    spendingType: spendingType,
                                                    totalSavings:
                                                        totalSavingsAndSurplus,
                                                    salary: salary,
                                                  );

                                                  if (savingType != null) {
                                                    print(
                                                        'Saving type updated to $savingType');

                                                    double totalDebt =
                                                        individualAmountsDebt
                                                            .values
                                                            .fold(
                                                                0,
                                                                (a, b) =>
                                                                    a + b);
                                                    String? debtType =
                                                        await budgetState
                                                            .updateDebtType(
                                                      budgetId: budgetId,
                                                      debt: totalDebt,
                                                      income: salary,
                                                    );

                                                    if (debtType != null) {
                                                      print(
                                                          'Debt type updated to $debtType');
                                                    } else {
                                                      print(
                                                          'Failed to update debt type');
                                                    }
                                                  } else {
                                                    print(
                                                        'Failed to update saving type');
                                                  }
                                                } else {
                                                  print(
                                                      'Failed to update spending type');
                                                }

                                                print(
                                                    'getIndividualAmounts: $individualAmountsNecessary');
                                                print(
                                                    'Discretionary Categories With Amount: $individualAmountsDiscretionary');
                                                print(
                                                    'Extracted Debt Loan Categories: $individualAmountsDebt');
                                                print(
                                                    'Spending Type: $spendingType');
                                                editLoadingDialogController
                                                    .show(context);

                                                await budgetState
                                                    .updateBudgetInfoSubscriberSalary(
                                                  budgetId: budgetId ?? '',
                                                  salary: salary,
                                                );

                                                await budgetState.updateAmounts(
                                                  budgetId: budgetId,
                                                  necessaryAmounts:
                                                      individualAmountsNecessary,
                                                );

                                                await budgetState
                                                    .updateDiscretionaryAmounts(
                                                  budgetId: budgetId,
                                                  discretionaryAmounts:
                                                      individualAmountsDiscretionary,
                                                );

                                                await budgetState
                                                    .updateDebtAmounts(
                                                  budgetId: budgetId,
                                                  debtAmounts:
                                                      individualAmountsDebt,
                                                );

                                                await budgetState.updateSurplus(
                                                  budgetId: budgetId,
                                                  remainingFunds:
                                                      remainingFunds,
                                                );

                                                await budgetState
                                                    .deleteZeroValueCategories(
                                                  budgetId: budgetId,
                                                );
                                                editLoadingDialogController
                                                    .hide();

                                                if (budgetState.state.status ==
                                                    BudgetStatus.success) {
                                                  // Show SnackBar with success message
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Your budget has been updated!',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppStyle
                                                            .txtHelveticaNowTextBold16WhiteA700
                                                            .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.3),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          ColorConstant
                                                              .greenA700,
                                                    ),
                                                  );
                                                } else {
                                                  // Show SnackBar with failure message
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Something went wrong! Please try again later.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppStyle
                                                            .txtHelveticaNowTextBold16WhiteA700
                                                            .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.3),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          ColorConstant.redA700,
                                                    ),
                                                  );
                                                }

                                                Navigator.pushNamed(
                                                  context,
                                                  '/home_page_screen',
                                                );
                                              },
                                              child: Text('Confirm',
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold14
                                                      .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(0.2),
                                                    color:
                                                        ColorConstant.blueA700,
                                                  )),
                                            ),
                                          ],
                                        );
                                      });
                                    });
                              },
                              height: getVerticalSize(56),
                              text: "Finalize Changes",
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
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

Future<double> fetchExchangeRate(
    String baseCurrency, String targetCurrency) async {
  String apiKey =
      '75b1040cb041406086e97f3476c890d7'; // Replace with your API key from exchangeratesapi.io
  String apiUrl =
      'https://open.er-api.com/v6/latest/$baseCurrency?apikey=$apiKey';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      double exchangeRate = jsonResponse['rates'][targetCurrency];
      return exchangeRate;
    } else {
      throw Exception('Failed to load exchange rate');
    }
  } catch (e) {
    throw Exception('Failed to fetch exchange rate: $e');
  }
}
