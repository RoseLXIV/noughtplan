import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_icon_button.dart';

// ignore: must_be_immutable
class GridtrendingupItemWidget extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onTap;

  GridtrendingupItemWidget({
    required this.text,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: getPadding(
          left: 20,
          top: 16,
          right: 20,
          bottom: 16,
        ),
        decoration: AppDecoration.fillGray50.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomIconButton(
              height: 48,
              width: 48,
              shape: IconButtonShape.CircleBorder24,
              child: CustomImageView(
                svgPath: iconPath,
              ),
            ),
            Padding(
              padding: getPadding(
                top: 8,
              ),
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtManropeSemiBold10.copyWith(
                  letterSpacing: getHorizontalSize(
                    0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
