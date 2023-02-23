import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

// ignore: must_be_immutable
class ListdatatypeoneItemWidget extends StatelessWidget {
  ListdatatypeoneItemWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "1",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppStyle.txtHelveticaNowTextMedium24,
        ),
        Text(
          "2",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppStyle.txtHelveticaNowTextMedium24,
        ),
        Text(
          "3",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppStyle.txtHelveticaNowTextMedium24,
        ),
      ],
    );
  }
}
