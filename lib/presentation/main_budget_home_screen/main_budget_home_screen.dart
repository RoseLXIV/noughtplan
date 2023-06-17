import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/presentation/budget_screen/budget_screen.dart';
import 'package:noughtplan/presentation/chat_bot_screen/chat_bot_screen.dart';
import 'package:noughtplan/presentation/expense_tracking_screen/expense_tracking_screen.dart';
import 'package:noughtplan/presentation/home_page_screen/home_page_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBudgetHomeScreen extends StatefulWidget {
  @override
  _MainBudgetHomeScreenState createState() => _MainBudgetHomeScreenState();
}

class _MainBudgetHomeScreenState extends State<MainBudgetHomeScreen> {
  final container = ProviderContainer();
  late PageController _pageController;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    container.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> makePurchase() async {
    try {
      Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null) {
        Package package = offerings.current!.availablePackages[0];
        await Purchases.purchasePackage(package);
        return true;
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print('Error: ${e.code} - ${e.message}');
      }
    }
    return false;
  }

  Future<bool> checkIsSubscribed() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      try {
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        print('Customer Info: $customerInfo');
        return customerInfo.entitlements.all['pro_features']?.isActive ?? false;
      } catch (e) {
        print('Failed to log in and get purchaser info: $e');
      }
    }
    return false;
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

  Future<void> loadAndShowRewardedAd(BuildContext context) async {
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

  Future<void> startFreeTrial() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now();
    // Store the start of the trial
    await prefs.setString('free_trial_start', currentTime.toIso8601String());

    // Debugging line
    print('Trial started at: ${prefs.getString('free_trial_start')}');
  }

  Future<bool?> isFreeTrialExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final trialStartString = prefs.getString('free_trial_start');
    if (trialStartString != null) {
      final trialStart = DateTime.parse(trialStartString);
      final trialEnd = trialStart.add(Duration(minutes: 30));
      final currentTime = DateTime.now();
      // Check if the current time is past the trial end time
      if (currentTime.isAfter(trialEnd)) {
        return true;
      } else {
        return false;
      }
    }
    // If there's no trial start time, the trial hasn't started yet
    return null;
  }

  int _previousIndex = 1;

  void _onItemTapped(int index) async {
    if (index == 0) {
      // if ChatBotScreen is at index 0
      Map<String, dynamic> subscriptionInfo = await getSubscriptionInfo();
      bool? isTrialExpired = await isFreeTrialExpired();
      if ((subscriptionInfo['isSubscribed'] as bool) ||
          isTrialExpired == false) {
        _previousIndex =
            _currentIndex; // save the current index before navigating
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentIndex = index;
        });
      } else {
        // Show a dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/gradient_sub1.png'),
                        fit: BoxFit.fill,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(24),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Monthly \nSubscription',
                                style:
                                    AppStyle.txtHelveticaNowTextBold32.copyWith(
                                  color: ColorConstant.gray900,
                                )),
                            Padding(
                              padding: getPadding(top: 4),
                              child: Text('\$4.99 /month',
                                  style: AppStyle.txtHelveticaNowTextLight18
                                      .copyWith(
                                    color: ColorConstant.gray900,
                                  )),
                            ),
                            Divider(
                              color: ColorConstant.blueGray300,
                              thickness:
                                  0.5, // You can customize the thickness of the line
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: getPadding(right: 12),
                                    child: CustomImageView(
                                        svgPath: ImageConstant.imgMessage1,
                                        height: getSize(32),
                                        width: getSize(32),
                                        color: ColorConstant.blueA700),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('A.I. Financial advisor',
                                            style: AppStyle.txtManropeSemiBold14
                                                .copyWith(
                                              color: ColorConstant.gray900,
                                            )),
                                        Text(
                                          'Get personalized financial advice from our A.I-powered advisor powered by ChatGPT.',
                                          style: AppStyle.txtManropeRegular12
                                              .copyWith(
                                            color: ColorConstant.blueGray500,
                                          ),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: getPadding(right: 12),
                                    child: CustomImageView(
                                        svgPath: ImageConstant.imgPlus,
                                        height: getSize(32),
                                        width: getSize(32),
                                        color: ColorConstant.blueA700),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Multiple budgets',
                                            style: AppStyle.txtManropeSemiBold14
                                                .copyWith(
                                              color: ColorConstant.gray900,
                                            )),
                                        Text(
                                          'Create and manage up to 5 custom budgets for greater control over your spending.',
                                          style: AppStyle.txtManropeRegular12
                                              .copyWith(
                                            color: ColorConstant.blueGray500,
                                          ),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: getPadding(right: 12),
                                    child: CustomImageView(
                                        svgPath: ImageConstant.imgArchive,
                                        height: getSize(32),
                                        width: getSize(32),
                                        color: ColorConstant.blueA700),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('More Trackers and Expenses',
                                            style: AppStyle.txtManropeSemiBold14
                                                .copyWith(
                                              color: ColorConstant.gray900,
                                            )),
                                        Text(
                                          'Unlock the ability to add more trackers, and record more expenses and income for your budget. This allows for a more comprehensive and detailed view of your finances.',
                                          style: AppStyle.txtManropeRegular12
                                              .copyWith(
                                            color: ColorConstant.blueGray500,
                                          ),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: getPadding(right: 12),
                                    child: CustomImageView(
                                        svgPath: ImageConstant.imgVideoSlash,
                                        height: getSize(32),
                                        width: getSize(32),
                                        color: ColorConstant.blueA700),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Ad-free experience',
                                            style: AppStyle.txtManropeSemiBold14
                                                .copyWith(
                                              color: ColorConstant.gray900,
                                            )),
                                        Text(
                                          'Enjoy a more focused and streamlined experience without ads.',
                                          style: AppStyle.txtManropeRegular12
                                              .copyWith(
                                            color: ColorConstant.blueGray500,
                                          ),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: getPadding(top: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      bool purchaseSuccess =
                                          await makePurchase();
                                      if (purchaseSuccess) {
                                        bool isSubscribed =
                                            await checkIsSubscribed();
                                        if (isSubscribed) {
                                          print('User is Subscribed');
                                        } else {
                                          print('User is Not Subscribed');
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: getVerticalSize(50),
                                      width: getHorizontalSize(100),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorConstant.blueA700,
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Upgrade',
                                            style: AppStyle.txtManropeBold14
                                                .copyWith(
                                                    color: ColorConstant
                                                        .whiteA700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: getPadding(top: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder<bool?>(
                                    future: isFreeTrialExpired(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<bool?> snapshot) {
                                      // While we're waiting for the future to resolve, show a loading spinner
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.data == null ||
                                          snapshot.data == false) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                      dialogContext) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        'Watch an ad to try AI Assistant for Free',
                                                        style: AppStyle
                                                            .txtManropeRegular14
                                                            .copyWith(
                                                                color: ColorConstant
                                                                    .blueGray500,
                                                                letterSpacing:
                                                                    0.2),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                            'OK',
                                                            style: AppStyle
                                                                .txtHelveticaNowTextBold14
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        0.2,
                                                                    color: ColorConstant
                                                                        .blueA700),
                                                          ),
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    dialogContext)
                                                                .pop();
                                                            await loadAndShowRewardedAd(
                                                                context);

                                                            // Start the free trial here
                                                            await startFreeTrial();
                                                            // Close the dialog
                                                            Navigator.pop(
                                                                context);
                                                            // Set the current page to ChatBotScreen
                                                            setState(() {
                                                              _currentIndex =
                                                                  index;
                                                            });
                                                            _pageController
                                                                .jumpToPage(
                                                                    index);
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text(
                                                            'Cancel',
                                                            style: AppStyle
                                                                .txtHelveticaNowTextBold14
                                                                .copyWith(
                                                                    color: ColorConstant
                                                                        .blueGray800,
                                                                    letterSpacing:
                                                                        0.2),
                                                          ),
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
                                              },
                                              child: Text(
                                                'Try AI Assistant for Free',
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold12
                                                    .copyWith(
                                                  color: ColorConstant.blueA700,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    },
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
            );
          },
        );
      }
    } else {
      _previousIndex =
          _currentIndex; // save the current index before navigating
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex = index;
      });
    }
  }

  double _getTranslationValue() {
    switch (_currentIndex) {
      case 0:
        return -MediaQuery.of(context).size.width / 3;
      case 1:
        return 0;
      case 2:
        return MediaQuery.of(context).size.width / 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) async {
          if (index == 0) {
            Map<String, dynamic> subscriptionInfo = await getSubscriptionInfo();
            bool? isTrialExpired = await isFreeTrialExpired();
            if (subscriptionInfo['isSubscribed'] as bool ||
                isTrialExpired == false) {
              setState(() {
                _currentIndex = index;
              });
            } else {
              // Show dialog
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/gradient_sub1.png'),
                              fit: BoxFit.fill,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(24),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Monthly \nSubscription',
                                      style: AppStyle.txtHelveticaNowTextBold32
                                          .copyWith(
                                        color: ColorConstant.gray900,
                                      )),
                                  Padding(
                                    padding: getPadding(top: 4),
                                    child: Text('\$4.99 /month',
                                        style: AppStyle
                                            .txtHelveticaNowTextLight18
                                            .copyWith(
                                          color: ColorConstant.gray900,
                                        )),
                                  ),
                                  Divider(
                                    color: ColorConstant.blueGray300,
                                    thickness:
                                        0.5, // You can customize the thickness of the line
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: getPadding(right: 12),
                                          child: CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgMessage1,
                                              height: getSize(32),
                                              width: getSize(32),
                                              color: ColorConstant.blueA700),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('A.I. Financial advisor',
                                                  style: AppStyle
                                                      .txtManropeSemiBold14
                                                      .copyWith(
                                                    color:
                                                        ColorConstant.gray900,
                                                  )),
                                              Text(
                                                'Get personalized financial advice from our A.I-powered advisor powered by ChatGPT.',
                                                style: AppStyle
                                                    .txtManropeRegular12
                                                    .copyWith(
                                                  color:
                                                      ColorConstant.blueGray500,
                                                ),
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: getPadding(right: 12),
                                          child: CustomImageView(
                                              svgPath: ImageConstant.imgPlus,
                                              height: getSize(32),
                                              width: getSize(32),
                                              color: ColorConstant.blueA700),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Multiple budgets',
                                                  style: AppStyle
                                                      .txtManropeSemiBold14
                                                      .copyWith(
                                                    color:
                                                        ColorConstant.gray900,
                                                  )),
                                              Text(
                                                'Create and manage up to 5 custom budgets for greater control over your spending.',
                                                style: AppStyle
                                                    .txtManropeRegular12
                                                    .copyWith(
                                                  color:
                                                      ColorConstant.blueGray500,
                                                ),
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: getPadding(right: 12),
                                          child: CustomImageView(
                                              svgPath: ImageConstant.imgArchive,
                                              height: getSize(32),
                                              width: getSize(32),
                                              color: ColorConstant.blueA700),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('More Trackers and Expenses',
                                                  style: AppStyle
                                                      .txtManropeSemiBold14
                                                      .copyWith(
                                                    color:
                                                        ColorConstant.gray900,
                                                  )),
                                              Text(
                                                'Unlock the ability to add more trackers, and record more expenses and income for your budget. This allows for a more comprehensive and detailed view of your finances.',
                                                style: AppStyle
                                                    .txtManropeRegular12
                                                    .copyWith(
                                                  color:
                                                      ColorConstant.blueGray500,
                                                ),
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: getPadding(right: 12),
                                          child: CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgVideoSlash,
                                              height: getSize(32),
                                              width: getSize(32),
                                              color: ColorConstant.blueA700),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Ad-free experience',
                                                  style: AppStyle
                                                      .txtManropeSemiBold14
                                                      .copyWith(
                                                    color:
                                                        ColorConstant.gray900,
                                                  )),
                                              Text(
                                                'Enjoy a more focused and streamlined experience without ads.',
                                                style: AppStyle
                                                    .txtManropeRegular12
                                                    .copyWith(
                                                  color:
                                                      ColorConstant.blueGray500,
                                                ),
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(top: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            bool purchaseSuccess =
                                                await makePurchase();
                                            if (purchaseSuccess) {
                                              bool isSubscribed =
                                                  await checkIsSubscribed();
                                              if (isSubscribed) {
                                                print('User is Subscribed');
                                              } else {
                                                print('User is Not Subscribed');
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: getVerticalSize(50),
                                            width: getHorizontalSize(100),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.blueA700,
                                              borderRadius:
                                                  BorderRadius.circular(80),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Upgrade',
                                                  style: AppStyle
                                                      .txtManropeBold14
                                                      .copyWith(
                                                          color: ColorConstant
                                                              .whiteA700),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(top: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FutureBuilder<bool?>(
                                          future: isFreeTrialExpired(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<bool?> snapshot) {
                                            // While we're waiting for the future to resolve, show a loading spinner
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.data == null ||
                                                snapshot.data == false) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      await showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            dialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              'Watch an ad to try AI Assistant for Free',
                                                              style: AppStyle
                                                                  .txtManropeRegular14
                                                                  .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray500,
                                                                      letterSpacing:
                                                                          0.2),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: Text(
                                                                  'OK',
                                                                  style: AppStyle
                                                                      .txtHelveticaNowTextBold14
                                                                      .copyWith(
                                                                          letterSpacing:
                                                                              0.2,
                                                                          color:
                                                                              ColorConstant.blueA700),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.of(
                                                                          dialogContext)
                                                                      .pop();
                                                                  await loadAndShowRewardedAd(
                                                                      context);

                                                                  // Start the free trial here
                                                                  await startFreeTrial();
                                                                  // Close the dialog
                                                                  Navigator.pop(
                                                                      context);
                                                                  // Set the current page to ChatBotScreen
                                                                  setState(() {
                                                                    _currentIndex =
                                                                        index;
                                                                  });
                                                                  _pageController
                                                                      .jumpToPage(
                                                                          index);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: AppStyle
                                                                      .txtHelveticaNowTextBold14
                                                                      .copyWith(
                                                                          color: ColorConstant
                                                                              .blueGray800,
                                                                          letterSpacing:
                                                                              0.2),
                                                                ),
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
                                                    },
                                                    child: Text(
                                                      'Try AI Assistant for Free',
                                                      style: AppStyle
                                                          .txtHelveticaNowTextBold12
                                                          .copyWith(
                                                        color: ColorConstant
                                                            .blueA700,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return SizedBox.shrink();
                                            }
                                          },
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
                  );
                },
              );
              // Animate back to the BudgetScreen
              _pageController.animateToPage(
                1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              return;
            }
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        children: [
          ChatBotScreen(),
          BudgetScreen(),
          ExpenseTrackingScreen(),
        ],
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  padding: getPadding(
                    right: 25,
                  ),
                  icon: CustomImageView(
                    svgPath: ImageConstant.imgMessage,
                    color: _currentIndex == 0
                        ? ColorConstant.blueGray300
                        : Colors.grey,
                  ),
                  onPressed: () => _onItemTapped(0),
                ),
                IconButton(
                  icon: CustomImageView(
                    svgPath: ImageConstant.imgClockWhiteA700,
                    color: _currentIndex == 1 ? Colors.white : Colors.grey,
                  ),
                  onPressed: () => _onItemTapped(1),
                ),
                // To leave space for the blue container
                IconButton(
                  padding: getPadding(
                    left: 25,
                  ),
                  icon: CustomImageView(
                    svgPath: ImageConstant.imgVolumeBlueGray300,
                    color: _currentIndex == 2
                        ? ColorConstant.blueGray300
                        : Colors.grey,
                  ),
                  onPressed: () => _onItemTapped(2),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10, // Adjust the value as needed
            left: 0,
            right: 0,
            child: Center(
              child: Transform.translate(
                offset: Offset(_getTranslationValue(), 0),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 1,
                    intensity: 0.7,
                    surfaceIntensity: 0.9,
                    lightSource: LightSource.top,
                    color: ColorConstant.gray50,
                  ),
                  child: Container(
                    height: 50,
                    width: 110,
                    decoration: AppDecoration.fillBlueA700.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder12,
                    ),
                    child: _currentIndex == 0
                        ? IconButton(
                            icon: CustomImageView(
                              svgPath: ImageConstant.imgMessage,
                              color: Colors.white,
                            ),
                            onPressed: () => _onItemTapped(0),
                          )
                        : _currentIndex == 1
                            ? IconButton(
                                icon: CustomImageView(
                                  svgPath: ImageConstant.imgClockWhiteA700,
                                  color: Colors.white,
                                ),
                                onPressed: () => _onItemTapped(1),
                              )
                            : IconButton(
                                icon: CustomImageView(
                                  svgPath: ImageConstant.imgVolumeBlueGray300,
                                  color: Colors.white,
                                ),
                                onPressed: () => _onItemTapped(2),
                              ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
