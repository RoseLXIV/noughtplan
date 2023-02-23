import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

// ignore: must_be_immutable
class CutBackItemWidget extends StatelessWidget {
  CutBackItemWidget();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.all(0),
      color: ColorConstant.whiteA700,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: ColorConstant.indigo50,
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
        height: getVerticalSize(
          64,
        ),
        width: getHorizontalSize(
          327,
        ),
        padding: getPadding(
          left: 13,
          top: 10,
          right: 13,
          bottom: 10,
        ),
        decoration: AppDecoration.outlineIndigo502.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder12,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: getPadding(
                  left: 3,
                  top: 7,
                ),
                child: Text(
                  "Streaming Services",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtManropeSemiBold12Gray900.copyWith(
                    letterSpacing: getHorizontalSize(
                      0.2,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: getPadding(
                  right: 3,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "\$945.92",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtHelveticaNowTextBold14Gray900.copyWith(
                        letterSpacing: getHorizontalSize(
                          0.3,
                        ),
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
                        top: 5,
                      ),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: getHorizontalSize(
                                298,
                              ),
                              child: Divider(
                                color: ColorConstant.gray100,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: getPadding(
                                top: 4,
                              ),
                              child: SizedBox(
                                width: getHorizontalSize(
                                  256,
                                ),
                                child: Divider(
                                  color: ColorConstant.greenA70001,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: getPadding(
                                right: 28,
                              ),
                              child: Text(
                                "90%",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold7.copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.2,
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
            ),
          ],
        ),
      ),
    );
  }
}
