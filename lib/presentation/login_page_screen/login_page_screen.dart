import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_checkbox.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class LoginPageScreen extends StatelessWidget {
  TextEditingController inputEmailController = TextEditingController();

  TextEditingController inputPasswordController = TextEditingController();

  bool checkbox = false;

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
                    height: size.height,
                    width: double.maxFinite,
                    child: Stack(alignment: Alignment.topCenter, children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: double.maxFinite,
                                    child: Container(
                                        width: double.maxFinite,
                                        padding: getPadding(
                                            left: 24,
                                            top: 16,
                                            right: 24,
                                            bottom: 16),
                                        decoration: AppDecoration.fillWhiteA700,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CustomImageView(
                                                  svgPath:
                                                      ImageConstant.imgClose,
                                                  height: getSize(24),
                                                  width: getSize(24),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  onTap: () {
                                                    onTapImgClose(context);
                                                  }),
                                              Padding(
                                                  padding: getPadding(top: 160),
                                                  child: Text("Welcome Back!",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtHelveticaNowTextBold24)),
                                              Padding(
                                                  padding: getPadding(
                                                      top: 6, bottom: 20),
                                                  child: Text(
                                                      "Sign in to your account",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular14Bluegray300
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.3))))
                                            ]))),
                                CustomTextFormField(
                                    focusNode: FocusNode(),
                                    controller: inputEmailController,
                                    hintText: "Email",
                                    margin:
                                        getMargin(left: 24, top: 24, right: 24),
                                    textInputType: TextInputType.emailAddress),
                                CustomTextFormField(
                                    focusNode: FocusNode(),
                                    controller: inputPasswordController,
                                    hintText: "Password",
                                    margin:
                                        getMargin(left: 24, top: 16, right: 24),
                                    padding: TextFormFieldPadding.PaddingT16,
                                    textInputAction: TextInputAction.done,
                                    textInputType:
                                        TextInputType.visiblePassword,
                                    suffix: Container(
                                        margin: getMargin(
                                            left: 30,
                                            top: 16,
                                            right: 16,
                                            bottom: 16),
                                        child: CustomImageView(
                                            svgPath: ImageConstant
                                                .imgEyeBlueGray300)),
                                    suffixConstraints: BoxConstraints(
                                        maxHeight: getVerticalSize(56)),
                                    isObscureText: true),
                                Padding(
                                    padding: getPadding(
                                        left: 24, top: 24, right: 24),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomCheckbox(
                                              text: "Remember me",
                                              iconSize: getHorizontalSize(16),
                                              value: checkbox,
                                              margin: getMargin(bottom: 1),
                                              fontStyle: CheckboxFontStyle
                                                  .HelveticaNowTextMedium14,
                                              onChange: (value) {
                                                checkbox = value;
                                              }),
                                          Padding(
                                              padding: getPadding(top: 1),
                                              child: Text("Forgot Password?",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold14
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.3))))
                                        ])),
                                CustomButton(
                                    height: getVerticalSize(56),
                                    text: "Sign In",
                                    margin: getMargin(
                                        left: 24, top: 24, right: 24)),
                                Padding(
                                    padding: getPadding(top: 27),
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
                                                  width: getHorizontalSize(44),
                                                  child: Divider(
                                                      color: ColorConstant
                                                          .indigo50))),
                                          Padding(
                                              padding: getPadding(left: 12),
                                              child: Text("Or sign in with",
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  width: getHorizontalSize(44),
                                                  child: Divider(
                                                      color: ColorConstant
                                                          .indigo50)))
                                        ])),
                                Padding(
                                    padding: getPadding(
                                        left: 24, top: 15, right: 24),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomButton(
                                              height: getVerticalSize(55),
                                              width: getHorizontalSize(155),
                                              text: "Facebook",
                                              variant:
                                                  ButtonVariant.OutlineIndigo50,
                                              padding: ButtonPadding.PaddingT14,
                                              fontStyle: ButtonFontStyle
                                                  .HelveticaNowTextBold16Gray900,
                                              prefixWidget: Container(
                                                  margin: getMargin(right: 15),
                                                  child: CustomImageView(
                                                    imagePath: ImageConstant
                                                        .imgFacebook,
                                                  ))),
                                          CustomButton(
                                              height: getVerticalSize(56),
                                              width: getHorizontalSize(155),
                                              text: "Google",
                                              margin: getMargin(left: 16),
                                              variant:
                                                  ButtonVariant.OutlineIndigo50,
                                              padding: ButtonPadding.PaddingT14,
                                              fontStyle: ButtonFontStyle
                                                  .HelveticaNowTextBold16Gray900,
                                              prefixWidget: Container(
                                                  margin: getMargin(right: 15),
                                                  child: CustomImageView(
                                                      svgPath: ImageConstant
                                                          .imgGoogle)))
                                        ])),
                                Padding(
                                    padding: getPadding(top: 29),
                                    child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: "Don’t have an account? ",
                                              style: TextStyle(
                                                  color:
                                                      ColorConstant.blueGray500,
                                                  fontSize: getFontSize(14),
                                                  fontFamily: 'Manrope',
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing:
                                                      getHorizontalSize(0.3))),
                                          TextSpan(
                                              text: "Sign Up",
                                              style: TextStyle(
                                                  color: ColorConstant.blueA700,
                                                  fontSize: getFontSize(14),
                                                  fontFamily:
                                                      'Helvetica Now Text ',
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing:
                                                      getHorizontalSize(0.3)))
                                        ]),
                                        textAlign: TextAlign.left))
                              ])),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              padding: getPadding(
                                  left: 143, top: 40, right: 143, bottom: 123),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage(ImageConstant.Topographic),
                                      fit: BoxFit.none)),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomImageView(
                                        imagePath: ImageConstant.imgGroup182982,
                                        height: getSize(87),
                                        width: getSize(87),
                                        margin: getMargin(top: 52))
                                  ])))
                    ])))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
