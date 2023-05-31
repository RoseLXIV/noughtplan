import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class PrivacyAndPolicyScreen extends StatelessWidget {
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
                height: getVerticalSize(100),
                leadingWidth: 375,
                leading: CustomImageView(
                    height: getSize(24),
                    width: getSize(24),
                    svgPath: ImageConstant.imgArrowleft,
                    margin:
                        getMargin(left: 28, top: 16, right: 323, bottom: 16),
                    onTap: () => onTapArrowleft7(context)),
                styleType: Style.bgOutlineIndigo50),
            body: Container(
                width: double.maxFinite,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: getPadding(left: 24, top: 8, right: 4),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding: getPadding(top: 18),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("Privacy Policy",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold32),
                                              CustomTextFormField(
                                                  focusNode: FocusNode(),
                                                  controller: dateController,
                                                  hintText:
                                                      "Last update: 12 October 2022",
                                                  margin: getMargin(top: 10),
                                                  shape: TextFormFieldShape
                                                      .RoundedBorder6,
                                                  padding: TextFormFieldPadding
                                                      .PaddingAll8,
                                                  fontStyle:
                                                      TextFormFieldFontStyle
                                                          .ManropeRegular14,
                                                  textInputAction:
                                                      TextInputAction.done),
                                              Container(
                                                  width: getHorizontalSize(313),
                                                  margin: getMargin(
                                                      top: 18, right: 13),
                                                  child: Text(
                                                      "The protection and confidentiality of your personal information is very important to us. Therefore, Financial Company with the website financial.com and the Financial mobile application (hereinafter referred to as “Financial”) set the privacy policy as follows:",
                                                      maxLines: null,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular12Bluegray800
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.2))))
                                            ]))),
                                Padding(
                                    padding: getPadding(bottom: 134),
                                    child: SizedBox(
                                        width: getHorizontalSize(6),
                                        child: Divider(
                                            color: ColorConstant.gray100)))
                              ])),
                      Container(
                          height: getVerticalSize(449),
                          width: double.maxFinite,
                          margin: getMargin(top: 24),
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                        padding:
                                            getPadding(left: 24, right: 28),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("Our Commitment",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold16
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.4))),
                                              Container(
                                                  width: getHorizontalSize(315),
                                                  margin: getMargin(
                                                      top: 11, right: 6),
                                                  child: Text(
                                                      "We collect and use your personal information in accordance with the relevant provisions of the personal data protection law. This privacy policy describes the collection, use, storage and protection of your personal information. This applies to applications, all websites, sites and related services of the Financial regardless of how you access or use it.",
                                                      maxLines: null,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular12Bluegray800
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.2)))),
                                              Padding(
                                                  padding: getPadding(top: 25),
                                                  child: Text(
                                                      "Scope and Approval",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtHelveticaNowTextBold16
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.4)))),
                                              Container(
                                                  width: getHorizontalSize(320),
                                                  margin: getMargin(top: 9),
                                                  child: Text(
                                                      "You accept this privacy policy when you register, access, or use our products, services, content, features, technology or functions offered on the application, all websites, sites and related services (collectively called “Financial Services”). We can upload policy changes on this page periodically, the revised version will take effect on the effective date of publication. You are responsible for reviewing this privacy policy as often as possible.",
                                                      maxLines: null,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular12Bluegray800
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.2)))),
                                              Container(
                                                  width: getHorizontalSize(322),
                                                  margin: getMargin(top: 9),
                                                  child: Text(
                                                      "For the purposes of this privacy policy, we use the term “personal information” to describe information that can be associated with a particular individual and can be used to identify that individual. This privacy policy does not apply to information that is made anonymous so that it cannot identify certain users.",
                                                      maxLines: null,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular12Bluegray800
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.2))))
                                            ]))),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        height: getVerticalSize(100),
                                        width: double.maxFinite,
                                        margin: getMargin(bottom: 3),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment(0.5, 0.09),
                                                end: Alignment(0.5, 1.08),
                                                colors: [
                                              ColorConstant.whiteA70000,
                                              ColorConstant.whiteA700
                                            ]))))
                              ]))
                    ]))));
  }

  onTapArrowleft7(BuildContext context) {
    Navigator.pop(context);
  }
}
