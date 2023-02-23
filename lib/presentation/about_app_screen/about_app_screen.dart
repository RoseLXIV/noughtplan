import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

class AboutAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: Container(
                width: double.maxFinite,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        top: 18,
                                        right: 24,
                                        bottom: 18),
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
                                              margin: getMargin(top: 41),
                                              onTap: () {
                                                onTapImgArrowleft(context);
                                              }),
                                          Container(
                                              width: getHorizontalSize(236),
                                              margin:
                                                  getMargin(top: 34, right: 90),
                                              child: Text(
                                                  "The Nought Plan - A.I Budgeting Solution",
                                                  maxLines: null,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold24WhiteA700)),
                                          Container(
                                              width: getHorizontalSize(327),
                                              margin: getMargin(top: 7),
                                              child: Text(
                                                  "At NoughtPlan, our mission is to help people achieve their financial goals by providing personalized budgeting and financial planning tools.",
                                                  maxLines: null,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtManropeRegular12Blue100
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2))))
                                        ])))
                          ])),
                      Padding(
                          padding: getPadding(left: 24, top: 24),
                          child: Text("About Us",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtHelveticaNowTextBold18
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.2)))),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                              width: getHorizontalSize(320),
                              margin: getMargin(
                                  left: 24, top: 10, right: 30, bottom: 5),
                              child: Text(
                                  "Our app uses cutting-edge AI technology to analyze your spending habits and provide you with a budget that suits your unique needs. We understand the importance of financial security and take the protection of your data seriously. That's why we employ the highest standards of security to ensure that your personal and financial information is safe and secure. We are committed to helping you take control of your finances and achieving your financial goals. ",
                                  maxLines: null,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtManropeRegular14Bluegray500
                                      .copyWith(
                                          letterSpacing:
                                              getHorizontalSize(0.3)))))
                    ]))));
  }

  onTapImgArrowleft(BuildContext context) {
    Navigator.pop(context);
  }
}
