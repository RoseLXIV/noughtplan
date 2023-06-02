import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/budget/providers/interstitial_ads_class_provider.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/call_chat_gpt_highlights.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/debts_provider.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/goals_provider.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/spending_type_progress_bar.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/selected_budget_id.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/user_types_bugdet_widget.dart';
import 'package:noughtplan/presentation/expense_tracking_screen/actual_expenses_provider.dart';
import 'package:noughtplan/widgets/custom_button_form.dart';
import 'package:http/http.dart' as http;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

import '../allocate_funds_screen/allocate_funds_screen.dart';
import '../budget_screen/widgets/listchart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:fl_chart/fl_chart.dart';

import 'widgets/add_tracker_modal.dart';
import 'widgets/debts_lists_widget.dart';
import 'widgets/goals_lists_widget.dart';

final buttonStateProvider =
    StateNotifierProvider.family<ButtonState, ButtonData, String>(
        (ref, budgetId) {
  return ButtonState(budgetId);
});

class ButtonState extends StateNotifier<ButtonData> {
  final String budgetId;

  ButtonState(this.budgetId) : super(ButtonData(enabled: true, timerText: ''));

  void update({required bool enabled, required String timerText}) {
    state = ButtonData(enabled: enabled, timerText: timerText);
  }
}

class ButtonData {
  final bool enabled;
  final String timerText;

  ButtonData({required this.enabled, required this.timerText});
}

class InsightsNotifier extends StateNotifier<InsightsState> {
  InsightsNotifier() : super(InsightsState());

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setDataList(List<InsightItem> dataList) {
    state = state.copyWith(dataList: dataList);
  }

  void clearTimer() {
    state.timer?.cancel();
    state = state.copyWith(timer: null);
  }

  void setTimer(Timer timer) {
    clearTimer();
    state = state.copyWith(timer: timer);
  }
}

class InsightsState {
  final bool isLoading;
  final List<InsightItem> dataList;
  final Timer? timer;

  InsightsState({
    this.isLoading = false,
    this.dataList = const [],
    this.timer,
  });

  InsightsState copyWith({
    bool? isLoading,
    List<InsightItem>? dataList,
    Timer? timer,
  }) {
    return InsightsState(
      isLoading: isLoading ?? this.isLoading,
      dataList: dataList ?? this.dataList,
      timer: timer ?? this.timer,
    );
  }
}

class InsightItem {
  final String iconPath;
  final String content;
  final String budgetId;

  InsightItem({
    required this.iconPath,
    required this.content,
    required this.budgetId,
  });

  factory InsightItem.fromJson(Map<String, dynamic> json) {
    return InsightItem(
      iconPath: json['iconPath'] as String,
      content: json['content'] as String,
      budgetId: json['budgetId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iconPath': iconPath,
      'content': content,
      'budgetId': budgetId,
    };
  }
}

final insightsNotifierProvider =
    StateNotifierProvider<InsightsNotifier, InsightsState>(
        (ref) => InsightsNotifier());

class BudgetScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final isLoading = ValueNotifier<bool>(false);
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Budget selectedBudget = args['budget'];
    final String firstName = args['firstName'];

    final budgetNotifier = ref.watch(budgetStateProvider.notifier);

    final _budgets = useState<List<Budget?>?>(null);
    Budget? _updatedSelectedBudget;

    final String budgetId = selectedBudget.budgetId;
    print('Budget Id: $budgetId');

    final totalExpenses = selectedBudget.salary;

    final numberFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    Map<String, double> getTotalAmountPerCategory(
        List<Map<String, dynamic>> actualExpenses) {
      Map<String, double> totalAmountPerCategory = {};

      DateTime today = DateTime.now();

      actualExpenses.forEach((expense) {
        final expenseDate = DateTime.parse(expense['date'] as String);
        if (expenseDate.isAfter(today)) {
          return; // skip this expense if its date is greater than today
        }

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
        getTotalAmountPerCategory(selectedBudget.actualExpenses);

    if (_budgets.value != null) {
      // Future.microtask(() async {
      final updatedSelectedBudget = _budgets.value!.firstWhere(
        (budget) => budget?.budgetId == selectedBudget.budgetId,
        orElse: () => null,
      );

      _updatedSelectedBudget = updatedSelectedBudget;

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

    Map<String, double> totalAmountsWithIncome =
        getTotalAmountPerCategory(_updatedSelectedBudget?.actualExpenses ?? []);

    double totalIncome = 0;
    if (totalAmountsWithIncome.containsKey('Income')) {
      totalIncome = totalAmountsWithIncome['Income']!;
    }

    print('totalAmountsWithIncome $totalAmountsWithIncome');

    String totalRemainingFundsFormatted = '';

    double getTotalAmountsSum(Map<String, double> totalAmounts) {
      double sum = 0;
      totalAmounts.values.forEach((value) {
        sum += value;
      });
      return sum;
    }

    double totalExpensesSum =
        getTotalAmountsSum(totalAmountsWithIncome) - totalIncome;
    double totalRemainingFunds = totalExpenses + totalIncome - totalExpensesSum;
    totalRemainingFundsFormatted = numberFormat.format(totalRemainingFunds);

    // print('Total Amounts: $totalAmounts');
    print('Updated Selected Budget Goals: ${_updatedSelectedBudget?.goals}');
    print('Updated Selected Budget Debts: ${_updatedSelectedBudget?.debts}');

    void updateExpensesOnLoad() {
      Future.microtask(
        () async {
          final fetchedBudgets = await budgetNotifier.fetchUserBudgets();
          if (context.mounted) {
            _budgets.value = fetchedBudgets;
          }

          if (_budgets.value != null) {
            final updatedSelectedBudget = _budgets.value!.firstWhere(
              (budget) => budget?.budgetId == selectedBudget.budgetId,
              orElse: () => null,
            );

            if (updatedSelectedBudget != null) {
              // Update the selectedBudgetIdProvider with the budgetId of the updatedSelectedBudget
              ref.read(selectedBudgetIdProvider.notifier).state =
                  updatedSelectedBudget.budgetId;

              // print(
              //     'Setting the selected budget id to: ${updatedSelectedBudget.budgetId}');

              final actualExpensesNotifier =
                  await ref.read(actualExpensesProvider.notifier);
              actualExpensesNotifier
                  .updateActualExpenses(updatedSelectedBudget.actualExpenses);

              // totalAmounts = calculateTotalAmounts(updatedSelectedBudget);
            }
          }
        },
      );
    }

    ValueNotifier<bool> buttonEnabled = ValueNotifier<bool>(true);
    ValueNotifier<String> remainingTime = ValueNotifier<String>('');

    Future<List<String>> fetchGPTDataMonthlyHightlights() async {
      if (_updatedSelectedBudget != null) {
        List<String> highlights =
            await getHighlights(_updatedSelectedBudget, firstName);

        // print('Highlights: $highlights');
        return highlights;
      }
      return [];
    }

    Future<List<String>> fetchGPTDataMonthlySuggestions() async {
      if (_updatedSelectedBudget != null) {
        List<String> suggestions =
            await getSuggestions(_updatedSelectedBudget, firstName);

        // print('Suggestions: $suggestions');
        return suggestions;
      }
      return [];
    }

    Future<DateTime> fetchServerTime() async {
      final response =
          await http.get(Uri.parse('http://worldtimeapi.org/api/ip'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        DateTime serverTime = DateTime.parse(data['datetime']);
        return serverTime;
      } else {
        throw Exception('Failed to fetch server time');
      }
    }

    Future<void> saveEndTime(String budgetId, int endTime) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('endTime_$budgetId', endTime);
    }

    Future<int?> loadEndTime(String budgetId) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt('endTime_$budgetId');
    }

    void startTimer(String budgetId, int duration) {
      Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (duration < 1000) {
          timer.cancel();
          buttonEnabled.value = true;
        } else {
          duration -= 1000;
          int days = duration ~/ Duration.millisecondsPerDay;
          int hours = duration %
              Duration.millisecondsPerDay ~/
              Duration.millisecondsPerHour;
          int minutes = duration %
              Duration.millisecondsPerHour ~/
              Duration.millisecondsPerMinute;
          int seconds = duration %
              Duration.millisecondsPerMinute ~/
              Duration.millisecondsPerSecond;
          remainingTime.value =
              '$days days, $hours hours, $minutes minutes, $seconds seconds';
        }
      });
    }

    Future<int?> checkTimerStatus() async {
      int? savedEndTime = await loadEndTime(budgetId);
      if (savedEndTime != null) {
        int currentTime = DateTime.now().millisecondsSinceEpoch;
        if (currentTime >= savedEndTime) {
          buttonEnabled.value = true;
          return null;
        } else {
          buttonEnabled.value = false;
          int remainingDuration = savedEndTime - currentTime;
          startTimer(budgetId, remainingDuration);
          return remainingDuration;
        }
      } else {
        buttonEnabled.value = true;
        return null;
      }
    }

    Future<void> saveListData(
        String budgetId, List<InsightItem> listData) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String listDataJson =
          jsonEncode(listData.map((item) => item.toJson()).toList());

      await prefs.setString('listData_$budgetId', listDataJson);
    }

    Future<void> fetchDataAndShuffleList(String budgetId) async {
      buttonEnabled.value = false;
      ref.read(insightsNotifierProvider.notifier).setLoading(true);
      List<String> highlights = await fetchGPTDataMonthlyHightlights();
      List<String> suggestions = await fetchGPTDataMonthlySuggestions();
      List<InsightItem> combinedList = [
        ...highlights.map((highlight) => InsightItem(
            content: highlight,
            iconPath: 'assets/images/star.png',
            budgetId: budgetId)),
        ...suggestions.map((suggestion) => InsightItem(
            content: suggestion,
            iconPath: 'assets/images/bulb.png',
            budgetId: budgetId)),
      ];
      List<InsightItem> specialItems = combinedList
          .where((item) =>
              item.content.contains("Overall") ||
              item.content.contains("Finally") ||
              item.content.contains("Lastly"))
          .toList();

      // Remove the special items from the combined list
      combinedList.removeWhere((item) => specialItems.contains(item));

      // Shuffle the remaining items
      combinedList.shuffle();

      // Add the special items back to the end of the list
      combinedList.addAll(specialItems);
      ref.read(insightsNotifierProvider.notifier).setDataList(combinedList);

      await saveListData(budgetId, combinedList);
      ref.read(insightsNotifierProvider.notifier).setLoading(false);
    }

    Future<List<InsightItem>?> loadListData(String budgetId) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? listDataJson = prefs.getString('listData_$budgetId');
      if (listDataJson != null) {
        List<dynamic> listDataMap = jsonDecode(listDataJson);
        List<InsightItem> listData = listDataMap
            .map((item) => InsightItem.fromJson(item as Map<String, dynamic>))
            .where((item) => item.budgetId != null && item.budgetId == budgetId)
            .toList();
        return listData;
      }
      return null;
    }

    void updateTimerText(int remainingDuration) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        remainingDuration -= 1000;

        int days = remainingDuration ~/ Duration.millisecondsPerDay;
        int hours = remainingDuration %
            Duration.millisecondsPerDay ~/
            Duration.millisecondsPerHour;
        int minutes = remainingDuration %
            Duration.millisecondsPerHour ~/
            Duration.millisecondsPerMinute;
        int seconds = remainingDuration %
            Duration.millisecondsPerMinute ~/
            Duration.millisecondsPerSecond;

        String timerText =
            "${days} Days ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

        if (remainingDuration <= 0) {
          if (context.mounted) {
            timer.cancel();
            ref
                .read(buttonStateProvider(budgetId).notifier)
                .update(enabled: true, timerText: '');
          }
        } else {
          if (context.mounted) {
            ref
                .read(buttonStateProvider(budgetId).notifier)
                .update(enabled: false, timerText: timerText);
          }
        }
      });
    }

    useEffect(() {
      updateExpensesOnLoad();

      loadListData(selectedBudget.budgetId).then((listData) {
        if (listData != null) {
          ref.read(insightsNotifierProvider.notifier).setDataList(listData);
        }
      });
      checkTimerStatus().then((remainingDuration) {
        if (remainingDuration != null && remainingDuration > 0) {
          updateTimerText(remainingDuration);
        }
      });
      ref.read(goalsProvider.notifier).loadGoals(budgetId);
      ref.read(debtsProvider.notifier).loadDebts(budgetId);

      return () {}; // Clean-up function
    }, []);

    final Map<String, double> necessaryCategories =
        selectedBudget.necessaryExpense ?? {};
    final Map<String, double> discretionaryCategories =
        selectedBudget.discretionaryExpense ?? {};
    final Map<String, double> debtCategories = selectedBudget.debtExpense ?? {};

    final double necessaryTotal =
        necessaryCategories.values.fold(0, (a, b) => a + b);
    final double discretionaryTotal =
        discretionaryCategories.values.fold(0, (a, b) => a + b);
    final double debtTotal = debtCategories.values.fold(0, (a, b) => a + b);

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

    Future<Map<String, double>> _convertAndStoreTotals(String currency,
        double necessaryTotal, double discretionaryTotal) async {
      double necessaryTotalUSD = necessaryTotal;
      double discretionaryTotalUSD = discretionaryTotal;

      if (currency == 'JMD') {
        double exchangeRate = await fetchExchangeRate('JMD', 'USD');
        necessaryTotalUSD = necessaryTotal * exchangeRate;
        discretionaryTotalUSD = discretionaryTotal * exchangeRate;
      }

      return {
        'necessaryTotalUSD': necessaryTotalUSD,
        'discretionaryTotalUSD': discretionaryTotalUSD,
      };
    }

    final String necessaryTotalFormatted = numberFormat.format(necessaryTotal);
    final String discretionaryTotalFormatted =
        numberFormat.format(discretionaryTotal);
    final String debtTotalFormatted = numberFormat.format(debtTotal);
    final String totalExpensesFormatted = numberFormat.format(totalExpenses);

    final pieChartDataResult = _generatePieChartData(
        context, necessaryCategories, discretionaryCategories, debtCategories);
    final PieChartData pieChartData = pieChartDataResult['pieChartData'];
    final percentages = pieChartDataResult['percentages'];

    List<Map<String, String>> necessaryBudgetItems = [];
    List<Map<String, String>> discretionaryBudgetItems = [];
    List<Map<String, String>> debtBudgetItems = [];

    necessaryCategories.forEach((key, value) {
      necessaryBudgetItems.add({
        'category': key,
        'amount': numberFormat.format(value),
      });
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

    // print('Total Remaining Funds: $totalRemainingFundsFormatted');

    double calculateTotalSavings(Map<String, double>? necessaryExpenses) {
      if (necessaryExpenses == null) {
        return 0.0;
      }

      final Set<String> savingsCategories = {
        "Emergency Fund",
        "Retirement Savings",
        "Investments",
        "Education Savings",
        "Vacation Fund",
        "Down Payment",
        "Home Improvement Fund",
        "Home Equity Loan",
        "Debt Payoff",
        "Wedding Fund",
        "Vehicle Savings",
        "General Savings",
        "Surplus",
      };

      double totalSavings = 0.0;

      necessaryExpenses.forEach((key, value) {
        if (savingsCategories.contains(key) ||
            key.contains("Savings") ||
            key.contains("Investment")) {
          totalSavings += value;
        }
      });

      return totalSavings;
    }

    final double totalSavings =
        calculateTotalSavings(selectedBudget.necessaryExpense);

    String? _selectedCategory;
    String _explanation = '';

    Future<void> loadAndShowInterstitialAd(
        BuildContext context, WidgetRef ref) async {
      InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/8691691433',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                Navigator.pushNamed(context, '/generator_salary_screen_edit',
                    arguments: {'selectedBudget': _updatedSelectedBudget});
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent:
                  (InterstitialAd ad, AdError error) {
                print('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
            );
            ad.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
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

    final subscriptionInfoFuture = useMemoized(() => getSubscriptionInfo(), []);

//

    return WillPopScope(
      onWillPop: () async {
        // Prevent navigation if insights are loading.
        return !ref.read(insightsNotifierProvider).isLoading;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.whiteA700,
          body: Container(
            height: getVerticalSize(812),
            width: double.maxFinite,
            child: Stack(
              // alignment: Alignment.bottomCenter,
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
                SingleChildScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    padding: getPadding(bottom: 25),
                    child: Column(
                      children: [
                        Container(
                          height: getVerticalSize(
                            75,
                          ),
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
                                margin: getMargin(
                                  left: 17,
                                  top: 0,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/home_page_screen',
                                  );
                                },
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: getPadding(
                                        right: 17,
                                        top: 0,
                                      ),
                                      child: IconButton(
                                        icon: CustomImageView(
                                          svgPath: ImageConstant.imgEdit1,
                                          height: getSize(24),
                                          width: getSize(24),
                                        ),
                                        onPressed: () async {
                                          // Wrap your dialog with a FutureBuilder
                                          bool? isSubscribed =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (context) {
                                              return FutureBuilder<
                                                  Map<String, dynamic>>(
                                                future: subscriptionInfoFuture,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            Map<String,
                                                                dynamic>>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return SizedBox.shrink();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    print(snapshot.error);
                                                    return AlertDialog(
                                                      title: Text(
                                                          'An error occurred'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  false),
                                                          child: Text('Close'),
                                                        ),
                                                      ],
                                                    );
                                                  } else if (snapshot
                                                      .data!['isSubscribed']) {
                                                    // If user is subscribed, directly return true without showing the dialog
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Edit Your Budget',
                                                          style: AppStyle
                                                              .txtHelveticaNowTextBold18
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      0.2)),
                                                      content: Text(
                                                          'Would you like to edit your budget?',
                                                          style: AppStyle
                                                              .txtManropeRegular14
                                                              .copyWith(
                                                                  color: ColorConstant
                                                                      .blueGray500,
                                                                  letterSpacing:
                                                                      0.2)),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  false),
                                                          child: Text('Cancel',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14
                                                                  .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray800,
                                                                      letterSpacing:
                                                                          0.2)),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/generator_salary_screen_edit',
                                                                arguments: {
                                                                  'selectedBudget':
                                                                      _updatedSelectedBudget
                                                                });
                                                          },
                                                          child: Text('Confirm',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          0.2,
                                                                      color: ColorConstant
                                                                          .blueA700)),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    // User is not subscribed, show the dialog to watch ads
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Watch a quick ad to Edit your budget!',
                                                          style: AppStyle
                                                              .txtHelveticaNowTextBold18
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      0.2)),
                                                      content: Text(
                                                          'To update your budget, we kindly ask that you watch a brief ad. We really appreciate your support and understanding.',
                                                          style: AppStyle
                                                              .txtManropeRegular14
                                                              .copyWith(
                                                                  color: ColorConstant
                                                                      .blueGray500,
                                                                  letterSpacing:
                                                                      0.2)),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  false),
                                                          child: Text('Cancel',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14
                                                                  .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray800,
                                                                      letterSpacing:
                                                                          0.2)),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  true),
                                                          child: Text('Confirm',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          0.2,
                                                                      color: ColorConstant
                                                                          .blueA700)),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          );

                                          if (isSubscribed == true) {
                                            await loadAndShowInterstitialAd(
                                                context, ref);
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(
                                        right: 17,
                                        top: 0,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Budget Details',
                                                  textAlign: TextAlign.center,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold16,
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppStyle
                                                          .txtManropeRegular14,
                                                    ),
                                                    FutureBuilder(
                                                      future:
                                                          _convertAndStoreTotals(
                                                              selectedBudget
                                                                  .currency,
                                                              necessaryTotal,
                                                              discretionaryTotal),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  Map<String,
                                                                      double>>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return LinearProgressIndicator();
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        } else {
                                                          final necessaryTotalUSD =
                                                              snapshot.data![
                                                                      'necessaryTotalUSD'] ??
                                                                  0.0;
                                                          final discretionaryTotalUSD =
                                                              snapshot.data![
                                                                      'discretionaryTotalUSD'] ??
                                                                  0.0;

                                                          return SpendingTypeProgressBar(
                                                            totalNecessaryExpense:
                                                                necessaryTotalUSD,
                                                            totalDiscretionaryExpense:
                                                                discretionaryTotalUSD,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    Padding(
                                                      padding:
                                                          getPadding(top: 7),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Necessary\n Spender',
                                                            style: AppStyle
                                                                .txtManropeSemiBold10
                                                                .copyWith(
                                                              color: ColorConstant
                                                                  .blueGray800,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            softWrap: true,
                                                          ),
                                                          Text(
                                                            'Balanced\n Spender',
                                                            style: AppStyle
                                                                .txtManropeSemiBold10
                                                                .copyWith(
                                                              color: ColorConstant
                                                                  .blueGray800,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            softWrap: true,
                                                          ),
                                                          Text(
                                                            'Impulsive\n Spender',
                                                            style: AppStyle
                                                                .txtManropeSemiBold10
                                                                .copyWith(
                                                              color: ColorConstant
                                                                  .blueGray800,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            softWrap: true,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        SaverTypeProgressBar(
                                                          spendingType:
                                                              selectedBudget
                                                                  .spendingType, // replace with the actual spending type
                                                          savings:
                                                              totalSavings, // replace with the actual savings amount
                                                          salary: selectedBudget
                                                              .salary, // replace with the actual salary amount
                                                        ),
                                                        Padding(
                                                          padding: getPadding(
                                                              top: 7),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: getSavingsLabels(
                                                                selectedBudget
                                                                    .spendingType),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        DebtTypeProgressBar(
                                                          debt: debtTotal,
                                                          income: selectedBudget
                                                              .salary,
                                                        ),
                                                        Padding(
                                                          padding: getPadding(
                                                              top: 7),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Debt\nFree',
                                                                style: AppStyle
                                                                    .txtManropeSemiBold10
                                                                    .copyWith(
                                                                  color: ColorConstant
                                                                      .blueGray800,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                softWrap: true,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    getPadding(
                                                                        right:
                                                                            16),
                                                                child: Text(
                                                                  'Minimal\nDebt',
                                                                  style: AppStyle
                                                                      .txtManropeSemiBold10
                                                                      .copyWith(
                                                                    color: ColorConstant
                                                                        .blueGray800,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                  softWrap:
                                                                      true,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    getPadding(
                                                                        right:
                                                                            16),
                                                                child: Text(
                                                                  'Moderate\nDebt',
                                                                  style: AppStyle
                                                                      .txtManropeSemiBold10
                                                                      .copyWith(
                                                                    color: ColorConstant
                                                                        .blueGray800,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                  softWrap:
                                                                      true,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Danger\nZone',
                                                                style: AppStyle
                                                                    .txtManropeSemiBold10
                                                                    .copyWith(
                                                                  color: ColorConstant
                                                                      .blueGray800,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                softWrap: true,
                                                              ),
                                                              Text(
                                                                'High\nDebt',
                                                                style: AppStyle
                                                                    .txtManropeSemiBold10
                                                                    .copyWith(
                                                                  color: ColorConstant
                                                                      .blueGray800,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                softWrap: true,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
                                                          child:
                                                              StatefulBuilder(
                                                            builder: (BuildContext
                                                                    context,
                                                                StateSetter
                                                                    setState) {
                                                              List<
                                                                      DropdownMenuItem<
                                                                          String>>
                                                                  getCategoryItems() {
                                                                List<String>
                                                                    categories =
                                                                    [
                                                                  // Add your categories here (spendingType, savingType, and debtType)
                                                                  'Necessary Spender',
                                                                  'Balanced Spender',
                                                                  'Impulsive Spender',
                                                                  'Cautious',
                                                                  'Frugal',
                                                                  'Prudent Saver',
                                                                  'Limited Saver',
                                                                  'Strategic',
                                                                  'Balanced Saver',
                                                                  'Debt Free',
                                                                  'Minimal Debt',
                                                                  'Moderate Debt',
                                                                  'Danger Zone',
                                                                  'High Debt',
                                                                ];

                                                                return categories.map<
                                                                    DropdownMenuItem<
                                                                        String>>((String
                                                                    category) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        category,
                                                                    child: Text(
                                                                        category),
                                                                  );
                                                                }).toList();
                                                              }

                                                              void updateExplanation(
                                                                  String?
                                                                      category) {
                                                                String
                                                                    explanation =
                                                                    '';

                                                                // Update the explanation variable based on the selected category
                                                                // Add explanations for each category
                                                                switch (
                                                                    category) {
                                                                  case 'Necessary Spender':
                                                                    explanation =
                                                                        'A Necessary Spender is someone who primarily spends on essential expenses such as housing, utilities, food, and healthcare. They are cautious with their money and avoid unnecessary expenses.';
                                                                    break;
                                                                  case 'Balanced Spender':
                                                                    explanation =
                                                                        'A Balanced Spender is someone who manages their money well by covering essential expenses, saving for the future, and occasionally indulging in non-essential items or experiences. They maintain a healthy balance between needs and wants.';
                                                                    break;
                                                                  case 'Impulsive Spender':
                                                                    explanation =
                                                                        'An Impulsive Spender is someone who frequently makes unplanned purchases, often prioritizing immediate gratification over long-term financial goals. They may struggle with saving money and are more susceptible to impulse buys.';
                                                                    break;
                                                                  case 'Cautious':
                                                                    explanation =
                                                                        'A Cautious saver is someone who has some savings but has not yet reached a comfortable emergency fund. They may be working on increasing their savings to achieve financial security.';
                                                                    break;
                                                                  case 'Frugal':
                                                                    explanation =
                                                                        'A Frugal saver is someone who is very careful with their money and prioritizes saving over spending. They often have a substantial emergency fund and may also be saving for long-term goals like retirement or a down payment on a home.';
                                                                    break;
                                                                  case 'Prudent Saver':
                                                                    explanation =
                                                                        'A Prudent Saver is someone who consistently saves money and makes thoughtful decisions about their spending. They prioritize financial goals and have a strong safety net in case of emergencies.';
                                                                    break;
                                                                  case 'Limited Saver':
                                                                    explanation =
                                                                        'A Limited Saver is someone who saves some money but may struggle to consistently prioritize savings. They might have difficulty building an emergency fund or saving for long-term goals.';
                                                                    break;
                                                                  case 'Strategic':
                                                                    explanation =
                                                                        'A Strategic saver is someone who plans their savings and investments to achieve specific financial goals. They have a solid financial plan and allocate their money accordingly to maximize their financial potential.';
                                                                    break;
                                                                  case 'Balanced Saver':
                                                                    explanation =
                                                                        'A Balanced Saver is someone who saves a moderate amount of their income, focusing on both short-term and long-term financial goals. They maintain a balance between saving, investing, and spending on necessities and occasional wants.';
                                                                    break;
                                                                  case 'Debt Free':
                                                                    explanation =
                                                                        'Debt Free refers to a financial situation where an individual has no outstanding debts, such as credit card balances, student loans, or car loans. Being debt-free can provide financial flexibility and peace of mind.';
                                                                    break;
                                                                  case 'Minimal Debt':
                                                                    explanation =
                                                                        'Minimal Debt refers to a financial situation where an individual has a small amount of debt relative to their income and assets. This can make it easier to manage and pay off debts, as well as save and invest for the future.';
                                                                    break;
                                                                  case 'Moderate Debt':
                                                                    explanation =
                                                                        'Moderate Debt refers to a financial situation where an individual has a moderate amount of debt relative to their income and assets. This can make it more challenging to manage and pay off debts, as well as save and invest for the future.';
                                                                    break;
                                                                  case 'Danger Zone':
                                                                    explanation =
                                                                        'Danger Zone refers to a financial situation where an individual has a high amount of debt relative to their income and assets. This can create significant financial stress and make it difficult to manage debts, save, or invest. It may require a more aggressive debt repayment plan to regain financial stability.';
                                                                    break;
                                                                  case 'High Debt':
                                                                    explanation =
                                                                        'High Debt refers to a financial situation where an individual has an extremely high amount of debt relative to their income and assets. This can lead to severe financial strain and may necessitate drastic changes to spending habits or seeking professional help to regain control of their finances.';
                                                                    break;
                                                                  default:
                                                                    explanation =
                                                                        'Please select a category to see its explanation.';
                                                                }

                                                                setState(() {
                                                                  _explanation =
                                                                      explanation;
                                                                });
                                                              }

                                                              return Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                8),
                                                                    child: Text(
                                                                      'Use the dropdown below to learn more about each user category.',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: AppStyle
                                                                          .txtManropeSemiBold12
                                                                          .copyWith(
                                                                        color: ColorConstant
                                                                            .blueGray800,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                8),
                                                                    child: DropdownButton<
                                                                        String>(
                                                                      hint: Text(
                                                                          'Select a category'),
                                                                      style: AppStyle
                                                                          .txtManropeBold14
                                                                          .copyWith(
                                                                              color: ColorConstant.blueGray800),
                                                                      value:
                                                                          _selectedCategory,
                                                                      items:
                                                                          getCategoryItems(),
                                                                      onChanged:
                                                                          (String?
                                                                              newValue) {
                                                                        // print(
                                                                        //     newValue);
                                                                        setState(
                                                                            () {
                                                                          _selectedCategory =
                                                                              newValue;
                                                                        });
                                                                        updateExplanation(
                                                                            newValue);
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                8),
                                                                    child: Text(
                                                                      _explanation,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: AppStyle
                                                                          .txtManropeRegular12
                                                                          .copyWith(
                                                                        color: ColorConstant
                                                                            .blueGray800,
                                                                      ),
                                                                    ),
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
                        ),
                        Container(
                          child: Padding(
                            padding: getPadding(
                              top: 8,
                            ),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: getPadding(
                                  left: 30,
                                  right: 30,
                                  bottom: 1,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: getPadding(
                                        left: 0,
                                        right: 0,
                                      ),
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(20)),
                                          depth: 0.5,
                                          intensity: 2,
                                          surfaceIntensity: 0.8,
                                          lightSource: LightSource.top,
                                          color: ColorConstant.gray50,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            gradient: LinearGradient(
                                              colors: [
                                                getColorForSpendingType(
                                                    selectedBudget
                                                        .spendingType),
                                                getColorForSavingType(
                                                    selectedBudget.savingType),
                                                getColorForDebtType(
                                                    selectedBudget.debtType),
                                              ],
                                              stops: [0.0, 0.5, 1.0],
                                            ),
                                          ),
                                          height: 13,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: SpendingTypePill(
                                                    type: selectedBudget
                                                        .spendingType,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: SavingTypePill(
                                                    type: selectedBudget
                                                        .savingType,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: DebtTypePill(
                                                    type:
                                                        selectedBudget.debtType,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(top: 7),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(selectedBudget.spendingType,
                                              style: AppStyle
                                                  .txtManropeSemiBold12
                                                  .copyWith(
                                                color: getColorForSpendingType(
                                                    selectedBudget
                                                        .spendingType),
                                              )),
                                          Text(selectedBudget.savingType,
                                              style: AppStyle
                                                  .txtManropeSemiBold12
                                                  .copyWith(
                                                color: getColorForSavingType(
                                                    selectedBudget.savingType),
                                              )),
                                          Text(selectedBudget.debtType,
                                              style: AppStyle
                                                  .txtManropeSemiBold12
                                                  .copyWith(
                                                color: getColorForDebtType(
                                                    selectedBudget.debtType),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: getPadding(
                                        top: 20,
                                      ),
                                      width: double.maxFinite,
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          shape: NeumorphicShape.flat,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(20)),
                                          depth: 3,
                                          intensity: 0.5,
                                          lightSource: LightSource.topLeft,
                                          color: ColorConstant.gray50,
                                        ),
                                        child: Container(
                                          width: getHorizontalSize(
                                            327,
                                          ),
                                          padding: getPadding(
                                            left: 5,
                                            top: 30,
                                            right: 5,
                                            bottom: 15,
                                          ),
                                          decoration: AppDecoration
                                              .outlineGray100
                                              .copyWith(
                                            borderRadius: BorderRadiusStyle
                                                .roundedBorder12,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Neumorphic(
                                                style: NeumorphicStyle(
                                                  shape: NeumorphicShape.convex,
                                                  boxShape: NeumorphicBoxShape
                                                      .circle(),
                                                  depth: 1,
                                                  intensity: 0.7,
                                                  lightSource:
                                                      LightSource.topLeft,
                                                  color: ColorConstant.gray50,
                                                ),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.78, // 40% of screen width
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.78,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.46 /
                                                                2),
                                                  ), // 40% of screen width
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Neumorphic(
                                                          style:
                                                              NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .concave,
                                                            boxShape:
                                                                NeumorphicBoxShape
                                                                    .circle(),
                                                            depth: 20,
                                                            intensity: 0.5,
                                                            surfaceIntensity:
                                                                0.1,
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft,
                                                            color: ColorConstant
                                                                .gray100,
                                                          ),
                                                          child: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                1, // 30% of screen width
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                1,
                                                            child: PieChart(
                                                              pieChartData,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Neumorphic(
                                                          style:
                                                              NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .concave,
                                                            boxShape:
                                                                NeumorphicBoxShape
                                                                    .circle(),
                                                            depth: -1.5,
                                                            intensity: 0.70,
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft,
                                                            color: ColorConstant
                                                                .blue50,
                                                          ),
                                                          child: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.48, // 25% of screen width
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.48, // 25% of screen width
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius.circular(
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.46 /
                                                                      2), // half of width or height
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        getPadding(
                                                                      bottom:
                                                                          10,
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          '${percentages['necessary'].toStringAsFixed(0)} / ${percentages['discretionary'].toStringAsFixed(0)} / ${percentages['debt'].toStringAsFixed(0)}',
                                                                          style: AppStyle
                                                                              .txtHelveticaNowTextBold12
                                                                              .copyWith(
                                                                            color:
                                                                                ColorConstant.blueGray300,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: getPadding(
                                                                        bottom:
                                                                            3),
                                                                    child: Text(
                                                                      'Total Remaining Amount',
                                                                      style: AppStyle
                                                                          .txtManropeRegular10
                                                                          .copyWith(
                                                                        color: ColorConstant
                                                                            .blueGray300,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${totalRemainingFundsFormatted}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: AppStyle
                                                                        .txtHelveticaNowTextBold24
                                                                        .copyWith(
                                                                      color: ColorConstant
                                                                          .gray90001,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        getPadding(
                                                                            top:
                                                                                4),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          'of ',
                                                                          style: AppStyle
                                                                              .txtManropeSemiBold12
                                                                              .copyWith(
                                                                            color:
                                                                                ColorConstant.blueGray300,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                        Text(
                                                                          '${totalExpensesFormatted}',
                                                                          style: AppStyle
                                                                              .txtHelveticaNowTextBold12
                                                                              .copyWith(
                                                                            color:
                                                                                ColorConstant.blueGray300,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        getPadding(
                                                                            top:
                                                                                15),
                                                                  ),
                                                                  Text(
                                                                    'Created: ${DateFormat('MM/dd/yyyy').format(selectedBudget.budgetDate)}',
                                                                    style: AppStyle
                                                                        .txtManropeSemiBold12
                                                                        .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray300,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // Add your content or child widget here
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: getPadding(
                                                  // left: 6,
                                                  top: 22,
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Neumorphic(
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          boxShape: NeumorphicBoxShape
                                                              .roundRect(
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          depth: 1,
                                                          intensity: 0.7,
                                                          surfaceIntensity: 0.2,
                                                          lightSource:
                                                              LightSource.top,
                                                          color: ColorConstant
                                                              .whiteA700,
                                                        ),
                                                        child: Container(
                                                          width:
                                                              getHorizontalSize(
                                                            110,
                                                          ),
                                                          height: getSize(
                                                            40,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Neumorphic(
                                                                style:
                                                                    NeumorphicStyle(
                                                                  shape:
                                                                      NeumorphicShape
                                                                          .convex,
                                                                  boxShape: NeumorphicBoxShape.roundRect(
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                                  depth: 1,
                                                                  intensity:
                                                                      0.7,
                                                                  surfaceIntensity:
                                                                      0.6,
                                                                  lightSource:
                                                                      LightSource
                                                                          .top,
                                                                  color:
                                                                      ColorConstant
                                                                          .gray50,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      getSize(
                                                                    18,
                                                                  ),
                                                                  width:
                                                                      getSize(
                                                                    18,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFF1A237E),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      getHorizontalSize(
                                                                        2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    getPadding(
                                                                  left: 6,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Necessary",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtManropeBold11
                                                                          .copyWith(
                                                                        color: ColorConstant
                                                                            .blueGray9007f,
                                                                        letterSpacing:
                                                                            getHorizontalSize(
                                                                          0.3,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "${necessaryTotalFormatted}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtHelveticaNowTextBold12
                                                                          .copyWith(
                                                                        color: Color(
                                                                            0xFF1A237E),
                                                                        letterSpacing:
                                                                            getHorizontalSize(
                                                                          0.2,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Neumorphic(
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          boxShape: NeumorphicBoxShape
                                                              .roundRect(
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          depth: 1,
                                                          intensity: 0.7,
                                                          surfaceIntensity: 0.2,
                                                          lightSource:
                                                              LightSource.top,
                                                          color: ColorConstant
                                                              .whiteA700,
                                                        ),
                                                        child: Container(
                                                          width:
                                                              getHorizontalSize(
                                                            110,
                                                          ),
                                                          height: getSize(
                                                            40,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Neumorphic(
                                                                style:
                                                                    NeumorphicStyle(
                                                                  shape:
                                                                      NeumorphicShape
                                                                          .convex,
                                                                  boxShape: NeumorphicBoxShape.roundRect(
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                                  depth: 1,
                                                                  intensity:
                                                                      0.7,
                                                                  surfaceIntensity:
                                                                      0.6,
                                                                  lightSource:
                                                                      LightSource
                                                                          .top,
                                                                  color:
                                                                      ColorConstant
                                                                          .gray50,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      getSize(
                                                                    18,
                                                                  ),
                                                                  width:
                                                                      getSize(
                                                                    18,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFF1E90FF),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      getHorizontalSize(
                                                                        2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    getPadding(
                                                                  left: 6,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Discretionary",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtManropeBold11
                                                                          .copyWith(
                                                                        color: ColorConstant
                                                                            .blueGray9007f,
                                                                        letterSpacing:
                                                                            getHorizontalSize(
                                                                          0.3,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "${discretionaryTotalFormatted}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtHelveticaNowTextBold12
                                                                          .copyWith(
                                                                        color: Color(
                                                                            0xFF1E90FF),
                                                                        letterSpacing:
                                                                            getHorizontalSize(
                                                                          0.2,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Neumorphic(
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          boxShape: NeumorphicBoxShape
                                                              .roundRect(
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          depth: 1,
                                                          intensity: 0.7,
                                                          surfaceIntensity: 0.2,
                                                          lightSource:
                                                              LightSource.top,
                                                          color: ColorConstant
                                                              .whiteA700,
                                                        ),
                                                        child: Container(
                                                          width:
                                                              getHorizontalSize(
                                                            110,
                                                          ),
                                                          height: getSize(
                                                            40,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Neumorphic(
                                                                style:
                                                                    NeumorphicStyle(
                                                                  shape:
                                                                      NeumorphicShape
                                                                          .convex,
                                                                  boxShape: NeumorphicBoxShape.roundRect(
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                                  depth: 1,
                                                                  intensity:
                                                                      0.7,
                                                                  surfaceIntensity:
                                                                      0.6,
                                                                  lightSource:
                                                                      LightSource
                                                                          .top,
                                                                  color:
                                                                      ColorConstant
                                                                          .gray50,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      getSize(
                                                                    18,
                                                                  ),
                                                                  width:
                                                                      getSize(
                                                                    18,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ColorConstant
                                                                        .blueA700,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      getHorizontalSize(
                                                                        2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    getPadding(
                                                                  left: 6,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Debt/Loans",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtManropeBold11
                                                                          .copyWith(
                                                                        color: ColorConstant
                                                                            .blueGray9007f,
                                                                        letterSpacing:
                                                                            getHorizontalSize(
                                                                          0.3,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "${debtTotalFormatted}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtHelveticaNowTextBold12
                                                                          .copyWith(
                                                                        color: ColorConstant
                                                                            .blueA700,
                                                                        letterSpacing:
                                                                            getHorizontalSize(
                                                                          0.2,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(top: 24, bottom: 16),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Consumer(
                                                builder: (context, ref, _) {
                                              return FutureBuilder<
                                                  Map<String, dynamic>>(
                                                future: subscriptionInfoFuture,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            Map<String,
                                                                dynamic>>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return SizedBox.shrink();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    print(snapshot.error);
                                                    return Text(
                                                        'An error occurred');
                                                  } else {
                                                    bool isSubscribed = snapshot
                                                        .data!['isSubscribed'];
                                                    bool buttonEnabled = true;
                                                    return FutureBuilder<
                                                            Map<String,
                                                                dynamic>>(
                                                        future:
                                                            getSubscriptionInfo(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    Map<String,
                                                                        dynamic>>
                                                                snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return CircularProgressIndicator(); // Show loading indicator while waiting for getSubscriptionInfo
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                'Error: ${snapshot.error}');
                                                          } else {
                                                            bool isSubscribed =
                                                                snapshot.data![
                                                                    'isSubscribed'];
                                                            final goals =
                                                                ref.watch(
                                                                    goalsProvider);
                                                            final debts =
                                                                ref.watch(
                                                                    debtsProvider);
                                                            int trackersCount =
                                                                goals.length +
                                                                    debts
                                                                        .length;

                                                            if (isSubscribed) {
                                                              if (trackersCount >=
                                                                  10) {
                                                                buttonEnabled =
                                                                    false;
                                                              }
                                                            } else {
                                                              if (trackersCount >=
                                                                  6) {
                                                                buttonEnabled =
                                                                    false;
                                                              }
                                                            }
                                                            return CustomButtonForm(
                                                              onTap: () async {
                                                                showAddTrackerModal(
                                                                    context,
                                                                    selectedBudget,
                                                                    ref);
                                                              },
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              text:
                                                                  'Add a Tracker',
                                                              height:
                                                                  getVerticalSize(
                                                                      56),
                                                              enabled:
                                                                  buttonEnabled,
                                                            );
                                                          }
                                                        });
                                                  }
                                                },
                                              );
                                            }),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: getPadding(
                                                      left: 8,
                                                      right: 8,
                                                      top: 30,
                                                      bottom: 16),
                                                  child: Text(
                                                    "Goal Trackers",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtHelveticaNowTextBold16
                                                        .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                        0.4,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            StatefulBuilder(builder: (context,
                                                StateSetter setState) {
                                              return Consumer(
                                                builder: (context, ref, child) {
                                                  final goals =
                                                      ref.watch(goalsProvider);
                                                  final debts =
                                                      ref.watch(debtsProvider);

                                                  void _onDismissed(int index) {
                                                    if (goals.isNotEmpty &&
                                                        index >= 0 &&
                                                        index < goals.length) {
                                                      setState(() {
                                                        goals.removeAt(index);
                                                        print('Index: $index');
                                                      });
                                                    } else {
                                                      print(
                                                          'Invalid index: $index for goals list of length: ${goals.length}');
                                                    }
                                                  }

                                                  void _onDismissedDebt(
                                                      int index) {
                                                    if (debts.isNotEmpty &&
                                                        index >= 0 &&
                                                        index < debts.length) {
                                                      setState(() {
                                                        debts.removeAt(
                                                            debts.length -
                                                                1 -
                                                                index);
                                                        print('Index: $index');
                                                      });
                                                    } else {
                                                      print(
                                                          'Invalid index: $index for debts list of length: ${debts.length}');
                                                    }
                                                  }

                                                  print(
                                                      'Goals length: ${goals.length}');

                                                  print(
                                                      'Debts length: ${debts.length}');
                                                  return Column(
                                                    children: [
                                                      goals.length > 0
                                                          ? Padding(
                                                              padding:
                                                                  getPadding(
                                                                      bottom:
                                                                          16),
                                                              child: SizedBox(
                                                                height: 155,
                                                                child: ListView
                                                                    .separated(
                                                                  physics:
                                                                      BouncingScrollPhysics(),
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  separatorBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return SizedBox(
                                                                      width:
                                                                          getHorizontalSize(
                                                                              16),
                                                                    ); // Use width instead of height for a horizontal separator
                                                                  },
                                                                  itemCount: goals
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final goalData =
                                                                        goals[goals.length -
                                                                            1 -
                                                                            index];
                                                                    return Dismissible(
                                                                      key:
                                                                          UniqueKey(), // Change this to your unique identifier
                                                                      background:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          gradient:
                                                                              LinearGradient(
                                                                            colors: [
                                                                              Colors.transparent,
                                                                              ColorConstant.redA700
                                                                            ],
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end:
                                                                                Alignment.bottomCenter,
                                                                            stops: [
                                                                              0.15,
                                                                              1.0
                                                                            ],
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                getPadding(bottom: 16),
                                                                            child:
                                                                                CustomImageView(
                                                                              svgPath: ImageConstant.imgTrashNew,
                                                                              height: getSize(24),
                                                                              width: getSize(24),
                                                                              color: ColorConstant.whiteA700,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      direction:
                                                                          DismissDirection
                                                                              .up,
                                                                      confirmDismiss:
                                                                          (direction) async {
                                                                        return await showDialog<
                                                                            bool>(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: Text('Confirm Deletion', style: AppStyle.txtHelveticaNowTextBold18),
                                                                              content: Text('Are you sure you want to delete this Goal?', style: AppStyle.txtManropeRegular14),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.of(context).pop(false),
                                                                                  child: Text('Cancel', style: AppStyle.txtHelveticaNowTextBold14),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop(true);
                                                                                  },
                                                                                  child: Text('Delete',
                                                                                      style: AppStyle.txtHelveticaNowTextBold14.copyWith(
                                                                                        color: ColorConstant.redA700,
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      onDismissed:
                                                                          (direction) async {
                                                                        print(
                                                                            'Index on Dismiss: $index');
                                                                        int reversedIndex = goals.length -
                                                                            1 -
                                                                            index;

                                                                        if (reversedIndex >=
                                                                                0 &&
                                                                            reversedIndex <
                                                                                goals.length) {
                                                                          print(
                                                                              'Index in deleteGoal: $reversedIndex');

                                                                          await ref.read(budgetStateProvider.notifier).deleteGoal(
                                                                              budgetId,
                                                                              index,
                                                                              reversedIndex,
                                                                              ref);
                                                                          // _onDismissed(
                                                                          //     index);
                                                                          ref.read(goalsProvider.notifier).loadGoals(
                                                                              budgetId);
                                                                        } else {
                                                                          print(
                                                                              'Invalid index: $reversedIndex for goals list of length: ${goals.length}');
                                                                        }
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.75,
                                                                        child:
                                                                            GoalsListWidget(
                                                                          budget:
                                                                              _updatedSelectedBudget,
                                                                          goalData:
                                                                              goalData,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  getPadding(
                                                                      top: 0,
                                                                      bottom:
                                                                          16),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Neumorphic(
                                                                      style:
                                                                          NeumorphicStyle(
                                                                        shape: NeumorphicShape
                                                                            .convex,
                                                                        boxShape:
                                                                            NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                                                                        depth:
                                                                            0.1,
                                                                        intensity:
                                                                            1,
                                                                        surfaceIntensity:
                                                                            0.5,
                                                                        lightSource:
                                                                            LightSource.top,
                                                                        color: ColorConstant
                                                                            .gray50,
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            getVerticalSize(95),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              ColorConstant.gray100,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text("Press 'Add a Tracker' to get started!",
                                                                                  style: AppStyle.txtManropeBold12.copyWith(
                                                                                    color: ColorConstant.blueGray500,
                                                                                    letterSpacing: getHorizontalSize(1),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding: getPadding(
                                                                left: 8,
                                                                right: 8,
                                                                top: 0,
                                                                bottom: 16),
                                                            child: Text(
                                                              "Debt Trackers",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold16
                                                                  .copyWith(
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                  0.4,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      debts.length > 0
                                                          ? Padding(
                                                              padding:
                                                                  getPadding(
                                                                      bottom:
                                                                          16),
                                                              child: SizedBox(
                                                                height: 210,
                                                                child: ListView
                                                                    .separated(
                                                                  physics:
                                                                      BouncingScrollPhysics(),
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  separatorBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return SizedBox(
                                                                      width:
                                                                          getHorizontalSize(
                                                                              16),
                                                                    );
                                                                  },
                                                                  itemCount: debts
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final debtData =
                                                                        debts[debts.length -
                                                                            1 -
                                                                            index];
                                                                    return Dismissible(
                                                                      key:
                                                                          UniqueKey(),
                                                                      background:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          gradient:
                                                                              LinearGradient(
                                                                            colors: [
                                                                              Colors.transparent,
                                                                              ColorConstant.redA700
                                                                            ],
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end:
                                                                                Alignment.bottomCenter,
                                                                            stops: [
                                                                              0.15,
                                                                              1.0
                                                                            ],
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                getPadding(bottom: 16),
                                                                            child:
                                                                                CustomImageView(
                                                                              svgPath: ImageConstant.imgTrashNew,
                                                                              height: getSize(24),
                                                                              width: getSize(24),
                                                                              color: ColorConstant.whiteA700,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      direction:
                                                                          DismissDirection
                                                                              .up,
                                                                      confirmDismiss:
                                                                          (direction) async {
                                                                        return await showDialog<
                                                                            bool>(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: Text('Confirm Deletion', style: AppStyle.txtHelveticaNowTextBold18),
                                                                              content: Text('Are you sure you want to delete this Debt?', style: AppStyle.txtManropeRegular14),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.of(context).pop(false),
                                                                                  child: Text('Cancel', style: AppStyle.txtHelveticaNowTextBold14),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.of(context).pop(true),
                                                                                  child: Text('Delete',
                                                                                      style: AppStyle.txtHelveticaNowTextBold14.copyWith(
                                                                                        color: ColorConstant.redA700,
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      onDismissed:
                                                                          (direction) async {
                                                                        print(
                                                                            'Index on Dismiss: $index');
                                                                        int reversedIndex = debts.length -
                                                                            1 -
                                                                            index;

                                                                        if (reversedIndex >=
                                                                                0 &&
                                                                            reversedIndex <
                                                                                debts.length) {
                                                                          print(
                                                                              'Index in deleteDebt: $reversedIndex');

                                                                          await ref.read(budgetStateProvider.notifier).deleteDebt(
                                                                              budgetId,
                                                                              index,
                                                                              reversedIndex,
                                                                              ref);

                                                                          ref.read(debtsProvider.notifier).loadDebts(
                                                                              budgetId);
                                                                        } else {
                                                                          print(
                                                                              'Invalid index: $reversedIndex for debts list of length: ${debts.length}');
                                                                        }
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.84,
                                                                        child:
                                                                            DebtsListWidget(
                                                                          // Make sure to replace this with the appropriate Widget for showing a single Debt
                                                                          budget:
                                                                              _updatedSelectedBudget,
                                                                          debtData:
                                                                              debtData,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  getPadding(
                                                                      top: 0,
                                                                      bottom:
                                                                          16),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Neumorphic(
                                                                      style:
                                                                          NeumorphicStyle(
                                                                        shape: NeumorphicShape
                                                                            .convex,
                                                                        boxShape:
                                                                            NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                                                                        depth:
                                                                            0.1,
                                                                        intensity:
                                                                            1,
                                                                        surfaceIntensity:
                                                                            0.5,
                                                                        lightSource:
                                                                            LightSource.top,
                                                                        color: ColorConstant
                                                                            .gray50,
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            getVerticalSize(95),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              ColorConstant.gray100,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text("Press 'Add a Tracker' to get started!",
                                                                                  style: AppStyle.txtManropeBold12.copyWith(
                                                                                    color: ColorConstant.blueGray500,
                                                                                    letterSpacing: getHorizontalSize(1),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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

  Map<String, dynamic> _generatePieChartData(
    BuildContext context,
    Map<String, double> necessaryCategories,
    Map<String, double> discretionaryCategories,
    Map<String, double> debtCategories,
  ) {
    final List<Color> colors = [
      Color(0xFF1A237E), // Indigo 900
      Color(0xFF1E90FF), // Indigo 200
      ColorConstant.blueA700, // Blue 800
    ];

    final double necessaryTotal =
        necessaryCategories.values.fold(0, (a, b) => a + b);
    final double discretionaryTotal =
        discretionaryCategories.values.fold(0, (a, b) => a + b);
    final double debtTotal = debtCategories.values.fold(0, (a, b) => a + b);

    final double screenWidth = MediaQuery.of(context).size.width;

    final double responsiveRadius = screenWidth * 0.1; // 10% of screen width
    final double responsiveCenterSpaceRadius = screenWidth * 0.2659;

    final mainSections = {
      "Necessary": necessaryTotal,
      "Discretionary": discretionaryTotal,
      "Debt": debtTotal,
    };

    final double totalBudget = necessaryTotal + discretionaryTotal + debtTotal;

    final double necessaryPercentage = necessaryTotal / totalBudget * 100;
    final double discretionaryPercentage =
        discretionaryTotal / totalBudget * 100;
    final double debtPercentage = debtTotal / totalBudget * 100;

    int colorIndex = 0;

    final sections = mainSections.entries.map((entry) {
      final categoryColor = colors[colorIndex % colors.length];
      colorIndex++;

      return PieChartSectionData(
        color: categoryColor,
        value: entry.value,
        title: '',
        radius: responsiveRadius,
        titleStyle: TextStyle(color: Colors.white, fontSize: 12),
      );
    }).toList();

    return {
      'pieChartData': PieChartData(
        sections: sections,
        sectionsSpace: 0,
        centerSpaceRadius: responsiveCenterSpaceRadius,
        borderData: FlBorderData(show: true),
      ),
      'percentages': {
        'necessary': necessaryPercentage,
        'discretionary': discretionaryPercentage,
        'debt': debtPercentage,
      },
    };
  }
}
//

// Color(0xFF0D47A1), // Light Blue 900
// Color(0xFF42A5F5), // Light Blue 400
// Color(0xFF8B1E9B), // Bright Purple
// Color(0xFF4A61DC), // Bright Indigo
// Color.fromARGB(255, 28, 89, 83), // Turquoise
// Color(0xFF3CB371), // Medium Sea Green
// Color(0xFF32CD32), // Lime Green
// Color(0xFF9ACD32), // Yellow Green
// Color(0xFFFFD700), // Gold
// Color(0xFFFFA500), // Orange
// Color(0xFF7B68EE), // Medium Slate Blue
// Color(0xFF4682B4), // Steel Blue
// Color(0xFF00CED1), // Dark Turquoise
// Color(0xFF20B2AA), // Light Sea Green
// Color(0xFFADFF2F), // Green Yellow
// Color(0xFFFFD54F), // Light Yellow
// Color(0xFF8BC34A), // Light Green
// Color(0xFFCDDC39), // Lime
// Color(0xFFFFC107), // Amber
// Color(0xFFBA68C8), // Medium Orchid
// Color(0xFF7E57C2), // Deep Lavender
// Color(0xFF5C6BC0), // Light Blue
// Color(0xFF26A69A), // Medium Aquamarine
// Color(0xFF66BB6A), // Soft Green
// Color(0xFFD4E157), // Light Lime
// Color(0xFFFFB74D), // Light Orange
// Color(0xFF9575CD), // Light Purple
// Color(0xFF7986CB), // Soft Blue
// Color(0xFF4DB6AC), // Soft Green

class CustomListItem extends HookConsumerWidget {
  final String iconPath;
  final String text;
  final Color backgroundColor;

  CustomListItem(
      {required this.iconPath,
      required this.text,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isExpanded = useState(false);
    final isTruncated = useState(true);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final textPainter = TextPainter(
          text: TextSpan(text: text),
          textDirection: ui.TextDirection.ltr,
          maxLines: 3,
        );
        textPainter.layout(maxWidth: context.size?.width ?? 0);
        isTruncated.value = textPainter.didExceedMaxLines;
      });
      return;
    }, const []);

    return Neumorphic(
      style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          depth: 0.5,
          intensity: 0.1,
          surfaceIntensity: 0.2,
          lightSource: LightSource.bottom,
          color: Colors.transparent),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        padding: getPadding(left: 16, right: 8, top: 8, bottom: 12),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.grey, width: 1),
        //   borderRadius: BorderRadius.circular(12),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(iconPath, height: 32, width: 32),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.left,
                        overflow: _isExpanded.value
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        maxLines: _isExpanded.value
                            ? null
                            : 4, // Change the number of lines here
                        style: AppStyle.txtManropeRegular12.copyWith(
                            color: ColorConstant.black900, letterSpacing: 0.2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (!_isExpanded.value && isTruncated.value)
              Container(
                height: 32,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                    onPressed: () {
                      _isExpanded.value = true;
                    },
                    icon: CustomImageView(
                      height: 32,
                      width: 32,
                      svgPath: ImageConstant.imgArrowDown,
                      color: ColorConstant.blueA700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

List<Widget> getSavingsLabels(String spendingType) {
  if (spendingType == 'Impulsive Spender') {
    return [
      Text(
        'Overspender',
        style: AppStyle.txtManropeSemiBold10.copyWith(
          color: ColorConstant.blueGray800,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        softWrap: true,
      ),
      Text(
        'Moderate\nSaver',
        style: AppStyle.txtManropeSemiBold10.copyWith(
          color: ColorConstant.blueGray800,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        softWrap: true,
      ),
      Text(
        'Wealthy',
        style: AppStyle.txtManropeSemiBold10.copyWith(
          color: ColorConstant.blueGray800,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        softWrap: true,
      ),
    ];
  } else if (spendingType == 'Necessary Spender') {
    return [
      Text(
        'Cautious',
        style: AppStyle.txtManropeSemiBold10.copyWith(
          color: ColorConstant.blueGray800,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        softWrap: true,
      ),
      Text(
        'Prudent\nSaver',
        style: AppStyle.txtManropeSemiBold10.copyWith(
          color: ColorConstant.blueGray800,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        softWrap: true,
      ),
      Text(
        'Frugal',
        style: AppStyle.txtManropeSemiBold10.copyWith(
          color: ColorConstant.blueGray800,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        softWrap: true,
      ),
    ];
  } else if (spendingType == 'Balanced Spender') {
    return [
      Text(
        'Limited\nSaver',
        style: AppStyle.txtManropeSemiBold10.copyWith(
          color: ColorConstant.blueGray800,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        softWrap: true,
      ),
      Text(
        'Balanced\nSaver',
        style: AppStyle.txtManropeSemiBold10.copyWith(
          color: ColorConstant.blueGray800,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        softWrap: true,
      ),
      Text(
        'Strategic',
        style: AppStyle.txtManropeSemiBold10.copyWith(
          color: ColorConstant.blueGray800,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        softWrap: true,
      ),
    ];
  } else {
    return [
      Text(
        'Unknown',
        style: AppStyle.txtManropeSemiBold10.copyWith(
          color: ColorConstant.blueGray800,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        softWrap: true,
      ),
    ];
  }
}
