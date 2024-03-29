import 'dart:math';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/budget/allocate_funds/controller/allocate_funds_controller.dart';
import 'package:noughtplan/core/budget/allocate_funds/controller/remaining_funds_controller.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:noughtplan/core/providers/first_time_provider.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/discretionary_categories_with_amount_notifier.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/listdebt_item_widget.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/listdiscretionary_item_widget.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/listsavings_item_widget.dart';
import 'package:noughtplan/presentation/category_necessary_screen/category_necessary_screen.dart';
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

import 'widgets/loading_dialog_controller.dart';

final executedOnceProvider = StateProvider<bool>((ref) => false);

// String generateNewBudgetId() {
//   var uuid = Uuid();
//   String newBudgetId = uuid.v4();
//   return newBudgetId;
// }

final isAllAmountsEnteredProvider = StateProvider<bool>((ref) {
  return false;
});

class AllocateFundsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generateSalaryState = ref.watch(generateSalaryProvider);

    final _animationController =
        useAnimationController(duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);

    final firstTime = ref.watch(firstTimeProvider);

    // final Map<String, dynamic>? args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // final Map<String, double> necessaryCategoriesWithAmount =
    //     args?['necessaryCategoriesWithAmount'] as Map<String, double>? ?? {};

    // final Map<String, double> extractedDebtLoanCategories =
    //     args?['extractedDebtLoanCategories'] as Map<String, double>? ?? {};

    // final Map<String, double> discretionaryCategoriesWithAmount =
    //     args?['discretionaryCategoriesWithAmount'] as Map<String, double>? ??
    //         {};

    final necessaryCategoriesWithAmount =
        ref.watch(necessaryCategoriesProvider);
    final extractedDebtLoanCategories = ref.watch(debtCategoriesProvider);
    final discretionaryCategoriesWithAmount =
        ref.watch(discretionaryCategoriesProvider);
    final savingsWithAmount = ref.watch(savingsCategoriesProvider);

    final generateSalaryController = ref.watch(generateSalaryProvider.notifier);

    // final Salary = generateSalaryController.state.salary;

    // print('Salary in allocate screen: $Salary');

    // print('budgetId in allocate screen: $budgetId');

    List<String> combinedCategories = [
      ...necessaryCategoriesWithAmount.keys,
      ...extractedDebtLoanCategories.keys,
      ...discretionaryCategoriesWithAmount.keys,
      ...savingsWithAmount.keys
    ];

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

    Map<String, double> getIndividualAmountsSavings(
        WidgetRef ref, List<String> categories) {
      Map<String, double> individualAmounts = {};

      for (String category in categories) {
        double amount = ref
            .read(enteredAmountsSavingsProvider.notifier)
            .getAmount(category);
        individualAmounts[category] = amount;
      }

      return individualAmounts;
    }

    List<String> getAllCategories(
      Map<String, double> necessaryCategoriesWithAmount,
      Map<String, double> extractedDebtLoanCategories,
      Map<String, double> discretionaryCategoriesWithAmount,
      Map<String, double> savingsWithAmount,
    ) {
      Set<String> allCategories = {};

      allCategories.addAll(necessaryCategoriesWithAmount.keys);
      allCategories.addAll(extractedDebtLoanCategories.keys);
      allCategories.addAll(discretionaryCategoriesWithAmount.keys);
      allCategories.addAll(savingsWithAmount.keys);

      return allCategories.toList();
    }

    // Get the total amount of entered numbers for all categories
    List<String> allCategories = getAllCategories(
        necessaryCategoriesWithAmount,
        extractedDebtLoanCategories,
        discretionaryCategoriesWithAmount,
        savingsWithAmount);
    Map<String, double> individualAmounts =
        getIndividualAmounts(ref, allCategories);
    Map<String, double> individualAmountsDiscretionary =
        getIndividualAmountsDiscretionary(ref, allCategories);
    Map<String, double> individualAmountsDebt =
        getIndividualAmountsDebt(ref, allCategories);
    Map<String, double> individualAmountsSavings =
        getIndividualAmountsSavings(ref, allCategories);

    double totalEnteredAmountNecessary =
        individualAmounts.values.fold(0, (a, b) => a + b);
    double totalEnteredAmountDiscretionary =
        individualAmountsDiscretionary.values.fold(0, (a, b) => a + b);
    double totalEnteredAmountDebt =
        individualAmountsDebt.values.fold(0, (a, b) => a + b);
    double totalEnteredAmountSavings =
        individualAmountsSavings.values.fold(0, (a, b) => a + b);

    double allTotalEnteredAmount = totalEnteredAmountNecessary +
        totalEnteredAmountDiscretionary +
        totalEnteredAmountDebt +
        totalEnteredAmountSavings;

    bool isAllTotalEnteredAmountNonZero = allTotalEnteredAmount != 0;
    // print('allTotalEnteredAmount: $allTotalEnteredAmount');

    // Update the remainingFunds state
    double initialRemainingFunds =
        ref.watch(remainingFundsProvider.notifier).initialValue;

    print('initialRemainingFunds: $initialRemainingFunds');

    ref
        .read(remainingFundsProvider.notifier)
        .updateInitialValue(initialRemainingFunds - allTotalEnteredAmount);

    // Set the executedOnce flag to true

    // print('Salary value on load allocate: ${generateSalaryState.salary.value}');

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

      double savingsTotal = 0.0;
      savingsWithAmount.keys.forEach((category) {
        savingsTotal += ref
            .read(enteredAmountsSavingsProvider.notifier)
            .getAmount(category);
      });

      double editedTotal = ref
          .read(enteredAmountsDiscretionaryProvider.notifier)
          .getEditedAmounts(ref);
      print('editedTotal: $editedTotal');
      ref.read(remainingFundsProvider.notifier).resetRemainingFunds(
          ref, necessaryTotal, editedTotal, debtTotal, savingsTotal);
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
            ref,
            totalRandomAmounts,
            necessaryTotal,
            editedTotal,
            debtTotal,
            savingsTotal);
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

    final loadingDialogController = LoadingDialogController();
    final bool isValidated = generateSalaryState.status.isValidated;

    // final allocateFundsState = ref.watch(allocateFundsProvider);
    // final bool isValidated = allocateFundsState.status.isValidated;
    // final allocateFundsController = ref.watch(allocateFundsProvider.notifier);

    // Define variables for error messages
    String budgetIdErrorMessage =
        'Please enter your Salary, Currency & Budget Type';
    String combinedCategoriesErrorMessage =
        'Please select at least one (1) category';
    String remainingFundsErrorMessage = 'Remaining funds cannot be negative';
    String totalAmountErrorMessage = 'Please enter at least one (1) amount';

// Check conditions for error messages
    bool showBudgetIdError = !isValidated;
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
                      Transform(
                        transform: Matrix4.identity()..scale(1.0, 1.0, 0.1),
                        alignment: Alignment.center,
                        child: CustomImageView(
                          imagePath: ImageConstant.expenseTop,
                          height: MediaQuery.of(context).size.height *
                              1, // Set the height to 50% of the screen height
                          width: MediaQuery.of(context)
                              .size
                              .width, // Set the width to the full screen width
                          alignment: Alignment.topCenter,
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
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Allocate Your Expenses',
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
                                                                'Here are the steps to allocate your funds effectively:\n\n'),
                                                        TextSpan(
                                                            text:
                                                                '1. Fill In Amounts:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' Enter the amounts for each category. If you need to start over, simply press the reset button to clear all inputs.\n\n'),
                                                        TextSpan(
                                                            text:
                                                                '2. Auto-Assign Discretionary Funds:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' Use the auto-assign discretionary button to distribute funds evenly across categories. Note that if you manually edit a field afterward, the auto-assign function will no longer be available.\n\n'),
                                                        TextSpan(
                                                            text:
                                                                '3. Complete All Fields:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' Ensure that you enter amounts for all categories. Any leftover funds will not be included in the final budget results.\n\n'),
                                                        TextSpan(
                                                            text:
                                                                '4. Name Your Budget:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' Once you are finished you will be asked to enter a name for your budget. This will help you identify it later if you need to make edits or review details.\n\n'),
                                                        TextSpan(
                                                            text:
                                                                'Remember, carefully allocating funds across your budget will create a balanced plan that suits your lifestyle and helps manage your finances efficiently. All the values and settings can be edited later as per your needs.'),
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
                              Column(
                                children: [
                                  Padding(
                                    padding: getPadding(
                                      top: 12,
                                    ),
                                    child: Text(
                                      "Remaining Funds",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style:
                                          AppStyle.txtManropeRegular14.copyWith(
                                        letterSpacing: getHorizontalSize(0.3),
                                      ),
                                    ),
                                  ),
                                ],
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
                                          double savingsTotal = 0.0;

                                          necessaryCategoriesWithAmount.keys
                                              .forEach((category) {
                                            necessaryTotal += ref
                                                .read(enteredAmountsProvider
                                                    .notifier)
                                                .getAmount(category);
                                          });

                                          savingsWithAmount.keys
                                              .forEach((category) {
                                            savingsTotal += ref
                                                .read(
                                                    enteredAmountsSavingsProvider
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
                                                .resetFundsDebt(
                                                    necessaryTotal,
                                                    discretionaryTotal,
                                                    savingsTotal);
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
                                      return ListDebtItemWidget(
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
                                        child: Text("Savings/Goals",
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
                                          double debtTotal = 0.0;

                                          necessaryCategoriesWithAmount.keys
                                              .forEach((category) {
                                            necessaryTotal += ref
                                                .read(enteredAmountsProvider
                                                    .notifier)
                                                .getAmount(category);
                                          });

                                          extractedDebtLoanCategories.keys
                                              .forEach((category) {
                                            debtTotal += ref
                                                .read(enteredAmountsDebtProvider
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
                                                .resetFundsDebt(
                                                    necessaryTotal,
                                                    discretionaryTotal,
                                                    debtTotal);
                                          });

                                          savingsWithAmount.keys
                                              .forEach((category) {
                                            ref
                                                .read(
                                                    textEditingSavingsControllerProvider(
                                                            category)
                                                        .notifier)
                                                .state
                                                .clear();
                                          });

                                          ref
                                              .read(
                                                  enteredAmountsSavingsProvider
                                                      .notifier)
                                              .resetAmounts();
                                          // ref
                                          //     .read(allocateFundsProvider
                                          //         .notifier)
                                          //     .resetValidationDebt();
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
                                    itemCount: savingsWithAmount.keys.length,
                                    itemBuilder: (context, index) {
                                      String category = savingsWithAmount.keys
                                          .elementAt(index);
                                      double amount =
                                          savingsWithAmount[category] ?? 0;
                                      return ListSavingsItemWidget(
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
                                          double savingsTotal = 0.0;

                                          discretionaryCategoriesWithAmount.keys
                                              .forEach((category) {
                                            discretionaryTotal += ref
                                                .read(
                                                    enteredAmountsDiscretionaryProvider
                                                        .notifier)
                                                .getAmount(category);
                                          });

                                          savingsWithAmount.keys
                                              .forEach((category) {
                                            savingsTotal += ref
                                                .read(
                                                    enteredAmountsSavingsProvider
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
                                                    debtLoanTotal,
                                                    savingsTotal);
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
                                                  double savingsTotal = 0.0;

                                                  extractedDebtLoanCategories
                                                      .keys
                                                      .forEach((category) {
                                                    debtLoanTotal += ref
                                                        .read(
                                                            enteredAmountsDebtProvider
                                                                .notifier)
                                                        .getAmount(category);
                                                  });

                                                  savingsWithAmount.keys
                                                      .forEach((category) {
                                                    savingsTotal += ref
                                                        .read(
                                                            enteredAmountsSavingsProvider
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
                                                            debtLoanTotal,
                                                            savingsTotal);
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
                KeyboardVisibilityBuilder(builder: (context, visible) {
                  return Visibility(
                    visible:
                        !visible, // Hide the container when the keyboard is visible
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
                                  visible: showBudgetIdError,
                                  child:
                                      errorMessageWidget(budgetIdErrorMessage),
                                ),
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
                                                'Please confirm that your budget information is accurate and complete.\nYou can always make changes later.',
                                                style: AppStyle
                                                    .txtManropeRegular14
                                                    .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              TextField(
                                                textAlign: TextAlign.center,
                                                controller:
                                                    budgetNameController,
                                                style: AppStyle
                                                    .txtManropeRegular16
                                                    .copyWith(
                                                        color: ColorConstant
                                                            .blueGray800),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      'Enter Your Budget Name...',
                                                  labelStyle: AppStyle
                                                      .txtHelveticaNowTextBold16Blue
                                                      .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(0.2),
                                                  ),
                                                  hintText:
                                                      'Enter budget name...',
                                                  hintStyle: AppStyle
                                                      .txtManropeRegular12Bluegray300
                                                      .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(0.2),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  setState(
                                                      () {}); // Update the state to enable/disable the "Confirm" button
                                                },
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
                                              onPressed: budgetNameController
                                                      .text.isNotEmpty
                                                  ? () async {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      loadingDialogController
                                                          .show(context);

                                                      final budgetState =
                                                          ref.watch(
                                                              budgetStateProvider
                                                                  .notifier);

                                                      await generateSalaryController
                                                          .saveBudgetInfo();
                                                      final budgetId =
                                                          generateSalaryController
                                                              .state.budgetId;

                                                      await budgetState
                                                          .saveBudgetNecessaryInfo(
                                                        budgetId: budgetId,
                                                        necessaryExpense:
                                                            necessaryCategoriesWithAmount,
                                                      );

                                                      await budgetState
                                                          .saveBudgetDebtInfo(
                                                        budgetId: budgetId,
                                                        debtExpense:
                                                            extractedDebtLoanCategories,
                                                      );

                                                      await budgetState
                                                          .saveBudgetDiscretionaryInfo(
                                                        budgetId: budgetId,
                                                        discretionaryExpense:
                                                            discretionaryCategoriesWithAmount,
                                                      );

                                                      await budgetState
                                                          .saveSavingsNecessaryInfo(
                                                        budgetId: budgetId,
                                                        savings:
                                                            savingsWithAmount,
                                                      );
                                                      print(
                                                          'Remaining Funds on Next Button: ${remainingFunds}');

                                                      List<String>
                                                          allCategories =
                                                          Set<String>.from(
                                                                  necessaryCategoriesWithAmount
                                                                      .keys)
                                                              .toList();

                                                      List<String>
                                                          allCategoriesDiscretionary =
                                                          Set<String>.from(
                                                                  discretionaryCategoriesWithAmount
                                                                      .keys)
                                                              .toList();

                                                      List<String>
                                                          allCategoriesDebt =
                                                          Set<String>.from(
                                                                  extractedDebtLoanCategories
                                                                      .keys)
                                                              .toList();

                                                      List<String>
                                                          allCategoriesSavings =
                                                          Set<String>.from(
                                                                  savingsWithAmount
                                                                      .keys)
                                                              .toList();

                                                      // final Map<String, double>
                                                      //     savingsCategories = {
                                                      //   "Emergency Fund": 0,
                                                      //   "Retirement Savings": 0,
                                                      //   "Investments": 0,
                                                      //   "Education Savings": 0,
                                                      //   "Vacation Fund": 0,
                                                      //   "Down Payment": 0,
                                                      //   "Home Improvement Fund":
                                                      //       0,
                                                      //   "Home Equity Loan": 0,
                                                      //   "Debt Payoff": 0,
                                                      //   "Wedding Fund": 0,
                                                      //   "Vehicle Savings": 0,
                                                      //   "General Savings": 0,
                                                      // };

                                                      Map<String, double>
                                                          individualAmountsNecessary =
                                                          getIndividualAmounts(
                                                              ref,
                                                              allCategories);

                                                      Map<String, double>
                                                          individualAmountsDiscretionary =
                                                          getIndividualAmountsDiscretionary(
                                                              ref,
                                                              allCategoriesDiscretionary);

                                                      Map<String, double>
                                                          individualAmountsDebt =
                                                          getIndividualAmountsDebt(
                                                              ref,
                                                              allCategoriesDebt);

                                                      Map<String, double>
                                                          individualAmountsSavings =
                                                          getIndividualAmountsSavings(
                                                              ref,
                                                              allCategoriesSavings);

                                                      double totalSavings =
                                                          individualAmountsSavings
                                                              .values
                                                              .fold(
                                                                  0,
                                                                  (prev, amount) =>
                                                                      prev +
                                                                      amount);

                                                      // individualAmountsNecessary
                                                      //     .forEach(
                                                      //         (key, value) {
                                                      //   RegExp regex = RegExp(
                                                      //       r'savings|saving|investment',
                                                      //       caseSensitive:
                                                      //           false);
                                                      //   if (regex
                                                      //       .hasMatch(key)) {
                                                      //     totalSavings += value;
                                                      //   } else if (savingsCategories
                                                      //       .containsKey(key)) {
                                                      //     totalSavings += value;
                                                      //   }
                                                      // });

                                                      // individualAmountsDiscretionary
                                                      //     .forEach(
                                                      //         (key, value) {
                                                      //   RegExp regex = RegExp(
                                                      //       r'savings|saving|investment',
                                                      //       caseSensitive:
                                                      //           false);
                                                      //   if (regex
                                                      //       .hasMatch(key)) {
                                                      //     totalSavings += value;
                                                      //   } else if (savingsCategories
                                                      //       .containsKey(key)) {
                                                      //     totalSavings += value;
                                                      //   }
                                                      // });

                                                      double
                                                          totalSavingsAndSurplus =
                                                          totalSavings +
                                                              remainingFunds;

                                                      print(
                                                          'Total Savings: $totalSavingsAndSurplus');

                                                      print(
                                                          'Budget ID before get getCurrency: $budgetId');

                                                      double exchangeRate = 1.0;
                                                      String currency =
                                                          await budgetState
                                                              .getCurrency(
                                                                  budgetId:
                                                                      budgetId);

                                                      print(
                                                          'Budget ID: $budgetId');
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
                                                                  0,
                                                                  (a, b) =>
                                                                      a + b);
                                                      double
                                                          totalEnteredAmountDiscretionary =
                                                          individualAmountsDiscretionary
                                                              .values
                                                              .fold(
                                                                  0,
                                                                  (a, b) =>
                                                                      a + b);
                                                      // double
                                                      //     totalEnteredAmountDebt =
                                                      //     individualAmountsDebt
                                                      //         .values
                                                      //         .fold(
                                                      //             0,
                                                      //             (a, b) =>
                                                      //                 a + b);

                                                      double
                                                          totalEnteredAmountNecessaryUSD =
                                                          totalEnteredAmountNecessary *
                                                              exchangeRate;

                                                      final remainingFundsController =
                                                          ref.read(
                                                              remainingFundsProvider
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

                                                      if (spendingType !=
                                                          null) {
                                                        print(
                                                            'Spending type updated to $spendingType');

                                                        String? savingType =
                                                            await budgetState
                                                                .updateSavingType(
                                                          budgetId: budgetId,
                                                          spendingType:
                                                              spendingType,
                                                          totalSavings:
                                                              totalSavingsAndSurplus,
                                                          salary: salary,
                                                        );

                                                        if (savingType !=
                                                            null) {
                                                          print(
                                                              'Saving type updated to $savingType');

                                                          double totalDebt =
                                                              individualAmountsDebt
                                                                  .values
                                                                  .fold(
                                                                      0,
                                                                      (a, b) =>
                                                                          a +
                                                                          b);
                                                          String? debtType =
                                                              await budgetState
                                                                  .updateDebtType(
                                                            budgetId: budgetId,
                                                            debt: totalDebt,
                                                            income: salary,
                                                          );

                                                          if (debtType !=
                                                              null) {
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

                                                      await budgetState
                                                          .updateBudgetInfoSubscriberSalary(
                                                        budgetId: budgetId!,
                                                        salary: salary,
                                                      );

                                                      await budgetState
                                                          .updateAmounts(
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

                                                      await budgetState
                                                          .updateSavingsAmounts(
                                                        budgetId: budgetId,
                                                        savings:
                                                            individualAmountsSavings,
                                                      );

                                                      await budgetState
                                                          .updateSurplus(
                                                        budgetId: budgetId,
                                                        remainingFunds:
                                                            remainingFunds,
                                                      );

                                                      await budgetState
                                                          .updateBudgetNameAndDate(
                                                        budgetId: budgetId,
                                                        budgetName:
                                                            budgetNameController
                                                                .text,
                                                      );

                                                      await budgetState
                                                          .deleteZeroValueCategories(
                                                        budgetId: budgetId,
                                                      );

                                                      await budgetState
                                                          .deleteBudgetsWithNoName();
                                                      loadingDialogController
                                                          .hide();

                                                      if (budgetState
                                                              .state.status ==
                                                          BudgetStatus
                                                              .success) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Your budget has been created!',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
                                                        Navigator.pop(context);
                                                        Navigator.pushNamed(
                                                          context,
                                                          '/home_page_screen',
                                                        );
                                                      } else {
                                                        // Show SnackBar with failure message
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Something went wrong! Please try again later.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
                                                                    .redA700,
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  : null,
                                              child: Text('Confirm',
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold14
                                                      .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(0.2),
                                                    color: budgetNameController
                                                            .text.isNotEmpty
                                                        ? ColorConstant.blueA700
                                                        : Colors.grey,
                                                  )),
                                            ),
                                          ],
                                        );
                                      });
                                    });
                              },
                              height: getVerticalSize(56),
                              text: "Create Your Budget",
                              enabled: combinedCategories.isNotEmpty &&
                                  isValidated &&
                                  remainingFunds >= 0 &&
                                  isAllTotalEnteredAmountNonZero,
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
