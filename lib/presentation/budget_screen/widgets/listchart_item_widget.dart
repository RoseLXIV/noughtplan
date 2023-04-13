import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:noughtplan/core/app_export.dart';

// ignore: must_be_immutable
class ListchartItemWidget extends StatelessWidget {
  final String category;
  final String amount;

  ListchartItemWidget({
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(
        left: 20,
        top: 9,
        right: 20,
        bottom: 9,
      ),
      decoration: AppDecoration.outlineIndigo501.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 0.1,
                      intensity: 0.9,
                      surfaceIntensity: 0.2,
                      lightSource: LightSource.top,
                      color: ColorConstant.gray50,
                    ),
                    child: Container(
                      height: getVerticalSize(50),
                      width: getSize(150),
                      decoration: AppDecoration.fillGray100.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder8,
                      ),
                      child: Center(
                        child: Text(
                          category,
                          textAlign: TextAlign.center,
                          style: AppStyle.txtManropeSemiBold12.copyWith(
                              letterSpacing: 0.3,
                              color: ColorConstant.black900),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: getPadding(top: 6),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Amount",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeSemiBold10Bluegray300.copyWith(
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
                        amount,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtHelveticaNowTextBold18.copyWith(
                          letterSpacing: getHorizontalSize(
                            0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: getPadding(top: 5),
          ),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 1,
                    intensity: 0.7,
                    surfaceIntensity: 0.5,
                    lightSource: LightSource.top,
                    color: ColorConstant.gray50,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    child: LinearProgressIndicator(
                      value: 0 /
                          double.parse(
                              amount.replaceAll('\$', '').replaceAll(',', '')),
                      minHeight: 10,
                      backgroundColor: ColorConstant.gray50,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: max(
                    0,
                    (MediaQuery.of(context).size.width - 16) *
                            (0 /
                                double.parse(amount
                                    .replaceAll('\$', '')
                                    .replaceAll(',', ''))) -
                        28), // Adjust this value to position the text properly
                child: Text(
                  '\$0.00',
                  textAlign: TextAlign.left,
                  style: AppStyle.txtHelveticaNowTextBold12
                      .copyWith(color: Colors.blue.shade800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
