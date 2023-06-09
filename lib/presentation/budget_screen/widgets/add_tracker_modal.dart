import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/expense_tracker/controller/custom_goal_tracker_controller.dart';
import 'package:noughtplan/core/budget/expense_tracker/controller/debt_tracker_controller.dart';
import 'package:noughtplan/core/budget/expense_tracker/controller/goal_tracker_controller.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/widgets/custom_button_form.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'debts_provider.dart';
import 'goals_provider.dart';

String? selectedCategory;
String? frequencyType;
String? trackerType;

final amountController = TextEditingController();
TextEditingController amountOustandingController = TextEditingController();
TextEditingController goalNameController = TextEditingController();
TextEditingController interestController = TextEditingController();
TextEditingController recurringAmountController = TextEditingController();

void resetControllers() {
  selectedCategory = null;
  frequencyType = null;
  trackerType = null;

  amountController.clear();
  amountOustandingController.clear();
  interestController.clear();
  recurringAmountController.clear();
  goalNameController.clear();
}

Future<void> showAddTrackerModal(
    BuildContext context, Budget? budget, WidgetRef ref) async {
  final categoryFocusNode = FocusNode();
  final frequencyFocusNode = FocusNode();
  final amountFocusNode = FocusNode();
  final amountOutstandingFocusNode = FocusNode();
  final interestFocusNode = FocusNode();
  final trackerFocusNode = FocusNode();
  final recurringAmountFocusNode = FocusNode();
  final customGoalNameFocusNode = FocusNode();

  final necessaryCategories = budget?.necessaryExpense ?? {};
  final discretionaryCategories = budget?.discretionaryExpense ?? {};
  final debtCategories = budget?.debtExpense ?? {};

  final goalState = ref.watch(goalTrackerProvider);
  final debtState = ref.watch(debtTrackerProvider);
  final customGoalState = ref.watch(customGoalTrackerProvider);

  final showErrorCategoryGoal = goalState.category.error;
  final showErrorAmountGoal = goalState.amount.error;
  final showErrorFrequencyGoal = goalState.frequency.error;
  final showErrorTrackerGoal = goalState.tracker.error;

  final showErrorCategoryCustomGoal = customGoalState.category.error;
  final showErrorAmountCustomGoal = customGoalState.amount.error;
  final showErrorFrequencyCustomGoal = customGoalState.frequency.error;
  final showErrorTrackerCustomGoal = customGoalState.tracker.error;
  final showErrorRecurringAmountCustomGoal =
      customGoalState.recurringAmount.error;

  final showErrorCategoryDebt = debtState.category.error;
  final showErrorAmountDebt = debtState.amount.error;
  final showErrorOutstandingDebt = debtState.outstanding.error;
  final showErrorInterestDebt = debtState.interest.error;
  final showErrorFrequencyDebt = debtState.frequency.error;
  final showErrorTrackerDebt = debtState.tracker.error;

  final goalController = ref.watch(goalTrackerProvider.notifier);
  final debtController = ref.watch(debtTrackerProvider.notifier);
  final customGoalController = ref.watch(customGoalTrackerProvider.notifier);

  Future<void> loadAndShowRewardedAd(
      BuildContext context, WidgetRef ref) async {
    RewardedAd? rewardedAd;
    await RewardedAd.load(
      adUnitId:
          'ca-app-pub-9181910622688491/9213189503', // Replace with your own AdUnitID
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('RewardedAd loaded: ${ad.adUnitId}');
          rewardedAd = ad;

          rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              // Perform the action after ad is completed
              // Generate insights here
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              print('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
            },
            onAdShowedFullScreenContent: (RewardedAd ad) {
              print('$ad onAdShowedFullScreenContent.');
            },
            onAdImpression: (RewardedAd ad) {
              print('$ad onAdImpression.');
            },
          );

          rewardedAd?.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              print(
                  '$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
              // You can also perform any action needed when the user earns a reward here
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
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

  amountController.text = (budget?.debtExpense?[selectedCategory]?.toString() ??
      budget?.discretionaryExpense?[selectedCategory]?.toString() ??
      budget?.necessaryExpense?[selectedCategory]?.toString() ??
      '');

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
          List<String> allCategories;

          if (trackerType == 'Debt') {
            allCategories = debtCategories.keys.toList();
          } else if (trackerType == 'Goal') {
            allCategories = [
              ...necessaryCategories.keys,
              ...discretionaryCategories.keys,
            ];
          } else {
            allCategories = [
              ...necessaryCategories.keys,
              ...discretionaryCategories.keys,
              ...debtCategories.keys,
            ];
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
                                            color: ColorConstant.blueGray800,
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
                                                  : trackerType == "Custom Goal"
                                                      ? customGoalState.category
                                                                      .error !=
                                                                  null &&
                                                              trackerFocusNode
                                                                  .hasFocus
                                                          ? Tracker.showTrackerErrorMessage(
                                                                  showErrorTrackerCustomGoal)
                                                              .toString()
                                                          : null
                                                      : debtState.category
                                                                      .error !=
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
                                              // 'Custom Goal'
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
                                              if (trackerType == 'Goal') {
                                                goalController
                                                    .onTrackerTypeChange(
                                                        newValue ?? '');
                                              } else if (trackerType ==
                                                  'Debt') {
                                                debtController
                                                    .onTrackerTypeChange(
                                                        newValue ?? '');
                                              } else if (trackerType ==
                                                  'Custom Goal') {
                                                customGoalController
                                                    .onTrackerTypeChange(
                                                        newValue ?? '');
                                              }
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
                                                  ? goalState.amount.error !=
                                                              null &&
                                                          frequencyFocusNode
                                                              .hasFocus
                                                      ? Frequency.showFrequencyErrorMessage(
                                                              showErrorFrequencyGoal)
                                                          .toString()
                                                      : null
                                                  : trackerType == "Custom Goal"
                                                      ? customGoalState.amount
                                                                      .error !=
                                                                  null &&
                                                              frequencyFocusNode
                                                                  .hasFocus
                                                          ? Frequency.showFrequencyErrorMessage(
                                                                  showErrorFrequencyCustomGoal)
                                                              .toString()
                                                          : null
                                                      : debtState.amount
                                                                      .error !=
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
                                              if (trackerType == 'Goal') {
                                                goalController
                                                    .onFrequencyChange(
                                                        newValue ?? '');
                                              } else if (trackerType ==
                                                  'Debt') {
                                                debtController
                                                    .onFrequencyChange(
                                                        newValue ?? '');
                                              } else if (trackerType ==
                                                  'Custom Goal') {
                                                customGoalController
                                                    .onFrequencyChange(
                                                        newValue ?? '');
                                              }
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
                                      final customGoalState =
                                          ref.watch(customGoalTrackerProvider);
                                      final bool isValidatedGoal =
                                          goalState.status.isValidated;
                                      final bool isValidatedDebt =
                                          debtState.status.isValidated;
                                      final bool isValidatedCustomGoal =
                                          customGoalState.status.isValidated;

                                      void submitForm(BuildContext context,
                                          WidgetRef ref) async {
                                        final goals =
                                            await ref.watch(goalsProvider);
                                        final debts =
                                            await ref.watch(debtsProvider);
                                        int trackersCount =
                                            goals.length + debts.length;

                                        print('trackersCount: $trackersCount');
                                        if (trackerType == 'Goal') {
                                          if (isValidatedGoal) {
                                            Map<String, dynamic> goalData = {
                                              'category': selectedCategory,
                                              'frequency': frequencyType,
                                              'amount': double.tryParse(
                                                      amountController.text
                                                          .replaceAll(
                                                              ',', '')) ??
                                                  0.0,
                                            };

                                            String budgetId = budget!.budgetId;
                                            print('budgetId: $budgetId');
                                            print('goalData: $goalData');

                                            if (trackersCount > 2) {
                                              Map<String, dynamic>
                                                  subscriptionInfo =
                                                  await getSubscriptionInfo();
                                              bool isSubscribed =
                                                  subscriptionInfo[
                                                      'isSubscribed'];

                                              if (!isSubscribed) {
                                                await showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                      dialogContext) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Watch an ad to add more trackers',
                                                          style: AppStyle
                                                              .txtManropeRegular14
                                                              .copyWith(
                                                                  color: ColorConstant
                                                                      .blueGray500,
                                                                  letterSpacing:
                                                                      0.2)),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('OK',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          0.2,
                                                                      color: ColorConstant
                                                                          .blueA700)),
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    dialogContext)
                                                                .pop();
                                                            await loadAndShowRewardedAd(
                                                                context, ref);

                                                            // Add the code to add trackers here
                                                            await goalController
                                                                .addGoalToBudget(
                                                                    budgetId,
                                                                    goalData,
                                                                    ref);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Cancel',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14
                                                                  .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray800,
                                                                      letterSpacing:
                                                                          0.2)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    dialogContext)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                // Add the code to add trackers here for subscribed users
                                                await goalController
                                                    .addGoalToBudget(budgetId,
                                                        goalData, ref);
                                                Navigator.pop(context);
                                              }
                                            } else {
                                              // Add the code to add trackers here for users with 2 or less trackers
                                              await goalController
                                                  .addGoalToBudget(
                                                      budgetId, goalData, ref);
                                              Navigator.pop(context);
                                            }
                                          }
                                        } else if (trackerType == 'Debt') {
                                          if (isValidatedDebt) {
                                            double amount = double.tryParse(
                                                    amountController.text
                                                        .replaceAll(',', '')) ??
                                                0.0;
                                            double outstanding = double.tryParse(
                                                    amountOustandingController
                                                        .text
                                                        .replaceAll(',', '')) ??
                                                0.0;
                                            double interest = double.tryParse(
                                                    interestController.text
                                                        .replaceAll(',', '')) ??
                                                0.0;

                                            int paymentFrequencyPerYear;

                                            switch (frequencyType) {
                                              case 'Weekly':
                                                paymentFrequencyPerYear = 52;
                                                break;
                                              case 'Bi-Weekly':
                                                paymentFrequencyPerYear = 26;
                                                break;
                                              case 'Monthly':
                                              default:
                                                paymentFrequencyPerYear = 12;
                                            }

                                            double periodicInterest =
                                                (outstanding *
                                                    (interest /
                                                        paymentFrequencyPerYear /
                                                        100));

                                            // Check if the payment is less than the monthly interest
                                            if (amount <= periodicInterest) {
                                              // Show AlertDialog with error message
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Invalid Input',
                                                        style: AppStyle
                                                            .txtHelveticaNowTextBold18),
                                                    content:
                                                        SingleChildScrollView(
                                                      // Use SingleChildScrollView if content may overflow
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              'The monthly payment entered is less than the monthly interest that would accrue on your loan balance. This would result in your loan balance increasing over time, rather than decreasing.',
                                                              style: AppStyle
                                                                  .txtManropeRegular14),
                                                          Text('',
                                                              style: AppStyle
                                                                  .txtManropeRegular14),
                                                          Text(
                                                              'Please adjust your values as follows:',
                                                              style: AppStyle
                                                                  .txtManropeRegular14),
                                                          Text('',
                                                              style: AppStyle
                                                                  .txtManropeRegular14),
                                                          Text(
                                                            '1. Increase your monthly/weekly or bi-weekly payment amount so that it exceeds the monthly interest charge which is \$${NumberFormat("#,##0.00", "en_US").format(periodicInterest)}',
                                                            style: AppStyle
                                                                .txtManropeRegular14,
                                                          ),
                                                          Text('',
                                                              style: AppStyle
                                                                  .txtManropeRegular14),
                                                          Text(
                                                              '2. Or, decrease the outstanding loan balance or the annual interest rate.',
                                                              style: AppStyle
                                                                  .txtManropeRegular14),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text('Close',
                                                            style: AppStyle
                                                                .txtHelveticaNowTextBold14),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              return;
                                            }
                                            Map<String, dynamic> debtData = {
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
                                                      interestController.text
                                                          .replaceAll(
                                                              ',', '')) ??
                                                  0.0,
                                            };
                                            String budgetId = budget!.budgetId;
                                            print('budgetId: $budgetId');
                                            print('debtData: $debtData');

                                            if (trackersCount > 2) {
                                              Map<String, dynamic>
                                                  subscriptionInfo =
                                                  await getSubscriptionInfo();
                                              bool isSubscribed =
                                                  subscriptionInfo[
                                                      'isSubscribed'];

                                              if (!isSubscribed) {
                                                await showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                      dialogContext) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Watch an ad to add more trackers',
                                                          style: AppStyle
                                                              .txtManropeRegular14
                                                              .copyWith(
                                                                  color: ColorConstant
                                                                      .blueGray500,
                                                                  letterSpacing:
                                                                      0.2)),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('OK',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          0.2,
                                                                      color: ColorConstant
                                                                          .blueA700)),
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    dialogContext)
                                                                .pop();
                                                            await loadAndShowRewardedAd(
                                                                context, ref);

                                                            // Add the code to add trackers here
                                                            await debtController
                                                                .addDebtToBudget(
                                                                    budgetId,
                                                                    debtData,
                                                                    ref);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Cancel',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14
                                                                  .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray800,
                                                                      letterSpacing:
                                                                          0.2)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    dialogContext)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                // Add the code to add trackers here for subscribed users
                                                await debtController
                                                    .addDebtToBudget(budgetId,
                                                        debtData, ref);
                                                Navigator.pop(context);
                                              }
                                            } else {
                                              // Add the code to add trackers here for users with 2 or less trackers
                                              await debtController
                                                  .addDebtToBudget(
                                                      budgetId, debtData, ref);
                                              Navigator.pop(context);
                                            }
                                          }
                                        } else if (trackerType ==
                                            'Custom Goal') {
                                          if (isValidatedCustomGoal) {
                                            Map<String, dynamic>
                                                customGoalData = {
                                              'category': goalNameController
                                                  .text
                                                  .trim(),
                                              'frequency': frequencyType,
                                              'amount': double.tryParse(
                                                      amountController.text
                                                          .replaceAll(
                                                              ',', '')) ??
                                                  0.0,
                                              'recurringAmount': double.tryParse(
                                                      recurringAmountController
                                                          .text
                                                          .replaceAll(
                                                              ',', '')) ??
                                                  0.0,
                                            };
                                            String budgetId = budget!.budgetId;
                                            print('budgetId: $budgetId');
                                            print(
                                                'customGoalData: $customGoalData');

                                            if (trackersCount > 2) {
                                              Map<String, dynamic>
                                                  subscriptionInfo =
                                                  await getSubscriptionInfo();
                                              bool isSubscribed =
                                                  subscriptionInfo[
                                                      'isSubscribed'];

                                              if (!isSubscribed) {
                                                await showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                      dialogContext) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Watch an ad to add more trackers',
                                                          style: AppStyle
                                                              .txtManropeRegular14
                                                              .copyWith(
                                                                  color: ColorConstant
                                                                      .blueGray500,
                                                                  letterSpacing:
                                                                      0.2)),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('OK',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          0.2,
                                                                      color: ColorConstant
                                                                          .blueA700)),
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    dialogContext)
                                                                .pop();
                                                            await loadAndShowRewardedAd(
                                                                context, ref);

                                                            // Add the code to add trackers here
                                                            await customGoalController
                                                                .addGoalToBudget(
                                                                    budgetId,
                                                                    customGoalData,
                                                                    ref);
                                                            String
                                                                amountWithoutCommas =
                                                                recurringAmountController
                                                                    .text
                                                                    .replaceAll(
                                                                        ",",
                                                                        "");
                                                            double newAmount =
                                                                double.parse(
                                                                    amountWithoutCommas);
                                                            await customGoalController
                                                                .addCustomCategory(
                                                                    budgetId,
                                                                    goalNameController
                                                                        .text,
                                                                    newAmount);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Cancel',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14
                                                                  .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray800,
                                                                      letterSpacing:
                                                                          0.2)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    dialogContext)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                // Add the code to add trackers here for subscribed users
                                                await customGoalController
                                                    .addGoalToBudget(budgetId,
                                                        customGoalData, ref);
                                                String amountWithoutCommas =
                                                    recurringAmountController
                                                        .text
                                                        .replaceAll(",", "");
                                                double newAmount = double.parse(
                                                    amountWithoutCommas);
                                                await customGoalController
                                                    .addCustomCategory(
                                                        budgetId,
                                                        goalNameController.text,
                                                        newAmount);
                                                Navigator.pop(context);
                                              }
                                            } else {
                                              // Add the code to add trackers here for users with 2 or less trackers
                                              await customGoalController
                                                  .addGoalToBudget(budgetId,
                                                      customGoalData, ref);
                                              String amountWithoutCommas =
                                                  recurringAmountController.text
                                                      .replaceAll(",", "");
                                              double newAmount = double.parse(
                                                  amountWithoutCommas);
                                              await customGoalController
                                                  .addCustomCategory(
                                                      budgetId,
                                                      goalNameController.text,
                                                      newAmount);
                                              Navigator.pop(context);
                                            }
                                          }
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
                                            child: trackerType != 'Custom Goal'
                                                ? DropdownSearch<String>(
                                                    focusNode:
                                                        categoryFocusNode,
                                                    mode: Mode.BOTTOM_SHEET,
                                                    showSearchBox: true,
                                                    selectedItem:
                                                        selectedCategory,
                                                    dropdownBuilder: (context,
                                                        selectedItem) {
                                                      return Text(
                                                        selectedItem ??
                                                            "Select a category",
                                                        style: selectedItem ==
                                                                null
                                                            ? AppStyle
                                                                .txtHelveticaNowTextBold18
                                                                .copyWith(
                                                                color: ColorConstant
                                                                    .blueGray300, // Your desired color for "Select a category"
                                                              )
                                                            : AppStyle
                                                                .txtHelveticaNowTextBold18
                                                                .copyWith(
                                                                color:
                                                                    ColorConstant
                                                                        .black900,
                                                              ),
                                                      );
                                                    },
                                                    items: allCategories,
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        selectedCategory =
                                                            newValue;
                                                      });

                                                      // Fetch the category amount from the corresponding expense map
                                                      final categoryAmount = budget
                                                                  ?.debtExpense?[
                                                              newValue ?? ''] ??
                                                          budget?.discretionaryExpense?[
                                                              newValue ?? ''] ??
                                                          budget?.necessaryExpense?[
                                                              newValue ?? ''];

                                                      if (trackerType ==
                                                          'Goal') {
                                                        goalController
                                                            .onCategoryChange(
                                                                newValue ?? '');
                                                      } else if (trackerType ==
                                                          'Debt') {
                                                        debtController
                                                            .onCategoryChange(
                                                                newValue ?? '');

                                                        debtController
                                                            .onAmountChange(
                                                                categoryAmount
                                                                        ?.toString() ??
                                                                    '');

                                                        final formatCurrency =
                                                            NumberFormat(
                                                                "#,##0.00",
                                                                "en_US");
                                                        amountController.text =
                                                            categoryAmount !=
                                                                    null
                                                                ? formatCurrency
                                                                    .format(
                                                                        categoryAmount)
                                                                : '';
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
                                                        color: ColorConstant
                                                            .blueGray800,
                                                      ),
                                                      fillColor:
                                                          Colors.transparent,
                                                      filled: true,
                                                      border: InputBorder.none,
                                                      errorText: trackerType ==
                                                              "Goal"
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
                                                              color:
                                                                  ColorConstant
                                                                      .redA700),
                                                    ),
                                                    popupItemBuilder: (context,
                                                        item, isSelected) {
                                                      return Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
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
                                                                color:
                                                                    ColorConstant
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
                                                  )
                                                : TextField(
                                                    controller:
                                                        goalNameController,
                                                    focusNode:
                                                        customGoalNameFocusNode,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Custom Goal Name',
                                                      labelStyle: AppStyle
                                                          .txtHelveticaNowTextBold14
                                                          .copyWith(
                                                        color: ColorConstant
                                                            .blueGray800,
                                                      ),
                                                      fillColor:
                                                          Colors.transparent,
                                                      filled: true,
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
                                                      errorText: customGoalState
                                                                      .category
                                                                      .error !=
                                                                  null &&
                                                              customGoalNameFocusNode
                                                                  .hasFocus
                                                          ? Category
                                                              .showCategoryErrorMessage(
                                                                  showErrorCategoryCustomGoal)
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
                                                    onChanged: (category) {
                                                      customGoalController
                                                          .onCategoryChange(
                                                              category);
                                                      // print(category);
                                                    },
                                                  ),
                                          ),
                                          SizedBox(height: 16),
                                          TextField(
                                            onSubmitted: (_) {
                                              submitForm(context, ref);
                                            },
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
                                              if (trackerType == 'Goal') {
                                                goalController
                                                    .onAmountChange(amount);
                                              } else if (trackerType ==
                                                  'Debt') {
                                                debtController
                                                    .onAmountChange(amount);
                                              } else if (trackerType ==
                                                  'Custom Goal') {
                                                customGoalController
                                                    .onAmountChange(amount);
                                              }
                                            },
                                            decoration: InputDecoration(
                                              labelText: () {
                                                if (trackerType != 'Debt') {
                                                  return 'Total Amount of Goal';
                                                }

                                                if (frequencyType ==
                                                    'Monthly') {
                                                  return 'Monthly Payment';
                                                } else if (frequencyType ==
                                                    'Weekly') {
                                                  return 'Weekly Payment';
                                                } else if (frequencyType ==
                                                    'Bi-Weekly') {
                                                  return 'Bi-Weekly Payment';
                                                } else {
                                                  return 'Payment'; // Fallback for any other frequency types
                                                }
                                              }(),
                                              labelStyle: AppStyle
                                                  .txtHelveticaNowTextBold14
                                                  .copyWith(
                                                color:
                                                    ColorConstant.blueGray800,
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
                                                  ? goalState.amount.error !=
                                                              null &&
                                                          amountFocusNode
                                                              .hasFocus
                                                      ? Amount.showAmountErrorMessage(
                                                              showErrorAmountGoal)
                                                          .toString()
                                                      : null
                                                  : trackerType == "Custom Goal"
                                                      ? customGoalState.amount
                                                                      .error !=
                                                                  null &&
                                                              amountFocusNode
                                                                  .hasFocus
                                                          ? Amount.showAmountErrorMessage(
                                                                  showErrorAmountCustomGoal)
                                                              .toString()
                                                          : null
                                                      : debtState.amount
                                                                      .error !=
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
                                                    focusNode:
                                                        amountOutstandingFocusNode,
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    inputFormatters: [
                                                      ThousandsFormatter(),
                                                    ],
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Current Loan Balance',
                                                      labelStyle: AppStyle
                                                          .txtHelveticaNowTextBold14
                                                          .copyWith(
                                                        color: ColorConstant
                                                            .blueGray800,
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
                                                                      .outstanding
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
                                                    onSubmitted: (_) {
                                                      submitForm(context, ref);
                                                    },
                                                    controller:
                                                        interestController,
                                                    focusNode:
                                                        interestFocusNode,
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Ann. Interest Rate',
                                                      labelStyle: AppStyle
                                                          .txtHelveticaNowTextBold14
                                                          .copyWith(
                                                        color: ColorConstant
                                                            .blueGray800,
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
                                                                      .interest
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
                                          if (trackerType == 'Custom Goal')
                                            TextField(
                                              onSubmitted: (_) {
                                                submitForm(context, ref);
                                              },
                                              controller:
                                                  recurringAmountController,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              inputFormatters: [
                                                ThousandsFormatter(),
                                              ],
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Reccuring Savings Amount',
                                                labelStyle: AppStyle
                                                    .txtHelveticaNowTextBold14
                                                    .copyWith(
                                                  color:
                                                      ColorConstant.blueGray800,
                                                ),
                                                prefixText: '\$ ',
                                                prefixStyle: AppStyle
                                                    .txtHelveticaNowTextBold24
                                                    .copyWith(
                                                  color:
                                                      ColorConstant.blue90001,
                                                ),
                                                fillColor: Colors.transparent,
                                                filled: true,
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
                                                errorText: customGoalState
                                                                .recurringAmount
                                                                .error !=
                                                            null &&
                                                        recurringAmountFocusNode
                                                            .hasFocus
                                                    ? Amount.showAmountErrorMessage(
                                                        showErrorRecurringAmountCustomGoal)
                                                    : null,
                                                errorStyle: AppStyle
                                                    .txtManropeRegular12
                                                    .copyWith(
                                                        color: ColorConstant
                                                            .redA700),
                                              ),
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold24
                                                  .copyWith(
                                                color: ColorConstant.blue90001,
                                              ),
                                              onChanged: (amount) {
                                                customGoalController
                                                    .onRecurringAmountChange(
                                                        amount);
                                                // print(amount);
                                              },
                                            ),
                                          SizedBox(height: 16),
                                          CustomButtonForm(
                                            onTap: () {
                                              submitForm(context, ref);
                                            },
                                            alignment: Alignment.bottomCenter,
                                            height: getVerticalSize(56),
                                            text: "Create Tracker",
                                            enabled: trackerType == "Goal"
                                                ? isValidatedGoal
                                                : trackerType == "Custom Goal"
                                                    ? isValidatedCustomGoal
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
  print('selectedCategory BEFORE: $selectedCategory');
  print('frequencyType BEFORE: $frequencyType');
  print('trackerType BEFORE: $trackerType');
  print('amount BEFORE: ${amountController.text}');
  print('amountOutstanding BEFORE: ${amountOustandingController.text}');
  print('interest BEFORE: ${interestController.text}');
  print('recurringAmount BEFORE: ${recurringAmountController.text}');
  print('goal name BEFORE: ${goalNameController.text}');
  resetControllers();
  ref.read(goalTrackerProvider.notifier).reset();
  ref.read(debtTrackerProvider.notifier).reset();
  ref.read(customGoalTrackerProvider.notifier).reset();
  print('selectedCategory: $selectedCategory');
  print('frequencyType: $frequencyType');
  print('trackerType: $trackerType');
  print('amount: ${amountController.text}');
  print('amountOutstanding: ${amountOustandingController.text}');
  print('interest: ${interestController.text}');
  print('recurringAmount: ${recurringAmountController.text}');
  print('goal name: ${goalNameController.text}');
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
