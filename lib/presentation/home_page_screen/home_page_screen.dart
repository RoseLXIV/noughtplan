import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';

import '../home_page_screen/widgets/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';

bool hasLoaded = false;

class HomePageScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetNotifier = ref.watch(budgetStateProvider.notifier);

    if (!hasLoaded) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        budgetNotifier.fetchUserBudgets();
      });
      hasLoaded = true;
    }

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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 7,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ],
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
                          height: MediaQuery.of(context).size.height * 0.6,
                          padding: EdgeInsets.only(top: 8),
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            padding: getPadding(top: 5, bottom: 25),
                            // scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: getVerticalSize(16));
                            },
                            itemCount: userBudgets.length,
                            itemBuilder: (context, index) {
                              final budget = userBudgets[index];
                              return Dismissible(
                                key: Key(budget!.budgetId),
                                background: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: getVerticalSize(95),
                                          decoration: BoxDecoration(
                                            color: ColorConstant.redA700,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // SizedBox(width: 25),
                                              Padding(
                                                padding: getPadding(right: 16),
                                                child: CustomImageView(
                                                  svgPath:
                                                      ImageConstant.imgTrashNew,
                                                  height: getSize(32),
                                                  width: getSize(32),
                                                  color:
                                                      ColorConstant.whiteA700,
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
                                            style:
                                                AppStyle.txtManropeRegular14),
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
                                                Navigator.of(context).pop(true),
                                            child: Text('Delete',
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold14
                                                    .copyWith(
                                                  color: ColorConstant.redA700,
                                                )),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                onDismissed: (direction) {
                                  budgetNotifier.deleteBudget(budget.budgetId);
                                },
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/budget_screen',
                                        arguments: budget);
                                  },
                                  child: ListItemWidget(
                                    budgetName: budget.budgetName,
                                    budgetType: budget.budgetType,
                                    totalExpenses: budget.debtExpense.values
                                            .reduce((a, b) => a + b) +
                                        budget.necessaryExpense.values
                                            .reduce((a, b) => a + b) +
                                        budget.discretionaryExpense.values
                                            .reduce((a, b) => a + b),
                                    spendingType: budget.spendingType,
                                    savingType: budget.savingType,
                                    debtType: budget.debtType,
                                  ),
                                ),
                              );
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/generator_salary_screen');
            },
            child: Icon(Icons.add),
            backgroundColor: ColorConstant.lightBlueA200,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }

  onTapArrowleft2(BuildContext context) {
    Navigator.pop(context);
  }
}
