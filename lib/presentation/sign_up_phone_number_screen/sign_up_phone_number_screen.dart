import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_phone_number.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class SignUpPhoneNumberScreen extends StatelessWidget {
  Country selectedCountry = CountryPickerUtils.getCountryByPhoneCode('1');

  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            resizeToAvoidBottomInset: false,
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 22, top: 16, right: 22, bottom: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomImageView(
                          svgPath: ImageConstant.imgCloseGray900,
                          height: getSize(24),
                          width: getSize(24),
                          margin: getMargin(left: 2),
                          onTap: () {
                            onTapImgClose(context);
                          }),
                      Padding(
                          padding: getPadding(left: 2, top: 40),
                          child: Text("Almost Done!",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtHelveticaNowTextBold24)),
                      Container(
                          width: getHorizontalSize(301),
                          margin: getMargin(left: 2, top: 10, right: 27),
                          child: Text(
                              "Enter your phone number and we’ll text you a code to activate your account.",
                              maxLines: null,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeRegular14Bluegray500
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.3)))),
                      Padding(
                          padding: getPadding(left: 2, top: 23),
                          child: CustomPhoneNumber(
                              country: selectedCountry,
                              controller: phoneNumberController,
                              onTap: (Country country) {
                                selectedCountry = country;
                              })),
                      Spacer(),
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "Continue",
                          margin: getMargin(left: 2, bottom: 291))
                    ]))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
