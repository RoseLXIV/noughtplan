import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_icon_button.dart';
import 'package:noughtplan/widgets/custom_switch.dart';

// ignore: must_be_immutable
class ListtrashItemWidget extends StatelessWidget {
  ListtrashItemWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(
        all: 16,
      ),
      decoration: AppDecoration.outlineIndigo504.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            height: 40,
            width: 40,
            variant: IconButtonVariant.FillGray50,
            child: CustomImageView(
              svgPath: ImageConstant.imgTrashBlueGray300,
            ),
          ),
          Padding(
            padding: getPadding(
              left: 12,
              top: 2,
              bottom: 1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "News",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtHelveticaNowTextBold12Gray900.copyWith(
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
                    "Receive notification for news",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtManropeRegular10Bluegray500.copyWith(
                      letterSpacing: getHorizontalSize(
                        0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          CustomSwitch(
            margin: getMargin(
              top: 8,
              bottom: 8,
            ),
            value: true,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
