import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

@immutable
class CustomButtonAllocate extends StatelessWidget {
  CustomButtonAllocate({
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
    required this.enabled,
  });
  bool enabled;

  ButtonShapeAllocate? shape;

  ButtonPaddingAllocate? padding;

  ButtonVariantAllocate? variant;

  ButtonFontStyleAllocate? fontStyle;

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
        onPressed: enabled ? onTap : null,
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
      case ButtonPaddingAllocate.PaddingT14:
        return getPadding(
          top: 14,
          right: 14,
          bottom: 14,
        );
      case ButtonPaddingAllocate.PaddingT7:
        return getPadding(
          left: 7,
          top: 7,
          bottom: 7,
        );
      case ButtonPaddingAllocate.PaddingT3:
        return getPadding(
          top: 3,
          right: 3,
          bottom: 3,
        );
      case ButtonPaddingAllocate.PaddingT3_1:
        return getPadding(
          left: 3,
          top: 3,
          bottom: 3,
        );
      case ButtonPaddingAllocate.PaddingAll4:
        return getPadding(
          all: 4,
        );
      case ButtonPaddingAllocate.PaddingAll9:
        return getPadding(
          all: 9,
        );
      case ButtonPaddingAllocate.PaddingT12:
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
    if (!enabled) {
      return ColorConstant.gray90014; // Return grey when button is disabled
    }
    switch (variant) {
      case ButtonVariantAllocate.OutlineIndigo50:
        return ColorConstant.whiteA700;
      case ButtonVariantAllocate.FillIndigo5001:
        return ColorConstant.indigo5001;
      case ButtonVariantAllocate.FillGray50:
        return ColorConstant.gray50;
      case ButtonVariantAllocate.FillWhiteA700:
        return ColorConstant.whiteA700;
      case ButtonVariantAllocate.OutlineBlueA700:
        return ColorConstant.indigo5001;
      case ButtonVariantAllocate.FillGreenOutlined:
        return ColorConstant.whiteA700;
      case ButtonVariantAllocate.FillGray100:
        return ColorConstant.gray100;
      case ButtonVariantAllocate.FillGray900:
        return ColorConstant.gray900;
      case ButtonVariantAllocate.FillIndigoA10001:
        return ColorConstant.indigoA10001;
      case ButtonVariantAllocate.OutlineIndigoA100:
        return null;
      default:
        return ColorConstant.blueA700;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariantAllocate.OutlineIndigo50:
        return BorderSide(
          color: ColorConstant.indigo50,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariantAllocate.OutlineBlueA700:
        return BorderSide(
          color: ColorConstant.blueA700,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariantAllocate.FillGreenOutlined:
        return BorderSide(
          color: ColorConstant.blue90001,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonVariantAllocate.OutlineIndigoA100:
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
      case ButtonShapeAllocate.RoundedBorder6:
        return BorderRadius.circular(
          getHorizontalSize(
            6.00,
          ),
        );
      case ButtonShapeAllocate.Square:
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
      case ButtonFontStyleAllocate.HelveticaNowTextBold16Gray900:
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
      case ButtonFontStyleAllocate.HelveticaNowTextBold16BlueA700:
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
      case ButtonFontStyleAllocate.HelveticaNowTextBold16:
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
      case ButtonFontStyleAllocate.ManropeSemiBold12:
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
      case ButtonFontStyleAllocate.ManropeSemiBold12Bluegray300:
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
      case ButtonFontStyleAllocate.HelveticaNowTextBold12:
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
      case ButtonFontStyleAllocate.HelveticaNowTextBold12BlueA700:
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
      case ButtonFontStyleAllocate.ManropeSemiBold12Gray900:
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
      case ButtonFontStyleAllocate.ManropeSemiBold10:
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
      case ButtonFontStyleAllocate.ManropeSemiBold10WhiteA700:
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
      case ButtonFontStyleAllocate.ManropeSemiBold8:
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
      case ButtonFontStyleAllocate.ManropeSemiBold12Gray900_1:
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
      case ButtonFontStyleAllocate.ManropeMedium10:
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

enum ButtonShapeAllocate {
  Square,
  RoundedBorder12,
  RoundedBorder6,
}

enum ButtonPaddingAllocate {
  PaddingAll15,
  PaddingT14,
  PaddingT7,
  PaddingT3,
  PaddingT3_1,
  PaddingAll4,
  PaddingAll9,
  PaddingT12,
}

enum ButtonVariantAllocate {
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
  FillGreenOutlined,
}

enum ButtonFontStyleAllocate {
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
