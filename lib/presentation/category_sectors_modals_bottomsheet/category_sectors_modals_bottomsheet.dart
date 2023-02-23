import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';

class CategorySectorsModalsBottomsheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            width: double.maxFinite,
            child: Container(
                width: double.maxFinite,
                padding: getPadding(top: 17, bottom: 17),
                decoration: AppDecoration.fillWhiteA700
                    .copyWith(borderRadius: BorderRadiusStyle.customBorderTL32),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: getVerticalSize(6),
                          width: getHorizontalSize(40),
                          decoration: BoxDecoration(
                              color: ColorConstant.indigo50,
                              borderRadius:
                                  BorderRadius.circular(getHorizontalSize(3)))),
                      Container(
                          width: double.maxFinite,
                          margin: getMargin(top: 16),
                          padding: getPadding(
                              left: 24, top: 3, right: 24, bottom: 3),
                          decoration: AppDecoration.outlineIndigo50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: getPadding(bottom: 11),
                                    child: Text("Housing",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold16
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.4)))),
                                CustomImageView(
                                    svgPath: ImageConstant.imgCloseBlueGray300,
                                    height: getSize(20),
                                    width: getSize(20),
                                    margin: getMargin(bottom: 16),
                                    onTap: () {
                                      onTapImgClose(context);
                                    })
                              ])),
                      Padding(
                          padding: getPadding(left: 50, top: 21, right: 60),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: getHorizontalSize(59),
                                    padding: getPadding(
                                        left: 16,
                                        top: 10,
                                        right: 16,
                                        bottom: 10),
                                    decoration: AppDecoration
                                        .txtOutlineBlueA7001
                                        .copyWith(
                                            borderRadius: BorderRadiusStyle
                                                .txtRoundedBorder10),
                                    child: Text("Rent",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold12
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2)))),
                                Container(
                                    width: getHorizontalSize(76),
                                    margin: getMargin(left: 12),
                                    padding: getPadding(
                                        left: 16, top: 8, right: 16, bottom: 8),
                                    decoration: AppDecoration.txtFillGray50
                                        .copyWith(
                                            borderRadius: BorderRadiusStyle
                                                .txtRoundedBorder10),
                                    child: Text("Parking",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold12Bluegray300
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2)))),
                                Container(
                                    width: getHorizontalSize(106),
                                    margin: getMargin(left: 12),
                                    padding: getPadding(
                                        left: 16, top: 9, right: 16, bottom: 9),
                                    decoration: AppDecoration.txtFillGray50
                                        .copyWith(
                                            borderRadius: BorderRadiusStyle
                                                .txtRoundedBorder10),
                                    child: Text("Property Tax",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold12Bluegray300
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2))))
                              ])),
                      Padding(
                          padding: getPadding(top: 23),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                    height: getVerticalSize(40),
                                    width: getHorizontalSize(117),
                                    text: "House Repairs",
                                    variant: ButtonVariant.FillGray50,
                                    padding: ButtonPadding.PaddingAll9,
                                    fontStyle:
                                        ButtonFontStyle.HelveticaNowTextBold12),
                                CustomButton(
                                    height: getVerticalSize(40),
                                    width: getHorizontalSize(106),
                                    text: "Property Tax",
                                    margin: getMargin(left: 12),
                                    variant: ButtonVariant.FillGray50,
                                    padding: ButtonPadding.PaddingAll9,
                                    fontStyle:
                                        ButtonFontStyle.HelveticaNowTextBold12)
                              ])),
                      Padding(
                          padding: getPadding(top: 23),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                    height: getVerticalSize(40),
                                    width: getHorizontalSize(104),
                                    text: "Renovations",
                                    variant: ButtonVariant.FillGray50,
                                    padding: ButtonPadding.PaddingAll9,
                                    fontStyle:
                                        ButtonFontStyle.HelveticaNowTextBold12),
                                CustomButton(
                                    height: getVerticalSize(40),
                                    width: getHorizontalSize(142),
                                    text: "Mortgage Principle",
                                    margin: getMargin(left: 12),
                                    variant: ButtonVariant.FillGray50,
                                    padding: ButtonPadding.PaddingAll9,
                                    fontStyle:
                                        ButtonFontStyle.HelveticaNowTextBold12)
                              ])),
                      Padding(
                          padding: getPadding(left: 45, top: 23, right: 55),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                    height: getVerticalSize(40),
                                    width: getHorizontalSize(126),
                                    text: "Home Insurance",
                                    variant: ButtonVariant.OutlineBlueA700,
                                    padding: ButtonPadding.PaddingAll9,
                                    fontStyle: ButtonFontStyle
                                        .HelveticaNowTextBold12BlueA700),
                                CustomButton(
                                    height: getVerticalSize(40),
                                    width: getHorizontalSize(136),
                                    text: "Mortgage Interest",
                                    margin: getMargin(left: 12),
                                    variant: ButtonVariant.FillGray50,
                                    padding: ButtonPadding.PaddingAll9,
                                    fontStyle:
                                        ButtonFontStyle.HelveticaNowTextBold12)
                              ])),
                      CustomButton(
                          height: getVerticalSize(40),
                          width: getHorizontalSize(88),
                          text: "Mortgage",
                          margin: getMargin(top: 23),
                          variant: ButtonVariant.FillGray50,
                          padding: ButtonPadding.PaddingAll9,
                          fontStyle: ButtonFontStyle.HelveticaNowTextBold12),
                      Spacer(),
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "Apply",
                          margin: getMargin(left: 24, right: 24, bottom: 25))
                    ]))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
