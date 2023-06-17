import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/allocate_funds_screen.dart';
import 'package:noughtplan/presentation/category_discretionary_screen/category_discretionary_screen.dart';
import 'package:noughtplan/presentation/category_necessary_screen/category_necessary_screen.dart';
import 'package:noughtplan/presentation/generator_salary_screen/generator_salary_screen.dart';
import 'package:uuid/uuid.dart';

class BudgetCreationPageView extends StatefulWidget {
  final int initialIndex;

  BudgetCreationPageView({required this.initialIndex});
  @override
  _BudgetCreationPageViewState createState() => _BudgetCreationPageViewState();
}

class _BudgetCreationPageViewState extends State<BudgetCreationPageView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // _generateBudgetId();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentIndex == index ? ColorConstant.blueA700 : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final Map<String, double> necessaryCategoriesWithAmount =
        args?['necessaryCategoriesWithAmount'] as Map<String, double>? ?? {};

    final Map<String, double> extractedDebtLoanCategories =
        args?['extractedDebtLoanCategories'] as Map<String, double>? ?? {};

    final Map<String, double> discretionaryCategoriesWithAmount =
        args?['discretionaryCategoriesWithAmount'] as Map<String, double>? ??
            {};

    final String budgetId = args?['budgetId'] as String? ?? '';
    // print('budgetId in allocate screen: $budgetId');

    print(
        'necessaryCategoriesWithAmount in BudgetCreation: ${necessaryCategoriesWithAmount}');
    print(
        'extractedDebtLoanCategories in BudgetCreation: ${extractedDebtLoanCategories}');
    print(
        'discretionaryCategoriesWithAmount in BudgetCreation: ${discretionaryCategoriesWithAmount}');

    print('budgetId in BudgetCreation as argument: ${budgetId}');

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                GeneratorSalaryScreen(),
                CategoryNecessaryScreen(),
                AllocateFundsScreen(),
              ],
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(0),
                    _buildDot(1),
                    _buildDot(2),
                  ],
                ),
                Padding(
                  padding: getPadding(bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomImageView(
                        svgPath: ImageConstant.imgArrowLeft,
                        height: getSize(16),
                        width: getSize(16),
                        color: ColorConstant.lightBlueA200,
                      ),
                      Padding(
                        padding: getPadding(left: 6, right: 6),
                        child: Text('Swipe to Navigate',
                            style: AppStyle.txtManropeSemiBold12
                                .copyWith(color: ColorConstant.lightBlueA200)),
                      ),
                      CustomImageView(
                        svgPath: ImageConstant.imgArrowRight,
                        height: getSize(16),
                        width: getSize(16),
                        color: ColorConstant.lightBlueA200,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
