import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_icon_button.dart';

// ignore: must_be_immutable
class DebtpageItemWidget extends StatelessWidget {
  DebtpageItemWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.outlineIndigo501.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: getHorizontalSize(
              99,
            ),
            margin: getMargin(
              top: 22,
              bottom: 22,
            ),
            padding: getPadding(
              top: 1,
              bottom: 1,
            ),
            decoration: AppDecoration.txtFillWhiteA700.copyWith(
              borderRadius: BorderRadiusStyle.txtRoundedBorder10,
            ),
            child: Text(
              "Auto Loan",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtManropeSemiBold12Gray900.copyWith(
                letterSpacing: getHorizontalSize(
                  0.2,
                ),
              ),
            ),
          ),
          Padding(
            padding: getPadding(
              left: 37,
              top: 12,
              bottom: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Monthly Payment",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtManropeRegular10.copyWith(
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
                    "\$70,000.00",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtHelveticaNowTextBold16.copyWith(
                      letterSpacing: getHorizontalSize(
                        0.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomIconButton(
            height: 64,
            width: 64,
            margin: getMargin(
              left: 15,
            ),
            variant: IconButtonVariant.FillBlueA700,
            shape: IconButtonShape.CustomBorderLR12,
            child: CustomImageView(
              svgPath: ImageConstant.imgUpload,
            ),
          ),
        ],
      ),
    );
  }
}
