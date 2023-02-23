import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton(
      {this.shape,
      this.padding,
      this.variant,
      this.alignment,
      this.margin,
      this.width,
      this.height,
      this.child,
      this.onTap});

  IconButtonShape? shape;

  IconButtonPadding? padding;

  IconButtonVariant? variant;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  double? width;

  double? height;

  Widget? child;

  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildIconButtonWidget(),
          )
        : _buildIconButtonWidget();
  }

  _buildIconButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: IconButton(
        iconSize: getSize(height ?? 0),
        padding: EdgeInsets.all(0),
        icon: Container(
          alignment: Alignment.center,
          width: getSize(width ?? 0),
          height: getSize(height ?? 0),
          padding: _setPadding(),
          decoration: _buildDecoration(),
          child: child,
        ),
        onPressed: onTap,
      ),
    );
  }

  _buildDecoration() {
    return BoxDecoration(
      color: _setColor(),
      border: _setBorder(),
      borderRadius: _setBorderRadius(),
      boxShadow: _setBoxShadow(),
    );
  }

  _setPadding() {
    switch (padding) {
      case IconButtonPadding.PaddingAll15:
        return getPadding(
          all: 15,
        );
      case IconButtonPadding.PaddingAll7:
        return getPadding(
          all: 7,
        );
      default:
        return getPadding(
          all: 11,
        );
    }
  }

  _setColor() {
    switch (variant) {
      case IconButtonVariant.OutlineWhiteA700:
        return ColorConstant.greenA700;
      case IconButtonVariant.OutlineWhiteA700_1:
        return ColorConstant.blueA700;
      case IconButtonVariant.FillBlueA700:
        return ColorConstant.blueA700;
      case IconButtonVariant.FillBlue90001:
        return ColorConstant.blue90001;
      case IconButtonVariant.FillGray50:
        return ColorConstant.gray50;
      case IconButtonVariant.FillIndigo5002:
        return ColorConstant.indigo5002;
      case IconButtonVariant.FillBlue50:
        return ColorConstant.blue50;
      case IconButtonVariant.OutlineIndigo50:
        return null;
      default:
        return ColorConstant.whiteA700;
    }
  }

  _setBorder() {
    switch (variant) {
      case IconButtonVariant.OutlineWhiteA700:
        return Border.all(
          color: ColorConstant.whiteA700,
          width: getHorizontalSize(
            3.00,
          ),
        );
      case IconButtonVariant.OutlineWhiteA700_1:
        return Border.all(
          color: ColorConstant.whiteA700,
          width: getHorizontalSize(
            3.00,
          ),
        );
      case IconButtonVariant.OutlineIndigo50:
        return Border.all(
          color: ColorConstant.indigo50,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case IconButtonVariant.FillWhiteA700:
      case IconButtonVariant.FillBlueA700:
      case IconButtonVariant.FillBlue90001:
      case IconButtonVariant.FillGray50:
      case IconButtonVariant.FillIndigo5002:
      case IconButtonVariant.FillBlue50:
        return null;
      default:
        return null;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case IconButtonShape.CircleBorder24:
        return BorderRadius.circular(
          getHorizontalSize(
            24.00,
          ),
        );
      case IconButtonShape.CustomBorderLR12:
        return BorderRadius.only(
          topLeft: Radius.circular(
            getHorizontalSize(
              0.00,
            ),
          ),
          topRight: Radius.circular(
            getHorizontalSize(
              12.00,
            ),
          ),
          bottomLeft: Radius.circular(
            getHorizontalSize(
              0.00,
            ),
          ),
          bottomRight: Radius.circular(
            getHorizontalSize(
              12.00,
            ),
          ),
        );
      case IconButtonShape.CircleBorder28:
        return BorderRadius.circular(
          getHorizontalSize(
            28.00,
          ),
        );
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            20.00,
          ),
        );
    }
  }

  _setBoxShadow() {
    switch (variant) {
      case IconButtonVariant.OutlineWhiteA700:
        return [
          BoxShadow(
            color: ColorConstant.gray9001401,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: Offset(
              2.2,
              4.4,
            ),
          )
        ];
      case IconButtonVariant.OutlineWhiteA700_1:
        return [
          BoxShadow(
            color: ColorConstant.gray9001401,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: Offset(
              2.2,
              4.4,
            ),
          )
        ];
      case IconButtonVariant.FillWhiteA700:
      case IconButtonVariant.FillBlueA700:
      case IconButtonVariant.FillBlue90001:
      case IconButtonVariant.OutlineIndigo50:
      case IconButtonVariant.FillGray50:
      case IconButtonVariant.FillIndigo5002:
      case IconButtonVariant.FillBlue50:
        return null;
      default:
        return null;
    }
  }
}

enum IconButtonShape {
  CircleBorder24,
  CircleBorder20,
  CustomBorderLR12,
  CircleBorder28,
}

enum IconButtonPadding {
  PaddingAll11,
  PaddingAll15,
  PaddingAll7,
}

enum IconButtonVariant {
  FillWhiteA700,
  OutlineWhiteA700,
  OutlineWhiteA700_1,
  FillBlueA700,
  FillBlue90001,
  OutlineIndigo50,
  FillGray50,
  FillIndigo5002,
  FillBlue50,
}
