import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class TermAndConditionScreen extends StatelessWidget {
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
                    onTap: () => onTapArrowleft8(context)),
                styleType: Style.bgOutlineIndigo50),
            body: Container(
                height: getVerticalSize(712),
                width: double.maxFinite,
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                          padding: getPadding(right: 4),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding: getPadding(top: 15),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("Terms & Conditions",
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
                                                  margin: getMargin(top: 13),
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
                                                  width: getHorizontalSize(321),
                                                  margin: getMargin(
                                                      top: 17, right: 5),
                                                  child: RichText(
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                            text:
                                                                "General terms and conditions (hereinafter referred to as “",
                                                            style: TextStyle(
                                                                color: ColorConstant
                                                                    .blueGray800,
                                                                fontSize:
                                                                    getFontSize(
                                                                        12),
                                                                fontFamily:
                                                                    'Manrope',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2))),
                                                        TextSpan(
                                                            text: "TC",
                                                            style: TextStyle(
                                                                color: ColorConstant
                                                                    .gray900,
                                                                fontSize:
                                                                    getFontSize(
                                                                        12),
                                                                fontFamily:
                                                                    'Helvetica Now Text ',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2))),
                                                        TextSpan(
                                                            text:
                                                                "”) Financial Company (“",
                                                            style: TextStyle(
                                                                color: ColorConstant
                                                                    .blueGray800,
                                                                fontSize:
                                                                    getFontSize(
                                                                        12),
                                                                fontFamily:
                                                                    'Manrope',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2))),
                                                        TextSpan(
                                                            text: "Financial",
                                                            style: TextStyle(
                                                                color: ColorConstant
                                                                    .gray900,
                                                                fontSize:
                                                                    getFontSize(
                                                                        12),
                                                                fontFamily:
                                                                    'Helvetica Now Text ',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2))),
                                                        TextSpan(
                                                            text:
                                                                "”) are terms and conditions regarding the use of services, products, technology, service features provided by Financial including but not limited to the use of applications, all associated websites, Application Programming Interface (API), and all related services (collectively called “",
                                                            style: TextStyle(
                                                                color: ColorConstant
                                                                    .blueGray800,
                                                                fontSize:
                                                                    getFontSize(
                                                                        12),
                                                                fontFamily:
                                                                    'Manrope',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2))),
                                                        TextSpan(
                                                            text:
                                                                "Financial Services",
                                                            style: TextStyle(
                                                                color: ColorConstant
                                                                    .gray900,
                                                                fontSize:
                                                                    getFontSize(
                                                                        12),
                                                                fontFamily:
                                                                    'Helvetica Now Text ',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2))),
                                                        TextSpan(
                                                            text: "”). ",
                                                            style: TextStyle(
                                                                color: ColorConstant
                                                                    .blueGray800,
                                                                fontSize:
                                                                    getFontSize(
                                                                        12),
                                                                fontFamily:
                                                                    'Manrope',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2)))
                                                      ]),
                                                      textAlign:
                                                          TextAlign.left)),
                                              Container(
                                                  width: getHorizontalSize(323),
                                                  margin: getMargin(
                                                      top: 19, right: 3),
                                                  child: Text(
                                                      "Before using Financial Services, it is recommended that you read carefully the entire contents of this TC as well as other documents mentioned in it. By registering as a user, you declare that you have READ, UNDERSTOOD, COMPREHENDED, OBSERVED, AGREED AND ACCEPTED all terms and conditions contained in this TC which become effective and legally binding.",
                                                      maxLines: null,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular12Bluegray800
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.2)))),
                                              Container(
                                                  width: getHorizontalSize(323),
                                                  margin: getMargin(
                                                      top: 17, right: 3),
                                                  child: Text(
                                                      "Financial can upload changes / replace TC on this page periodically. The revised version will take into effect on the effective date of publication. You are responsible for reviewing this TC from time to time. If you do not agree with the changes / replacements of this TC, you must immediately stop using Financial Services. Financial shall not be held liable for your failure to review and agree with the modification and / or replacement of this TC.",
                                                      maxLines: null,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular12Bluegray800
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.2)))),
                                              Padding(
                                                  padding: getPadding(top: 23),
                                                  child: Text("Risk Disclosure",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtHelveticaNowTextBold16
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.4)))),
                                              Padding(
                                                  padding: getPadding(top: 13),
                                                  child: Text(
                                                      "Investment Asset is a risky activity because prices can change significantly over time. Financial is not responsible for changes in exchange rates of assets, the risk of loss from buying, selling, holding, investing, and trading any assets. It is the user’s responsibility to manage the aforementioned risks. Therefore, users are advised to be careful and measure their financial condition and make sure that each user is ready to face risks before making a decision. All decisions regarding crypto asset trading are conscious and independent decisions of the user and there is no coercion whatsoever.",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular12Bluegray8001
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.2)))),
                                              Spacer(),
                                              Text("Guarentee",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold16Gray900
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.4))),
                                              Container(
                                                  width: getHorizontalSize(327),
                                                  margin: getMargin(top: 8),
                                                  child: Text(
                                                      "In connection with the terms and conditions of registration, prospective members declare and guarantee that matters relating to private data / documents / information / statements provided during the registration process on the Financial application are true, original, complete and actual. Users agree to update their data / documents / information / personal statement if any of the information users provided has changed All matters relating to registration in the form of delivering private data / documents / information / statements will be collected by Financial and Financial has the right to verify, maintain confidentiality and use it for the benefit of Financial in accordance with applicable legal provisions without any obligation for Financial to notify, request approval, provide compensation for any reason. Financial will manage and carry out supervision in accordance with procedures determined by Financial. Registered users / verified users agree and authorize Financial to use data / documents / information / statements obtained by Financial.",
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
                                    padding: getPadding(bottom: 1281),
                                    child: SizedBox(
                                        width: getHorizontalSize(6),
                                        child: Divider(
                                            color: ColorConstant.gray100)))
                              ]))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: getVerticalSize(100),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment(0.5, 0.09),
                                  end: Alignment(0.5, 1.08),
                                  colors: [
                                ColorConstant.whiteA70000,
                                ColorConstant.whiteA700
                              ]))))
                ]))));
  }

  onTapArrowleft8(BuildContext context) {
    Navigator.pop(context);
  }
}
