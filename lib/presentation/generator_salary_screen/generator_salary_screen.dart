import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/core/budget/providers/banner_ads_class_provider.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';

import 'package:noughtplan/widgets/custom_button_form.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@immutable
class CurrencyTypes {
  final String name;
  final String flag;

  const CurrencyTypes({
    required this.name,
    required this.flag,
  });
}

class BudgetTypes {
  final String types;

  const BudgetTypes({
    required this.types,
  });
}

class DataModel extends ChangeNotifier {
  List<CurrencyTypes> _currencyList = [
    CurrencyTypes(name: "USD", flag: ImageConstant.imgUsa),
    CurrencyTypes(name: "JMD", flag: ImageConstant.imgJamaica),
  ];

  List<CurrencyTypes> get currencyList => _currencyList;

  set currencyList(List<CurrencyTypes> currency) {
    _currencyList = currency;
    notifyListeners();
  }

  CurrencyTypes? _selectedCurrency;

  CurrencyTypes? get selectedCurrency => _selectedCurrency;

  set selectedCurrency(CurrencyTypes? currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }
}

class DataModelTypes extends ChangeNotifier {
  List<BudgetTypes> _budgetList = [
    BudgetTypes(types: "Zero-Based Budgeting"),
  ];

  List<BudgetTypes> get budgetList => _budgetList;

  set budgetList(List<BudgetTypes> budgettypes) {
    _budgetList = budgettypes;
    notifyListeners();
  }

  BudgetTypes? _selectedType;

  BudgetTypes? get selectedType => _selectedType;

  set selectedType(BudgetTypes? budgetTypes) {
    _selectedType = budgetTypes;
    notifyListeners();
  }
}

final dataProvider = ChangeNotifierProvider((ref) => DataModel());
final dataProviderBudgets = ChangeNotifierProvider((ref) => DataModelTypes());

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier()
      : super(
            true); // True indicates that onboarding instructions should be shown

  void markOnboardingAsComplete() {
    state = false; // Set to false when onboarding is completed
  }
}

final onboardingNotifierProvider =
    StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

final arrowVisibleProvider = StateProvider<bool>((ref) => true);

class GeneratorSalaryScreen extends HookConsumerWidget {
  final salaryFocusNode = FocusNode();
  final currencyFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _animationController =
        useAnimationController(duration: const Duration(seconds: 1));

    final salaryController = useTextEditingController(text: '');
    final hasInitialized = useState(false);

    final data = ref.watch(dataProvider);
    final dataBudgets = ref.watch(dataProviderBudgets);
    final currencyList = data.currencyList;
    final budgetList = dataBudgets.budgetList;
    final generateSalaryState = ref.watch(generateSalaryProvider);
    final showErrorSalary = generateSalaryState.salary.error;
    final showErrorCurrency = generateSalaryState.currency.error;
    final showErrorBudgetType = generateSalaryState.budgetType.error;
    final generateSalaryController = ref.watch(generateSalaryProvider.notifier);
    final bool isValidated = generateSalaryState.status.isValidated;

    final arrowVisible = ref.watch(arrowVisibleProvider);

    Future<Map<String, dynamic>> getSubscriptionInfo() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      Map<String, dynamic> subscriptionInfo = {
        'isSubscribed': false,
        'expiryDate': null
      };

      if (firebaseUser != null) {
        try {
          CustomerInfo customerInfo = await Purchases.getCustomerInfo();
          bool isSubscribed =
              customerInfo.entitlements.all['pro_features']?.isActive ?? false;

          // parse the String into a DateTime
          String? expiryDateString =
              customerInfo.entitlements.all['pro_features']?.expirationDate;

          String? managementUrl = customerInfo.managementURL;
          DateTime? expiryDate;
          if (expiryDateString != null) {
            expiryDate = DateTime.parse(expiryDateString);
          }

          subscriptionInfo['isSubscribed'] = isSubscribed;
          subscriptionInfo['expiryDate'] = expiryDate;
          subscriptionInfo['managementUrl'] = managementUrl;
        } catch (e) {
          print('Failed to get customer info: $e');
        }
      }
      return subscriptionInfo;
    }

    useEffect(() {
      // Start the animation as before...
      _animationController.repeat(reverse: true);

      // After 5 seconds, hide the arrow
      Future.delayed(const Duration(seconds: 10), () {
        ref.read(arrowVisibleProvider.notifier).state = false;
      });

      return _animationController.dispose;
    }, []);

    return WillPopScope(
      onWillPop: () async {
        final budgetState = ref.read(budgetStateProvider.notifier);
        await budgetState.deleteBudgetsWithNoName();
        Navigator.pop(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorConstant.whiteA700,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: double.maxFinite,
              child: Stack(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgTopographic5,
                    height: getVerticalSize(290),
                    width: getHorizontalSize(375),
                  ),
                  Padding(
                      padding: getPadding(left: 24, right: 24),
                      child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomAppBar(
                              height: getVerticalSize(100),
                              leadingWidth: 25,
                              leading: CustomImageView(
                                onTap: () async {
                                  final budgetState =
                                      ref.read(budgetStateProvider.notifier);
                                  await budgetState.deleteBudgetsWithNoName();
                                  Navigator.pop(context);
                                },
                                height: getSize(24),
                                width: getSize(24),
                                svgPath: ImageConstant.imgArrowleft,
                              ),
                              centerTitle: true,
                              title:
                                  AppbarTitle(text: "Salary and Budget Type"),
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
                                            style: AppStyle.txtManropeRegular14,
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
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          child: SvgPicture.asset(
                                            ImageConstant.imgQuestion,
                                            height: 24,
                                            width: 24,
                                            color: ColorConstant.blueGray500,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: AnimatedBuilder(
                                          animation: _animationController,
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            if (_animationController
                                                .isCompleted)
                                              return SizedBox
                                                  .shrink(); // This line ensures that the arrow disappears after the animation has completed

                                            return Transform.translate(
                                              offset: Offset(
                                                  0,
                                                  -10 *
                                                      _animationController
                                                          .value),
                                              child: SvgPicture.asset(
                                                ImageConstant
                                                    .imgArrowUp, // path to your arrow SVG image
                                                height: 24,
                                                width: 24,
                                                color: ColorConstant.blueA700,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      getPadding(top: 24, right: 18, left: 18),
                                  child: TextField(
                                      controller: salaryController,
                                      focusNode: salaryFocusNode,
                                      maxLength: 12,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        ThousandsFormatter(),
                                      ],
                                      onChanged: (salary) {
                                        generateSalaryController
                                            .onSalaryChange(salary);
                                        print(salary);
                                      },
                                      decoration: InputDecoration(
                                        prefixText: '\$ ',
                                        errorText:
                                            generateSalaryState.salary.error !=
                                                        null &&
                                                    salaryFocusNode.hasFocus
                                                ? Salary.showSalaryErrorMessage(
                                                        showErrorSalary)
                                                    .toString()
                                                : null,
                                        errorStyle: AppStyle.txtManropeRegular12
                                            .copyWith(
                                                color: ColorConstant.redA700),
                                        prefixStyle:
                                            AppStyle.txtHelveticaNowTextBold40,
                                        hintText: '0.00',
                                        labelText: 'Salary',
                                        labelStyle:
                                            AppStyle.txtHelveticaNowTextBold16,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                      ),
                                      textAlign: TextAlign.center,
                                      style:
                                          AppStyle.txtHelveticaNowTextBold40),
                                ),
                                Container(
                                  // padding: const EdgeInsets.all(8.0),
                                  // height: getVerticalSize(42),
                                  // margin: getMargin(top: 132),
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
                                      Column(
                                        children: [
                                          DropdownButton<CurrencyTypes>(
                                            alignment: Alignment.center,
                                            value: data._selectedCurrency,
                                            onChanged:
                                                (CurrencyTypes? currency) {
                                              ref
                                                  .watch(dataProvider)
                                                  .selectedCurrency = currency;
                                              generateSalaryController
                                                  .onCurrencyChange(
                                                      currency?.name ?? '');
                                              print(
                                                  'Selected currency: ${currency?.name}');
                                            },
                                            items: currencyList
                                                .map<
                                                    DropdownMenuItem<
                                                        CurrencyTypes>>(
                                                  (currency) =>
                                                      DropdownMenuItem<
                                                          CurrencyTypes>(
                                                    value: currency,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                            currency.flag,
                                                            height: 20,
                                                            width: 30),
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
                                          if (generateSalaryState
                                                  .currency.error !=
                                              null)
                                            Text(
                                              Currency.showCurrencyErrorMessage(
                                                      showErrorCurrency)
                                                  .toString(),
                                              style: AppStyle
                                                  .txtManropeRegular12
                                                  .copyWith(
                                                      color: ColorConstant
                                                          .lightBlueA200),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              // padding: const EdgeInsets.all(8.0),
                              // height: getVerticalSize(42),

                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Budget Type",
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtHelveticaNowTextBold16
                                          .copyWith(
                                              letterSpacing:
                                                  getHorizontalSize(0.5))),
                                  Column(
                                    children: [
                                      DropdownButton<BudgetTypes>(
                                        alignment: Alignment.center,
                                        value: dataBudgets._selectedType,
                                        onChanged: (BudgetTypes? budgettypes) {
                                          ref
                                              .watch(dataProviderBudgets)
                                              .selectedType = budgettypes;
                                          generateSalaryController
                                              .onBudgetTypeChange(
                                                  budgettypes?.types ?? '');
                                          print(
                                              'Selected Budget Type: ${budgettypes?.types}');
                                        },
                                        items: budgetList
                                            .map<DropdownMenuItem<BudgetTypes>>(
                                              (budgetTypes) =>
                                                  DropdownMenuItem<BudgetTypes>(
                                                value: budgetTypes,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 5),
                                                    Text(budgetTypes.types,
                                                        style: AppStyle
                                                            .txtHelveticaNowTextBold16),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      if (generateSalaryState
                                              .budgetType.error !=
                                          null)
                                        Text(
                                          BudgetType.showBudgetTypeErrorMessage(
                                                  showErrorBudgetType)
                                              .toString(),
                                          style: AppStyle.txtManropeRegular12
                                              .copyWith(
                                                  color: ColorConstant
                                                      .lightBlueA200),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: getPadding(top: 20),
                                child: Text("Enter Your Salary Details",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtHelveticaNowTextBold24)),
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
                            Column(
                              children: [
                                Padding(
                                  padding: getPadding(bottom: 10),
                                  child: FutureBuilder<Map<String, dynamic>>(
                                    future: getSubscriptionInfo(),
                                    builder: (context, snapshot) {
                                      // The future is still loading
                                      if (snapshot.connectionState !=
                                          ConnectionState.done) {
                                        return Container(); // Or some other placeholder
                                      }

                                      // The future completed with an error
                                      if (snapshot.hasError) {
                                        return Text('An error occurred');
                                      }

                                      // The future completed with a result
                                      Map<String, dynamic> subscriptionInfo =
                                          snapshot.data ??
                                              {
                                                'isSubscribed': false,
                                                'expiryDate': null
                                              };
                                      bool isSubscribed =
                                          subscriptionInfo['isSubscribed'] ??
                                              false;
                                      DateTime? expiryDate =
                                          subscriptionInfo['expiryDate'];

                                      // If the user is not subscribed, show the ad
                                      if (!isSubscribed) {
                                        return Container(
                                          color: Colors.white,
                                          child: Center(
                                            child: BannerAdWidget(),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                                CustomImageView(
                                  svgPath: ImageConstant.imgCarousel1,
                                  margin: getMargin(top: 10, bottom: 10),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: CustomButtonForm(
                                    alignment: Alignment.bottomCenter,
                                    height: getVerticalSize(56),
                                    text: "Next",
                                    onTap: isValidated
                                        ? () async {
                                            final result =
                                                await generateSalaryController
                                                    .saveBudgetInfo();
                                            if (result == true) {
                                              Navigator.pushNamed(context,
                                                  '/category_necessary_screen');
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Information saved successfully!',
                                                    textAlign: TextAlign.center,
                                                    style: AppStyle
                                                        .txtHelveticaNowTextBold16WhiteA700
                                                        .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.3),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      ColorConstant.blue900,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Please fill in all the fields!',
                                                    textAlign: TextAlign.center,
                                                    style: AppStyle
                                                        .txtHelveticaNowTextBold16WhiteA700
                                                        .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.3),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      ColorConstant.redA700,
                                                ),
                                              );
                                            }
                                            print(result);
                                          }
                                        : null,
                                    enabled: isValidated,
                                  ),
                                ),
                              ],
                            ),
                          ])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
