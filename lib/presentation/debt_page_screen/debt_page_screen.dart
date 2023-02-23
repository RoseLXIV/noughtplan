import '../debt_page_screen/widgets/debtpage_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';

class DebtPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: Container(
                height: getVerticalSize(702),
                width: double.maxFinite,
                child: Stack(alignment: Alignment.topCenter, children: [
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
                                    height: getVerticalSize(169),
                                    leadingWidth: 48,
                                    leading: AppbarImage(
                                        height: getSize(24),
                                        width: getSize(24),
                                        svgPath: ImageConstant.imgArrowleft,
                                        margin: getMargin(left: 24),
                                        onTap: () => onTapArrowleft4(context)),
                                    centerTitle: true,
                                    title: AppbarTitle(text: "Debt/Loan Entry"),
                                    actions: [
                                      AppbarImage(
                                          height: getSize(24),
                                          width: getSize(24),
                                          svgPath: ImageConstant.imgQuestion,
                                          margin:
                                              getMargin(left: 24, right: 24))
                                    ])
                              ]))),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: getPadding(left: 24, top: 110, right: 24),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Debt/Loan Details",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtHelveticaNowTextBold18
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2))),
                                      CustomButton(
                                          height: getVerticalSize(28),
                                          width: getHorizontalSize(49),
                                          text: "Reset",
                                          variant:
                                              ButtonVariant.OutlineIndigoA100,
                                          shape: ButtonShape.RoundedBorder6,
                                          padding: ButtonPadding.PaddingAll4,
                                          fontStyle: ButtonFontStyle
                                              .HelveticaNowTextBold12BlueA700)
                                    ]),
                                Padding(
                                    padding: getPadding(top: 16),
                                    child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                              height: getVerticalSize(16));
                                        },
                                        itemCount: 4,
                                        itemBuilder: (context, index) {
                                          return DebtpageItemWidget();
                                        }))
                              ])))
                ])),
            bottomNavigationBar: Container(
                padding: getPadding(left: 24, top: 12, right: 24, bottom: 12),
                decoration: AppDecoration.outlineBluegray5000c,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "Next",
                          margin: getMargin(bottom: 30))
                    ]))));
  }

  onTapArrowleft4(BuildContext context) {
    Navigator.pop(context);
  }
}
