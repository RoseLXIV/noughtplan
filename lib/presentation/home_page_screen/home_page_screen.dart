import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';

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

class HomePageScreen extends HookConsumerWidget {
  final ValueNotifier<bool> _isDataFetched = ValueNotifier(false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetNotifier = ref.watch(budgetStateProvider.notifier);
    final dataFetched = ref.watch(dataFetchedProvider.notifier);
    final _budgets = useState<List<Budget?>?>(null);

    useEffect(() {
      Future<void> fetchBudgets() async {
        final fetchedBudgets = await budgetNotifier.fetchUserBudgets();
        _budgets.value = fetchedBudgets;
      }

      fetchBudgets();
      return () {}; // Clean-up function
    }, []);

    final userBudgets = budgetNotifier.state.budgets;
    String? displayName = FirebaseAuth.instance.currentUser?.displayName;
    String? firstName = displayName?.split(' ')[0];

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
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.31,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/gradient (3).png'),
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
                            // await ref.read(authStateProvider.notifier).logOut();
                            Navigator.pop(context);

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
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Transform(
                  transform: Matrix4.identity()..scale(1.0, -1.0, 0.1),
                  alignment: Alignment.center,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgTopographic8309x375,
                    height: MediaQuery.of(context).size.height *
                        0.4, // Set the height to 50% of the screen height
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set the width to the full screen width
                    // alignment: Alignment.,
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                padding: getPadding(left: 30, right: 30, bottom: 11, top: 175),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: getPadding(left: 0, bottom: 10),
                      child: Text(
                        "Welcome back, ${firstName}",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: AppStyle.txtHelveticaNowTextBold20.copyWith(
                          color: ColorConstant.gray200,
                          letterSpacing: getHorizontalSize(1),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: getPadding(bottom: 50),
                    // ),
                    Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          padding: EdgeInsets.only(top: 8),
                          child: Consumer(
                            builder: (context, ref, child) {
                              // final budgetState =
                              //     ref.watch(budgetStateProvider);
                              // final userBudgets = budgetState.budgets;
                              if (_budgets.value == null) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (_budgets.value!.isEmpty) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(12)),
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
                                                  "Press the plus (+) button to add a budget",
                                                  style: AppStyle
                                                      .txtManropeBold12
                                                      .copyWith(
                                                    color: ColorConstant
                                                        .blueGray500,
                                                    letterSpacing:
                                                        getHorizontalSize(1),
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
                                                  height: getVerticalSize(95),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        ColorConstant.redA700,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      // SizedBox(width: 25),
                                                      Padding(
                                                        padding: getPadding(
                                                            right: 16),
                                                        child: CustomImageView(
                                                          svgPath: ImageConstant
                                                              .imgTrashNew,
                                                          height: getSize(32),
                                                          width: getSize(32),
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
                                        direction: DismissDirection.endToStart,
                                        confirmDismiss: (direction) async {
                                          // Show confirmation dialog
                                          return await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Confirm Deletion',
                                                    style: AppStyle
                                                        .txtHelveticaNowTextBold18),
                                                content: Text(
                                                    'Are you sure you want to delete this budget?',
                                                    style: AppStyle
                                                        .txtManropeRegular14),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: Text('Cancel',
                                                        style: AppStyle
                                                            .txtHelveticaNowTextBold14),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child: Text('Delete',
                                                        style: AppStyle
                                                            .txtHelveticaNowTextBold14
                                                            .copyWith(
                                                          color: ColorConstant
                                                              .redA700,
                                                        )),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        onDismissed: (direction) {
                                          budgetNotifier
                                              .deleteBudget(budget.budgetId);
                                        },
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                '/main_budget_home_screen',
                                                arguments: budget);
                                          },
                                          child: ListItemWidget(
                                            budgetName: budget.budgetName,
                                            budgetType: budget.budgetType,
                                            totalExpenses: [
                                              ...?budget.debtExpense?.values,
                                              ...?budget
                                                  .necessaryExpense?.values,
                                              ...?budget
                                                  .discretionaryExpense?.values,
                                            ].fold(0, (a, b) => a + b),
                                            spendingType: budget.spendingType,
                                            savingType: budget.savingType,
                                            debtType: budget.debtType,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
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
              color: ColorConstant.lightBlueA200,
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

  onTapArrowleft2(BuildContext context) {
    Navigator.pop(context);
  }
}

class CustomFabLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Customize the position of the FloatingActionButton here
    final double offsetX = 16.0; // Horizontal offset from the right edge
    final double offsetY = 480.0; // Vertical offset from the bottom edge

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
