import '../category_discretionary_screen/widgets/gridicon_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_floating_button.dart';
import 'package:noughtplan/widgets/custom_search_view.dart';

// ignore_for_file: must_be_immutable
class CategoryDiscretionaryScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            resizeToAvoidBottomInset: false,
            body: Container(
                height: size.height,
                width: double.maxFinite,
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: getPadding(left: 24, top: 16, right: 24),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomAppBar(
                                    height: getVerticalSize(25),
                                    leadingWidth: 48,
                                    leading: AppbarImage(
                                        height: getSize(24),
                                        width: getSize(24),
                                        svgPath: ImageConstant.imgArrowleft,
                                        margin: getMargin(left: 24, bottom: 1),
                                        onTap: () => onTapArrowleft2(context)),
                                    centerTitle: true,
                                    title: AppbarTitle(text: "Categories"),
                                    actions: [
                                      AppbarImage(
                                          height: getSize(21),
                                          width: getSize(21),
                                          svgPath: ImageConstant
                                              .imgQuestionBlueGray300,
                                          margin: getMargin(
                                              left: 26,
                                              top: 1,
                                              right: 26,
                                              bottom: 3))
                                    ]),
                                CustomSearchView(
                                    focusNode: FocusNode(),
                                    controller: searchController,
                                    hintText: "Search...",
                                    margin: getMargin(top: 14),
                                    prefix: Container(
                                        margin: getMargin(
                                            left: 16,
                                            top: 18,
                                            right: 12,
                                            bottom: 18),
                                        child: CustomImageView(
                                            svgPath: ImageConstant.imgSearch)),
                                    prefixConstraints: BoxConstraints(
                                        maxHeight: getVerticalSize(56))),
                                Padding(
                                    padding: getPadding(top: 18),
                                    child: Text("Popular Categories",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold16
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.4)))),
                                Padding(
                                    padding: getPadding(top: 21),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: getHorizontalSize(59),
                                              padding: getPadding(
                                                  left: 16,
                                                  top: 10,
                                                  right: 16,
                                                  bottom: 10),
                                              decoration: AppDecoration
                                                  .txtOutlineBlueA700
                                                  .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .txtRoundedBorder10),
                                              child: Text("Rent",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold12
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2)))),
                                          Container(
                                              width: getHorizontalSize(76),
                                              padding: getPadding(
                                                  left: 16,
                                                  top: 9,
                                                  right: 16,
                                                  bottom: 9),
                                              decoration: AppDecoration
                                                  .txtOutlineBlueA700
                                                  .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .txtRoundedBorder10),
                                              child: Text("Utilities",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold12
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2)))),
                                          Container(
                                              width: getHorizontalSize(84),
                                              padding: getPadding(
                                                  left: 16,
                                                  top: 10,
                                                  right: 16,
                                                  bottom: 10),
                                              decoration: AppDecoration
                                                  .txtFillGray50
                                                  .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .txtRoundedBorder10),
                                              child: Text("Car Loan",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold12Bluegray300
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2)))),
                                          Container(
                                              width: getHorizontalSize(72),
                                              padding:
                                                  getPadding(top: 8, bottom: 8),
                                              decoration: AppDecoration
                                                  .txtFillGray50
                                                  .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .txtRoundedBorder10),
                                              child: Text("Mortgage",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold12Bluegray300
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2))))
                                        ])),
                                Padding(
                                    padding: getPadding(top: 24),
                                    child: Text("Budget Category Sectors",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold16
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.4)))),
                                Padding(
                                    padding: getPadding(top: 15),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomButton(
                                              height: getVerticalSize(28),
                                              width: getHorizontalSize(143),
                                              text: "Necessary Exps.",
                                              variant:
                                                  ButtonVariant.FillWhiteA700,
                                              shape: ButtonShape.RoundedBorder6,
                                              padding: ButtonPadding.PaddingT3,
                                              fontStyle: ButtonFontStyle
                                                  .ManropeSemiBold12Bluegray300,
                                              prefixWidget: Container(
                                                  margin: getMargin(right: 8),
                                                  child: CustomImageView(
                                                      svgPath: ImageConstant
                                                          .imgVolume))),
                                          CustomButton(
                                              height: getVerticalSize(28),
                                              width: getHorizontalSize(175),
                                              text: "Discretionary Exps.",
                                              shape: ButtonShape.RoundedBorder6,
                                              padding:
                                                  ButtonPadding.PaddingT3_1,
                                              fontStyle: ButtonFontStyle
                                                  .ManropeSemiBold12,
                                              suffixWidget: Container(
                                                  margin: getMargin(left: 8),
                                                  child: CustomImageView(
                                                      svgPath: ImageConstant
                                                          .imgCartWhiteA700)))
                                        ])),
                                Padding(
                                    padding: getPadding(top: 21),
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                mainAxisExtent:
                                                    getVerticalSize(109),
                                                crossAxisCount: 3,
                                                mainAxisSpacing:
                                                    getHorizontalSize(16),
                                                crossAxisSpacing:
                                                    getHorizontalSize(16)),
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: 9,
                                        itemBuilder: (context, index) {
                                          return GridiconItemWidget();
                                        }))
                              ]))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          margin: getMargin(left: 3),
                          padding: getPadding(
                              left: 21, top: 12, right: 21, bottom: 12),
                          decoration: AppDecoration.outlineBluegray5000c,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomButton(
                                    height: getVerticalSize(56),
                                    text: "Next",
                                    margin: getMargin(bottom: 30))
                              ])))
                ])),
            floatingActionButton: CustomFloatingButton(
                height: 48,
                width: 48,
                child: CustomImageView(
                    svgPath: ImageConstant.imgVideocamera48x48,
                    height: getVerticalSize(24.0),
                    width: getHorizontalSize(24.0)))));
  }

  onTapArrowleft2(BuildContext context) {
    Navigator.pop(context);
  }
}
