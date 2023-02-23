import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class DebtEntryBottomsheet extends StatelessWidget {
  TextEditingController inputEmailController = TextEditingController();

  TextEditingController inputPasswordController = TextEditingController();

  TextEditingController inputPasswordOneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            width: double.maxFinite,
            child: Container(
                width: double.maxFinite,
                padding: getPadding(top: 12, bottom: 12),
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
                          margin: getMargin(top: 12),
                          padding: getPadding(
                              left: 24, top: 1, right: 24, bottom: 1),
                          decoration: AppDecoration.outlineIndigo50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: getPadding(bottom: 11),
                                    child: Text("Auto Loan",
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
                                    margin: getMargin(top: 1, bottom: 13),
                                    onTap: () {
                                      onTapImgClose(context);
                                    })
                              ])),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: inputEmailController,
                          hintText: "Principal Amount",
                          margin: getMargin(left: 24, top: 24, right: 24),
                          padding: TextFormFieldPadding.PaddingT16,
                          suffix: Container(
                              margin: getMargin(
                                  left: 30, top: 16, right: 16, bottom: 16),
                              child: CustomImageView(
                                  svgPath: ImageConstant.imgQuestion)),
                          suffixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: inputPasswordController,
                          hintText: "Monthly Payment",
                          margin: getMargin(left: 24, top: 16, right: 24),
                          padding: TextFormFieldPadding.PaddingT16,
                          suffix: Container(
                              margin: getMargin(
                                  left: 30, top: 16, right: 16, bottom: 16),
                              child: CustomImageView(
                                  svgPath: ImageConstant.imgQuestion)),
                          suffixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: inputPasswordOneController,
                          hintText: "Loan Period (in Years)",
                          margin: getMargin(left: 24, top: 16, right: 24),
                          padding: TextFormFieldPadding.PaddingT16,
                          textInputAction: TextInputAction.done,
                          suffix: Container(
                              margin: getMargin(
                                  left: 30, top: 16, right: 16, bottom: 16),
                              child: CustomImageView(
                                  svgPath: ImageConstant.imgQuestion)),
                          suffixConstraints:
                              BoxConstraints(maxHeight: getVerticalSize(56))),
                      Container(
                          margin: getMargin(left: 24, top: 16, right: 24),
                          padding: getPadding(all: 16),
                          decoration: AppDecoration.fillGray50.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder12),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: getPadding(top: 1),
                                    child: Text("Loan Start Date  ",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtManropeRegular16
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.4)))),
                                CustomImageView(
                                    svgPath:
                                        ImageConstant.imgCalendarBlueGray300,
                                    height: getSize(24),
                                    width: getSize(24))
                              ])),
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "Apply",
                          margin: getMargin(
                              left: 24, top: 35, right: 24, bottom: 29))
                    ]))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
