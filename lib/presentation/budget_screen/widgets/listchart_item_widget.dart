import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

// ignore: must_be_immutable
class ListchartItemWidget extends StatelessWidget {
  ListchartItemWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(
        top: 3,
        bottom: 3,
      ),
      decoration: AppDecoration.outlineIndigo50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            margin: getMargin(
              top: 3,
              bottom: 3,
            ),
            color: ColorConstant.greenA700A0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  getHorizontalSize(
                    7,
                  ),
                ),
                bottomLeft: Radius.circular(
                  getHorizontalSize(
                    7,
                  ),
                ),
              ),
            ),
            child: Container(
              height: getVerticalSize(
                68,
              ),
              width: getHorizontalSize(
                91,
              ),
              padding: getPadding(
                left: 28,
                top: 17,
                right: 28,
                bottom: 17,
              ),
              decoration: AppDecoration.fillGreenA700a0.copyWith(
                borderRadius: BorderRadiusStyle.customBorderTL7,
              ),
              child: Stack(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgChart33x34,
                    height: getVerticalSize(
                      33,
                    ),
                    width: getHorizontalSize(
                      34,
                    ),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: getPadding(
              top: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: getHorizontalSize(
                    210,
                  ),
                  child: Text(
                    "Three (3) more months savings till Goal Achieved!",
                    maxLines: null,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtHelveticaNowTextMedium14Gray900.copyWith(
                      letterSpacing: getHorizontalSize(
                        0.2,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(
                    top: 11,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: getPadding(
                          top: 1,
                        ),
                        child: Text(
                          "Savings",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style:
                              AppStyle.txtManropeSemiBold10Bluegray500.copyWith(
                            letterSpacing: getHorizontalSize(
                              0.2,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: getSize(
                          4,
                        ),
                        width: getSize(
                          4,
                        ),
                        margin: getMargin(
                          left: 6,
                          top: 5,
                          bottom: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.blueGray100,
                          borderRadius: BorderRadius.circular(
                            getHorizontalSize(
                              2,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          left: 6,
                          top: 1,
                        ),
                        child: Text(
                          "2h ago",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style:
                              AppStyle.txtManropeSemiBold10Bluegray500.copyWith(
                            letterSpacing: getHorizontalSize(
                              0.2,
                            ),
                          ),
                        ),
                      ),
                      CustomImageView(
                        svgPath: ImageConstant.imgCarBlueGray300,
                        height: getSize(
                          14,
                        ),
                        width: getSize(
                          14,
                        ),
                        margin: getMargin(
                          left: 119,
                          bottom: 1,
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
    );
  }
}
