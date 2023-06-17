import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

// ignore: must_be_immutable
class AppbarTitle extends StatelessWidget {
  AppbarTitle({required this.text, this.margin, this.onTap});

  String text;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppStyle.txtHelveticaNowTextBold16.copyWith(
            letterSpacing: getHorizontalSize(
              0.4,
            ),
            color: ColorConstant.gray900,
          ),
        ),
      ),
    );
  }
}
