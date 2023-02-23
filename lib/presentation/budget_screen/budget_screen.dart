import '../budget_screen/widgets/listchart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';

class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        body: Container(
          height: getVerticalSize(
            812,
          ),
          width: double.maxFinite,
          padding: getPadding(
            top: 2,
            bottom: 2,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomImageView(
                svgPath: ImageConstant.imgAppbar,
                height: getVerticalSize(
                  64,
                ),
                width: getHorizontalSize(
                  112,
                ),
                alignment: Alignment.topRight,
                margin: getMargin(
                  top: 42,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: getPadding(
                    left: 27,
                    right: 21,
                    bottom: 1,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: getPadding(
                          left: 6,
                          right: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: getPadding(
                                left: 10,
                                top: 5,
                                right: 10,
                                bottom: 5,
                              ),
                              decoration: AppDecoration.fillGray50.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder12,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: getPadding(
                                      top: 3,
                                    ),
                                    child: Text(
                                      "Danger Zone",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle
                                          .txtManropeSemiBold10Pink400
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
                            Container(
                              padding: getPadding(
                                left: 10,
                                top: 5,
                                right: 10,
                                bottom: 5,
                              ),
                              decoration: AppDecoration.fillGray50.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder12,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: getPadding(
                                      top: 3,
                                    ),
                                    child: Text(
                                      "Impulsive Spender",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle
                                          .txtManropeSemiBold10BlueA700
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
                            CustomButton(
                              height: getVerticalSize(
                                28,
                              ),
                              width: getHorizontalSize(
                                98,
                              ),
                              text: "Moderate Saver",
                              variant: ButtonVariant.FillGray50,
                              padding: ButtonPadding.PaddingAll4,
                              fontStyle: ButtonFontStyle.ManropeSemiBold10,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        child: Container(
                          width: getHorizontalSize(
                            327,
                          ),
                          margin: getMargin(
                            top: 16,
                          ),
                          padding: getPadding(
                            left: 5,
                            top: 8,
                            right: 5,
                            bottom: 8,
                          ),
                          decoration: AppDecoration.outlineGray100.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder12,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: getSize(
                                  275,
                                ),
                                width: getSize(
                                  275,
                                ),
                                margin: getMargin(
                                  top: 9,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: getPadding(
                                                left: 1,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Rent",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtManropeRegular10
                                                            .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
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
                                                      62,
                                                    ),
                                                    text: "0.00%",
                                                    margin: getMargin(
                                                      top: 14,
                                                    ),
                                                    variant: ButtonVariant
                                                        .FillGray900,
                                                    padding:
                                                        ButtonPadding.PaddingT3,
                                                    fontStyle: ButtonFontStyle
                                                        .ManropeSemiBold10WhiteA700,
                                                    prefixWidget: Container(
                                                      margin: getMargin(
                                                        right: 4,
                                                      ),
                                                      child: CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgArrowup,
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
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold24,
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
                                    ),
                                    Align(
                                      alignment: Alignment.center,
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
                                              color:
                                                  ColorConstant.blueGray100E5,
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
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: getSize(
                                          260,
                                        ),
                                        width: getSize(
                                          260,
                                        ),
                                        child: CircularProgressIndicator(
                                          value: 0.5,
                                          backgroundColor:
                                              ColorConstant.blueA700,
                                          color: ColorConstant.gray90002,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: getSize(
                                          260,
                                        ),
                                        width: getSize(
                                          260,
                                        ),
                                        child: CircularProgressIndicator(
                                          value: 0.5,
                                          backgroundColor:
                                              ColorConstant.deepPurpleA400,
                                          color: ColorConstant.gray90002,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: getSize(
                                          260,
                                        ),
                                        width: getSize(
                                          260,
                                        ),
                                        child: CircularProgressIndicator(
                                          value: 0.5,
                                          backgroundColor:
                                              ColorConstant.gray90002,
                                          color: ColorConstant.lightBlueA200,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: getSize(
                                          260,
                                        ),
                                        width: getSize(
                                          260,
                                        ),
                                        child: CircularProgressIndicator(
                                          value: 0.5,
                                          backgroundColor:
                                              ColorConstant.blue900,
                                          color: ColorConstant.gray90002,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  left: 6,
                                  top: 22,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: getHorizontalSize(
                                        54,
                                      ),
                                      margin: getMargin(
                                        top: 2,
                                        bottom: 2,
                                      ),
                                      padding: getPadding(
                                        left: 5,
                                        top: 6,
                                        right: 5,
                                        bottom: 6,
                                      ),
                                      decoration: AppDecoration
                                          .outlineBluegray200e5
                                          .copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: getSize(
                                              12,
                                            ),
                                            width: getSize(
                                              12,
                                            ),
                                            margin: getMargin(
                                              top: 1,
                                              bottom: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.blue900,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                getHorizontalSize(
                                                  2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: getPadding(
                                              left: 8,
                                              top: 1,
                                            ),
                                            child: Text(
                                              "Rent",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle.txtManropeBold10
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
                                    Container(
                                      width: getHorizontalSize(
                                        112,
                                      ),
                                      margin: getMargin(
                                        left: 5,
                                        top: 2,
                                        bottom: 2,
                                      ),
                                      padding: getPadding(
                                        all: 5,
                                      ),
                                      decoration:
                                          AppDecoration.fillGray50.copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: getSize(
                                              12,
                                            ),
                                            width: getSize(
                                              12,
                                            ),
                                            margin: getMargin(
                                              top: 2,
                                              bottom: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.blueA700,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                getHorizontalSize(
                                                  2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: getPadding(
                                              left: 8,
                                              top: 3,
                                            ),
                                            child: Text(
                                              "Transaportation",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeBold10Bluegray300
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
                                    Container(
                                      width: getHorizontalSize(
                                        71,
                                      ),
                                      margin: getMargin(
                                        left: 5,
                                      ),
                                      padding: getPadding(
                                        left: 5,
                                        top: 8,
                                        right: 5,
                                        bottom: 8,
                                      ),
                                      decoration:
                                          AppDecoration.fillGray50.copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: getSize(
                                              12,
                                            ),
                                            width: getSize(
                                              12,
                                            ),
                                            margin: getMargin(
                                              top: 1,
                                              bottom: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  ColorConstant.deepPurpleA400,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                getHorizontalSize(
                                                  2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: getPadding(
                                              left: 8,
                                            ),
                                            child: Text(
                                              "Utilities",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeBold10Bluegray300
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
                                    Container(
                                      width: getHorizontalSize(
                                        59,
                                      ),
                                      margin: getMargin(
                                        left: 5,
                                      ),
                                      padding: getPadding(
                                        top: 7,
                                        bottom: 7,
                                      ),
                                      decoration:
                                          AppDecoration.fillGray50.copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: getSize(
                                              12,
                                            ),
                                            width: getSize(
                                              12,
                                            ),
                                            margin: getMargin(
                                              top: 2,
                                              bottom: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  ColorConstant.lightBlueA200,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                getHorizontalSize(
                                                  2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: getPadding(
                                              left: 8,
                                              top: 3,
                                            ),
                                            child: Text(
                                              "Savings",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeBold10Bluegray300
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
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          top: 29,
                        ),
                        child: Text(
                          "Highlights",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtHelveticaNowTextBold16.copyWith(
                            letterSpacing: getHorizontalSize(
                              0.4,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          top: 8,
                        ),
                        child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: getVerticalSize(
                                1,
                              ),
                            );
                          },
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return ListchartItemWidget();
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
                                        BorderRadiusStyle.roundedBorder12,
                                  ),
                                  child: Stack(
                                    children: [
                                      CustomImageView(
                                        svgPath:
                                            ImageConstant.imgClockWhiteA700,
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
                                svgPath: ImageConstant.imgVolumeBlueGray300,
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
              CustomImageView(
                imagePath: ImageConstant.imgGroup183001,
                height: getVerticalSize(
                  53,
                ),
                width: getHorizontalSize(
                  161,
                ),
                alignment: Alignment.topLeft,
                margin: getMargin(
                  left: 17,
                  top: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
