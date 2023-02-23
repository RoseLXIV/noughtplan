import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

// ignore: must_be_immutable
class ListframefiftysixItemWidget extends StatelessWidget {
  ListframefiftysixItemWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(
        top: 5,
        bottom: 5,
      ),
      decoration: AppDecoration.outlineIndigo50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: getVerticalSize(
              68,
            ),
            width: getHorizontalSize(
              91,
            ),
            margin: getMargin(
              top: 2,
              bottom: 2,
            ),
            decoration: BoxDecoration(
              color: ColorConstant.blueA7007f,
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
          ),
          Padding(
            padding: getPadding(
              top: 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: getVerticalSize(
                    45,
                  ),
                  width: getHorizontalSize(
                    210,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstant.gray100,
                    borderRadius: BorderRadius.circular(
                      getHorizontalSize(
                        12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(
                    top: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: getVerticalSize(
                          7,
                        ),
                        width: getHorizontalSize(
                          147,
                        ),
                        margin: getMargin(
                          top: 3,
                          bottom: 3,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.gray100,
                          borderRadius: BorderRadius.circular(
                            getHorizontalSize(
                              3,
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
                          left: 60,
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
