import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    this.shape,
    this.padding,
    this.variant,
    this.fontStyle,
    this.alignment,
    this.margin,
    this.onTap,
    this.width,
    this.height,
    this.text,
    this.prefixWidget,
    this.suffixWidget,
  });

  ButtonShape? shape;

  ButtonPadding? padding;

  ButtonVariant? variant;

  ButtonFontStyle? fontStyle;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  VoidCallback? onTap;

  double? width;

  double? height;

  String? text;

  Widget? prefixWidget;

  Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onTap,
        style: _buildTextButtonStyle(),
        child: _buildButtonWithOrWithoutIcon(),
      ),
    );
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixWidget ?? SizedBox(),
          Text(
            text ?? "",
            textAlign: TextAlign.center,
            style: _setFontStyle(),
          ),
          suffixWidget ?? SizedBox(),
        ],
      );
    } else {
      return Text(
        text ?? "",
        textAlign: TextAlign.center,
        style: _setFontStyle(),
      );
    }
  }

  _buildTextButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        width ?? double.maxFinite,
        height ?? getVerticalSize(40),
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      side: _setTextButtonBorder(),
      shape: RoundedRectangleBorder(
        borderRadius: _setBorderRadius(),
      ),
    );
  }

  _setPadding() {
    switch (padding) {
      case ButtonPadding.PaddingT14:
        return getPadding(
          top: 14,
          right: 14,
          bottom: 14,
        );
      case ButtonPadding.PaddingT7:
        return getPadding(
          left: 7,
          top: 7,
          bottom: 7,
        );
      case ButtonPadding.PaddingT3:
        return getPadding(
          top: 3,
          right: 3,
          bottom: 3,
        );
      case ButtonPadding.PaddingT3_1:
        return getPadding(
          left: 3,
          top: 3,
          bottom: 3,
        );
      case ButtonPadding.PaddingAll4:
        return getPadding(
          all: 4,
        );
      case ButtonPadding.PaddingAll9:
        return getPadding(
          all: 9,
        );
      case ButtonPadding.PaddingT12:
        return getPadding(
          left: 8,
          top: 12,
          right: 8,
          bottom: 12,
        );
      default:
        return getPadding(
          all: 15,
        );
    }
  }

  _setColor() {
    switch (variant) {
      case ButtonVariant.OutlineIndigo50:
        return ColorConstant.whiteA700;
      case ButtonVariant.FillIndigo5001:
        return ColorConstant.indigo5001;
      case ButtonVariant.FillRedA700:
        return ColorConstant.redA700;
      case ButtonVariant.FillGray50:
        return ColorConstant.gray50;
      case ButtonVariant.FillWhiteA700:
        return ColorConstant.whiteA700;
      case ButtonVariant.OutlineBlueA700:
        return ColorConstant.indigo5001;
      case ButtonVariant.FillGreenOutlined:
        return ColorConstant.whiteA700;
      case ButtonVariant.FillGray100:
        return ColorConstant.gray100;
      case ButtonVariant.FillGray900:
        return ColorConstant.gray900;
      case ButtonVariant.FillIndigoA10001:
        return ColorConstant.indigoA10001;
      case ButtonVariant.OutlineIndigoA100:
        return null;
      default:
        return ColorConstant.blueA700;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant.OutlineIndigo50:
        return BorderSide(
          color: ColorConstant.indigo50,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineBlueA700:
        return BorderSide(
          color: ColorConstant.blueA700,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.FillGreenOutlined:
        return BorderSide(
          color: ColorConstant.blue90001,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonVariant.OutlineIndigoA100:
        return BorderSide(
          color: ColorConstant.indigoA100,
          width: getHorizontalSize(
            1.00,
          ),
        );
      default:
        return null;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case ButtonShape.RoundedBorder6:
        return BorderRadius.circular(
          getHorizontalSize(
            6.00,
          ),
        );
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            12.00,
          ),
        );
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.HelveticaNowTextBold16Gray900:
        return TextStyle(
          color: ColorConstant.gray900,
          fontSize: getFontSize(
            16,
          ),
          letterSpacing: 0.5,
          fontFamily: 'Helvetica Now Text ',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.HelveticaNowTextBold16BlueA700:
        return TextStyle(
          color: ColorConstant.blueA700,
          fontSize: getFontSize(
            16,
          ),
          letterSpacing: 0.5,
          fontFamily: 'Helvetica Now Text ',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.HelveticaNowTextBold16:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            16,
          ),
          letterSpacing: 0.5,
          fontFamily: 'Helvetica Now Text ',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.ManropeSemiBold12:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.42,
          ),
        );
      case ButtonFontStyle.ManropeSemiBold12Bluegray300:
        return TextStyle(
          color: ColorConstant.blueGray300,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.42,
          ),
        );
      case ButtonFontStyle.HelveticaNowTextBold12:
        return TextStyle(
          color: ColorConstant.blueGray300,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Helvetica Now Text ',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.HelveticaNowTextBold12BlueA700:
        return TextStyle(
          color: ColorConstant.blueA700,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Helvetica Now Text ',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.ManropeSemiBold12Gray900:
        return TextStyle(
          color: ColorConstant.gray900,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.42,
          ),
        );
      case ButtonFontStyle.ManropeSemiBold10:
        return TextStyle(
          color: ColorConstant.greenA700,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.40,
          ),
        );
      case ButtonFontStyle.ManropeSemiBold10WhiteA700:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.40,
          ),
        );
      case ButtonFontStyle.ManropeSemiBold8:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            8,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.38,
          ),
        );
      case ButtonFontStyle.ManropeSemiBold12Gray900_1:
        return TextStyle(
          color: ColorConstant.gray900,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.67,
          ),
        );
      case ButtonFontStyle.ManropeMedium10:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.40,
          ),
        );
      default:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Helvetica Now Text ',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.50,
          ),
        );
    }
  }
}

enum ButtonShape {
  Square,
  RoundedBorder12,
  RoundedBorder6,
}

enum ButtonPadding {
  PaddingAll15,
  PaddingT14,
  PaddingT7,
  PaddingT3,
  PaddingT3_1,
  PaddingAll4,
  PaddingAll9,
  PaddingT12,
}

enum ButtonVariant {
  FillBlueA700,
  OutlineIndigo50,
  FillIndigo5001,
  FillRedA700,
  FillGray50,
  FillWhiteA700,
  OutlineBlueA700,
  OutlineIndigoA100,
  FillGray100,
  FillGray900,
  FillIndigoA10001,
  FillGreenOutlined,
}

enum ButtonFontStyle {
  HelveticaNowTextBold16,
  HelveticaNowTextBold16Gray900,
  HelveticaNowTextBold16BlueA700,
  ManropeSemiBold12,
  ManropeSemiBold12Bluegray300,
  HelveticaNowTextBold12,
  HelveticaNowTextBold12BlueA700,
  ManropeSemiBold12Gray900,
  ManropeSemiBold10,
  ManropeSemiBold10WhiteA700,
  ManropeSemiBold8,
  ManropeSemiBold12Gray900_1,
  ManropeMedium10,
}
