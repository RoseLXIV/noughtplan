import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/allocate_funds/controller/remaining_funds_controller.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/core/budget/providers/banner_ads_class_provider.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/providers/first_time_provider.dart';
import 'package:noughtplan/presentation/budget_creation_page_view/budget_creation_page_view.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';

import 'package:noughtplan/widgets/custom_button_form.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

final arrowVisibleProvider = StateProvider<bool>((ref) => true);

class GeneratorSalaryScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salaryFocusNode = FocusNode();
    final currencyFocusNode = FocusNode();
    final _animationController =
        useAnimationController(duration: const Duration(seconds: 1));
    final firstTime = ref.watch(firstTimeProvider);

    final salaryValue = useState('');

    final salaryController = useTextEditingController();

    // salaryController.text = salaryValue.value;

    print('salaryValue on Load: ${salaryValue.value}');

    Future<void> saveSalaryValue(String value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('salaryValue', value);
    }

    Future<String?> getSavedSalaryValue() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('salaryValue');
    }

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

    print('Salary value on load: ${generateSalaryState.salary.value}');

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

    // Future<void> _fetchData() async {
    //   await saveSalaryValue(salaryController.text);
    //   print('salaryValue: ${salaryController.text}');
    //   String sanitizedValue = salaryController.text.replaceAll(',', '');
    //   double? salary = double.tryParse(sanitizedValue);

    //   final selectedCurrency = data._selectedCurrency?.name ?? '';
    //   final selectedBudgetType = dataBudgets._selectedType?.types ?? '';
    //   await generateSalaryController.initializeSalary(salary ?? 0.0);
    //   await generateSalaryController.initializeCurrency(selectedCurrency);
    //   await generateSalaryController.initializeBudgetType(selectedBudgetType);
    // }

    // // Future.microtask(() async {
    // if (!hasInitialized.value) {
    //   _fetchData();
    //   hasInitialized.value = true;
    // }
    // // });

    // String sanitizedValue = salaryValue.value.replaceAll(',', '');
    // double? salary = double.tryParse(sanitizedValue);
    // generateSalaryController.initializeSalary(salary ?? 0.0);

    useEffect(() {
      Future.microtask(() async {
        _animationController.repeat(reverse: true);

        final savedSalaryValue = await getSavedSalaryValue();
        // print('SavedSalaryValue $savedSalaryValue');
        salaryValue.value = savedSalaryValue ?? '';
        String sanitizedValue = salaryValue.value.replaceAll(',', '');
        double? salary = double.tryParse(sanitizedValue);
        print('salary in generator: ${salary}');
        final selectedCurrency = data._selectedCurrency?.name ?? '';
        final selectedBudgetType = dataBudgets._selectedType?.types ?? '';
        generateSalaryController.initializeSalary(salary ?? 0.0);
        generateSalaryController.initializeCurrency(selectedCurrency);
        generateSalaryController.initializeBudgetType(selectedBudgetType);

        // print('selectedBudgetType: ${selectedBudgetType}');
      });
      return null;
    }, [firstTime]);

    return WillPopScope(
      onWillPop: () async {
        final budgetNotifier = ref.watch(budgetStateProvider.notifier);
        await budgetNotifier.deleteBudgetsWithNoName();

        Navigator.pushNamed(
          context,
          '/home_page_screen',
        );
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
                  Transform(
                    transform: Matrix4.identity()..scale(1.0, 1.0, 1.0),
                    // alignment: Alignment.center,
                    child: CustomImageView(
                      imagePath: ImageConstant.chatTopo,
                      height: MediaQuery.of(context).size.height *
                          1, // Set the height to 50% of the screen height
                      width: MediaQuery.of(context)
                          .size
                          .width, // Set the width to the full screen width
                      // alignment: Alignment.bottomCenter,
                    ),
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
                                  final budgetNotifier =
                                      ref.watch(budgetStateProvider.notifier);
                                  await budgetNotifier
                                      .deleteBudgetsWithNoName();
                                  Navigator.pushNamed(
                                    context,
                                    '/home_page_screen',
                                  );
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
                                            'Setting Up Your Budget',
                                            textAlign: TextAlign.center,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold16,
                                          ),
                                          content: SingleChildScrollView(
                                            physics: BouncingScrollPhysics(),
                                            child: Container(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: AppStyle
                                                      .txtManropeRegular14
                                                      .copyWith(
                                                          color: ColorConstant
                                                              .blueGray800),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            'Follow these simple steps to set up your personalized budget:\n\n'),
                                                    TextSpan(
                                                        text:
                                                            '1. Enter Your Salary/Income:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    TextSpan(
                                                        text:
                                                            ' Please enter your monthly salary or total income. This helps us understand your financial background.\n\n'),
                                                    TextSpan(
                                                        text:
                                                            '2. Select Your Currency:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    TextSpan(
                                                        text:
                                                            ' Choose your preferred currency from the dropdown menu. This will be the default currency used in your budget plans.\n\n'),
                                                    TextSpan(
                                                        text:
                                                            '3. Choose Your Budget Type:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    TextSpan(
                                                        text:
                                                            ' Decide between (More budget types will be added soon):\n\n'),
                                                    TextSpan(
                                                        text:
                                                            'Zero Based Budgeting',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    TextSpan(
                                                        text:
                                                            '  - Zero Based Budgeting:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    TextSpan(
                                                        text:
                                                            ' This budgeting method ensures every dollar has a purpose. It’s called "zero-based" because it makes you account for all of your money and start each month at zero.\n\n'),
                                                    TextSpan(
                                                        text:
                                                            "Our smart algorithms will take this information and create a personalized budget plan to help you manage and save your finances effectively. You're on your way to financial fitness!"),
                                                  ],
                                                ),
                                              ),
                                            ),
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
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              boxShape:
                                                  NeumorphicBoxShape.circle(),
                                              depth: 0.9,
                                              intensity: 8,
                                              surfaceIntensity: 0.7,
                                              shadowLightColor: Colors.white,
                                              lightSource: LightSource.top,
                                              color: firstTime
                                                  ? ColorConstant.blueA700
                                                  : Colors.white,
                                            ),
                                            child: SvgPicture.asset(
                                              ImageConstant.imgQuestion,
                                              height: 24,
                                              width: 24,
                                              color: firstTime
                                                  ? ColorConstant.whiteA700
                                                  : ColorConstant.blueGray500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: AnimatedBuilder(
                                          animation: _animationController,
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            if (!firstTime ||
                                                _animationController
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
                                  padding: getPadding(right: 18),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          side: MaterialStateProperty.all(
                                              BorderSide(
                                                  color:
                                                      ColorConstant.indigoA100,
                                                  width: 1)),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.all(4)),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Clear Information',
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold18
                                                      .copyWith(
                                                          letterSpacing: 0.2),
                                                ),
                                                content: Text(
                                                  'Are you sure you want to clear your information?',
                                                  style: AppStyle
                                                      .txtManropeRegular14
                                                      .copyWith(
                                                          letterSpacing: 0.2),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Cancel',
                                                        style: AppStyle
                                                            .txtHelveticaNowTextBold14
                                                            .copyWith(
                                                                letterSpacing:
                                                                    0.2)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      'Clear',
                                                      style: AppStyle
                                                          .txtHelveticaNowTextBold14
                                                          .copyWith(
                                                              letterSpacing:
                                                                  0.2,
                                                              color:
                                                                  ColorConstant
                                                                      .redA700),
                                                    ),
                                                    onPressed: () async {
                                                      final selectedCurrency =
                                                          data._selectedCurrency
                                                                  ?.name ??
                                                              '';
                                                      final selectedBudgetType =
                                                          dataBudgets
                                                                  ._selectedType
                                                                  ?.types ??
                                                              '';
                                                      String sanitizedValue =
                                                          salaryValue.value
                                                              .replaceAll(
                                                                  ',', '');
                                                      double? salary =
                                                          double.tryParse(
                                                              sanitizedValue);
                                                      salaryController.clear();
                                                      salaryValue.value = '';
                                                      saveSalaryValue(
                                                          salaryValue.value);
                                                      await generateSalaryController
                                                          .initializeSalary(
                                                              salary ?? 0);

                                                      data.selectedCurrency =
                                                          null;
                                                      dataBudgets.selectedType =
                                                          null;

                                                      await generateSalaryController
                                                          .initializeCurrency(
                                                              selectedCurrency);
                                                      await generateSalaryController
                                                          .initializeBudgetType(
                                                              selectedBudgetType);

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              BudgetCreationPageView(
                                                                  initialIndex:
                                                                      0),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Clear',
                                          style: AppStyle
                                              .txtHelveticaNowTextBold14
                                              .copyWith(
                                                  color:
                                                      ColorConstant.blueA700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      getPadding(top: 8, right: 18, left: 18),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, bottom: 24),
                                          child: Text(
                                            '\$',
                                            style: AppStyle
                                                .txtHelveticaNowTextBold40,
                                          ),
                                        ),
                                        TextField(
                                            controller: salaryController,
                                            // focusNode: salaryFocusNode,
                                            maxLength: 12,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            inputFormatters: [
                                              ThousandsFormatter(),
                                            ],
                                            onChanged: (salary) async {
                                              salaryValue.value = salary;
                                              saveSalaryValue(salary);
                                              generateSalaryController
                                                  .onSalaryChange(salary);

                                              // String sanitizedValue =
                                              //     salaryValue.value
                                              //         .replaceAll(',', '');
                                              // double salaryPrevious =
                                              //     double.parse(sanitizedValue);
                                              // await generateSalaryController
                                              //     .setSalary(salaryPrevious);

                                              print(salaryValue.value);
                                              print(salary);
                                            },
                                            decoration: InputDecoration(
                                              prefix: Text('\$'),
                                              errorText: generateSalaryState
                                                          .salary.error !=
                                                      null
                                                  ? Salary.showSalaryErrorMessage(
                                                          showErrorSalary)
                                                      .toString()
                                                  : null,
                                              errorStyle: AppStyle
                                                  .txtManropeRegular12
                                                  .copyWith(
                                                      color: ColorConstant
                                                          .redA700),
                                              prefixStyle: AppStyle
                                                  .txtHelveticaNowTextBold40,
                                              hintText:
                                                  salaryValue.value.isNotEmpty
                                                      ? salaryValue.value
                                                      : '0.00',
                                              labelText: 'Salary',
                                              labelStyle: AppStyle
                                                  .txtHelveticaNowTextBold16,
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
                                            style: AppStyle
                                                .txtHelveticaNowTextBold40),
                                      ],
                                    ),
                                  ),
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
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    children: [
                                      // Padding(
                                      //   padding: getPadding(bottom: 8),
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.center,
                                      //     crossAxisAlignment:
                                      //         CrossAxisAlignment.center,
                                      //     children: [
                                      //       CustomImageView(
                                      //         svgPath:
                                      //             ImageConstant.imgAlertcircle,
                                      //         height: getSize(16),
                                      //         width: getSize(16),
                                      //         color: ColorConstant.amber600,
                                      //       ),
                                      //       Padding(
                                      //         padding: getPadding(left: 6),
                                      //         child: Text(
                                      //             'Remember to save your information!',
                                      //             style: AppStyle
                                      //                 .txtManropeSemiBold12
                                      //                 .copyWith(
                                      //                     color: ColorConstant
                                      //                         .amber600)),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      CustomButtonForm(
                                        alignment: Alignment.bottomCenter,
                                        height: getVerticalSize(56),
                                        text: "Swipe Left to Continue",
                                        suffixWidget: CustomImageView(
                                          svgPath: ImageConstant.imgArrowright,
                                          height: getSize(24),
                                          width: getSize(24),
                                          color: ColorConstant.whiteA700,
                                          alignment: Alignment.bottomCenter,
                                          margin: getMargin(left: 10),
                                        ),
                                        onTap: isValidated
                                            ? () async {
                                                saveSalaryValue(
                                                    salaryValue.value);

                                                final result =
                                                    // await generateSalaryController
                                                    //     .saveBudgetInfo();

                                                    // final budgetId =
                                                    //     generateSalaryController
                                                    //         .state.budgetId;
                                                    // print(
                                                    //     'budgetId from Generator Screen: $budgetId');

                                                    Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BudgetCreationPageView(
                                                            initialIndex: 1),
                                                  ),
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Information saved successfully!',
                                                      textAlign:
                                                          TextAlign.center,
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
                                                // }
                                                // else {
                                                //   ScaffoldMessenger.of(context)
                                                //       .showSnackBar(
                                                //     SnackBar(
                                                //       content: Text(
                                                //         'Please fill in all the fields!',
                                                //         textAlign:
                                                //             TextAlign.center,
                                                //         style: AppStyle
                                                //             .txtHelveticaNowTextBold16WhiteA700
                                                //             .copyWith(
                                                //           letterSpacing:
                                                //               getHorizontalSize(
                                                //                   0.3),
                                                //         ),
                                                //       ),
                                                //       backgroundColor:
                                                //           ColorConstant.redA700,
                                                //     ),
                                                //   );
                                                // }
                                                print(result);
                                              }
                                            : null,
                                        enabled:
                                            //             .text.isNotEmpty &&
                                            //         selectedCurrency.isNotEmpty &&
                                            //         selectedBudgetType.isNotEmpty) ||
                                            isValidated,
                                      ),
                                    ],
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
  final int maxLength;

  ThousandsFormatter({this.maxLength = 12});

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

      // truncate the integer part if it exceeds maxLength
      if (parts[0].length > maxLength) {
        parts[0] = parts[0].substring(0, maxLength);
      }

      // truncate the decimal part if it exceeds 2 digits
      if (parts.length > 1 && parts[1].length > 2) {
        parts[1] = parts[1].substring(0, 2);
      }

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
