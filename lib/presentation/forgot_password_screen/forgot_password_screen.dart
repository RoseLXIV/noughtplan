import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class ForgotPasswordScreen extends StatelessWidget {
  TextEditingController inputPasswordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            resizeToAvoidBottomInset: false,
            body: Form(
                key: _formKey,
                child: Container(
                    width: double.maxFinite,
                    padding:
                        getPadding(left: 24, top: 16, right: 24, bottom: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomImageView(
                              svgPath: ImageConstant.imgCloseGray900,
                              height: getSize(24),
                              width: getSize(24),
                              onTap: () {
                                onTapImgClose(context);
                              }),
                          Padding(
                              padding: getPadding(top: 40),
                              child: Text("Create New Password",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtHelveticaNowTextBold24)),
                          Container(
                              width: getHorizontalSize(261),
                              margin: getMargin(top: 10, right: 65),
                              child: Text(
                                  "Your new password must different from previous password.",
                                  maxLines: null,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtManropeRegular14Bluegray500
                                      .copyWith(
                                          letterSpacing:
                                              getHorizontalSize(0.3)))),
                          Container(
                              margin: getMargin(top: 23),
                              padding: getPadding(all: 16),
                              decoration: AppDecoration.outlinePink400.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder12),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomImageView(
                                        svgPath: ImageConstant.imgSignal,
                                        height: getVerticalSize(20),
                                        width: getHorizontalSize(54),
                                        margin: getMargin(top: 2, bottom: 2)),
                                    CustomImageView(
                                        svgPath:
                                            ImageConstant.imgEyeBlueGray300,
                                        height: getSize(24),
                                        width: getSize(24))
                                  ])),
                          Padding(
                              padding: getPadding(top: 14, right: 10),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomImageView(
                                        svgPath: ImageConstant.imgAlertcircle,
                                        height: getSize(16),
                                        width: getSize(16),
                                        margin: getMargin(top: 1, bottom: 18)),
                                    Expanded(
                                        child: Container(
                                            width: getHorizontalSize(292),
                                            margin: getMargin(left: 8),
                                            child: Text(
                                                "Your password is not strong enough. Your password is at least 8 characters.",
                                                maxLines: null,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeRegular12Pink400
                                                    .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                                0.2)))))
                                  ])),
                          CustomTextFormField(
                              focusNode: FocusNode(),
                              controller: inputPasswordController,
                              hintText: "Password",
                              margin: getMargin(top: 17),
                              padding: TextFormFieldPadding.PaddingT16,
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.visiblePassword,
                              suffix: Container(
                                  margin: getMargin(
                                      left: 30, top: 16, right: 16, bottom: 16),
                                  child: CustomImageView(
                                      svgPath:
                                          ImageConstant.imgEyeBlueGray300)),
                              suffixConstraints: BoxConstraints(
                                  maxHeight: getVerticalSize(56)),
                              isObscureText: true),
                          CustomButton(
                              height: getVerticalSize(56),
                              text: "Reset Password",
                              margin: getMargin(top: 33, bottom: 5))
                        ])))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
