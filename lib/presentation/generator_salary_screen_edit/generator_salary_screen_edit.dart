import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';

import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller_edit.dart';
import 'package:noughtplan/core/budget/providers/banner_ads_class_provider.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/providers/first_time_provider.dart';
import 'package:noughtplan/presentation/budget_creation_page_view_edit/budget_creation_page_view_edit.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';
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

  CurrencyTypes getCurrencyTypeByName(String? currencyName) {
    if (currencyName == null) return CurrencyTypes(name: '', flag: '');

    final currency = _currencyList.firstWhere(
      (element) => element.name == currencyName,
      orElse: () => CurrencyTypes(name: '', flag: ''),
    );

    return currency;
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

  BudgetTypes getBudgetTypeByName(String? typeName) {
    if (typeName == null) return BudgetTypes(types: '');

    final budgetType = _budgetList.firstWhere(
      (element) => element.types == typeName,
      orElse: () => BudgetTypes(types: ''),
    );

    return budgetType;
  }
}

final dataProvider = ChangeNotifierProvider((ref) => DataModel());
final dataProviderBudgets = ChangeNotifierProvider((ref) => DataModelTypes());
final ValueNotifier<bool> isValidatedNotifier = ValueNotifier(false);
final ValueNotifier<String> salaryValueNotifier = ValueNotifier<String>('');

class GeneratorSalaryScreenEdit extends HookConsumerWidget {
  final Budget selectedBudget;

  GeneratorSalaryScreenEdit({required this.selectedBudget});
  final salaryFocusNode = FocusNode();
  final currencyFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print(
    //     'Amount of Budgets in Generator Edit $selectedBudget.budgetId.length');
    final _animationController =
        useAnimationController(duration: const Duration(seconds: 1));
    final firstTime = ref.watch(firstTimeProvider);
    // final Map<String, dynamic> args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final Budget? selectedBudget = args['selectedBudget'];

    final salaryValueEdit = useState('');

    print('selectedBudget: ${selectedBudget.budgetId}');

    final salaryController = useTextEditingController();

    // salaryController.text = salaryValue.value;

    print('salaryValue on Load: ${salaryValueEdit.value}');

    Future<void> saveSalaryValue(String value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('salaryValueEdit', value);
    }

    Future<String?> getSavedSalaryValue() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('salaryValueEdit');
    }

    final currencyValue = useState('');
    final budgetTypeValue = useState('');

    Future<void> saveCurrencyValue(String value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('currencyValue', value);
    }

    Future<String?> getSavedCurrencyValue() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('currencyValue');
    }

    Future<void> saveBudgetTypeValue(String value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('budgetTypeValue', value);
    }

    Future<String?> getSavedBudgetTypeValue() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('budgetTypeValue');
    }

    final data = ref.watch(dataProvider);
    final dataBudgets = ref.watch(dataProviderBudgets);
    final selectedCurrency =
        data.getCurrencyTypeByName(selectedBudget.currency);
    final selectedCurrencyState = useState<CurrencyTypes>(selectedCurrency);
    final selectedBudgetType =
        dataBudgets.getBudgetTypeByName(selectedBudget.budgetType);
    final selectedBudgetTypeState = useState<BudgetTypes>(selectedBudgetType);
    final currencyList = data.currencyList;
    final budgetList = dataBudgets.budgetList;
    final generateSalaryState = ref.watch(generateSalaryProviderEdit);
    final showErrorSalary = generateSalaryState.salary.error;
    final showErrorCurrency = generateSalaryState.currency.error;
    final showErrorBudgetType = generateSalaryState.budgetType.error;
    final generateSalaryController =
        ref.watch(generateSalaryProviderEdit.notifier);
    final bool isValidated = generateSalaryState.status.isValidated;

    // generateSalaryController.initializeSalary(selectedBudget.salary);

    useEffect(() {
      Future.microtask(() async {
        final savedSalaryValue = await getSavedSalaryValue();
        // print('SavedSalaryValue $savedSalaryValue');
        salaryValueEdit.value = savedSalaryValue ?? '';
        String sanitizedValue = salaryValueEdit.value.replaceAll(',', '');
        double? salary = double.tryParse(sanitizedValue);
        print('salary in generator: ${salary}');
        final selectedCurrency = data._selectedCurrency?.name ?? '';
        final selectedBudgetType = dataBudgets._selectedType?.types ?? '';
        print('Salary on Generator: $salary');
        generateSalaryController.initializeSalary(salary ?? 0.0);
        generateSalaryController.initializeCurrency(selectedBudget.currency);
        generateSalaryController
            .initializeBudgetType(selectedBudget.budgetType);
      });
      return () {}; // Cleanup function
    }, [firstTime]);

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

    final numberFormat = NumberFormat("#,##0.00", "en_US");

    // final salaryController = TextEditingController();
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, '/home_page_screen');
        return Future.value(false);
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
                    transform: Matrix4.identity()..scale(1.0, 1.0, 0.1),
                    // alignment: Alignment.center,
                    child: CustomImageView(
                      imagePath: ImageConstant.chatTopo,
                      height: MediaQuery.of(context).size.height *
                          0.5, // Set the height to 50% of the screen height
                      width: MediaQuery.of(context)
                          .size
                          .width, // Set the width to the full screen width
                      // alignment: Alignment.bottomCenter,
                      fit: BoxFit.cover,
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
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/home_page_screen');
                                },
                                height: getSize(24),
                                width: getSize(24),
                                svgPath: ImageConstant.imgArrowleft,
                                margin: getMargin(bottom: 1),
                              ),
                              centerTitle: true,
                              title:
                                  AppbarTitle(text: "Salary and Budget Type"),
                              actions: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/home_page_screen');
                                      },
                                      child: Container(
                                        width: 70,
                                        child: SvgPicture.asset(
                                          ImageConstant.imgHome2,
                                          height: 24,
                                          width: 24,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Editing Your Budget',
                                                textAlign: TextAlign.center,
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold16,
                                              ),
                                              content: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
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
                                                                'Follow these simple steps to edit your personalized budget details:\n\n'),
                                                        TextSpan(
                                                            text:
                                                                '1. Edit Your Salary/Income:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' You have the option to update your monthly salary or total income. If you decide not to make changes, your previous salary/income value will automatically be used.\n\n'),
                                                        TextSpan(
                                                            text:
                                                                "2. Edit Your Currency:",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                " Feel free to change your preferred currency. If you don't select a new currency, your old one will be kept. This selected currency will be used in all your budget plans.\n\n"),
                                                        TextSpan(
                                                            text:
                                                                "3. Edit Your Budget Type:",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                " If your financial priorities or circumstances have changed, consider switching between "),
                                                        TextSpan(
                                                            text:
                                                                "Zero Based Budgeting",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ". (More Budget Types will be added soon)If you decide not to choose, your previous budgeting method will continue. Here’s a quick reminder of what each entails:\n\n"),
                                                        TextSpan(
                                                            text:
                                                                "  - Zero Based Budgeting:",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                " This budgeting method requires that every dollar has a purpose. It’s called 'zero-based' because it encourages you to account for all of your money and start each month at zero.\n\n"),
                                                        TextSpan(
                                                            text:
                                                                "\nRemember, it's okay to leave things unchanged if they still suit your needs. The old values will automatically be used. Maintaining an accurate and up-to-date budget is key to effective financial management. Stay on the path to financial fitness!"),
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
                                                  boxShape: NeumorphicBoxShape
                                                      .circle(),
                                                  depth: 0.9,
                                                  intensity: 8,
                                                  surfaceIntensity: 0.7,
                                                  shadowLightColor:
                                                      Colors.white,
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
                                                      : ColorConstant
                                                          .blueGray500,
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
                                                    color:
                                                        ColorConstant.blueA700,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: getPadding(
                                        top: 30, right: 18, left: 18),
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
                                            onChanged: (salary) {
                                              if (salary.isEmpty) {
                                                String defaultSalary =
                                                    numberFormat.format(
                                                        selectedBudget.salary);
                                                generateSalaryController
                                                    .onSalaryChange(
                                                        defaultSalary);
                                              } else {
                                                salaryValueEdit.value = salary;
                                                generateSalaryController
                                                    .onSalaryChange(salary);
                                              }
                                            },
                                            decoration: InputDecoration(
                                              errorText: generateSalaryState
                                                          .salary.error !=
                                                      null
                                                  // && salaryFocusNode.hasFocus
                                                  ? Salary.showSalaryErrorMessage(
                                                          showErrorSalary)
                                                      .toString()
                                                  : null,
                                              errorStyle: AppStyle
                                                  .txtManropeRegular12
                                                  .copyWith(
                                                      color: ColorConstant
                                                          .redA700),
                                              prefix: Text('\$'),
                                              prefixStyle: AppStyle
                                                  .txtHelveticaNowTextBold40,
                                              hintText: numberFormat.format(
                                                  selectedBudget.salary),
                                              hintStyle: AppStyle
                                                  .txtHelveticaNowTextBold40
                                                  .copyWith(
                                                color:
                                                    ColorConstant.blueGray300,
                                              ),
                                              labelText:
                                                  'Please enter a new salary amount',
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
                                            value: selectedCurrencyState.value,
                                            onChanged:
                                                (CurrencyTypes? currency) {
                                              selectedCurrencyState.value =
                                                  currency!;
                                              generateSalaryController
                                                  .onCurrencyChange(
                                                      currency.name);
                                              print(
                                                  'Selected currency: ${currency.name}');
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
                              margin: getMargin(top: 0),
                              alignment: Alignment.center,
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
                                        value: selectedBudgetTypeState.value,
                                        onChanged: (BudgetTypes? budgettypes) {
                                          selectedBudgetTypeState.value =
                                              budgettypes!;
                                          generateSalaryController
                                              .onBudgetTypeChange(
                                                  budgettypes.types);
                                          print(
                                              'Selected Budget Type: ${budgettypes.types}');
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
                                child: Text("Enter New Salary Details",
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
                                    "\"Please enter a new amount for your budget plan. If you'd like to keep the current amount, simply leave the field unchanged. Your previous amount will automatically be used for your updated budget.\"",
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
                                      Padding(
                                        padding: getPadding(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgAlertcircle,
                                              height: getSize(16),
                                              width: getSize(16),
                                              color: ColorConstant.amber600,
                                            ),
                                            Padding(
                                              padding: getPadding(left: 6),
                                              child: Text(
                                                  'Remember to save your information!',
                                                  style: AppStyle
                                                      .txtManropeSemiBold12
                                                      .copyWith(
                                                          color: ColorConstant
                                                              .amber600)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomButtonForm(
                                        alignment: Alignment.bottomCenter,
                                        height: getVerticalSize(56),
                                        text: "Save & Continue",
                                        onTap: isValidated
                                            ? () async {
                                                saveSalaryValue(
                                                    salaryValueEdit.value);
                                                saveCurrencyValue(
                                                    currencyValue.value);
                                                saveBudgetTypeValue(
                                                    budgetTypeValue.value);
                                                final budgetId =
                                                    selectedBudget.budgetId;
                                                final result =
                                                    await generateSalaryController
                                                        .saveBudgetInfoUpdate(
                                                  budgetId,
                                                );
                                                if (result == true) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          BudgetCreationPageViewEdit(
                                                        initialIndex: 1,
                                                        selectedBudget:
                                                            selectedBudget,
                                                      ),
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
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Please fill in all the fields!',
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
                                                          ColorConstant.redA700,
                                                    ),
                                                  );
                                                }
                                                print(result);
                                              }
                                            : null,
                                        enabled: isValidated,
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
