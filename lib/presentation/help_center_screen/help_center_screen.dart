import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_floating_button.dart';
import 'package:noughtplan/widgets/custom_icon_button.dart';
import 'package:noughtplan/widgets/custom_search_view.dart';

// ignore_for_file: must_be_immutable
class HelpCenterScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            resizeToAvoidBottomInset: false,
            body: Container(
                width: double.maxFinite,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: getVerticalSize(264),
                          width: double.maxFinite,
                          decoration: AppDecoration
                              .gradientDeeppurpleA400DeeppurpleA400,
                          child:
                              Stack(alignment: Alignment.topCenter, children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgRectangle264x375,
                                height: getVerticalSize(264),
                                width: getHorizontalSize(375),
                                alignment: Alignment.center),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    padding: getPadding(
                                        left: 24,
                                        top: 16,
                                        right: 24,
                                        bottom: 16),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                ImageConstant.imgGroup23),
                                            fit: BoxFit.cover)),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgArrowleftWhiteA700,
                                              height: getSize(24),
                                              width: getSize(24),
                                              margin: getMargin(top: 44),
                                              onTap: () {
                                                onTapImgArrowleft(context);
                                              }),
                                          Padding(
                                              padding: getPadding(top: 42),
                                              child: Text(
                                                  "Hi, how can we help?",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold24WhiteA700)),
                                          CustomSearchView(
                                              focusNode: FocusNode(),
                                              controller: searchController,
                                              hintText: "Search...",
                                              margin: getMargin(top: 21),
                                              prefix: Container(
                                                  margin: getMargin(
                                                      left: 16,
                                                      top: 18,
                                                      right: 12,
                                                      bottom: 18),
                                                  child: CustomImageView(
                                                      svgPath: ImageConstant
                                                          .imgSearch)),
                                              prefixConstraints: BoxConstraints(
                                                  maxHeight:
                                                      getVerticalSize(56)))
                                        ])))
                          ])),
                      Container(
                          margin: getMargin(left: 24, top: 24, right: 24),
                          padding: getPadding(all: 24),
                          decoration: AppDecoration.fillGray50.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder12),
                          child: Row(children: [
                            CustomImageView(
                                svgPath: ImageConstant.imgQuestionGreenA700,
                                height: getVerticalSize(48),
                                width: getHorizontalSize(51)),
                            Padding(
                                padding:
                                    getPadding(left: 20, top: 4, bottom: 1),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Frequently Asked Question",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtHelveticaNowTextBold14Gray900
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.3))),
                                      Padding(
                                          padding: getPadding(top: 6),
                                          child: Text(
                                              "Find all the answers to questions",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeRegular10Bluegray500
                                                  .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.2))))
                                    ]))
                          ])),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: getPadding(left: 24, top: 26),
                              child: Text("Community",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle
                                      .txtHelveticaNowTextBold14Gray900
                                      .copyWith(
                                          letterSpacing:
                                              getHorizontalSize(0.3))))),
                      Container(
                          width: getHorizontalSize(327),
                          margin: getMargin(left: 24, top: 6, right: 24),
                          child: Text(
                              "Connect with thousands of the Financial users to discuss and share about investment knowledge.",
                              maxLines: null,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeRegular12Bluegray500
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.2)))),
                      Container(
                          margin: getMargin(left: 24, top: 14, right: 24),
                          padding: getPadding(all: 16),
                          decoration: AppDecoration.outlineIndigo504.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder12),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconButton(
                                    height: 40,
                                    width: 40,
                                    variant: IconButtonVariant.FillIndigo5002,
                                    child: CustomImageView(
                                        svgPath: ImageConstant.imgFile)),
                                Padding(
                                    padding:
                                        getPadding(left: 12, top: 2, bottom: 1),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Discords",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold12Gray900
                                                  .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.2))),
                                          Padding(
                                              padding: getPadding(top: 3),
                                              child: Text("Discord Official",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtManropeRegular10Bluegray500
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2))))
                                        ])),
                                Spacer(),
                                CustomImageView(
                                    svgPath: ImageConstant.imgArrowright,
                                    height: getSize(20),
                                    width: getSize(20),
                                    margin: getMargin(top: 10, bottom: 10))
                              ])),
                      Container(
                          margin: getMargin(
                              left: 24, top: 16, right: 24, bottom: 160),
                          padding: getPadding(all: 16),
                          decoration: AppDecoration.outlineIndigo504.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder12),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconButton(
                                    height: 40,
                                    width: 40,
                                    variant: IconButtonVariant.FillBlue50,
                                    padding: IconButtonPadding.PaddingAll7,
                                    child: CustomImageView(
                                        svgPath:
                                            ImageConstant.imgSendBlueA700)),
                                Padding(
                                    padding: getPadding(left: 12, top: 4),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Telegram",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold12Gray900
                                                  .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.2))),
                                          Padding(
                                              padding: getPadding(top: 3),
                                              child: Text("Telegram Official",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtManropeRegular10Bluegray500
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2))))
                                        ])),
                                Spacer(),
                                CustomImageView(
                                    svgPath: ImageConstant.imgArrowright,
                                    height: getSize(20),
                                    width: getSize(20),
                                    margin: getMargin(top: 10, bottom: 10))
                              ]))
                    ])),
            floatingActionButton: CustomFloatingButton(
                height: 56,
                width: 56,
                variant: FloatingButtonVariant.FillBlueA700,
                shape: FloatingButtonShape.CircleBorder28,
                child: CustomImageView(
                    svgPath: ImageConstant.imgMusicWhiteA70056x56,
                    height: getVerticalSize(28.0),
                    width: getHorizontalSize(28.0)))));
  }

  onTapImgArrowleft(BuildContext context) {
    Navigator.pop(context);
  }
}
