import '../allocate_funds_screen/widgets/listrent_item_widget.dart';
import '../allocate_funds_screen/widgets/liststreamingservices_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';

class AllocateFundsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: Container(
                height: getVerticalSize(812),
                width: double.maxFinite,
                child: Stack(alignment: Alignment.center, children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          padding: getPadding(top: 60, bottom: 60),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ImageConstant.imgGroup23),
                                  fit: BoxFit.cover)),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomAppBar(
                                    height: getVerticalSize(24),
                                    leadingWidth: 48,
                                    leading: AppbarImage(
                                        height: getSize(24),
                                        width: getSize(24),
                                        svgPath: ImageConstant.imgArrowleft,
                                        margin: getMargin(left: 24),
                                        onTap: () => onTapArrowleft3(context)),
                                    centerTitle: true,
                                    title: AppbarTitle(text: "Allocate Funds"),
                                    actions: [
                                      AppbarImage(
                                          height: getSize(24),
                                          width: getSize(24),
                                          svgPath: ImageConstant.imgQuestion,
                                          margin:
                                              getMargin(left: 24, right: 24))
                                    ]),
                                Padding(
                                    padding: getPadding(top: 19),
                                    child: Text("Assigned Funds",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtManropeRegular14
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.3)))),
                                Padding(
                                    padding: getPadding(top: 3, bottom: 43),
                                    child: Text("\$0",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style:
                                            AppStyle.txtHelveticaNowTextBold40))
                              ]))),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: getPadding(
                              left: 22, top: 60, right: 24, bottom: 48),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: getPadding(left: 2),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgArrowleft,
                                              height: getSize(24),
                                              width: getSize(24)),
                                          Text("Allocate Funds",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold16
                                                  .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.4))),
                                          CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgQuestion,
                                              height: getSize(24),
                                              width: getSize(24))
                                        ])),
                                Spacer(),
                                Padding(
                                    padding: getPadding(right: 2),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: getPadding(top: 2),
                                              child: Text("Necessary Expenses",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold18
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2)))),
                                          CustomButton(
                                              height: getVerticalSize(28),
                                              width: getHorizontalSize(49),
                                              text: "Reset",
                                              margin: getMargin(bottom: 1),
                                              variant: ButtonVariant
                                                  .OutlineIndigoA100,
                                              shape: ButtonShape.RoundedBorder6,
                                              padding:
                                                  ButtonPadding.PaddingAll4,
                                              fontStyle: ButtonFontStyle
                                                  .HelveticaNowTextBold12BlueA700)
                                        ])),
                                Padding(
                                    padding: getPadding(top: 14, right: 2),
                                    child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                              height: getVerticalSize(16));
                                        },
                                        itemCount: 4,
                                        itemBuilder: (context, index) {
                                          return ListrentItemWidget();
                                        })),
                                Padding(
                                    padding: getPadding(top: 33, right: 2),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: getPadding(top: 2),
                                              child: Text(
                                                  "Discretionary Expenses",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold18
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2)))),
                                          Container(
                                              width: getHorizontalSize(97),
                                              margin: getMargin(bottom: 1),
                                              padding: getPadding(
                                                  left: 12,
                                                  top: 2,
                                                  right: 12,
                                                  bottom: 2),
                                              decoration: AppDecoration
                                                  .txtOutlineIndigoA100
                                                  .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .txtRoundedBorder10),
                                              child: Text("Auto-Assign",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold12
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2))))
                                        ])),
                                Padding(
                                    padding: getPadding(top: 14, right: 2),
                                    child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                              height: getVerticalSize(16));
                                        },
                                        itemCount: 2,
                                        itemBuilder: (context, index) {
                                          return ListstreamingservicesItemWidget();
                                        }))
                              ]))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding: getPadding(
                              left: 24, top: 12, right: 24, bottom: 12),
                          decoration: AppDecoration.outlineBluegray5000c,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomButton(
                                    height: getVerticalSize(56),
                                    text: "Next",
                                    margin: getMargin(bottom: 30))
                              ])))
                ]))));
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }
}
