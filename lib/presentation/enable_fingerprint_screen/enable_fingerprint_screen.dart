import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';

class EnableFingerprintScreen extends StatelessWidget {
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
                      CustomImageView(
                          svgPath: ImageConstant.imgCarousel,
                          height: getVerticalSize(3),
                          width: getHorizontalSize(375),
                          margin: getMargin(top: 16)),
                      Padding(
                          padding: getPadding(top: 109),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: getSize(4),
                                    width: getSize(4),
                                    margin: getMargin(top: 117),
                                    decoration: BoxDecoration(
                                        color: ColorConstant.blue100,
                                        borderRadius: BorderRadius.circular(
                                            getHorizontalSize(2)))),
                                Container(
                                    height: getVerticalSize(120),
                                    width: getHorizontalSize(123),
                                    margin: getMargin(left: 1, bottom: 1),
                                    child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Align(
                                              alignment: Alignment.center,
                                              child: Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  elevation: 0,
                                                  margin: EdgeInsets.all(0),
                                                  color: ColorConstant.gray100,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              getHorizontalSize(
                                                                  60))),
                                                  child: Container(
                                                      height: getSize(120),
                                                      width: getSize(120),
                                                      decoration: AppDecoration
                                                          .fillGray100
                                                          .copyWith(
                                                              borderRadius:
                                                                  BorderRadiusStyle
                                                                      .circleBorder60),
                                                      child: Stack(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          children: [
                                                            Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Container(
                                                                        margin: getMargin(
                                                                            left:
                                                                                19,
                                                                            right:
                                                                                19),
                                                                        padding: getPadding(
                                                                            left:
                                                                                8,
                                                                            top:
                                                                                12,
                                                                            right:
                                                                                8,
                                                                            bottom:
                                                                                12),
                                                                        decoration: AppDecoration.outlineGray90014.copyWith(
                                                                            borderRadius: BorderRadiusStyle
                                                                                .roundedBorder4),
                                                                        child: Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                  width: getHorizontalSize(62),
                                                                                  margin: getMargin(left: 4),
                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                    Expanded(child: CustomImageView(svgPath: ImageConstant.imgMusic, height: getSize(10), width: getSize(10), radius: BorderRadius.circular(getHorizontalSize(2)), margin: getMargin(right: 21))),
                                                                                    Expanded(child: CustomImageView(svgPath: ImageConstant.imgFavorite, height: getSize(10), width: getSize(10), radius: BorderRadius.circular(getHorizontalSize(2)), margin: getMargin(left: 21)))
                                                                                  ])),
                                                                              CustomImageView(svgPath: ImageConstant.imgFingerprint, height: getVerticalSize(48), width: getHorizontalSize(44), alignment: Alignment.center, margin: getMargin(top: 6)),
                                                                              Container(
                                                                                  width: getHorizontalSize(62),
                                                                                  margin: getMargin(left: 4, top: 7),
                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                    Expanded(child: CustomImageView(svgPath: ImageConstant.imgMusic, height: getSize(10), width: getSize(10), radius: BorderRadius.circular(getHorizontalSize(2)), margin: getMargin(right: 21))),
                                                                                    Expanded(child: CustomImageView(svgPath: ImageConstant.imgFavorite, height: getSize(10), width: getSize(10), radius: BorderRadius.circular(getHorizontalSize(2)), margin: getMargin(left: 21)))
                                                                                  ]))
                                                                            ]))),
                                                            Align(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child:
                                                                    Container(
                                                                        height: getVerticalSize(
                                                                            40),
                                                                        width: getHorizontalSize(
                                                                            35),
                                                                        child: Stack(
                                                                            alignment:
                                                                                Alignment.topCenter,
                                                                            children: [
                                                                              CustomImageView(svgPath: ImageConstant.imgClock, height: getVerticalSize(40), width: getHorizontalSize(35), alignment: Alignment.center),
                                                                              CustomImageView(svgPath: ImageConstant.imgLockWhiteA700, height: getSize(20), width: getSize(20), alignment: Alignment.topCenter, margin: getMargin(top: 8))
                                                                            ])))
                                                          ])))),
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
                                                                  2)))))
                                        ])),
                                Container(
                                    height: getSize(4),
                                    width: getSize(4),
                                    margin: getMargin(
                                        left: 10, top: 32, bottom: 85),
                                    decoration: BoxDecoration(
                                        color: ColorConstant.blue100,
                                        borderRadius: BorderRadius.circular(
                                            getHorizontalSize(2))))
                              ])),
                      Padding(
                          padding: getPadding(top: 42),
                          child: Text("Enable Fingerprint",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtHelveticaNowTextBold24)),
                      Container(
                          width: getHorizontalSize(256),
                          margin: getMargin(top: 7),
                          child: Text(
                              "Enable your fingerprint authentication as your security.",
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: AppStyle.txtManropeRegular14Bluegray500
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.3)))),
                      Spacer(),
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "Enable Fingerprint",
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
