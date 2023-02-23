import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_icon_button.dart';
import 'package:noughtplan/widgets/custom_switch.dart';

class MyAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: Container(
                width: double.maxFinite,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: getVerticalSize(284),
                          width: double.maxFinite,
                          decoration: AppDecoration
                              .gradientDeeppurpleA400DeeppurpleA400,
                          child: Stack(alignment: Alignment.center, children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgRectangle284x375,
                                height: getVerticalSize(284),
                                width: getHorizontalSize(375),
                                alignment: Alignment.center),
                            Align(
                                alignment: Alignment.center,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                              height: getVerticalSize(159),
                                              width: getHorizontalSize(325),
                                              margin: getMargin(top: 44),
                                              child: Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: [
                                                    CustomAppBar(
                                                        height:
                                                            getVerticalSize(24),
                                                        leadingWidth: 48,
                                                        leading: AppbarImage(
                                                            height: getSize(24),
                                                            width: getSize(24),
                                                            svgPath: ImageConstant
                                                                .imgArrowleftWhiteA700,
                                                            margin: getMargin(
                                                                left: 24),
                                                            onTap: () =>
                                                                onTapArrowleft9(
                                                                    context)),
                                                        actions: [
                                                          AppbarImage(
                                                              height:
                                                                  getSize(24),
                                                              width:
                                                                  getSize(24),
                                                              svgPath:
                                                                  ImageConstant
                                                                      .imgEdit,
                                                              margin: getMargin(
                                                                  left: 26,
                                                                  right: 26))
                                                        ]),
                                                    Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Padding(
                                                            padding: getPadding(
                                                                left: 90,
                                                                right: 77),
                                                            child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CustomImageView(
                                                                      imagePath:
                                                                          ImageConstant
                                                                              .imgAvatar,
                                                                      height:
                                                                          getSize(
                                                                              88),
                                                                      width:
                                                                          getSize(
                                                                              88),
                                                                      radius: BorderRadius
                                                                          .circular(
                                                                              getHorizontalSize(44))),
                                                                  Padding(
                                                                      padding: getPadding(
                                                                          top:
                                                                              17),
                                                                      child: Text(
                                                                          "Helena Sarapova",
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          style:
                                                                              AppStyle.txtHelveticaNowTextBold20))
                                                                ]))),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imageNotFound,
                                                        height: getSize(89),
                                                        width: getSize(89),
                                                        alignment:
                                                            Alignment.topCenter,
                                                        margin:
                                                            getMargin(top: 23))
                                                  ])),
                                          Padding(
                                              padding: getPadding(
                                                  left: 20, top: 12, right: 10),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width:
                                                            getHorizontalSize(
                                                                80),
                                                        padding: getPadding(
                                                            left: 10,
                                                            top: 6,
                                                            right: 10,
                                                            bottom: 6),
                                                        decoration: AppDecoration
                                                            .txtFillGray50
                                                            .copyWith(
                                                                borderRadius:
                                                                    BorderRadiusStyle
                                                                        .txtCircleBorder14),
                                                        child: Text(
                                                            "Debt Averse",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtManropeSemiBold10Amber600
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        getHorizontalSize(
                                                                            0.2)))),
                                                    Container(
                                                        width:
                                                            getHorizontalSize(
                                                                112),
                                                        margin:
                                                            getMargin(left: 10),
                                                        padding: getPadding(
                                                            left: 10,
                                                            top: 5,
                                                            right: 10,
                                                            bottom: 5),
                                                        decoration: AppDecoration
                                                            .txtFillGray50
                                                            .copyWith(
                                                                borderRadius:
                                                                    BorderRadiusStyle
                                                                        .txtCircleBorder14),
                                                        child: Text(
                                                            "Impulsive Spender",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtManropeSemiBold10BlueA700
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        getHorizontalSize(
                                                                            0.2)))),
                                                    Container(
                                                        width:
                                                            getHorizontalSize(
                                                                84),
                                                        margin:
                                                            getMargin(left: 10),
                                                        padding: getPadding(
                                                            left: 10,
                                                            top: 5,
                                                            right: 10,
                                                            bottom: 5),
                                                        decoration: AppDecoration
                                                            .txtFillGray50
                                                            .copyWith(
                                                                borderRadius:
                                                                    BorderRadiusStyle
                                                                        .txtCircleBorder14),
                                                        child: Text(
                                                            "High-Income",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtManropeSemiBold10GreenA700
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        getHorizontalSize(
                                                                            0.2))))
                                                  ]))
                                        ])))
                          ])),
                      Container(
                          height: getVerticalSize(593),
                          width: double.maxFinite,
                          margin: getMargin(top: 23),
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                        padding:
                                            getPadding(left: 29, right: 19),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("Settings",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold16
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.4))),
                                              Container(
                                                  margin: getMargin(top: 15),
                                                  padding: getPadding(all: 16),
                                                  decoration: AppDecoration
                                                      .outlineIndigo504
                                                      .copyWith(
                                                          borderRadius:
                                                              BorderRadiusStyle
                                                                  .roundedBorder12),
                                                  child: Row(children: [
                                                    CustomIconButton(
                                                        height: 40,
                                                        width: 40,
                                                        variant:
                                                            IconButtonVariant
                                                                .FillGray50,
                                                        child: CustomImageView(
                                                            svgPath: ImageConstant
                                                                .imgIconsaxlinearmoon)),
                                                    Padding(
                                                        padding: getPadding(
                                                            left: 12,
                                                            top: 11,
                                                            bottom: 10),
                                                        child: Text("Dark Mode",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtHelveticaNowTextBold12Gray900
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        getHorizontalSize(
                                                                            0.2)))),
                                                    Spacer(),
                                                    CustomSwitch(
                                                        margin: getMargin(
                                                            top: 8, bottom: 8),
                                                        value: false,
                                                        onChanged: (value) {})
                                                  ])),
                                              Container(
                                                  margin: getMargin(top: 16),
                                                  padding: getPadding(all: 16),
                                                  decoration: AppDecoration
                                                      .outlineIndigo504
                                                      .copyWith(
                                                          borderRadius:
                                                              BorderRadiusStyle
                                                                  .roundedBorder12),
                                                  child: Row(children: [
                                                    CustomIconButton(
                                                        height: 40,
                                                        width: 40,
                                                        variant:
                                                            IconButtonVariant
                                                                .FillGray50,
                                                        child: CustomImageView(
                                                            svgPath: ImageConstant
                                                                .imgNotification)),
                                                    Padding(
                                                        padding: getPadding(
                                                            left: 12, top: 2),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Push Notifications",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: AppStyle
                                                                      .txtHelveticaNowTextBold12Gray900
                                                                      .copyWith(
                                                                          letterSpacing:
                                                                              getHorizontalSize(0.2))),
                                                              Padding(
                                                                  padding:
                                                                      getPadding(
                                                                          top:
                                                                              4),
                                                                  child: Text(
                                                                      "Notification preferences",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtManropeRegular10Bluegray500
                                                                          .copyWith(
                                                                              letterSpacing: getHorizontalSize(0.2))))
                                                            ])),
                                                    Spacer(),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgArrowright,
                                                        height: getSize(20),
                                                        width: getSize(20),
                                                        margin: getMargin(
                                                            top: 10,
                                                            bottom: 10))
                                                  ])),
                                              Padding(
                                                  padding: getPadding(top: 17),
                                                  child: Text("Others",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtHelveticaNowTextBold16
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.4)))),
                                              Container(
                                                  margin: getMargin(top: 16),
                                                  padding: getPadding(all: 16),
                                                  decoration: AppDecoration
                                                      .outlineIndigo504
                                                      .copyWith(
                                                          borderRadius:
                                                              BorderRadiusStyle
                                                                  .roundedBorder12),
                                                  child: Row(children: [
                                                    CustomIconButton(
                                                        height: 40,
                                                        width: 40,
                                                        variant:
                                                            IconButtonVariant
                                                                .FillGray50,
                                                        child: CustomImageView(
                                                            svgPath: ImageConstant
                                                                .imgQuestionBlueGray30040x40)),
                                                    Padding(
                                                        padding: getPadding(
                                                            left: 12, top: 3),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Help Center",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: AppStyle
                                                                      .txtHelveticaNowTextBold12Gray900
                                                                      .copyWith(
                                                                          letterSpacing:
                                                                              getHorizontalSize(0.2))),
                                                              Padding(
                                                                  padding:
                                                                      getPadding(
                                                                          top:
                                                                              3),
                                                                  child: Text(
                                                                      "Get supports",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtManropeRegular10Bluegray500
                                                                          .copyWith(
                                                                              letterSpacing: getHorizontalSize(0.2))))
                                                            ])),
                                                    Spacer(),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgArrowright,
                                                        height: getSize(20),
                                                        width: getSize(20),
                                                        margin: getMargin(
                                                            top: 10,
                                                            bottom: 10))
                                                  ])),
                                              Container(
                                                  margin: getMargin(top: 16),
                                                  padding: getPadding(all: 16),
                                                  decoration: AppDecoration
                                                      .outlineIndigo504
                                                      .copyWith(
                                                          borderRadius:
                                                              BorderRadiusStyle
                                                                  .roundedBorder12),
                                                  child: Row(children: [
                                                    CustomIconButton(
                                                        height: 40,
                                                        width: 40,
                                                        variant:
                                                            IconButtonVariant
                                                                .FillGray50,
                                                        child: CustomImageView(
                                                            svgPath: ImageConstant
                                                                .imgQuestionBlueGray30040x40)),
                                                    Padding(
                                                        padding: getPadding(
                                                            left: 12, top: 2),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text("About",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: AppStyle
                                                                      .txtHelveticaNowTextBold12Gray900
                                                                      .copyWith(
                                                                          letterSpacing:
                                                                              getHorizontalSize(0.2))),
                                                              Padding(
                                                                  padding:
                                                                      getPadding(
                                                                          top:
                                                                              4),
                                                                  child: Text(
                                                                      "Learn more about TheNoughtPlan",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtManropeRegular10Bluegray500
                                                                          .copyWith(
                                                                              letterSpacing: getHorizontalSize(0.2))))
                                                            ])),
                                                    Spacer(),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgArrowright,
                                                        height: getSize(20),
                                                        width: getSize(20),
                                                        margin: getMargin(
                                                            top: 10,
                                                            bottom: 10))
                                                  ])),
                                              Container(
                                                  margin: getMargin(top: 16),
                                                  padding: getPadding(all: 16),
                                                  decoration: AppDecoration
                                                      .outlineIndigo504
                                                      .copyWith(
                                                          borderRadius:
                                                              BorderRadiusStyle
                                                                  .roundedBorder12),
                                                  child: Row(children: [
                                                    CustomIconButton(
                                                        height: 40,
                                                        width: 40,
                                                        variant:
                                                            IconButtonVariant
                                                                .FillGray50,
                                                        child: CustomImageView(
                                                            svgPath: ImageConstant
                                                                .imgIcon40x40)),
                                                    Padding(
                                                        padding: getPadding(
                                                            left: 12,
                                                            top: 2,
                                                            bottom: 1),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                      "Terms & Conditions",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtHelveticaNowTextBold12Gray900
                                                                          .copyWith(
                                                                              letterSpacing: getHorizontalSize(0.2)))),
                                                              Padding(
                                                                  padding:
                                                                      getPadding(
                                                                          top:
                                                                              3),
                                                                  child: Text(
                                                                      "Our terms & conditions",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtManropeRegular10Bluegray500
                                                                          .copyWith(
                                                                              letterSpacing: getHorizontalSize(0.2))))
                                                            ])),
                                                    Spacer(),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgArrowright,
                                                        height: getSize(20),
                                                        width: getSize(20),
                                                        margin: getMargin(
                                                            top: 10,
                                                            bottom: 10))
                                                  ])),
                                              Container(
                                                  margin: getMargin(top: 16),
                                                  padding: getPadding(all: 16),
                                                  decoration: AppDecoration
                                                      .outlineIndigo504
                                                      .copyWith(
                                                          borderRadius:
                                                              BorderRadiusStyle
                                                                  .roundedBorder12),
                                                  child: Row(children: [
                                                    CustomIconButton(
                                                        height: 40,
                                                        width: 40,
                                                        variant:
                                                            IconButtonVariant
                                                                .FillGray50,
                                                        child: CustomImageView(
                                                            svgPath: ImageConstant
                                                                .imgLockBlueGray300)),
                                                    Padding(
                                                        padding: getPadding(
                                                            left: 12,
                                                            top: 1,
                                                            bottom: 1),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Privacy Policy",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: AppStyle
                                                                      .txtHelveticaNowTextBold12Gray9001
                                                                      .copyWith(
                                                                          letterSpacing:
                                                                              getHorizontalSize(0.2))),
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Padding(
                                                                      padding: getPadding(
                                                                          top:
                                                                              2),
                                                                      child: Text(
                                                                          "Our privacy policy",
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          style: AppStyle
                                                                              .txtManropeRegular10Bluegray5001
                                                                              .copyWith(letterSpacing: getHorizontalSize(0.2)))))
                                                            ])),
                                                    Spacer(),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgArrowright,
                                                        height: getSize(20),
                                                        width: getSize(20),
                                                        margin: getMargin(
                                                            top: 10,
                                                            bottom: 10))
                                                  ]))
                                            ]))),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        height: getVerticalSize(69),
                                        width: double.maxFinite,
                                        margin: getMargin(bottom: 89),
                                        child: Stack(
                                            alignment: Alignment.topCenter,
                                            children: [
                                              Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Container(
                                                      height:
                                                          getVerticalSize(65),
                                                      width: double.maxFinite,
                                                      decoration: BoxDecoration(
                                                          color: ColorConstant
                                                              .whiteA700,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: ColorConstant
                                                                    .blueGray5000a,
                                                                spreadRadius:
                                                                    getHorizontalSize(
                                                                        2),
                                                                blurRadius:
                                                                    getHorizontalSize(
                                                                        2),
                                                                offset: Offset(
                                                                    0, -8))
                                                          ]))),
                                              Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Padding(
                                                      padding: getPadding(
                                                          left: 24,
                                                          right: 24,
                                                          bottom: 25),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            CustomImageView(
                                                                svgPath:
                                                                    ImageConstant
                                                                        .imgSort,
                                                                height:
                                                                    getVerticalSize(
                                                                        44),
                                                                width:
                                                                    getHorizontalSize(
                                                                        48)),
                                                            Spacer(flex: 31),
                                                            CustomImageView(
                                                                svgPath:
                                                                    ImageConstant
                                                                        .imgArrowleftBlueGray300,
                                                                height:
                                                                    getSize(24),
                                                                width:
                                                                    getSize(24),
                                                                margin:
                                                                    getMargin(
                                                                        top: 10,
                                                                        bottom:
                                                                            10)),
                                                            Spacer(flex: 37),
                                                            CustomImageView(
                                                                svgPath:
                                                                    ImageConstant
                                                                        .imgVolumeBlueGray300,
                                                                height:
                                                                    getSize(24),
                                                                width:
                                                                    getSize(24),
                                                                margin:
                                                                    getMargin(
                                                                        top: 10,
                                                                        bottom:
                                                                            10)),
                                                            Spacer(flex: 31),
                                                            Card(
                                                                clipBehavior: Clip
                                                                    .antiAlias,
                                                                elevation: 0,
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(0),
                                                                color:
                                                                    ColorConstant
                                                                        .blueA700,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(getHorizontalSize(
                                                                            10))),
                                                                child:
                                                                    Container(
                                                                        height: getVerticalSize(
                                                                            44),
                                                                        width: getHorizontalSize(
                                                                            48),
                                                                        padding: getPadding(
                                                                            left:
                                                                                12,
                                                                            top:
                                                                                10,
                                                                            right:
                                                                                12,
                                                                            bottom:
                                                                                10),
                                                                        decoration: AppDecoration
                                                                            .fillBlueA700
                                                                            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder8),
                                                                        child: Stack(children: [
                                                                          CustomImageView(
                                                                              svgPath: ImageConstant.imgUserWhiteA700,
                                                                              height: getSize(24),
                                                                              width: getSize(24),
                                                                              alignment: Alignment.center)
                                                                        ])))
                                                          ])))
                                            ])))
                              ])),
                      Spacer(),
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "Log Out",
                          margin: getMargin(left: 24, right: 24),
                          variant: ButtonVariant.FillIndigo5001,
                          fontStyle:
                              ButtonFontStyle.HelveticaNowTextBold16BlueA700)
                    ]))));
  }

  onTapArrowleft9(BuildContext context) {
    Navigator.pop(context);
  }
}
