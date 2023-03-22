import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton({
    this.shape,
    this.padding,
    this.variant,
    this.fontStyle,
    this.alignment,
    this.margin,
    this.onTap,
    this.height,
    this.text,
    this.prefixWidget,
    this.suffixWidget,
  });

  ButtonTextShape? shape;

  ButtonTextPadding? padding;

  ButtonTextVariant? variant;

  ButtonFontStyleText? fontStyle;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  VoidCallback? onTap;

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
      // fixedSize: Size(
      //   width ?? double.maxFinite,
      //   height ?? getVerticalSize(40),
      // ),
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
      case ButtonTextPadding.PaddingT14:
        return getPadding(
          top: 14,
          right: 14,
          bottom: 14,
        );
      case ButtonTextPadding.PaddingT7:
        return getPadding(
          left: 7,
          top: 7,
          bottom: 7,
        );
      case ButtonTextPadding.PaddingT3:
        return getPadding(
          top: 3,
          right: 3,
          bottom: 3,
        );
      case ButtonTextPadding.PaddingT3_1:
        return getPadding(
          left: 3,
          top: 3,
          bottom: 3,
        );
      case ButtonTextPadding.PaddingAll4:
        return getPadding(
          all: 4,
        );
      case ButtonTextPadding.PaddingAll9:
        return getPadding(
          all: 9,
        );
      case ButtonTextPadding.PaddingT12:
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
      case ButtonTextVariant.OutlineIndigo50:
        return ColorConstant.whiteA700;
      case ButtonTextVariant.FillIndigo5001:
        return ColorConstant.indigo5001;
      case ButtonTextVariant.FillGray50:
        return ColorConstant.gray50;
      case ButtonTextVariant.FillWhiteA700:
        return ColorConstant.whiteA700;
      case ButtonTextVariant.OutlineBlueA700:
        return ColorConstant.whiteA700;
      case ButtonTextVariant.FillGray100:
        return ColorConstant.gray100;
      case ButtonTextVariant.FillGray900:
        return ColorConstant.gray900;
      case ButtonTextVariant.FillIndigoA10001:
        return ColorConstant.indigoA10001;
      case ButtonTextVariant.OutlineIndigoA100:
        return null;
      default:
        return ColorConstant.blueA700;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonTextVariant.OutlineIndigo50:
        return BorderSide(
          color: ColorConstant.indigo50,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonTextVariant.OutlineBlueA700:
        return BorderSide(
          color: ColorConstant.blueA700,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonTextVariant.OutlineIndigoA100:
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
      case ButtonTextShape.RoundedBorder6:
        return BorderRadius.circular(
          getHorizontalSize(
            6.00,
          ),
        );
      case ButtonTextShape.Square:
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
      case ButtonFontStyleText.HelveticaNowTextBold16Gray900:
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
      case ButtonFontStyleText.HelveticaNowTextBold16BlueA700:
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
      case ButtonFontStyleText.HelveticaNowTextBold16:
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
      case ButtonFontStyleText.ManropeSemiBold12:
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
      case ButtonFontStyleText.ManropeSemiBold12Bluegray300:
        return TextStyle(
          color: ColorConstant.blueGray500,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.42,
          ),
        );

      case ButtonFontStyleText.ManropeBold12Bluegray300:
        return TextStyle(
          color: ColorConstant.blueGray500,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w900,
          height: getVerticalSize(
            1.42,
          ),
        );

      case ButtonFontStyleText.HelveticaNowTextBold12:
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
      case ButtonFontStyleText.HelveticaNowTextBold12BlueA700:
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
      case ButtonFontStyleText.ManropeSemiBold12Gray900:
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
      case ButtonFontStyleText.ManropeSemiBold10:
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
      case ButtonFontStyleText.ManropeSemiBold10WhiteA700:
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
      case ButtonFontStyleText.ManropeSemiBold8:
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
      case ButtonFontStyleText.ManropeSemiBold12Gray900_1:
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
      case ButtonFontStyleText.ManropeMedium10:
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

enum ButtonTextShape {
  Square,
  RoundedBorder12,
  RoundedBorder6,
}

enum ButtonTextPadding {
  PaddingAll15,
  PaddingT14,
  PaddingT7,
  PaddingT3,
  PaddingT3_1,
  PaddingAll4,
  PaddingAll9,
  PaddingT12,
}

enum ButtonTextVariant {
  FillBlueA700,
  OutlineIndigo50,
  FillIndigo5001,
  FillGray50,
  FillWhiteA700,
  OutlineBlueA700,
  OutlineIndigoA100,
  FillGray100,
  FillGray900,
  FillIndigoA10001,
}

enum ButtonFontStyleText {
  HelveticaNowTextBold16,
  HelveticaNowTextBold16Gray900,
  HelveticaNowTextBold16BlueA700,
  ManropeSemiBold12,
  ManropeSemiBold12Bluegray300,
  ManropeBold12Bluegray300,
  HelveticaNowTextBold12,
  HelveticaNowTextBold12BlueA700,
  ManropeSemiBold12Gray900,
  ManropeSemiBold10,
  ManropeSemiBold10WhiteA700,
  ManropeSemiBold8,
  ManropeSemiBold12Gray900_1,
  ManropeMedium10,
}
