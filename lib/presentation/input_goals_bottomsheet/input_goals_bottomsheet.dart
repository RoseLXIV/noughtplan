import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class InputGoalsBottomsheet extends StatelessWidget {
  TextEditingController inputEmailController = TextEditingController();

  TextEditingController inputPasswordController = TextEditingController();

  TextEditingController inputPasswordOneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            width: double.maxFinite,
            child: Container(
                width: getHorizontalSize(374),
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
                          margin: getMargin(top: 12),
                          padding: getPadding(
                              left: 23, top: 1, right: 23, bottom: 1),
                          decoration: AppDecoration.outlineIndigo50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: getPadding(left: 1, bottom: 11),
                                    child: Text("Create New Goal",
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
                          hintText: "Goal Name",
                          margin: getMargin(left: 24, top: 24, right: 23)),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: inputPasswordController,
                          hintText: "Amount",
                          margin: getMargin(left: 24, top: 16, right: 23)),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: inputPasswordOneController,
                          hintText: "Funding Date",
                          margin: getMargin(left: 24, top: 16, right: 23),
                          textInputAction: TextInputAction.done),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: getPadding(left: 24, top: 26),
                              child: Text("Goal Icons",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle
                                      .txtHelveticaNowTextBold14Gray900
                                      .copyWith(
                                          letterSpacing:
                                              getHorizontalSize(0.3))))),
                      CustomImageView(
                          svgPath: ImageConstant.imgMenu,
                          height: getVerticalSize(96),
                          width: getHorizontalSize(327),
                          margin: getMargin(top: 1)),
                      CustomImageView(
                          svgPath: ImageConstant.imgMenuIndigo50,
                          height: getVerticalSize(96),
                          width: getHorizontalSize(327)),
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "Apply",
                          margin: getMargin(
                              left: 23, top: 11, right: 24, bottom: 22))
                    ]))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
