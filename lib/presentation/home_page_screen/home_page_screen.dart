import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/budget/providers/banner_ads_class_provider.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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

    useEffect(() {
      Future<void> fetchBudgets() async {
        final fetchedBudgets = await budgetNotifier.fetchUserBudgets();
        // print('Fetched Budgets: $fetchedBudgets');
        _budgets.value = fetchedBudgets;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.black, // Set status bar color
          statusBarIconBrightness: Brightness.light, // Status bar icons' color
        ));
        // print('Budgets: ${_budgets.value}');
      }

      fetchBudgets();

//       ref.listen<BannerAd?>(adProvider, (oldAd, newAd) {
//   if (newAd != null) {
//     print('Ad is ready to be displayed');
//     ref.read(currentAdProvider.notifier).state = newAd;
//   }
// });
//       ref.read(adProvider.notifier).loadAd();
      return () {}; // Clean-up function
    }, []);

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

    // print(budgets);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          await ref.read(authStateProvider.notifier).logOut();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Logged out successfully!',
                textAlign: TextAlign.center,
                style: AppStyle.txtHelveticaNowTextBold16WhiteA700.copyWith(
                  letterSpacing: getHorizontalSize(0.3),
                ),
              ),
              backgroundColor: ColorConstant.blue900,
            ),
          );
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorConstant.whiteA700,
          body: Stack(
            children: [
              Positioned(
                bottom: 90,
                left: -20,
                right: 0,
                child: Transform(
                  transform: Matrix4.identity()..scale(-1.0, 1.0, 0.1),
                  alignment: Alignment.center,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgTopographic5,
                    height: MediaQuery.of(context).size.height *
                        0.5, // Set the height to 50% of the screen height
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set the width to the full screen width
                    // alignment: Alignment.,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/gradient_official.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomAppBar(
                        height: getVerticalSize(100),
                        leadingWidth: 48,
                        leading: AppbarImage(
                          height: getSize(24),
                          width: getSize(24),
                          svgPath: ImageConstant.imgArrowleft,
                          margin: getMargin(
                              left: 24, top: 15, bottom: 10, right: 0),
                          onTap: () async {
                            await ref.read(authStateProvider.notifier).logOut();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Logged out successfully!',
                                  textAlign: TextAlign.center,
                                  style: AppStyle
                                      .txtHelveticaNowTextBold16WhiteA700
                                      .copyWith(
                                    letterSpacing: getHorizontalSize(0.3),
                                  ),
                                ),
                                backgroundColor: ColorConstant.blue900,
                              ),
                            );
                          },
                        ),
                        centerTitle: true,
                        title: AppbarImage(
                          height: getSize(200),
                          width: getSize(200),
                          imagePath: ImageConstant.imgGroup18301,
                          margin: getMargin(bottom: 1),
                        ),
                        actions: [
                          // AppbarImage(
                          //     height: getSize(24),
                          //     width: getSize(24),
                          //     svgPath: ImageConstant.imgPlus,
                          //     margin: getMargin(left: 0, bottom: 2, right: 25),
                          //     onTap: () {
                          //       Navigator.pushNamed(
                          //           context, '/generator_salary_screen');
                          //     }),
                          AppbarImage(
                            height: getSize(24),
                            width: getSize(24),
                            svgPath: ImageConstant.imgSettings,
                            margin: getMargin(left: 0, bottom: 1, right: 25),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                padding: getPadding(left: 30, right: 30, bottom: 11, top: 150),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: getPadding(left: 0, bottom: 4),
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
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
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
                                        await budgetNotifier.fetchUserBudgets();
                                      },
                                      child: ListView.separated(
                                        physics: BouncingScrollPhysics(),
                                        padding: getPadding(top: 5, bottom: 25),
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
                                                      decoration: BoxDecoration(
                                                        color: ColorConstant
                                                            .redA700,
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
                                                            padding: getPadding(
                                                                right: 16),
                                                            child:
                                                                CustomImageView(
                                                              svgPath:
                                                                  ImageConstant
                                                                      .imgTrashNew,
                                                              height:
                                                                  getSize(32),
                                                              width:
                                                                  getSize(32),
                                                              color:
                                                                  ColorConstant
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
                                            confirmDismiss: (direction) async {
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
                                            onDismissed: (direction) {
                                              budgetNotifier.deleteBudget(
                                                  budget.budgetId);
                                              ref
                                                      .read(refreshKey.notifier)
                                                      .state =
                                                  !ref
                                                      .read(refreshKey.notifier)
                                                      .state;
                                              _onDismissed(index);
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.75,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/gradient (3).png', // Replace with your image file name
                                                    fit: BoxFit.cover,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1, // Adjust this value to achieve the desired overlap
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
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
                                                              color:
                                                                  ColorConstant
                                                                      .gray900,
                                                            )),
                                                        Padding(
                                                          padding: getPadding(
                                                              top: 4),
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
                                                                          color:
                                                                              ColorConstant.gray900,
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
                                                                          color:
                                                                              ColorConstant.gray900,
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
                                                                        'Weekly AI-generated Insights',
                                                                        style: AppStyle
                                                                            .txtManropeSemiBold14
                                                                            .copyWith(
                                                                          color:
                                                                              ColorConstant.gray900,
                                                                        )),
                                                                    Text(
                                                                      'Get weekly insights and recommendations to help you stay on track with your budget.',
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
                                                                          color:
                                                                              ColorConstant.gray900,
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
                                                          padding: getPadding(
                                                              top: 16),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {},
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      getVerticalSize(
                                                                          50),
                                                                  width:
                                                                      getHorizontalSize(
                                                                          100),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ColorConstant
                                                                        .blueA700,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                                            .copyWith(color: ColorConstant.whiteA700),
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: getPadding(
                                    left: 30, right: 30, bottom: 16, top: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Neumorphic(
                                      style: NeumorphicStyle(
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.circular(80)),
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
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // CustomImageView(
                                            //   svgPath: ImageConstant.imgStar1,
                                            //   height: getSize(24),
                                            //   width: getSize(24),
                                            //   color: ColorConstant.whiteA700,
                                            // ),
                                            Text(
                                              'Upgrade to Pro',
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
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Center(
                              child: BannerAdWidget(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: NeumorphicFloatingActionButton(
            style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(60)),
              depth: 0.5,
              // intensity: 9,
              surfaceIntensity: 0.8,
              lightSource: LightSource.top,
              color: ColorConstant.blueA700,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/generator_salary_screen');
            },
            child: Icon(
              Icons.add_rounded,
              color: ColorConstant.whiteA700,
              size: getSize(42),
            ),
            // backgroundColor: ColorConstant.lightBlueA200,
          ),
          floatingActionButtonLocation: CustomFabLocation(),
        ),
      ),
    );
  }

  onTapArrowleft(BuildContext context) {
    Navigator.pop(context);
  }
}

class CustomFabLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Customize the position of the FloatingActionButton here
    final double offsetX = 16.0; // Horizontal offset from the right edge
    final double offsetY = 525.0; // Vertical offset from the bottom edge

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
