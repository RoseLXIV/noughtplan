import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class SignUpEmailScreen extends StatelessWidget {
  TextEditingController inputFullnameController = TextEditingController();

  TextEditingController inputEmailController = TextEditingController();

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
                              padding: getPadding(top: 42),
                              child: Text("Create your account",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtHelveticaNowTextBold24)),
                          Padding(
                              padding: getPadding(top: 8),
                              child: Text(
                                  "Let’s get started with a free Financy account.",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtManropeRegular14.copyWith(
                                      letterSpacing: getHorizontalSize(0.3)))),
                          CustomTextFormField(
                              focusNode: FocusNode(),
                              controller: inputFullnameController,
                              hintText: "Full name",
                              margin: getMargin(top: 24)),
                          CustomTextFormField(
                              focusNode: FocusNode(),
                              controller: inputEmailController,
                              hintText: "Email",
                              margin: getMargin(top: 16),
                              textInputType: TextInputType.emailAddress),
                          CustomTextFormField(
                              focusNode: FocusNode(),
                              controller: inputPasswordController,
                              hintText: "Password",
                              margin: getMargin(top: 16),
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
                              text: "Sign Up",
                              margin: getMargin(top: 24)),
                          Padding(
                              padding: getPadding(top: 16, right: 18),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomImageView(
                                        svgPath: ImageConstant.imgVideocamera,
                                        height: getSize(24),
                                        width: getSize(24),
                                        margin: getMargin(bottom: 17)),
                                    Expanded(
                                        child: Container(
                                            width: getHorizontalSize(276),
                                            margin: getMargin(left: 8, top: 2),
                                            child: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          "I certify that I’m 18 years of age or older, and I agree to the ",
                                                      style: TextStyle(
                                                          color: ColorConstant
                                                              .gray900,
                                                          fontSize:
                                                              getFontSize(12),
                                                          fontFamily: 'Manrope',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2))),
                                                  TextSpan(
                                                      text: "User Agreement",
                                                      style: TextStyle(
                                                          color: ColorConstant
                                                              .blueA700,
                                                          fontSize:
                                                              getFontSize(12),
                                                          fontFamily:
                                                              'Helvetica Now Text ',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2))),
                                                  TextSpan(
                                                      text: " and ",
                                                      style: TextStyle(
                                                          color: ColorConstant
                                                              .gray900,
                                                          fontSize:
                                                              getFontSize(12),
                                                          fontFamily: 'Manrope',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2))),
                                                  TextSpan(
                                                      text: "Privacy Policy.",
                                                      style: TextStyle(
                                                          color: ColorConstant
                                                              .blueA700,
                                                          fontSize:
                                                              getFontSize(12),
                                                          fontFamily:
                                                              'Helvetica Now Text ',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2)))
                                                ]),
                                                textAlign: TextAlign.left)))
                                  ])),
                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: getPadding(top: 26),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding:
                                                getPadding(top: 6, bottom: 9),
                                            child: SizedBox(
                                                width: getHorizontalSize(42),
                                                child: Divider(
                                                    color: ColorConstant
                                                        .indigo50))),
                                        Padding(
                                            padding: getPadding(left: 12),
                                            child: Text("Or sign up with",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeRegular12
                                                    .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                                0.2)))),
                                        Padding(
                                            padding:
                                                getPadding(top: 6, bottom: 9),
                                            child: SizedBox(
                                                width: getHorizontalSize(42),
                                                child: Divider(
                                                    color: ColorConstant
                                                        .indigo50)))
                                      ]))),
                          Padding(
                              padding: getPadding(top: 23),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: CustomButton(
                                            height: getVerticalSize(56),
                                            text: "Apple",
                                            margin: getMargin(right: 8),
                                            variant:
                                                ButtonVariant.OutlineIndigo50,
                                            padding: ButtonPadding.PaddingT14,
                                            fontStyle: ButtonFontStyle
                                                .HelveticaNowTextBold16Gray900,
                                            prefixWidget: Container(
                                                margin: getMargin(right: 8),
                                                child: CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgEye)))),
                                    Expanded(
                                        child: CustomButton(
                                            height: getVerticalSize(56),
                                            text: "Google",
                                            margin: getMargin(left: 8),
                                            variant:
                                                ButtonVariant.OutlineIndigo50,
                                            padding: ButtonPadding.PaddingT14,
                                            fontStyle: ButtonFontStyle
                                                .HelveticaNowTextBold16Gray900,
                                            prefixWidget: Container(
                                                margin: getMargin(right: 8),
                                                child: CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgGoogle))))
                                  ])),
                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: getPadding(top: 73, bottom: 5),
                                  child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "Already h",
                                            style: TextStyle(
                                                color:
                                                    ColorConstant.blueGray500,
                                                fontSize: getFontSize(14),
                                                fontFamily: 'Manrope',
                                                fontWeight: FontWeight.w400,
                                                letterSpacing:
                                                    getHorizontalSize(0.3))),
                                        TextSpan(
                                            text: "ave an account? ",
                                            style: TextStyle(
                                                color:
                                                    ColorConstant.blueGray500,
                                                fontSize: getFontSize(14),
                                                fontFamily: 'Manrope',
                                                fontWeight: FontWeight.w400,
                                                letterSpacing:
                                                    getHorizontalSize(0.3))),
                                        TextSpan(
                                            text: "Sign In",
                                            style: TextStyle(
                                                color: ColorConstant.blueA700,
                                                fontSize: getFontSize(14),
                                                fontFamily:
                                                    'Helvetica Now Text ',
                                                fontWeight: FontWeight.w700,
                                                letterSpacing:
                                                    getHorizontalSize(0.3)))
                                      ]),
                                      textAlign: TextAlign.left)))
                        ])))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
