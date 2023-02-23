import '../budget_skeleton_screen/widgets/listframefiftysix_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

class BudgetSkeletonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        body: Container(
          width: double.maxFinite,
          padding: getPadding(
            top: 2,
            bottom: 2,
          ),
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
                  top: 42,
                ),
              ),
              CustomImageView(
                svgPath: ImageConstant.imgAssetallocation,
                height: getVerticalSize(
                  354,
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
                margin: getMargin(
                  top: 10,
                ),
              ),
              Container(
                height: getVerticalSize(
                  326,
                ),
                width: double.maxFinite,
                margin: getMargin(
                  top: 22,
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: getPadding(
                          left: 24,
                          right: 24,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Highlights",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style:
                                  AppStyle.txtHelveticaNowTextBold16.copyWith(
                                letterSpacing: getHorizontalSize(
                                  0.4,
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
                                  return ListframefiftysixItemWidget();
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
