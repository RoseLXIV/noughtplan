import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';

// ignore: must_be_immutable
class CustomPhoneNumber extends StatelessWidget {
  CustomPhoneNumber(
      {required this.country, required this.onTap, required this.controller});

  Country country;

  Function(Country) onTap;

  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            _openCountryPicker(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorConstant.gray50,
              borderRadius: BorderRadius.circular(
                getHorizontalSize(
                  12,
                ),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: getPadding(
                    left: 16,
                    top: 16,
                    bottom: 16,
                  ),
                  child: CountryPickerUtils.getDefaultFlagImage(
                    country,
                  ),
                ),
                Padding(
                  padding: getPadding(
                    left: 12,
                    top: 16,
                    right: 21,
                    bottom: 15,
                  ),
                  child: Text(
                    "+${country.phoneCode}",
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
        ),
        Expanded(
          child: CustomTextFormField(
            width: getHorizontalSize(
              226,
            ),
            focusNode: FocusNode(),
            controller: controller,
            hintText: "8976 88",
            margin: getMargin(
              left: 12,
            ),
            variant: TextFormFieldVariant.OutlineBlueA700,
            padding: TextFormFieldPadding.PaddingT16,
            fontStyle: TextFormFieldFontStyle.ManropeRegular16Bluegray100,
            suffix: Container(
              margin: getMargin(
                left: 30,
                top: 22,
                right: 20,
                bottom: 22,
              ),
              child: CustomImageView(
                svgPath: ImageConstant.imgCloseBlueGray300,
              ),
            ),
            suffixConstraints: BoxConstraints(
              maxHeight: getVerticalSize(
                56,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Container(
            margin: EdgeInsets.only(
              left: getHorizontalSize(10),
            ),
            width: getHorizontalSize(60.0),
            child: Text(
              "+${country.phoneCode}",
              style: TextStyle(fontSize: getFontSize(14)),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              country.name,
              style: TextStyle(fontSize: getFontSize(14)),
            ),
          ),
        ],
      );
  void _openCountryPicker(BuildContext context) => showDialog(
        context: context,
        builder: (context) => CountryPickerDialog(
          searchInputDecoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: getFontSize(14)),
          ),
          isSearchable: true,
          title: Text('Select your phone code',
              style: TextStyle(fontSize: getFontSize(14))),
          onValuePicked: (Country country) => onTap(country),
          itemBuilder: _buildDialogItem,
        ),
      );
}
