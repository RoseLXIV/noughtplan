import '../generator_salary_screen/widgets/listdatatypeone_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';

class GeneratorSalaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: Container(
                height: getVerticalSize(812),
                width: double.maxFinite,
                child: Stack(alignment: Alignment.center, children: [
                  CustomImageView(
                      imagePath: ImageConstant.imgTopographic5,
                      height: getVerticalSize(290),
                      width: getHorizontalSize(375),
                      alignment: Alignment.topCenter),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: getPadding(left: 24, right: 24),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomAppBar(
                                    height: getVerticalSize(25),
                                    leadingWidth: 48,
                                    leading: AppbarImage(
                                        height: getSize(24),
                                        width: getSize(24),
                                        svgPath: ImageConstant.imgArrowleft,
                                        margin: getMargin(left: 24, bottom: 1),
                                        onTap: () => onTapArrowleft(context)),
                                    centerTitle: true,
                                    title: AppbarTitle(text: "Salary"),
                                    actions: [
                                      AppbarImage(
                                          height: getSize(24),
                                          width: getSize(24),
                                          svgPath: ImageConstant.imgQuestion,
                                          margin: getMargin(
                                              left: 24, right: 24, bottom: 1))
                                    ]),
                                CustomButton(
                                    height: getVerticalSize(42),
                                    width: getHorizontalSize(143),
                                    text: "Currency",
                                    margin: getMargin(top: 94),
                                    variant: ButtonVariant.FillGray50,
                                    padding: ButtonPadding.PaddingT7,
                                    fontStyle: ButtonFontStyle
                                        .HelveticaNowTextBold16Gray900,
                                    suffixWidget: Container(
                                        margin: getMargin(left: 12),
                                        child: CustomImageView(
                                            svgPath: ImageConstant
                                                .imgCloseAmberA400))),
                                Padding(
                                    padding: getPadding(top: 58),
                                    child: Text("Input your Salary",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold24)),
                                Container(
                                    width: getHorizontalSize(260),
                                    margin:
                                        getMargin(left: 33, top: 7, right: 33),
                                    child: Text(
                                        "\"Your information is secure with us. We use top-notch security measures to protect your personal data.\"",
                                        maxLines: null,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtManropeRegular14Bluegray500
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.3)))),
                                CustomImageView(
                                    svgPath: ImageConstant.imgArrowdown,
                                    height: getSize(24),
                                    width: getSize(24),
                                    margin: getMargin(top: 7)),
                                Padding(
                                    padding: getPadding(
                                        left: 35, top: 22, right: 29),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: getPadding(right: 6),
                                              child: ListView.separated(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return SizedBox(
                                                        height: getVerticalSize(
                                                            27));
                                                  },
                                                  itemCount: 3,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListdatatypeoneItemWidget();
                                                  })),
                                          Padding(
                                              padding:
                                                  getPadding(left: 1, top: 23),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                        padding: getPadding(
                                                            bottom: 4),
                                                        child: Text("*",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtHelveticaNowTextMedium24)),
                                                    Spacer(flex: 51),
                                                    Padding(
                                                        padding:
                                                            getPadding(top: 4),
                                                        child: Text("0",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtHelveticaNowTextMedium24)),
                                                    Spacer(flex: 48),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgOffer,
                                                        height: getSize(28),
                                                        width: getSize(28),
                                                        margin: getMargin(
                                                            top: 7, bottom: 4))
                                                  ]))
                                        ])),
                                CustomButton(
                                    height: getVerticalSize(56),
                                    text: "Next",
                                    margin: getMargin(top: 37))
                              ]))),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: getPadding(top: 118),
                          child: Text("\$999,999,999.00",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtHelveticaNowTextBold40)))
                ]))));
  }

  onTapArrowleft(BuildContext context) {
    Navigator.pop(context);
  }
}
