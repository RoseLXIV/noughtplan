import 'package:flutter_svg/flutter_svg.dart';

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
          child: Stack(
            // alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Transform(
                  transform: Matrix4.identity()..scale(1.0, 1.0, 0.1),
                  alignment: Alignment.center,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgTopographic8309x375,
                    height: MediaQuery.of(context).size.height *
                        0.5, // Set the height to 50% of the screen height
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set the width to the full screen width
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              Padding(
                padding: getPadding(left: 24, top: 16, right: 24),
                child: Container(
                  height: size.height,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomAppBar(
                          height: getVerticalSize(70),
                          leadingWidth: 25,
                          leading: AppbarImage(
                            onTap: () {
                              // Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, '/category_necessary_screen');
                            },
                            height: getSize(24),
                            width: getSize(24),
                            svgPath: ImageConstant.imgArrowleft,
                            margin: getMargin(bottom: 1),
                          ),
                          centerTitle: true,
                          title: AppbarTitle(
                            text: "Allocate Funds",
                          ),
                          actions: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Please read the instructions below',
                                        textAlign: TextAlign.center,
                                        style:
                                            AppStyle.txtHelveticaNowTextBold16,
                                      ),
                                      content: Text(
                                        "In this step, you'll be able to add discretionary categories to your budget. Follow the instructions below:\n\n"
                                        "1. Browse through the available categories or use the search bar to find specific ones that match your interests and lifestyle.\n"
                                        "2. Tap on a category to add it to your chosen categories list. You can always tap again to remove it if needed.\n"
                                        "3. Once you've added all the discretionary categories you want, press the 'Next' button to move on to reviewing your budget.\n\n"
                                        "Remember, these discretionary categories represent your non-essential expenses, such as entertainment, hobbies, and dining out. Adding them thoughtfully will help you create a balanced budget, allowing for personal enjoyment while still managing your finances effectively.",
                                        textAlign: TextAlign.center,
                                        style: AppStyle.txtManropeRegular14,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              // height: getSize(24),
                              //     width: getSize(24),
                              //     svgPath: ImageConstant.imgQuestion,
                              //     margin: getMargin(bottom: 1)
                              child: Container(
                                margin: EdgeInsets.only(bottom: 7),
                                child: SvgPicture.asset(
                                  ImageConstant.imgQuestion,
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                            )
                          ]),
                      Padding(
                        padding: getPadding(
                          top: 19,
                        ),
                        child: Text(
                          "Remaining Funds",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeRegular14.copyWith(
                            letterSpacing: getHorizontalSize(0.3),
                          ),
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 8, bottom: 43),
                        child: Text("\$0",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtHelveticaNowTextBold40),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: getVerticalSize(200),
                left: 0,
                right: 0,
                bottom: getVerticalSize(50),
                child: SingleChildScrollView(
                  padding: getPadding(left: 22, right: 24, bottom: 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Spacer(),
                      Padding(
                        padding: getPadding(right: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: getPadding(top: 2),
                                child: Text("Necessary Expenses",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtHelveticaNowTextBold18
                                        .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.2)))),
                            CustomButton(
                                height: getVerticalSize(28),
                                width: getHorizontalSize(49),
                                text: "Reset",
                                margin: getMargin(bottom: 1),
                                variant: ButtonVariant.OutlineIndigoA100,
                                shape: ButtonShape.RoundedBorder6,
                                padding: ButtonPadding.PaddingAll4,
                                fontStyle: ButtonFontStyle
                                    .HelveticaNowTextBold12BlueA700),
                          ],
                        ),
                      ),
                      Padding(
                          padding: getPadding(top: 14, right: 2),
                          child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: getVerticalSize(16));
                              },
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return ListrentItemWidget();
                              })),
                      Padding(
                        padding: getPadding(top: 33, right: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: getPadding(top: 2),
                                child: Text("Discretionary Expenses",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtHelveticaNowTextBold18
                                        .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.2)))),
                            Container(
                              width: getHorizontalSize(97),
                              margin: getMargin(bottom: 1),
                              // padding: getPadding(
                              //     left: 5, top: 2, right: 5, bottom: 2),
                              // decoration: AppDecoration.txtOutlineIndigoA100
                              //     .copyWith(
                              //         borderRadius:
                              //             BorderRadiusStyle.txtRoundedBorder10),
                              child: CustomButton(
                                  height: getVerticalSize(28),
                                  width: getHorizontalSize(49),
                                  text: "Auto-Assign",
                                  margin: getMargin(bottom: 1),
                                  variant: ButtonVariant.OutlineIndigoA100,
                                  shape: ButtonShape.RoundedBorder6,
                                  padding: ButtonPadding.PaddingAll4,
                                  fontStyle: ButtonFontStyle
                                      .HelveticaNowTextBold12BlueA700),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: getPadding(top: 14, right: 2),
                          child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: getVerticalSize(16));
                              },
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return ListstreamingservicesItemWidget();
                              }))
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: getPadding(left: 24, top: 12, right: 24, bottom: 12),
                  decoration: AppDecoration.outlineBluegray5000c,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomButton(
                        height: getVerticalSize(56),
                        text: "Next",
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }
}
