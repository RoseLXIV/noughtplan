import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_icon_button.dart';

class EnableFaceIdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: Container(
                width: double.maxFinite,
                padding: getPadding(top: 16, bottom: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomImageView(
                          svgPath: ImageConstant.imgCloseGray900,
                          height: getSize(24),
                          width: getSize(24),
                          alignment: Alignment.centerLeft,
                          margin: getMargin(left: 24),
                          onTap: () {
                            onTapImgClose(context);
                          }),
                      Container(
                          height: getVerticalSize(3),
                          width: double.maxFinite,
                          margin: getMargin(top: 16),
                          child:
                              Stack(alignment: Alignment.centerLeft, children: [
                            Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                    width: double.maxFinite,
                                    child:
                                        Divider(color: ColorConstant.gray100))),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                    width: getHorizontalSize(62),
                                    child:
                                        Divider(color: ColorConstant.blueA700)))
                          ])),
                      Padding(
                          padding: getPadding(top: 109),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: getSize(4),
                                    width: getSize(4),
                                    margin: getMargin(top: 117, bottom: 1),
                                    decoration: BoxDecoration(
                                        color: ColorConstant.blue100,
                                        borderRadius: BorderRadius.circular(
                                            getHorizontalSize(2)))),
                                Container(
                                    height: getVerticalSize(122),
                                    width: getHorizontalSize(125),
                                    margin: getMargin(left: 1),
                                    child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                  margin: getMargin(
                                                      left: 3, right: 2),
                                                  padding: getPadding(
                                                      left: 19,
                                                      top: 7,
                                                      right: 19,
                                                      bottom: 7),
                                                  decoration: AppDecoration
                                                      .fillGray100
                                                      .copyWith(
                                                          borderRadius:
                                                              BorderRadiusStyle
                                                                  .circleBorder60),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                            height:
                                                                getVerticalSize(
                                                                    105),
                                                            width:
                                                                getHorizontalSize(
                                                                    82),
                                                            margin: getMargin(
                                                                bottom: 1),
                                                            decoration: BoxDecoration(
                                                                color: ColorConstant
                                                                    .whiteA700,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            getHorizontalSize(4)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: ColorConstant
                                                                          .gray90014,
                                                                      spreadRadius:
                                                                          getHorizontalSize(
                                                                              2),
                                                                      blurRadius:
                                                                          getHorizontalSize(
                                                                              2),
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              8))
                                                                ]))
                                                      ]))),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                  height: getSize(4),
                                                  width: getSize(4),
                                                  margin: getMargin(top: 16),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          ColorConstant.blue100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              getHorizontalSize(
                                                                  2))))),
                                          CustomIconButton(
                                              height: 40,
                                              width: 40,
                                              variant: IconButtonVariant
                                                  .OutlineWhiteA700_1,
                                              alignment: Alignment.bottomRight,
                                              child: CustomImageView(
                                                  svgPath:
                                                      ImageConstant.imgCamera)),
                                          CustomImageView(
                                              svgPath: ImageConstant.imgTrophy,
                                              height: getVerticalSize(60),
                                              width: getHorizontalSize(52),
                                              alignment: Alignment.center),
                                          CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgFavorite,
                                              height: getVerticalSize(10),
                                              width: getHorizontalSize(12),
                                              radius: BorderRadius.circular(
                                                  getHorizontalSize(2)),
                                              alignment: Alignment.topRight,
                                              margin: getMargin(
                                                  top: 24, right: 34)),
                                          Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                  padding:
                                                      getPadding(bottom: 47),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        CustomImageView(
                                                            svgPath:
                                                                ImageConstant
                                                                    .imgMusic,
                                                            height:
                                                                getVerticalSize(
                                                                    10),
                                                            width:
                                                                getHorizontalSize(
                                                                    12),
                                                            radius: BorderRadius
                                                                .circular(
                                                                    getHorizontalSize(
                                                                        2))),
                                                        CustomImageView(
                                                            svgPath:
                                                                ImageConstant
                                                                    .imgFavorite,
                                                            height:
                                                                getVerticalSize(
                                                                    10),
                                                            width:
                                                                getHorizontalSize(
                                                                    12),
                                                            radius: BorderRadius
                                                                .circular(
                                                                    getHorizontalSize(
                                                                        2)),
                                                            margin: getMargin(
                                                                left: 29))
                                                      ]))),
                                          CustomImageView(
                                              svgPath: ImageConstant.imgMusic,
                                              height: getVerticalSize(10),
                                              width: getHorizontalSize(12),
                                              radius: BorderRadius.circular(
                                                  getHorizontalSize(2)),
                                              alignment: Alignment.topLeft,
                                              margin:
                                                  getMargin(left: 36, top: 24))
                                        ])),
                                Container(
                                    height: getSize(4),
                                    width: getSize(4),
                                    margin:
                                        getMargin(left: 8, top: 32, bottom: 86),
                                    decoration: BoxDecoration(
                                        color: ColorConstant.blue100,
                                        borderRadius: BorderRadius.circular(
                                            getHorizontalSize(2))))
                              ])),
                      Padding(
                          padding: getPadding(top: 38),
                          child: Text("Enable Face ID",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtHelveticaNowTextBold24)),
                      Container(
                          width: getHorizontalSize(249),
                          margin: getMargin(top: 10),
                          child: Text(
                              "This help us check that you’re really you. Identity verification is one of the ways we keep secure.",
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: AppStyle.txtManropeRegular14Bluegray500
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.3)))),
                      Spacer(),
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "Enable Face ID",
                          margin: getMargin(left: 24, right: 24))
                    ])),
            bottomNavigationBar: CustomButton(
                height: getVerticalSize(56),
                text: "Skip for Now",
                margin: getMargin(left: 24, right: 24, bottom: 46),
                variant: ButtonVariant.FillIndigo5001,
                fontStyle: ButtonFontStyle.HelveticaNowTextBold16BlueA700)));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
