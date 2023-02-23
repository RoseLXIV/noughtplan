import '../budget_details_screen/widgets/list0_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';

class BudgetDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        body: Container(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgGroup183001,
                height: getVerticalSize(
                  53,
                ),
                width: getHorizontalSize(
                  161,
                ),
                margin: getMargin(
                  left: 14,
                  top: 44,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  margin: getMargin(
                    top: 10,
                  ),
                  color: ColorConstant.whiteA70001,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: ColorConstant.gray100,
                      width: getHorizontalSize(
                        1,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(
                      getHorizontalSize(
                        12,
                      ),
                    ),
                  ),
                  child: Container(
                    height: getSize(
                      327,
                    ),
                    width: getSize(
                      327,
                    ),
                    padding: getPadding(
                      left: 26,
                      top: 17,
                      right: 26,
                      bottom: 17,
                    ),
                    decoration: AppDecoration.outlineGray100.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder12,
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: getPadding(
                              left: 59,
                              right: 58,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: getPadding(
                                    left: 1,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Rent",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtManropeRegular10
                                                .copyWith(
                                              letterSpacing: getHorizontalSize(
                                                0.2,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: getPadding(
                                              top: 3,
                                            ),
                                            child: Text(
                                              "\$70,988.00",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtHelveticaNowTextMedium14
                                                  .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(
                                                  0.3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      CustomButton(
                                        height: getVerticalSize(
                                          24,
                                        ),
                                        width: getHorizontalSize(
                                          46,
                                        ),
                                        text: "0%",
                                        margin: getMargin(
                                          left: 25,
                                          top: 14,
                                        ),
                                        variant: ButtonVariant.FillGray900,
                                        padding: ButtonPadding.PaddingT3,
                                        fontStyle: ButtonFontStyle
                                            .ManropeSemiBold10WhiteA700,
                                        prefixWidget: Container(
                                          margin: getMargin(
                                            right: 4,
                                          ),
                                          child: CustomImageView(
                                            svgPath: ImageConstant
                                                .imgArrowdownWhiteA700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(
                                    top: 5,
                                  ),
                                  child: Text(
                                    "\$300,000.00",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtHelveticaNowTextBold24,
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(
                                    top: 4,
                                  ),
                                  child: Text(
                                    "Total Allocated Amount",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle
                                        .txtManropeRegular10Bluegray500
                                        .copyWith(
                                      letterSpacing: getHorizontalSize(
                                        0.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: getSize(
                              275,
                            ),
                            width: getSize(
                              275,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstant.gray5001,
                              borderRadius: BorderRadius.circular(
                                getHorizontalSize(
                                  137,
                                ),
                              ),
                              border: Border.all(
                                color: ColorConstant.blueGray100,
                                width: getHorizontalSize(
                                  1,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorConstant.blueGray100E5,
                                  spreadRadius: getHorizontalSize(
                                    2,
                                  ),
                                  blurRadius: getHorizontalSize(
                                    2,
                                  ),
                                  offset: Offset(
                                    1,
                                    1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: getPadding(
                              top: 7,
                            ),
                            child: Container(
                              height: getSize(
                                260,
                              ),
                              width: getSize(
                                260,
                              ),
                              child: CircularProgressIndicator(
                                value: 0.5,
                                backgroundColor: ColorConstant.blueA700,
                                color: ColorConstant.gray90002,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: getPadding(
                              top: 7,
                            ),
                            child: Container(
                              height: getSize(
                                260,
                              ),
                              width: getSize(
                                260,
                              ),
                              child: CircularProgressIndicator(
                                value: 0.5,
                                backgroundColor: ColorConstant.deepPurpleA400,
                                color: ColorConstant.gray90002,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: getPadding(
                              top: 7,
                            ),
                            child: Container(
                              height: getSize(
                                260,
                              ),
                              width: getSize(
                                260,
                              ),
                              child: CircularProgressIndicator(
                                value: 0.5,
                                backgroundColor: ColorConstant.gray90002,
                                color: ColorConstant.lightBlueA200,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: getPadding(
                              top: 7,
                            ),
                            child: Container(
                              height: getSize(
                                260,
                              ),
                              width: getSize(
                                260,
                              ),
                              child: CircularProgressIndicator(
                                value: 0.5,
                                backgroundColor: ColorConstant.blue900,
                                color: ColorConstant.gray90002,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: getVerticalSize(
                  512,
                ),
                width: double.maxFinite,
                margin: getMargin(
                  top: 20,
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: getPadding(
                          left: 22,
                          right: 26,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: getPadding(
                                right: 9,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: getPadding(
                                      top: 4,
                                      bottom: 3,
                                    ),
                                    child: Text(
                                      "Funds Details",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtHelveticaNowTextBold16
                                          .copyWith(
                                        letterSpacing: getHorizontalSize(
                                          0.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomButton(
                                    height: getVerticalSize(
                                      32,
                                    ),
                                    width: getHorizontalSize(
                                      116,
                                    ),
                                    text: "Cut-Back Rates",
                                    variant: ButtonVariant.OutlineIndigoA100,
                                    shape: ButtonShape.RoundedBorder6,
                                    padding: ButtonPadding.PaddingAll4,
                                    fontStyle: ButtonFontStyle
                                        .HelveticaNowTextBold12BlueA700,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                top: 16,
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
                                  return List0ItemWidget();
                                },
                              ),
                            ),
                            Container(
                              margin: getMargin(
                                top: 16,
                              ),
                              padding: getPadding(
                                left: 10,
                                top: 9,
                                right: 10,
                                bottom: 9,
                              ),
                              decoration: AppDecoration.fillGray50.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder12,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: getMargin(
                                      left: 6,
                                    ),
                                    padding: getPadding(
                                      left: 8,
                                      top: 11,
                                      right: 8,
                                      bottom: 11,
                                    ),
                                    decoration:
                                        AppDecoration.fillWhiteA700.copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder8,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: getPadding(
                                            top: 4,
                                          ),
                                          child: Text(
                                            "Streaming Services",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold12Gray900
                                                .copyWith(
                                              letterSpacing: getHorizontalSize(
                                                0.2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 2,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Amount",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtManropeSemiBold10Bluegray300
                                              .copyWith(
                                            letterSpacing: getHorizontalSize(
                                              0.2,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                            top: 1,
                                          ),
                                          child: Text(
                                            "\$9287.25",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold18
                                                .copyWith(
                                              letterSpacing: getHorizontalSize(
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
                            Container(
                              margin: getMargin(
                                top: 16,
                              ),
                              padding: getPadding(
                                all: 10,
                              ),
                              decoration:
                                  AppDecoration.outlineBlueA700.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder12,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    height: getVerticalSize(
                                      44,
                                    ),
                                    width: getHorizontalSize(
                                      139,
                                    ),
                                    text: "Credit Card Payment",
                                    margin: getMargin(
                                      left: 6,
                                    ),
                                    variant: ButtonVariant.FillWhiteA700,
                                    shape: ButtonShape.RoundedBorder6,
                                    padding: ButtonPadding.PaddingT12,
                                    fontStyle: ButtonFontStyle
                                        .ManropeSemiBold12Gray900_1,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Amount",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtManropeSemiBold10Bluegray3001
                                            .copyWith(
                                          letterSpacing: getHorizontalSize(
                                            0.2,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: getPadding(
                                          top: 2,
                                        ),
                                        child: Text(
                                          "\$5,035.00",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: AppStyle
                                              .txtHelveticaNowTextBold18Gray900
                                              .copyWith(
                                            letterSpacing: getHorizontalSize(
                                              0.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: getMargin(
                                top: 16,
                              ),
                              padding: getPadding(
                                all: 10,
                              ),
                              decoration:
                                  AppDecoration.outlineBlueA700.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder12,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    height: getVerticalSize(
                                      44,
                                    ),
                                    width: getHorizontalSize(
                                      68,
                                    ),
                                    text: "Car Loan",
                                    margin: getMargin(
                                      left: 6,
                                    ),
                                    variant: ButtonVariant.FillWhiteA700,
                                    shape: ButtonShape.RoundedBorder6,
                                    padding: ButtonPadding.PaddingT12,
                                    fontStyle: ButtonFontStyle
                                        .ManropeSemiBold12Gray900_1,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Amount",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtManropeSemiBold10Bluegray3001
                                            .copyWith(
                                          letterSpacing: getHorizontalSize(
                                            0.2,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: getPadding(
                                          top: 2,
                                        ),
                                        child: Text(
                                          "\$65,195.20",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: AppStyle
                                              .txtHelveticaNowTextBold18Gray900
                                              .copyWith(
                                            letterSpacing: getHorizontalSize(
                                              0.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                        margin: getMargin(
                          bottom: 156,
                        ),
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
                                      color: ColorConstant.blueGray5000a,
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
                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 0,
                                      margin: getMargin(
                                        left: 45,
                                      ),
                                      color: ColorConstant.blueA700,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          getHorizontalSize(
                                            10,
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
                                        decoration:
                                            AppDecoration.fillBlueA700.copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.roundedBorder8,
                                        ),
                                        child: Stack(
                                          children: [
                                            CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgClockWhiteA700,
                                              height: getSize(
                                                24,
                                              ),
                                              width: getSize(
                                                24,
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 45,
                                    ),
                                    CustomImageView(
                                      svgPath:
                                          ImageConstant.imgVolumeBlueGray300,
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
                                    Spacer(
                                      flex: 54,
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
      ),
    );
  }
}
