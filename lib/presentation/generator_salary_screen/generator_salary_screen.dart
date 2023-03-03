import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';

import '../generator_salary_screen/widgets/listdatatypeone_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';

@immutable
class Currency {
  final String name;
  final String flag;

  const Currency({
    required this.name,
    required this.flag,
  });
}

class DataModel extends ChangeNotifier {
  List<Currency> _currencyList = [
    Currency(name: "USD", flag: ImageConstant.imgUsa),
    Currency(name: "JMD", flag: ImageConstant.imgJamaica),
  ];

  List<Currency> get currencyList => _currencyList;

  set currencyList(List<Currency> currency) {
    _currencyList = currency;
    notifyListeners();
  }

  Currency? _selectedCurrency;

  Currency? get selectedCurrency => _selectedCurrency;

  set selectedCurrency(Currency? currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }
}

final dataProvider = ChangeNotifierProvider((ref) => DataModel());

class GeneratorSalaryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);
    final currencyList = data.currencyList;

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: ColorConstant.whiteA700,
            body: Container(
                height: getVerticalSize(812),
                width: double.maxFinite,
                child: Stack(alignment: Alignment.center, children: [
                  CustomImageView(
                      imagePath: ImageConstant.imgTopographic5,
                      height: getVerticalSize(290),
                      width: getHorizontalSize(375),
                      alignment: Alignment.topCenter),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: getPadding(left: 24, right: 24),
                          child: Column(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomAppBar(
                                    height: getVerticalSize(100),
                                    leadingWidth: 25,
                                    leading: AppbarImage(
                                      onTap: () async {
                                        await ref
                                            .read(authStateProvider.notifier)
                                            .logOut();
                                      },
                                      height: getSize(24),
                                      width: getSize(24),
                                      svgPath: ImageConstant.imgArrowleft,
                                      margin: getMargin(bottom: 1),
                                    ),
                                    centerTitle: true,
                                    title: AppbarTitle(text: "Salary"),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Welcome to The Nought Plan',
                                                  textAlign: TextAlign.center,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold16,
                                                ),
                                                content: Text(
                                                  'To get started, please enter your monthly salary and select your preferred currency from the dropdown menu below. Our smart algorithms will take care of the rest, providing you with a personalized budget plan to help you save and manage your finances.',
                                                  textAlign: TextAlign.center,
                                                  style: AppStyle
                                                      .txtManropeRegular14,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text('Close'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        // height: getSize(24),
                                        //     width: getSize(24),
                                        //     svgPath: ImageConstant.imgQuestion,
                                        //     margin: getMargin(bottom: 1)
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 7),
                                          child: SvgPicture.asset(
                                            ImageConstant.imgQuestion,
                                            height: 24,
                                            width: 24,
                                          ),
                                        ),
                                      )
                                    ]),
                                Container(
                                  // padding: const EdgeInsets.all(8.0),
                                  // height: getVerticalSize(42),
                                  margin: getMargin(top: 120),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("Currency",
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtHelveticaNowTextBold16
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.5))),
                                      DropdownButton<Currency>(
                                        alignment: Alignment.center,
                                        value: data._selectedCurrency,
                                        onChanged: (Currency? currency) {
                                          ref
                                              .watch(dataProvider)
                                              .selectedCurrency = currency;
                                        },
                                        items: currencyList
                                            .map<DropdownMenuItem<Currency>>(
                                              (currency) =>
                                                  DropdownMenuItem<Currency>(
                                                value: currency,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(currency.flag,
                                                        height: 20, width: 30),
                                                    SizedBox(width: 5),
                                                    Text(currency.name,
                                                        style: AppStyle
                                                            .txtHelveticaNowTextBold16),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: getPadding(top: 20),
                                    child: Text("Enter Your Salary Details",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold24)),
                                Container(
                                    width: getHorizontalSize(327),
                                    margin: getMargin(
                                      left: 10,
                                      top: 15,
                                      right: 10,
                                    ),
                                    child: Text(
                                        "\"At The Nought Plan, we take your security seriously. All your information is encrypted and stored securely on our servers, ensuring that your data is always protected.\"",
                                        maxLines: null,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtManropeRegular12Bluegray500
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.3)))),
                                CustomImageView(
                                    svgPath: ImageConstant.imgArrowdown,
                                    height: getSize(24),
                                    width: getSize(24),
                                    margin: getMargin(top: 15, bottom: 15)),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: CustomButton(
                                    alignment: Alignment.bottomCenter,
                                    height: getVerticalSize(56),
                                    text: "Next",
                                  ),
                                ),
                              ]))),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: getPadding(top: 120, right: 30, left: 30),
                          child: TextField(
                              maxLength: 11,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                ThousandsFormatter(),
                              ],
                              decoration: InputDecoration(
                                prefixText: '\$ ',
                                prefixStyle: AppStyle.txtHelveticaNowTextBold40,
                                hintText: '0.00',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                              ),
                              textAlign: TextAlign.center,
                              style: AppStyle.txtHelveticaNowTextBold40)))
                ]))));
  }

  onTapArrowleft(BuildContext context) {
    Navigator.pop(context);
  }
}

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text == '.') {
      return newValue.copyWith(text: '0.');
    } else if (newValue.text.contains('.') &&
        newValue.text.indexOf('.') != newValue.text.lastIndexOf('.')) {
      // if there are multiple dots
      return oldValue;
    } else {
      // remove all non-digit characters
      String value = newValue.text.replaceAll(RegExp(r'[^\d\.]'), '');

      // split the value into integer and decimal parts
      List<String> parts = value.split('.');

      // format the integer part with commas
      parts[0] = NumberFormat.decimalPattern().format(int.parse(parts[0]));

      // recombine the integer and decimal parts
      String result = parts.join('.');

      // return the updated TextEditingValue
      return newValue.copyWith(
        text: result,
        selection: TextSelection.collapsed(offset: result.length),
      );
    }
  }
}
