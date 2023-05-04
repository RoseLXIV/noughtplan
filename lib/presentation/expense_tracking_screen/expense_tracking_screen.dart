import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/expense_tracker/controller/expense_tracker_controller.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/listchart_item_widget.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/listchart_item_widget_debt.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/listchart_item_widget_save.dart';
import 'package:noughtplan/presentation/expense_tracking_screen/actual_expenses_provider.dart';
import 'package:noughtplan/widgets/custom_button_form.dart';

import 'widgets/calender_widget.dart';
import 'widgets/expenses_lists_widget.dart';

class ExpenseModalController extends StateNotifier<bool> {
  ExpenseModalController() : super(false);

  void openModal() => state = true;
  void closeModal() => state = false;
}

final expenseModalProvider =
    StateNotifierProvider<ExpenseModalController, bool>((ref) {
  return ExpenseModalController();
});

class ExpenseTrackingScreen extends HookConsumerWidget {
  // const ExpenseTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Budget? selectedBudget = args['budget'];
    final String? firstName = args['firstName'];

    final budgetNotifier = ref.watch(budgetStateProvider.notifier);
    // // final budgetState = ref.watch(budgetStateProvider);
    // print('Budget State: ${budgetState.budgets}');

    final _budgets = useState<List<Budget?>?>(null);

    Map<String, double> getTotalAmountPerCategory(
        List<Map<String, dynamic>> actualExpenses) {
      Map<String, double> totalAmountPerCategory = {};

      actualExpenses.forEach((expense) {
        String category = expense['category'];
        double amount = (expense['amount'] as num).toDouble();

        if (totalAmountPerCategory.containsKey(category)) {
          totalAmountPerCategory[category] =
              totalAmountPerCategory[category]! + amount;
        } else {
          totalAmountPerCategory[category] = amount;
        }
      });

      return totalAmountPerCategory;
    }

    Map<String, double> calculateTotalAmounts(Budget? budget) {
      return getTotalAmountPerCategory(budget?.actualExpenses ?? []);
    }

    Map<String, double> totalAmounts =
        getTotalAmountPerCategory(selectedBudget?.actualExpenses ?? []);

    if (_budgets.value != null) {
      // Future.microtask(() async {
      final updatedSelectedBudget = _budgets.value!.firstWhere(
        (budget) => budget?.budgetId == selectedBudget!.budgetId,
        orElse: () => null,
      );

      if (updatedSelectedBudget != null) {
        // final actualExpensesNotifier =
        //     ref.read(actualExpensesProvider.notifier);
        // actualExpensesNotifier
        //     .updateActualExpenses(updatedSelectedBudget.actualExpenses);

        // Update the totalAmounts
        totalAmounts = calculateTotalAmounts(updatedSelectedBudget);
      }
      // });
    }

    String totalRemainingFundsFormatted = '';

    double getTotalAmountsSum(Map<String, double> totalAmounts) {
      double sum = 0;
      totalAmounts.values.forEach((value) {
        sum += value;
      });
      return sum;
    }

    // print('Total Amounts: $totalAmounts');

    void updateExpensesOnLoad() {
      Future.microtask(
        () async {
          final fetchedBudgets = await budgetNotifier.fetchUserBudgets();
          if (context.mounted) {
            _budgets.value = fetchedBudgets;
          }

          if (_budgets.value != null) {
            final updatedSelectedBudget = _budgets.value!.firstWhere(
              (budget) => budget?.budgetId == selectedBudget!.budgetId,
              orElse: () => null,
            );

            if (updatedSelectedBudget != null) {
              final actualExpensesNotifier =
                  await ref.read(actualExpensesProvider.notifier);
              actualExpensesNotifier
                  .updateActualExpenses(updatedSelectedBudget.actualExpenses);
            }
          }
        },
      );
    }

    useEffect(() {
      updateExpensesOnLoad();
      return () {}; // Clean-up function
    }, []);

    final Map<String, double> necessaryCategories =
        selectedBudget?.necessaryExpense ?? {};
    final Map<String, double> discretionaryCategories =
        selectedBudget?.discretionaryExpense ?? {};
    final Map<String, double> debtCategories =
        selectedBudget?.debtExpense ?? {};

    final double necessaryTotal =
        necessaryCategories.values.fold(0, (a, b) => a + b);
    final double discretionaryTotal =
        discretionaryCategories.values.fold(0, (a, b) => a + b);
    final double debtTotal = debtCategories.values.fold(0, (a, b) => a + b);

    final totalExpenses = necessaryTotal + discretionaryTotal + debtTotal;

    final numberFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    final String necessaryTotalFormatted = numberFormat.format(necessaryTotal);
    final String discretionaryTotalFormatted =
        numberFormat.format(discretionaryTotal);
    final String debtTotalFormatted = numberFormat.format(debtTotal);
    final String totalExpensesFormatted = numberFormat.format(totalExpenses);

    final Map<String, double> savingsCategories = {
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

    List<Map<String, String>> necessaryBudgetItems = [];
    List<Map<String, String>> discretionaryBudgetItems = [];
    List<Map<String, String>> debtBudgetItems = [];
    List<Map<String, String>> savingsBudgetItems = [];

    necessaryCategories.forEach((key, value) {
      if (!savingsCategories.containsKey(key) &&
          !key.toLowerCase().contains('savings') &&
          !key.toLowerCase().contains('investment')) {
        necessaryBudgetItems.add({
          'category': key,
          'amount': numberFormat.format(value),
        });
      } else {
        savingsBudgetItems.add({
          'category': key,
          'amount': numberFormat.format(value),
        });
      }
    });

    discretionaryCategories.forEach((key, value) {
      discretionaryBudgetItems.add({
        'category': key,
        'amount': numberFormat.format(value),
      });
    });

    debtCategories.forEach((key, value) {
      debtBudgetItems.add({
        'category': key,
        'amount': numberFormat.format(value),
      });
    });

    print('savingsBudgetItems $savingsBudgetItems');

    double totalExpensesSum = getTotalAmountsSum(totalAmounts);
    double totalRemainingFunds = totalExpenses - totalExpensesSum;
    totalRemainingFundsFormatted = numberFormat.format(totalRemainingFunds);

    Widget buildDetailsSheet(BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.7,
                maxChildSize: 0.9,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Consumer(
                    builder: (context, watch, _) {
                      // Add your watch statements here if needed
                      return Container(
                        padding: EdgeInsets.only(
                            top: 8, left: 24, right: 24, bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
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
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Consumer(builder: (context, watch, child) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: getPadding(
                                            top: 29,
                                          ),
                                          child: Text(
                                            "Debt Amounts",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold16
                                                .copyWith(
                                              letterSpacing: getHorizontalSize(
                                                0.4,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                            top: 8,
                                          ),
                                          child: Padding(
                                            padding: getPadding(
                                                top: 8, left: 8, right: 8),
                                            child: ListView.separated(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  height: getVerticalSize(
                                                    16,
                                                  ),
                                                );
                                              },
                                              itemCount: debtBudgetItems.length,
                                              itemBuilder: (context, index) {
                                                return ListDebtChartItemWidgetDebt(
                                                  category:
                                                      debtBudgetItems[index]
                                                          ['category']!,
                                                  amount: debtBudgetItems[index]
                                                      ['amount']!,
                                                  totalAmount: totalAmounts[
                                                          debtBudgetItems[index]
                                                              ['category']] ??
                                                      0,
                                                  onLoad: updateExpensesOnLoad,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                            top: 29,
                                          ),
                                          child: Text(
                                            "Necessary Amounts",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold16
                                                .copyWith(
                                              letterSpacing: getHorizontalSize(
                                                0.4,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(top: 8),
                                          child: Padding(
                                            padding: getPadding(
                                                top: 8, left: 8, right: 8),
                                            child: ListView.separated(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  height: getVerticalSize(16),
                                                );
                                              },
                                              itemCount:
                                                  savingsBudgetItems.length,
                                              itemBuilder: (context, index) {
                                                return ListDebtChartItemWidgetSave(
                                                  category:
                                                      savingsBudgetItems[index]
                                                          ['category']!,
                                                  amount:
                                                      savingsBudgetItems[index]
                                                          ['amount']!,
                                                  totalAmount: totalAmounts[
                                                          savingsBudgetItems[
                                                                  index]
                                                              ['category']] ??
                                                      0,
                                                  onLoad: updateExpensesOnLoad,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                            top: 8,
                                          ),
                                          child: Padding(
                                            padding: getPadding(
                                                top: 8, left: 8, right: 8),
                                            child: ListView.separated(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  height: getVerticalSize(
                                                    16,
                                                  ),
                                                );
                                              },
                                              itemCount:
                                                  necessaryBudgetItems.length,
                                              itemBuilder: (context, index) {
                                                return ListchartItemWidget(
                                                  category:
                                                      necessaryBudgetItems[
                                                          index]['category']!,
                                                  amount: necessaryBudgetItems[
                                                      index]['amount']!,
                                                  totalAmount: totalAmounts[
                                                          necessaryBudgetItems[
                                                                  index]
                                                              ['category']] ??
                                                      0,
                                                  onLoad: updateExpensesOnLoad,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                            top: 29,
                                          ),
                                          child: Text(
                                            "Discretionary Amounts",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold16
                                                .copyWith(
                                              letterSpacing: getHorizontalSize(
                                                0.4,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                            top: 8,
                                          ),
                                          child: Padding(
                                            padding: getPadding(
                                                top: 8, left: 8, right: 8),
                                            child: ListView.separated(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  height: getVerticalSize(
                                                    16,
                                                  ),
                                                );
                                              },
                                              itemCount:
                                                  discretionaryBudgetItems
                                                      .length,
                                              itemBuilder: (context, index) {
                                                return ListchartItemWidget(
                                                  category:
                                                      discretionaryBudgetItems[
                                                          index]['category']!,
                                                  amount:
                                                      discretionaryBudgetItems[
                                                          index]['amount']!,
                                                  totalAmount: totalAmounts[
                                                          discretionaryBudgetItems[
                                                                  index]
                                                              ['category']] ??
                                                      0,
                                                  onLoad: updateExpensesOnLoad,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        body: Container(
          height: getVerticalSize(
            812,
          ),
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Transform(
                  transform: Matrix4.identity()..scale(1.0, 1.0, 0.1),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgTopographic7,
                    height: MediaQuery.of(context).size.height *
                        1, // Set the height to 50% of the screen height
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set the width to the full screen width
                    // alignment: Alignment.,
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgGroup183001,
                      height: getVerticalSize(
                        53,
                      ),
                      width: getHorizontalSize(
                        161,
                      ),
                      alignment: Alignment.topLeft,
                      margin: getMargin(
                        left: 17,
                        top: 25,
                      ),
                    ),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            children: [
                              Padding(
                                padding: getPadding(
                                  right: 17,
                                  top: 28,
                                ),
                                child: IconButton(
                                  icon: CustomImageView(
                                    svgPath: ImageConstant.imgBudgetDetails1,
                                    height: getSize(
                                      48,
                                    ),
                                    width: getSize(
                                      48,
                                    ),
                                    color: ColorConstant.blueA700,
                                  ), // Replace with your desired icon
                                  onPressed: () async {
                                    if (_budgets.value != null) {
                                      // Future.microtask(() async {
                                      final fetchedBudgets =
                                          await budgetNotifier
                                              .fetchUserBudgets();
                                      _budgets.value = fetchedBudgets;
                                      final updatedSelectedBudget =
                                          _budgets.value!.firstWhere(
                                        (budget) =>
                                            budget?.budgetId ==
                                            selectedBudget!.budgetId,
                                        orElse: () => null,
                                      );

                                      // print(
                                      // 'Modal updatedSelectedBudget: $updatedSelectedBudget');

                                      if (updatedSelectedBudget != null) {
                                        final actualExpensesNotifier = ref.read(
                                            actualExpensesProvider.notifier);
                                        actualExpensesNotifier
                                            .updateActualExpenses(
                                                updatedSelectedBudget
                                                    .actualExpenses);

                                        // Update the totalAmounts
                                        totalAmounts = calculateTotalAmounts(
                                            updatedSelectedBudget);
                                      }
                                      // });
                                    }
                                    showModalBottomSheet(
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
                                        return buildDetailsSheet(context);
                                      },
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  right: 17,
                                  top: 34,
                                ),
                                child: GestureDetector(
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
                                            style: AppStyle.txtManropeRegular14,
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
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 7),
                                    child: SvgPicture.asset(
                                      ImageConstant.imgQuestion,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: getPadding(top: 95, left: 12, right: 12),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: getPadding(bottom: 100),
                      child: Column(
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final actualExpenses =
                                  ref.watch(actualExpensesProvider);

                              // print(
                              //     'actualExpenses from Expenses screen: $actualExpenses');
                              return CalendarWidget(
                                budget: selectedBudget,
                                actualExpenses: actualExpenses,
                                onLoad: updateExpensesOnLoad,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: NeumorphicFloatingActionButton(
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(60)),
            depth: 0.5,
            // intensity: 9,
            surfaceIntensity: 0.8,
            lightSource: LightSource.top,
            color: ColorConstant.lightBlueA200,
          ),

          onPressed: () => _showAddExpenseModal(context, selectedBudget, ref),

          child: Icon(
            Icons.add_rounded,
            color: ColorConstant.whiteA700,
            size: getSize(42),
          ),
          // backgroundColor: ColorConstant.lightBlueA200,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<void> _showAddExpenseModal(
      BuildContext context, Budget? budget, WidgetRef ref) async {
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

    List<String> allCategories = [
      ...necessaryCategories.keys,
      ...discretionaryCategories.keys,
      ...debtCategories.keys,
    ];

    String? selectedCategory;
    String? recurringType;
    int? duration;
    TextEditingController amountController = TextEditingController();

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      DateTime? pickedDate =
                                          await showDatePicker(
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
                                                  expenseDates.add(
                                                      startDate.add(Duration(
                                                          days: 30 * i)));
                                                }
                                                break;
                                              case 'Bi-Weekly':
                                                for (int i = 0;
                                                    i < (duration ?? 0);
                                                    i++) {
                                                  expenseDates.add(
                                                      startDate.add(Duration(
                                                          days: 14 * i)));
                                                }
                                                break;
                                              case 'Weekly':
                                                for (int i = 0;
                                                    i < (duration ?? 0);
                                                    i++) {
                                                  expenseDates.add(
                                                      startDate.add(Duration(
                                                          days: 7 * i)));
                                                }
                                                break;
                                              default:
                                                expenseDates.add(startDate);
                                            }

                                            for (DateTime expenseDate
                                                in expenseDates) {
                                              Map<String, dynamic> expenseData =
                                                  {
                                                'date': expenseDate.toString(),
                                                'category':
                                                    selectedCategory ?? '',
                                                'amount': amountController
                                                        .text.isNotEmpty
                                                    ? double.tryParse(
                                                        amountController.text
                                                            .replaceAll(
                                                                ',', ''))
                                                    : 0.0,
                                              };

                                              String budgetId =
                                                  budget!.budgetId;
                                              print('budgetId: $budgetId');
                                              await expenseController
                                                  .addActualExpenseToBudget(
                                                      budgetId,
                                                      expenseData,
                                                      ref);
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
                                                    color: ColorConstant
                                                        .blueGray300,
                                                  ),
                                                  fillColor: Colors.transparent,
                                                  filled: true,
                                                  border: InputBorder.none,
                                                  errorText: expenseState
                                                                  .category
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
                                                popupItemBuilder: (context,
                                                    item, isSelected) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
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
                                                  color:
                                                      ColorConstant.blue90001,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                border: UnderlineInputBorder(),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  borderSide: BorderSide(
                                                    color: ColorConstant
                                                        .blueGray100,
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
                                                    padding:
                                                        getPadding(left: 10),
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
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(value,
                                                                style: AppStyle
                                                                    .txtHelveticaNowTextBold16
                                                                    .copyWith(
                                                                  color: ColorConstant
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
                                                        items: List<
                                                                int>.generate(
                                                            12,
                                                            (i) =>
                                                                i + 1).map<
                                                            DropdownMenuItem<
                                                                int>>((int
                                                            value) {
                                                          return DropdownMenuItem<
                                                              int>(
                                                            value: value,
                                                            child: Text(
                                                                value
                                                                    .toString(),
                                                                style: AppStyle
                                                                    .txtHelveticaNowTextBold16
                                                                    .copyWith(
                                                                  color: ColorConstant
                                                                      .black900,
                                                                )),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (int? newValue) {
                                                          setState(() {
                                                            duration =
                                                                newValue!;
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
                                              onTap: () {
                                                submitForm();
                                              },
                                              alignment: Alignment.bottomCenter,
                                              height: getVerticalSize(56),
                                              text: "Save",
                                              enabled: isValidated,
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
