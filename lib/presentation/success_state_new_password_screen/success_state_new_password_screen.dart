import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_icon_button.dart';

class SuccessStateNewPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, top: 16, right: 24, bottom: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomImageView(
                          svgPath: ImageConstant.imgCloseGray900,
                          height: getSize(24),
                          width: getSize(24),
                          alignment: Alignment.centerLeft,
                          onTap: () {
                            onTapImgClose(context);
                          }),
                      Spacer(),
                      Row(
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
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Container(
                                                                margin:
                                                                    getMargin(
                                                                        left:
                                                                            19,
                                                                        right:
                                                                            19),
                                                                padding:
                                                                    getPadding(
                                                                        left: 8,
                                                                        top: 9,
                                                                        right:
                                                                            8,
                                                                        bottom:
                                                                            9),
                                                                decoration: AppDecoration
                                                                    .outlineGray90014
                                                                    .copyWith(
                                                                        borderRadius:
                                                                            BorderRadiusStyle
                                                                                .roundedBorder4),
                                                                child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      CustomImageView(
                                                                          svgPath: ImageConstant
                                                                              .imgLock,
                                                                          height: getVerticalSize(
                                                                              28),
                                                                          width: getHorizontalSize(
                                                                              19),
                                                                          margin:
                                                                              getMargin(top: 1)),
                                                                      CustomImageView(
                                                                          svgPath: ImageConstant
                                                                              .imgTicket,
                                                                          height: getVerticalSize(
                                                                              20),
                                                                          width: getHorizontalSize(
                                                                              66),
                                                                          margin:
                                                                              getMargin(top: 12)),
                                                                      CustomImageView(
                                                                          svgPath: ImageConstant
                                                                              .imgTicket,
                                                                          height: getVerticalSize(
                                                                              20),
                                                                          width: getHorizontalSize(
                                                                              66),
                                                                          margin:
                                                                              getMargin(top: 6))
                                                                    ]))),
                                                        CustomIconButton(
                                                            height: 40,
                                                            width: 40,
                                                            variant:
                                                                IconButtonVariant
                                                                    .OutlineWhiteA700,
                                                            padding:
                                                                IconButtonPadding
                                                                    .PaddingAll7,
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: CustomImageView(
                                                                svgPath:
                                                                    ImageConstant
                                                                        .imgCheckmark))
                                                      ])))),
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                              height: getSize(4),
                                              width: getSize(4),
                                              margin: getMargin(top: 16),
                                              decoration: BoxDecoration(
                                                  color: ColorConstant.blue100,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          getHorizontalSize(
                                                              2)))))
                                    ])),
                            Container(
                                height: getSize(4),
                                width: getSize(4),
                                margin:
                                    getMargin(left: 10, top: 32, bottom: 85),
                                decoration: BoxDecoration(
                                    color: ColorConstant.blue100,
                                    borderRadius: BorderRadius.circular(
                                        getHorizontalSize(2))))
                          ]),
                      Padding(
                          padding: getPadding(top: 41),
                          child: Text("Password Updated!",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtHelveticaNowTextBold24)),
                      Container(
                          width: getHorizontalSize(208),
                          margin: getMargin(top: 8, bottom: 229),
                          child: Text(
                              "Your password has been set up successfully.",
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: AppStyle.txtManropeRegular14Bluegray500
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.3))))
                    ])),
            bottomNavigationBar: CustomButton(
                height: getVerticalSize(56),
                text: "Back to Sign In",
                margin: getMargin(left: 24, right: 24, bottom: 46))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
