import '../debt_statistics_page/widgets/listloandetails_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class DebtStatisticsPage extends StatelessWidget {
  TextEditingController tabController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        appBar: CustomAppBar(
          height: getVerticalSize(
            67,
          ),
          title: Padding(
            padding: getPadding(
              left: 16,
            ),
            child: Row(
              children: [
                CustomTextFormField(
                  width: getHorizontalSize(
                    103,
                  ),
                  focusNode: FocusNode(),
                  controller: tabController,
                  hintText: "Snowball",
                  variant: TextFormFieldVariant.FillBlueA700,
                  shape: TextFormFieldShape.RoundedBorder6,
                  padding: TextFormFieldPadding.PaddingT4,
                  fontStyle: TextFormFieldFontStyle.HelveticaNowTextBold12,
                  prefix: Container(
                    margin: getMargin(
                      left: 10,
                      top: 6,
                      right: 8,
                      bottom: 6,
                    ),
                    child: CustomImageView(
                      svgPath: ImageConstant.imgMusicWhiteA700,
                    ),
                  ),
                  prefixConstraints: BoxConstraints(
                    maxHeight: getVerticalSize(
                      28,
                    ),
                  ),
                ),
                AppbarImage(
                  height: getSize(
                    24,
                  ),
                  width: getSize(
                    24,
                  ),
                  svgPath: ImageConstant.imgCalculator,
                  margin: getMargin(
                    left: 13,
                    top: 2,
                    bottom: 2,
                  ),
                ),
                AppbarSubtitle1(
                  text: "Avalanche",
                  margin: getMargin(
                    left: 8,
                    top: 6,
                    bottom: 4,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            AppbarImage(
              height: getSize(
                24,
              ),
              width: getSize(
                24,
              ),
              svgPath: ImageConstant.imgCall,
              margin: getMargin(
                left: 12,
                top: 16,
                right: 16,
              ),
            ),
            AppbarSubtitle1(
              text: "Consolidate",
              margin: getMargin(
                left: 7,
                top: 20,
                right: 48,
                bottom: 2,
              ),
            ),
          ],
        ),
        body: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: getPadding(
                  left: 26,
                  top: 15,
                  right: 22,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Debt Management",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style:
                              AppStyle.txtManropeRegular16Bluegray500.copyWith(
                            letterSpacing: getHorizontalSize(
                              0.4,
                            ),
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            top: 1,
                          ),
                          child: Text(
                            "\$1,328,124.25",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtHelveticaNowTextBold32,
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            top: 2,
                          ),
                          child: Row(
                            children: [
                              CustomImageView(
                                svgPath: ImageConstant.imgBookmark,
                                height: getSize(
                                  14,
                                ),
                                width: getSize(
                                  14,
                                ),
                                margin: getMargin(
                                  bottom: 3,
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  left: 4,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "10.54% ",
                                        style: TextStyle(
                                          color: ColorConstant.greenA70001,
                                          fontSize: getFontSize(
                                            12,
                                          ),
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: getHorizontalSize(
                                            0.2,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Total Payment : \$65,345.13",
                                        style: TextStyle(
                                          color: ColorConstant.blueGray500,
                                          fontSize: getFontSize(
                                            12,
                                          ),
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: getHorizontalSize(
                                            0.2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgCarloan,
                      height: getVerticalSize(
                        61,
                      ),
                      width: getHorizontalSize(
                        60,
                      ),
                      margin: getMargin(
                        top: 12,
                        bottom: 17,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: getVerticalSize(
                  266,
                ),
                width: double.maxFinite,
                padding: getPadding(
                  left: 21,
                  right: 21,
                ),
                decoration: AppDecoration.fillWhiteA700,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: getPadding(
                          top: 10,
                          right: 3,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "\$2,000,000,00",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeRegular12Bluegray300
                                  .copyWith(
                                letterSpacing: getHorizontalSize(
                                  0.2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                top: 31,
                              ),
                              child: Text(
                                "\$1,000,000.00",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeRegular12Bluegray300
                                    .copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.2,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                top: 31,
                              ),
                              child: Text(
                                "\$500,000.00",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeRegular12Bluegray300
                                    .copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.2,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                top: 31,
                              ),
                              child: Text(
                                "\$250,000.00",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeRegular12Bluegray300
                                    .copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.2,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                top: 31,
                              ),
                              child: Text(
                                "0\$",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeRegular12Bluegray300
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
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: getPadding(
                          left: 3,
                          bottom: 8,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "2023",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeRegular12Bluegray300
                                  .copyWith(
                                letterSpacing: getHorizontalSize(
                                  0.2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 47,
                              ),
                              child: Text(
                                "2024",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeRegular12Bluegray300
                                    .copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.2,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 47,
                              ),
                              child: Text(
                                "2025",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeRegular12Bluegray300
                                    .copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.2,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 47,
                              ),
                              child: Text(
                                "2026 ",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeRegular12Bluegray300
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
                    CustomImageView(
                      svgPath: ImageConstant.imgChartGray100,
                      height: getVerticalSize(
                        34,
                      ),
                      width: getHorizontalSize(
                        276,
                      ),
                      alignment: Alignment.bottomLeft,
                      margin: getMargin(
                        left: 3,
                        bottom: 44,
                      ),
                    ),
                    CustomImageView(
                      svgPath: ImageConstant.imgDivider,
                      height: getVerticalSize(
                        147,
                      ),
                      width: getHorizontalSize(
                        231,
                      ),
                      alignment: Alignment.topLeft,
                      margin: getMargin(
                        top: 18,
                      ),
                    ),
                    CustomImageView(
                      svgPath: ImageConstant.imgVector,
                      height: getVerticalSize(
                        203,
                      ),
                      width: getHorizontalSize(
                        247,
                      ),
                      alignment: Alignment.topLeft,
                      margin: getMargin(
                        left: 1,
                        top: 18,
                      ),
                    ),
                    CustomImageView(
                      svgPath: ImageConstant.imgVectorGreenA700,
                      height: getVerticalSize(
                        204,
                      ),
                      width: getHorizontalSize(
                        216,
                      ),
                      alignment: Alignment.topLeft,
                      margin: getMargin(
                        left: 1,
                        top: 18,
                      ),
                    ),
                    CustomImageView(
                      svgPath: ImageConstant.imgVectorRedA700,
                      height: getVerticalSize(
                        201,
                      ),
                      width: getHorizontalSize(
                        247,
                      ),
                      alignment: Alignment.bottomLeft,
                      margin: getMargin(
                        left: 1,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: getPadding(
                          left: 43,
                          top: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: getPadding(
                                left: 18,
                                top: 6,
                                right: 18,
                                bottom: 6,
                              ),
                              decoration: AppDecoration.fillGray900.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: getPadding(
                                      top: 1,
                                    ),
                                    child: Text(
                                      "\$1,328,124.25",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle
                                          .txtManropeSemiBold10WhiteA700
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
                            SizedBox(
                              width: getHorizontalSize(
                                2,
                              ),
                              child: Divider(
                                color: ColorConstant.gray900,
                              ),
                            ),
                            Container(
                              height: getSize(
                                4,
                              ),
                              width: getSize(
                                4,
                              ),
                              decoration: BoxDecoration(
                                color: ColorConstant.whiteA700,
                                borderRadius: BorderRadius.circular(
                                  getHorizontalSize(
                                    2,
                                  ),
                                ),
                                border: Border.all(
                                  color: ColorConstant.gray900,
                                  width: getHorizontalSize(
                                    2,
                                  ),
                                  strokeAlign: BorderSide.strokeAlignOutside,
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
                  left: 21,
                  top: 5,
                  right: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: getHorizontalSize(
                        99,
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
                      decoration: AppDecoration.fillGray50.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              color: ColorConstant.greenA700,
                              borderRadius: BorderRadius.circular(
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
                              "Personal Plan",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style:
                                  AppStyle.txtManropeBold10Bluegray300.copyWith(
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
                      width: getHorizontalSize(
                        94,
                      ),
                      margin: getMargin(
                        left: 5,
                        top: 2,
                        bottom: 2,
                      ),
                      padding: getPadding(
                        left: 5,
                        top: 6,
                        right: 5,
                        bottom: 6,
                      ),
                      decoration: AppDecoration.fillGray50.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              color: ColorConstant.blue500,
                              borderRadius: BorderRadius.circular(
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
                              "Current Plan",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style:
                                  AppStyle.txtManropeBold10Bluegray300.copyWith(
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
                      width: getHorizontalSize(
                        131,
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
                      decoration: AppDecoration.fillGray50.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              color: ColorConstant.redA700,
                              borderRadius: BorderRadius.circular(
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
                              "Cumulative Interest",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style:
                                  AppStyle.txtManropeBold10Bluegray300.copyWith(
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
              Padding(
                padding: getPadding(
                  top: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: getPadding(
                        top: 5,
                        bottom: 4,
                      ),
                      child: Text(
                        "5Y",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold12Bluegray300
                            .copyWith(
                          letterSpacing: getHorizontalSize(
                            0.2,
                          ),
                        ),
                      ),
                    ),
                    CustomButton(
                      height: getVerticalSize(
                        28,
                      ),
                      width: getHorizontalSize(
                        48,
                      ),
                      text: "4Y",
                      margin: getMargin(
                        left: 24,
                      ),
                      shape: ButtonShape.RoundedBorder6,
                      padding: ButtonPadding.PaddingAll4,
                      fontStyle: ButtonFontStyle.ManropeSemiBold12,
                    ),
                    Padding(
                      padding: getPadding(
                        left: 24,
                        top: 6,
                        bottom: 4,
                      ),
                      child: Text(
                        "2Y",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeSemiBold12.copyWith(
                          letterSpacing: getHorizontalSize(
                            0.2,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(
                        left: 42,
                        top: 6,
                        bottom: 4,
                      ),
                      child: Text(
                        "1Y",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeSemiBold12.copyWith(
                          letterSpacing: getHorizontalSize(
                            0.2,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(
                        left: 39,
                        top: 6,
                        bottom: 4,
                      ),
                      child: Text(
                        "ALL",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeSemiBold12.copyWith(
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
                  left: 20,
                  top: 21,
                  right: 20,
                ),
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: getVerticalSize(
                        8,
                      ),
                    );
                  },
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return ListloandetailsItemWidget();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
