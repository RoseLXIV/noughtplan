import '../goal_savings_page/widgets/goalsavings_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_icon_button.dart';

// ignore_for_file: must_be_immutable
class GoalSavingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: getPadding(
                    top: 17,
                    bottom: 1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: getHorizontalSize(
                          327,
                        ),
                        margin: getMargin(
                          left: 25,
                          right: 23,
                        ),
                        padding: getPadding(
                          left: 16,
                          top: 9,
                          right: 16,
                          bottom: 9,
                        ),
                        decoration: AppDecoration.outlineBlueA700.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder12,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: getPadding(
                                top: 2,
                              ),
                              child: Text(
                                "Fund",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeSemiBold10Bluegray300
                                    .copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.2,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                top: 1,
                              ),
                              child: Text(
                                "\$15,000.00",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style:
                                    AppStyle.txtHelveticaNowTextBold18.copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: getMargin(
                          left: 24,
                          top: 8,
                          right: 24,
                        ),
                        decoration: AppDecoration.fillGray900.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder12,
                          image: DecorationImage(
                            image: AssetImage(
                              ImageConstant.imgGroup23,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 0,
                              margin: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  getHorizontalSize(
                                    12,
                                  ),
                                ),
                              ),
                              child: Container(
                                height: getVerticalSize(
                                  177,
                                ),
                                width: getHorizontalSize(
                                  327,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    getHorizontalSize(
                                      12,
                                    ),
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.imgRectangle,
                                      height: getVerticalSize(
                                        177,
                                      ),
                                      width: getHorizontalSize(
                                        327,
                                      ),
                                      radius: BorderRadius.circular(
                                        getHorizontalSize(
                                          12,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: getPadding(
                                          left: 16,
                                          right: 13,
                                          bottom: 9,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: getPadding(
                                                    top: 2,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Funding Goal",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtManropeRegular14Bluegray300
                                                            .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                            0.3,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "\$300,000.00",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtHelveticaNowTextBold32WhiteA700,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                CustomButton(
                                                  height: getVerticalSize(
                                                    24,
                                                  ),
                                                  width: getHorizontalSize(
                                                    93,
                                                  ),
                                                  text: "Emergency  Fund",
                                                  margin: getMargin(
                                                    bottom: 40,
                                                  ),
                                                  variant: ButtonVariant
                                                      .FillIndigoA10001,
                                                  padding:
                                                      ButtonPadding.PaddingAll4,
                                                  fontStyle: ButtonFontStyle
                                                      .ManropeMedium10,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: getPadding(
                                                top: 26,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: getPadding(
                                                      top: 12,
                                                    ),
                                                    child: Text(
                                                      "Fund by April 2026",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular16
                                                          .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                          0.4,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: getVerticalSize(
                                                      34,
                                                    ),
                                                    width: getHorizontalSize(
                                                      105,
                                                    ),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.topRight,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Text(
                                                            "\$156,000.00",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtHelveticaNowTextBold16WhiteA700
                                                                .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                0.4,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Text(
                                                            "Total Funds Needed",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtManropeRegular10
                                                                .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                0.4,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: getVerticalSize(
                                                13,
                                              ),
                                              width: getHorizontalSize(
                                                298,
                                              ),
                                              margin: getMargin(
                                                top: 9,
                                              ),
                                              child: Stack(
                                                alignment: Alignment.centerLeft,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: SizedBox(
                                                      width: getHorizontalSize(
                                                        298,
                                                      ),
                                                      child: Divider(
                                                        color: ColorConstant
                                                            .whiteA700,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: SizedBox(
                                                      width: getHorizontalSize(
                                                        146,
                                                      ),
                                                      child: Divider(
                                                        color: ColorConstant
                                                            .greenA700,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Text(
                                                      "52%",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeSemiBold7
                                                          .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                          0.2,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          left: 31,
                          top: 20,
                          right: 23,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: getPadding(
                                bottom: 1,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomIconButton(
                                    height: 56,
                                    width: 56,
                                    variant: IconButtonVariant.OutlineIndigo50,
                                    shape: IconButtonShape.CircleBorder28,
                                    padding: IconButtonPadding.PaddingAll15,
                                    child: CustomImageView(
                                      svgPath: ImageConstant.imgPlus,
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 12,
                                    ),
                                    child: Text(
                                      "Custom",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle
                                          .txtHelveticaNowTextMedium14BlueA700
                                          .copyWith(
                                        letterSpacing: getHorizontalSize(
                                          0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 15,
                                bottom: 1,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomIconButton(
                                    height: 56,
                                    width: 56,
                                    variant: IconButtonVariant.OutlineIndigo50,
                                    shape: IconButtonShape.CircleBorder28,
                                    padding: IconButtonPadding.PaddingAll15,
                                    child: CustomImageView(
                                      svgPath: ImageConstant.imgVolumeBlack900,
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 12,
                                    ),
                                    child: Text(
                                      "House",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle
                                          .txtHelveticaNowTextMedium14Bluegray500
                                          .copyWith(
                                        letterSpacing: getHorizontalSize(
                                          0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 15,
                                bottom: 1,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomIconButton(
                                    height: 56,
                                    width: 56,
                                    variant: IconButtonVariant.OutlineIndigo50,
                                    shape: IconButtonShape.CircleBorder28,
                                    padding: IconButtonPadding.PaddingAll15,
                                    child: CustomImageView(
                                      svgPath: ImageConstant.imgCarBlack900,
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 12,
                                    ),
                                    child: Text(
                                      "Car",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle
                                          .txtHelveticaNowTextMedium14Bluegray500
                                          .copyWith(
                                        letterSpacing: getHorizontalSize(
                                          0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 15,
                                bottom: 1,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomIconButton(
                                    height: 56,
                                    width: 56,
                                    variant: IconButtonVariant.OutlineIndigo50,
                                    shape: IconButtonShape.CircleBorder28,
                                    padding: IconButtonPadding.PaddingAll15,
                                    child: CustomImageView(
                                      svgPath: ImageConstant.imgMusicBlack900,
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 12,
                                    ),
                                    child: Text(
                                      "E-Fund",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle
                                          .txtHelveticaNowTextMedium14Bluegray500
                                          .copyWith(
                                        letterSpacing: getHorizontalSize(
                                          0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 15,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 0,
                                      margin: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: ColorConstant.indigo50,
                                          width: getHorizontalSize(
                                            1,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          getHorizontalSize(
                                            18,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        height: getVerticalSize(
                                          56,
                                        ),
                                        width: getHorizontalSize(
                                          36,
                                        ),
                                        padding: getPadding(
                                          top: 16,
                                          bottom: 16,
                                        ),
                                        decoration: AppDecoration
                                            .outlineIndigo503
                                            .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.roundedBorder18,
                                        ),
                                        child: Stack(
                                          children: [
                                            CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgTrashBlack900,
                                              height: getVerticalSize(
                                                24,
                                              ),
                                              width: getHorizontalSize(
                                                20,
                                              ),
                                              alignment: Alignment.centerRight,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: getPadding(
                                        top: 13,
                                      ),
                                      child: Text(
                                        "College",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextMedium14Bluegray500
                                            .copyWith(
                                          letterSpacing: getHorizontalSize(
                                            0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: getVerticalSize(
                          316,
                        ),
                        width: double.maxFinite,
                        margin: getMargin(
                          top: 19,
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: getPadding(
                                  left: 27,
                                  right: 21,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Spending Suggestions (ADS)",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtHelveticaNowTextBold16
                                          .copyWith(
                                        letterSpacing: getHorizontalSize(
                                          0.4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(
                                        top: 15,
                                      ),
                                      child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: getVerticalSize(
                                              16,
                                            ),
                                          );
                                        },
                                        itemCount: 3,
                                        itemBuilder: (context, index) {
                                          return GoalsavingsItemWidget();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: getVerticalSize(
                                  69,
                                ),
                                width: double.maxFinite,
                                child: Stack(
                                  alignment: Alignment.topLeft,
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: getVerticalSize(
                                          65,
                                        ),
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                          color: ColorConstant.whiteA700,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  ColorConstant.blueGray5000a,
                                              spreadRadius: getHorizontalSize(
                                                2,
                                              ),
                                              blurRadius: getHorizontalSize(
                                                2,
                                              ),
                                              offset: Offset(
                                                0,
                                                -8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: getPadding(
                                          left: 24,
                                          right: 36,
                                          bottom: 25,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomImageView(
                                              svgPath: ImageConstant.imgSort,
                                              height: getVerticalSize(
                                                44,
                                              ),
                                              width: getHorizontalSize(
                                                48,
                                              ),
                                            ),
                                            CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgArrowleftBlueGray300,
                                              height: getSize(
                                                24,
                                              ),
                                              width: getSize(
                                                24,
                                              ),
                                              margin: getMargin(
                                                top: 10,
                                                bottom: 10,
                                              ),
                                            ),
                                            Card(
                                              clipBehavior: Clip.antiAlias,
                                              elevation: 0,
                                              margin: EdgeInsets.all(0),
                                              color: ColorConstant.blueA700,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  getHorizontalSize(
                                                    8,
                                                  ),
                                                ),
                                              ),
                                              child: Container(
                                                height: getVerticalSize(
                                                  44,
                                                ),
                                                width: getHorizontalSize(
                                                  48,
                                                ),
                                                padding: getPadding(
                                                  left: 12,
                                                  top: 10,
                                                  right: 12,
                                                  bottom: 10,
                                                ),
                                                decoration: AppDecoration
                                                    .fillBlueA700
                                                    .copyWith(
                                                  borderRadius:
                                                      BorderRadiusStyle
                                                          .roundedBorder8,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    CustomImageView(
                                                      svgPath: ImageConstant
                                                          .imgVolumeWhiteA70024x24,
                                                      height: getSize(
                                                        24,
                                                      ),
                                                      width: getSize(
                                                        24,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            CustomImageView(
                                              svgPath: ImageConstant.imgUser,
                                              height: getSize(
                                                24,
                                              ),
                                              width: getSize(
                                                24,
                                              ),
                                              margin: getMargin(
                                                top: 10,
                                                bottom: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
