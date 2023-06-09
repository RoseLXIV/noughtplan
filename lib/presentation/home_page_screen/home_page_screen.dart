import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/budget/providers/banner_ads_class_provider.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/providers/first_time_provider.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home_page_screen/widgets/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';

final hasLoadedProvider = StateNotifierProvider<HasLoadedNotifier, bool>(
    (ref) => HasLoadedNotifier());

class HasLoadedNotifier extends StateNotifier<bool> {
  HasLoadedNotifier() : super(false);

  void setLoaded(bool loaded) {
    state = loaded;
  }
}

final dataFetchedProvider = StateProvider<bool>((ref) => false);

final refreshKey = StateProvider<bool>((ref) => false);

class HomePageScreen extends HookConsumerWidget {
  final ValueNotifier<bool> _isDataFetched = ValueNotifier(false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetNotifier = ref.watch(budgetStateProvider.notifier);

    final _budgets = useState<List<Budget?>?>(null);

    final authState = ref.watch(authStateProvider);
    final deviceId = authState.deviceId;

    void linkUser() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      // print('Firebase User: $firebaseUser');

      if (firebaseUser != null) {
        try {
          // Firebase User ID is used to identify the user in RevenueCat
          await Purchases.logIn(firebaseUser.uid);
          print(
              'User successfully logged in to RevenueCat with ID: ${firebaseUser.uid}');
        } catch (e) {
          print('Failed to log in user to RevenueCat: $e');
        }
      }
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
          return customerInfo.entitlements.all['pro_features']?.isActive ??
              false;
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

    final _animationController =
        useAnimationController(duration: const Duration(seconds: 1));
    final firstTime = ref.watch(firstTimeProvider);

    useEffect(() {
      Future.microtask(() async {
        await budgetNotifier.deleteBudgetsWithNoName();
        await budgetNotifier.fetchBudgetCount();
        Future<void> fetchBudgets() async {
          final fetchedBudgets = await budgetNotifier.fetchUserBudgets();
          _budgets.value = fetchedBudgets;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
          ));
        }

        linkUser();
        checkIsSubscribed();

        await fetchBudgets();

        checkIsSubscribed().then((value) {
          print('User is ${value ? 'Subscribed' : 'Not Subscribed'}');

          if (firstTime) {
            _animationController.repeat(reverse: true);
          }

          return _animationController.dispose;
        });
      });
      return () {};
    }, [firstTime]);

    final budgetCount =
        useValueListenable(budgetNotifier.budgetCountValueNotifier);
    print('Budget Count HomePage: $budgetCount');
    final isSubscriber = checkIsSubscribed();

    final userBudgets = budgetNotifier.state.budgets;
    String? displayName = FirebaseAuth.instance.currentUser?.displayName;

    String? firstName = displayName?.split(' ')[0];

    final List<String> greetings = [
      "Let's Make Progress, ${firstName}!",
      "Ready to Continue, ${firstName}?",
      "Good to Have You, ${firstName}!",
      "Time to Shine, ${firstName}!",
      "Welcome Back, ${firstName}!",
      "Ready for More, ${firstName}?",
      "Good to See You, ${firstName}!",
    ];

    final randomGreeting = (greetings..shuffle()).first;
    ScrollController _scrollController = ScrollController();

    Future<void> refreshData() async {
      await Future.wait([
        budgetNotifier.fetchBudgetCount(),
        checkIsSubscribed(), // This function will re-fetch subscription status
      ]);
    }

    // print(budgets);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          // // await Purchases.logOut();

          // await ref.read(authStateProvider.notifier).logOut();

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(
          //       'Logged out successfully!',
          //       textAlign: TextAlign.center,
          //       style: AppStyle.txtHelveticaNowTextBold16WhiteA700.copyWith(
          //         letterSpacing: getHorizontalSize(0.3),
          //       ),
          //     ),
          //     backgroundColor: ColorConstant.blue900,
          //   ),
          // );
          // // Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorConstant.whiteA700,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: FutureBuilder(
                  future: checkIsSubscribed(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LinearProgressIndicator(); // Or any other loading indicator you like
                    } else if (snapshot.hasError) {
                      // Handle the error here
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(snapshot.data!
                                ? 'assets/images/gradient_sub.png'
                                : 'assets/images/gradient_official.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: [
                            CustomAppBar(
                              height: getVerticalSize(100),
                              // leadingWidth: 48,
                              // leading: Container(
                              //   padding: getPadding(left: 24, top: 8),
                              //   child: CustomImageView(
                              //     height: getSize(24),
                              //     width: getSize(24),
                              //     svgPath: ImageConstant.imgArrowleft,
                              //     onTap: () async {
                              //       // await Purchases.logOut();

                              //       await ref
                              //           .read(authStateProvider.notifier)
                              //           .logOut();

                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //           content: Text(
                              //             'Logged out successfully!',
                              //             textAlign: TextAlign.center,
                              //             style: AppStyle
                              //                 .txtHelveticaNowTextBold16WhiteA700
                              //                 .copyWith(
                              //               letterSpacing:
                              //                   getHorizontalSize(0.3),
                              //             ),
                              //           ),
                              //           backgroundColor: ColorConstant.blue900,
                              //         ),
                              //       );
                              //       // Navigator.pop(context);
                              //     },
                              //   ),
                              // ),
                              // centerTitle: true,
                              title: AppbarImage(
                                height: getSize(200),
                                width: getSize(200),
                                imagePath: ImageConstant.imgGroup18301,
                                margin: getMargin(bottom: 8, left: 17),
                              ),
                              actions: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: getPadding(bottom: 0, right: 24),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Creating and Viewing Your Budget',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppStyle
                                                          .txtHelveticaNowTextBold16,
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      child: Container(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            style: AppStyle
                                                                .txtManropeRegular14
                                                                .copyWith(
                                                                    color: ColorConstant
                                                                        .blueGray800),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      'Welcome to the home page! Here are some simple steps to start managing your finances:\n\n'),
                                                              TextSpan(
                                                                  text:
                                                                      '1. Start Creating Your Budget:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              TextSpan(
                                                                  text:
                                                                      ' Tap on the plus (+) button to start creating your personalized budget plan. \n\n'),
                                                              TextSpan(
                                                                  text:
                                                                      '2. View Your Budget:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              TextSpan(
                                                                  text:
                                                                      ' Once you have created your budget, it will be displayed here. You can tap on each budget to view its details and features. \n\n'),
                                                              TextSpan(
                                                                  text:
                                                                      '3. Deleting a Budget:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              TextSpan(
                                                                  text:
                                                                      ' If you wish to delete a budget, just swipe left on the budget you want to remove. \n\n'),
                                                              TextSpan(
                                                                  text:
                                                                      '4. Upgrade to Pro:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              TextSpan(
                                                                  text:
                                                                      ' If you wish to access more features and details, consider subscribing to our Pro version. Just press the "Upgrade to Pro" button below. \n\n'),
                                                              TextSpan(
                                                                  text:
                                                                      '5. Logout:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              TextSpan(
                                                                  text:
                                                                      ' If you wish to log out, just press the back button. \n\n'),
                                                              TextSpan(
                                                                  text:
                                                                      'Now you\'re all set! Enjoy managing your finances effortlessly.'),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text('Close'),
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
                                                        shape: NeumorphicShape
                                                            .convex,
                                                        boxShape:
                                                            NeumorphicBoxShape
                                                                .circle(),
                                                        depth: 0.9,
                                                        intensity: 8,
                                                        surfaceIntensity: 0.7,
                                                        shadowLightColor:
                                                            Colors.white,
                                                        lightSource:
                                                            LightSource.top,
                                                        color: firstTime
                                                            ? ColorConstant
                                                                .blueA700
                                                            : Colors.white,
                                                      ),
                                                      child: SvgPicture.asset(
                                                        ImageConstant
                                                            .imgQuestion,
                                                        height: 24,
                                                        width: 24,
                                                        color: firstTime
                                                            ? ColorConstant
                                                                .whiteA700
                                                            : ColorConstant
                                                                .blueGray500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: AnimatedBuilder(
                                                    animation:
                                                        _animationController,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      if (!firstTime ||
                                                          _animationController
                                                              .isCompleted)
                                                        return SizedBox
                                                            .shrink(); // This line ensures that the arrow disappears after the animation has completed

                                                      return Transform
                                                          .translate(
                                                        offset: Offset(
                                                            0,
                                                            -20 *
                                                                _animationController
                                                                    .value),
                                                        child: SvgPicture.asset(
                                                          ImageConstant
                                                              .imgArrowUp, // path to your arrow SVG image
                                                          height: 24,
                                                          width: 24,
                                                          color: ColorConstant
                                                              .blueA700,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: getPadding(right: 17, top: 0),
                                      child: CustomImageView(
                                        height: getSize(24),
                                        width: getSize(24),
                                        svgPath: ImageConstant.imgSettings,
                                        onTap: () async {
                                          Navigator.pushNamed(
                                            context,
                                            '/my_account_screen',
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              FutureBuilder<Map<String, dynamic>>(
                future: getSubscriptionInfo(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Display loading indicator while waiting for response
                    return SizedBox.shrink();
                  } else if (snapshot.hasError) {
                    // Handle error if any
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Conditionally display the image based on subscription status
                    return Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Transform(
                        transform: Matrix4.identity()..scale(-1.0, -1.0, 0.1),
                        alignment: Alignment.center,
                        child: CustomImageView(
                          imagePath: snapshot.data!['isSubscribed']
                              ? ImageConstant.imgTopographic5_sub
                              : ImageConstant.imgTopographic5_nonsub,
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    );
                  }
                },
              ),
              Container(
                width: double.maxFinite,
                height: double.maxFinite,
                padding: getPadding(left: 30, right: 30, bottom: 11, top: 130),
                child: RefreshIndicator(
                  onRefresh: refreshData,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: getPadding(left: 0, bottom: 8, top: 8),
                          child: Text(
                            "$randomGreeting",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: AppStyle.txtHelveticaNowTextBold20.copyWith(
                              color: ColorConstant.black900,
                              letterSpacing: getHorizontalSize(1),
                              // shadows: [
                              //   Shadow(
                              //     color: Colors.black.withOpacity(0.5),
                              //     offset: Offset(0, 2),
                              //     blurRadius: 4,
                              //   ),
                              // ],
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: getPadding(bottom: 50),
                        // ),
                        Column(
                          children: [
                            StatefulBuilder(
                                builder: (context, StateSetter setState) {
                              void _onDismissed(int index) {
                                setState(() {
                                  _budgets.value!.removeAt(index);
                                });
                              }

                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.533,
                                padding: EdgeInsets.only(top: 8),
                                child: Consumer(
                                  builder: (context, ref, _) {
                                    final refresh = ref.watch(refreshKey);
                                    // final budgetState =
                                    //     ref.watch(budgetStateProvider);
                                    // final userBudgets = budgetState.budgets;
                                    if (_budgets.value == null) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (_budgets.value!.isEmpty) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Neumorphic(
                                              style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            12)),
                                                depth: 0.1,
                                                intensity: 1,
                                                surfaceIntensity: 0.5,
                                                lightSource: LightSource.top,
                                                color: ColorConstant.gray50,
                                              ),
                                              child: Container(
                                                height: getVerticalSize(95),
                                                decoration: BoxDecoration(
                                                  color: ColorConstant.gray100,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        "Press the plus (+) button to add a Budget",
                                                        style: AppStyle
                                                            .txtManropeBold12
                                                            .copyWith(
                                                          color: ColorConstant
                                                              .blueGray500,
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  1),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      final userBudgets = _budgets.value!;
                                      return RefreshIndicator(
                                        onRefresh: () async {
                                          await budgetNotifier
                                              .fetchUserBudgets();
                                        },
                                        child: ListView.separated(
                                          physics: BouncingScrollPhysics(),
                                          padding:
                                              getPadding(top: 5, bottom: 25),
                                          // scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                                height: getVerticalSize(16));
                                          },
                                          itemCount: userBudgets.length,
                                          itemBuilder: (context, index) {
                                            final budget = userBudgets[index];
                                            return Dismissible(
                                              key: Key(budget!.budgetId),
                                              background: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        height:
                                                            getVerticalSize(95),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors
                                                                  .transparent,
                                                              ColorConstant
                                                                  .redA700
                                                            ],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                            stops: [
                                                              0.15,
                                                              1.0
                                                            ], // first color stops at 70%, second at 100%
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            // SizedBox(width: 25),
                                                            Padding(
                                                              padding:
                                                                  getPadding(
                                                                      right:
                                                                          16),
                                                              child:
                                                                  CustomImageView(
                                                                svgPath:
                                                                    ImageConstant
                                                                        .imgTrashNew,
                                                                height:
                                                                    getSize(32),
                                                                width:
                                                                    getSize(32),
                                                                color: ColorConstant
                                                                    .whiteA700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              direction:
                                                  DismissDirection.endToStart,
                                              confirmDismiss:
                                                  (direction) async {
                                                // Show confirmation dialog
                                                return await showDialog<bool>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Confirm Deletion',
                                                          style: AppStyle
                                                              .txtHelveticaNowTextBold18),
                                                      content: Text(
                                                          'Are you sure you want to delete this budget?',
                                                          style: AppStyle
                                                              .txtManropeRegular14),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child: Text('Cancel',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true),
                                                          child: Text('Delete',
                                                              style: AppStyle
                                                                  .txtHelveticaNowTextBold14
                                                                  .copyWith(
                                                                color:
                                                                    ColorConstant
                                                                        .redA700,
                                                              )),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              onDismissed: (direction) async {
                                                await budgetNotifier
                                                    .deleteBudget(
                                                        budget.budgetId);
                                                ref
                                                        .read(refreshKey.notifier)
                                                        .state =
                                                    !ref
                                                        .read(
                                                            refreshKey.notifier)
                                                        .state;
                                                _onDismissed(index);
                                                await budgetNotifier
                                                    .fetchUserBudgets();
                                              },
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/main_budget_home_screen',
                                                    arguments: {
                                                      'budget': budget,
                                                      'firstName': firstName,
                                                    },
                                                  );
                                                },
                                                child: ListItemWidget(
                                                  budgetName: budget.budgetName,
                                                  budgetType: budget.budgetType,
                                                  totalExpenses: budget.salary,
                                                  spendingType:
                                                      budget.spendingType,
                                                  savingType: budget.savingType,
                                                  debtType: budget.debtType,
                                                  currency: budget.currency,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            }),
                            Padding(
                              padding: getPadding(bottom: 10),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/gradient_sub1.png'),
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          'Monthly \nSubscription',
                                                          style: AppStyle
                                                              .txtHelveticaNowTextBold32
                                                              .copyWith(
                                                            color: ColorConstant
                                                                .gray900,
                                                          )),
                                                      Padding(
                                                        padding:
                                                            getPadding(top: 4),
                                                        child: Text(
                                                            '\$4.99 /month',
                                                            style: AppStyle
                                                                .txtHelveticaNowTextLight18
                                                                .copyWith(
                                                              color:
                                                                  ColorConstant
                                                                      .gray900,
                                                            )),
                                                      ),
                                                      Divider(
                                                        color: ColorConstant
                                                            .blueGray300,
                                                        thickness:
                                                            0.5, // You can customize the thickness of the line
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  getPadding(
                                                                      right:
                                                                          12),
                                                              child: CustomImageView(
                                                                  svgPath:
                                                                      ImageConstant
                                                                          .imgMessage1,
                                                                  height:
                                                                      getSize(
                                                                          32),
                                                                  width:
                                                                      getSize(
                                                                          32),
                                                                  color: ColorConstant
                                                                      .blueA700),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      'A.I. Financial advisor',
                                                                      style: AppStyle
                                                                          .txtManropeSemiBold14
                                                                          .copyWith(
                                                                        color: ColorConstant
                                                                            .gray900,
                                                                      )),
                                                                  Text(
                                                                    'Get personalized financial advice from our A.I-powered advisor powered by ChatGPT.',
                                                                    style: AppStyle
                                                                        .txtManropeRegular12
                                                                        .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray500,
                                                                    ),
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  getPadding(
                                                                      right:
                                                                          12),
                                                              child: CustomImageView(
                                                                  svgPath:
                                                                      ImageConstant
                                                                          .imgPlus,
                                                                  height:
                                                                      getSize(
                                                                          32),
                                                                  width:
                                                                      getSize(
                                                                          32),
                                                                  color: ColorConstant
                                                                      .blueA700),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      'Multiple budgets',
                                                                      style: AppStyle
                                                                          .txtManropeSemiBold14
                                                                          .copyWith(
                                                                        color: ColorConstant
                                                                            .gray900,
                                                                      )),
                                                                  Text(
                                                                    'Create and manage up to 5 custom budgets for greater control over your spending.',
                                                                    style: AppStyle
                                                                        .txtManropeRegular12
                                                                        .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray500,
                                                                    ),
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  getPadding(
                                                                      right:
                                                                          12),
                                                              child: CustomImageView(
                                                                  svgPath:
                                                                      ImageConstant
                                                                          .imgArchive,
                                                                  height:
                                                                      getSize(
                                                                          32),
                                                                  width:
                                                                      getSize(
                                                                          32),
                                                                  color: ColorConstant
                                                                      .blueA700),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      'More Trackers and Expenses',
                                                                      style: AppStyle
                                                                          .txtManropeSemiBold14
                                                                          .copyWith(
                                                                        color: ColorConstant
                                                                            .gray900,
                                                                      )),
                                                                  Text(
                                                                    'Unlock the ability to add more trackers, and record more expenses and income for your budget. This allows for a more comprehensive and detailed view of your finances.',
                                                                    style: AppStyle
                                                                        .txtManropeRegular12
                                                                        .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray500,
                                                                    ),
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  getPadding(
                                                                      right:
                                                                          12),
                                                              child: CustomImageView(
                                                                  svgPath:
                                                                      ImageConstant
                                                                          .imgVideoSlash,
                                                                  height:
                                                                      getSize(
                                                                          32),
                                                                  width:
                                                                      getSize(
                                                                          32),
                                                                  color: ColorConstant
                                                                      .blueA700),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      'Ad-free experience',
                                                                      style: AppStyle
                                                                          .txtManropeSemiBold14
                                                                          .copyWith(
                                                                        color: ColorConstant
                                                                            .gray900,
                                                                      )),
                                                                  Text(
                                                                    'Enjoy a more focused and streamlined experience without ads.',
                                                                    style: AppStyle
                                                                        .txtManropeRegular12
                                                                        .copyWith(
                                                                      color: ColorConstant
                                                                          .blueGray500,
                                                                    ),
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            getPadding(top: 16),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                bool
                                                                    purchaseSuccess =
                                                                    await makePurchase();
                                                                if (purchaseSuccess) {
                                                                  bool
                                                                      isSubscribed =
                                                                      await checkIsSubscribed();
                                                                  if (isSubscribed) {
                                                                    print(
                                                                        'User is Subscribed');
                                                                  } else {
                                                                    print(
                                                                        'User is Not Subscribed');
                                                                  }
                                                                }
                                                              },
                                                              child: Container(
                                                                height:
                                                                    getVerticalSize(
                                                                        50),
                                                                width:
                                                                    getHorizontalSize(
                                                                        100),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal: 8,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: ColorConstant
                                                                      .blueA700,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              80),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      'Upgrade',
                                                                      style: AppStyle
                                                                          .txtManropeBold14
                                                                          .copyWith(
                                                                              color: ColorConstant.whiteA700),
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
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: FutureBuilder<bool>(
                                  future: checkIsSubscribed(),
                                  builder: (context, snapshot) {
                                    // The future is still loading
                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return SizedBox
                                          .shrink(); // Or some other placeholder
                                    }

                                    // The future completed with an error
                                    if (snapshot.hasError) {
                                      return Text('An error occurred');
                                    }

                                    // The future completed with a result
                                    bool isSubscribed = snapshot.data ?? false;

                                    // If the user is not subscribed, show the upgrade button
                                    if (!isSubscribed) {
                                      return Padding(
                                        padding: getPadding(
                                            left: 30,
                                            right: 30,
                                            bottom: 16,
                                            top: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Neumorphic(
                                              style: NeumorphicStyle(
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            80)),
                                                depth: 7,
                                                intensity: 7,
                                                surfaceIntensity: 0.8,
                                                lightSource: LightSource.top,
                                                color: ColorConstant.gray50,
                                                shape: NeumorphicShape.convex,
                                              ),
                                              child: Container(
                                                height: getVerticalSize(50),
                                                width: getHorizontalSize(140),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Upgrade to Pro',
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
                                      );
                                    } else {
                                      return Container(); // Display an empty container when the user is subscribed
                                    }
                                  },
                                ),
                              ),
                            ),
                            FutureBuilder<Map<String, dynamic>>(
                              future: getSubscriptionInfo(),
                              builder: (context, snapshot) {
                                // The future is still loading
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return Container(); // Or some other placeholder
                                }

                                // The future completed with an error
                                if (snapshot.hasError) {
                                  return Text('An error occurred');
                                }

                                // The future completed with a result
                                Map<String, dynamic> subscriptionInfo = snapshot
                                        .data ??
                                    {'isSubscribed': false, 'expiryDate': null};
                                bool isSubscribed =
                                    subscriptionInfo['isSubscribed'] ?? false;
                                DateTime? expiryDate =
                                    subscriptionInfo['expiryDate'];

                                // If the user is not subscribed, show the ad
                                if (!isSubscribed) {
                                  return Padding(
                                    padding: getPadding(bottom: 20),
                                    child: Container(
                                      color: Colors.white,
                                      child: Center(
                                        child: BannerAdWidget(),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: getPadding(
                                        top: 45, left: 0, right: 0, bottom: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Subscribed ",
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold18
                                                  .copyWith(
                                                      color: ColorConstant
                                                          .gray900),
                                            ),
                                            Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              size: 24,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: getPadding(top: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Subscription expires on: ",
                                                    style: AppStyle
                                                        .txtManropeRegular14
                                                        .copyWith(
                                                            color: ColorConstant
                                                                .blueGray500),
                                                  ),
                                                  Text(
                                                    "${DateFormat('EEEE, MMMM dd, yyyy').format(expiryDate?.toLocal() ?? DateTime.now())}",
                                                    style: AppStyle
                                                        .txtManropeBold14
                                                        .copyWith(
                                                            color: ColorConstant
                                                                .blueGray500),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(top: 6),
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (await canLaunch(
                                                  subscriptionInfo[
                                                      'managementUrl'])) {
                                                await launch(subscriptionInfo[
                                                    'managementUrl']);
                                              } else {
                                                throw 'Could not launch ${subscriptionInfo['managementUrl']}';
                                              }
                                            },
                                            child: Text(
                                              "Click here to manage your subscription",
                                              style: AppStyle
                                                  .txtManropeRegular12
                                                  .copyWith(
                                                color:
                                                    ColorConstant.blueGray500,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FutureBuilder<List<dynamic>>(
            future: Future.wait([
              Future.value(budgetCount),
              isSubscriber,
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink();
              } else {
                if (snapshot.hasError) {
                  return Container();
                } else {
                  int budgetCount = snapshot.data![0];
                  bool isSubscriber = snapshot.data![1];
                  if ((isSubscriber && budgetCount < 5) ||
                      (!isSubscriber && budgetCount < 1)) {
                    return NeumorphicFloatingActionButton(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(60)),
                        depth: 0.5,
                        // intensity: 9,
                        surfaceIntensity: 0.8,
                        lightSource: LightSource.top,
                        color: ColorConstant.blueA700,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/generator_salary_screen');
                      },
                      child: Icon(
                        Icons.add_rounded,
                        color: ColorConstant.whiteA700,
                        size: getSize(42),
                      ),
                      // backgroundColor: ColorConstant.lightBlueA200,
                    );
                  } else {
                    return Container();
                  }
                }
              }
            },
          ),
          floatingActionButtonLocation: CustomFabLocation(context),
        ),
      ),
    );
  }

  onTapArrowleft(BuildContext context) {
    Navigator.pop(context);
  }
}

class CustomFabLocation extends FloatingActionButtonLocation {
  final BuildContext context;

  CustomFabLocation(this.context);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Customize the position of the FloatingActionButton here
    final double screenFactor = MediaQuery.of(context).size.height / 812.0;

    final double offsetX = 16.0; // Horizontal offset from the right edge
    final double offsetY =
        560.0 * screenFactor; // Vertical offset from the bottom edge

    return Offset(
      scaffoldGeometry.scaffoldSize.width -
          scaffoldGeometry.floatingActionButtonSize.width -
          offsetX,
      scaffoldGeometry.scaffoldSize.height -
          scaffoldGeometry.floatingActionButtonSize.height -
          offsetY,
    );
  }
}
