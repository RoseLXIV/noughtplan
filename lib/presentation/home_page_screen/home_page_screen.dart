import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';

import '../home_page_screen/widgets/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';

class HomePageScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: ColorConstant.whiteA700,
            appBar: CustomAppBar(
                height: getVerticalSize(100),
                leadingWidth: 48,
                leading: AppbarImage(
                  height: getSize(24),
                  width: getSize(24),
                  svgPath: ImageConstant.imgArrowleft,
                  margin: getMargin(left: 24, top: 15, bottom: 10, right: 0),
                  onTap: () async {
                    await ref.read(authStateProvider.notifier).logOut();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Logged out successfully!',
                          textAlign: TextAlign.center,
                          style: AppStyle.txtHelveticaNowTextBold16WhiteA700
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
                title: AppbarTitle(text: "Budget Profiles"),
                actions: [
                  AppbarImage(
                      height: getSize(24),
                      width: getSize(24),
                      svgPath: ImageConstant.imgPlus,
                      margin: getMargin(left: 0, bottom: 2, right: 25),
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/generator_salary_screen');
                      }),
                  AppbarImage(
                      height: getSize(24),
                      width: getSize(24),
                      svgPath: ImageConstant.imgSettings,
                      margin: getMargin(left: 0, bottom: 1, right: 25))
                ]),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, right: 24, bottom: 11),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        hintText: 'Search...',
                        prefix: CustomImageView(
                            svgPath: ImageConstant.imgSearch,
                            margin: getMargin(bottom: 1, right: 12, left: 12)),
                        prefixConstraints:
                            BoxConstraints(maxHeight: getVerticalSize(56)),
                      ),
                      Padding(
                          padding: getPadding(top: 25),
                          child: Text("Zero-Based Budgets",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtHelveticaNowTextBold16
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.4)))),
                      Container(
                          height: getVerticalSize(150),
                          child: ListView.separated(
                              padding: getPadding(top: 14),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: getVerticalSize(16));
                              },
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return ListItemWidget();
                              })),
                      Padding(
                          padding: getPadding(left: 5, top: 24),
                          child: Text("Pay Yourself First Budgets",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtHelveticaNowTextBold16
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.4)))),
                      Container(
                          width: getHorizontalSize(160),
                          margin: getMargin(top: 14),
                          padding: getPadding(all: 16),
                          decoration: AppDecoration.fillBlue900.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder12),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: getPadding(top: 2),
                                    child: Text("My First Budget",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold14WhiteA700
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.3)))),
                                Padding(
                                    padding: getPadding(top: 1),
                                    child: Text("Created: Mar 14, 2023",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtManropeRegular10
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2)))),
                                Padding(
                                    padding: getPadding(top: 27),
                                    child: Text("\$238,285.00",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold12WhiteA700
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2)))),
                                Padding(
                                    padding: getPadding(top: 3),
                                    child: Row(children: [
                                      CustomImageView(
                                          svgPath: ImageConstant.imgArrowup,
                                          height: getSize(12),
                                          width: getSize(12),
                                          margin: getMargin(bottom: 1)),
                                      Padding(
                                          padding: getPadding(left: 4),
                                          child: Text("Cut-back: 2.56%",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeSemiBold10IndigoA100
                                                  .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.2))))
                                    ]))
                              ])),
                      Padding(
                          padding: getPadding(left: 5, top: 24),
                          child: Text("Envelope Budgets",
                              overflow: TextOverflow.ellipsis,
                              style: AppStyle.txtHelveticaNowTextBold16
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.4)))),
                      Container(
                          width: getHorizontalSize(160),
                          margin: getMargin(top: 14),
                          padding: getPadding(all: 16),
                          decoration: AppDecoration.fillBlue900.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder12),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: getPadding(top: 2),
                                    child: Text("My First Budget",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold14WhiteA700
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.3)))),
                                Padding(
                                    padding: getPadding(top: 1),
                                    child: Text("Created: Mar 14, 2023",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtManropeRegular10
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2)))),
                                Padding(
                                    padding: getPadding(top: 27),
                                    child: Text("\$238,285.00",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold12WhiteA700
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2)))),
                                Padding(
                                    padding: getPadding(top: 3),
                                    child: Row(children: [
                                      CustomImageView(
                                          svgPath: ImageConstant.imgArrowup,
                                          height: getSize(12),
                                          width: getSize(12),
                                          margin: getMargin(bottom: 1)),
                                      Padding(
                                          padding: getPadding(left: 4),
                                          child: Text("Cut-back: 2.56%",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeSemiBold10IndigoA100
                                                  .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.2))))
                                    ]))
                              ]))
                    ]))));
  }

  onTapArrowleft2(BuildContext context) {
    Navigator.pop(context);
  }
}
