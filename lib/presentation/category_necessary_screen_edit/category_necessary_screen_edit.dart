import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/auth/backend/authenticator.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_necessary_categories_storage.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/presentation/category_necessary_screen_edit/widgets/category_button.dart';
import 'package:noughtplan/widgets/custom_text_button.dart';

import '../category_necessary_screen/widgets/gridtrendingup_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_floating_button.dart';
import 'package:noughtplan/widgets/custom_search_view.dart';

final Map<int, String> buttonTexts = {
  0: 'Rent',
  1: 'Parking',
  2: 'Home Insurance',
  3: 'Property Tax',
  4: 'HOA Fees',
  5: 'Landscaping',
  6: 'Home Repairs',
  7: 'Home Improvements',
  8: 'General Housing Costs',
};

final Map<int, String> healthcareButtonTexts = {
  0: 'Doctor Visits',
  1: 'Prescriptions',
  2: 'Dental Care',
  3: 'Vision Care',
  4: 'Mental Health',
  5: 'Physical Therapy',
  6: 'Medical Bills',
  7: 'Health Insurance',
  8: 'General Healthcare Costs',
};

final Map<int, String> utilitiesButtonTexts = {
  0: 'Electricity',
  1: 'Gas',
  2: 'Water & Sewer',
  3: 'Trash & Recycling',
  4: 'Internet',
  5: 'Cable TV',
  6: 'Landline Phone',
  7: 'Cell Phone',
  8: 'General Utilities Costs',
};

final Map<int, String> transportationButtonTexts = {
  0: 'Fuel',
  1: 'Car Insurance',
  2: 'Car Maintenance',
  3: 'Car Repairs',
  4: 'Public Transportation',
  5: 'Ride Sharing',
  6: 'Taxis',
  7: 'Bike Maintenance',
  8: 'Parking Fees',
  9: 'Tolls',
  10: 'Vehicle Registration',
  11: 'Driver\'s License',
  12: 'General Transportation Costs',
};

final Map<int, String> debtLoansCategories = {
  0: 'Mortgage',
  1: 'Student Loan',
  2: 'Personal Loan',
  3: 'Car Loan',
  4: 'Credit Card Debt',
  5: 'Payday Loan',
  6: 'Business Loan',
  7: 'Medical Debt',
  8: 'Home Equity Loan',
  9: 'Consolidation Loan',
  10: 'Other Loans #1',
  11: 'Other Loans #2',
  12: 'General Debt',
};

final Map<int, String> savingsCategories = {
  0: 'Emergency Fund',
  1: 'Retirement Savings',
  2: 'Investments',
  3: 'Education Savings',
  4: 'Vacation Fund',
  5: 'Down Payment',
  6: 'Home Improvement Fund',
  7: 'Debt Payoff',
  8: 'Wedding Fund',
  9: 'Vehicle Savings',
  10: 'General Savings',
};

final Map<int, String> groceriesCategories = {
  0: 'Fresh Produce',
  1: 'Meat & Seafood',
  2: 'Dairy & Refrigerated',
  3: 'Bakery & Bread',
  4: 'Beverages',
  5: 'Pantry Essentials',
  6: 'Frozen Foods',
  7: 'Snacks & Sweets',
  8: 'Health & Wellness',
  9: 'Household Supplies',
  10: 'General Groceries',
};

final Map<int, String> educationCategories = {
  0: 'Tuition Fees',
  1: 'Textbooks & Course Materials',
  2: 'Supplies & Equipment',
  3: 'Technology & Software',
  4: 'Extracurricular Activities',
  5: 'Transportation & Travel',
  6: 'Childcare & Tutoring',
  8: 'Scholarships & Grants',
  9: 'General Education Costs',
};

final Map<int, String> petChildCategories = {
  0: 'Pet Food & Supplies',
  1: 'Veterinary Care',
  2: 'Pet Grooming',
  3: 'Pet Boarding & Sitting',
  4: 'Pet Training',
  5: 'Childcare & Babysitting',
  6: 'Children\'s Education & Tuition',
  7: 'Children\'s Clothing',
  8: 'Toys & Entertainment',
  9: 'Extracurricular Activities',
  10: 'Children\'s Health & Medical',
};

Map<int, String> mergeAllButtonTexts() {
  final allButtonTexts = <int, String>{};

  int offset = 0;
  List<Map<int, String>> allMaps = [
    buttonTexts,
    healthcareButtonTexts,
    utilitiesButtonTexts,
    transportationButtonTexts,
    debtLoansCategories,
    savingsCategories,
    groceriesCategories,
    educationCategories,
    petChildCategories
  ];

  for (final map in allMaps) {
    map.forEach((key, value) => allButtonTexts[key + offset] = value);
    offset += map.length;
  }

  return allButtonTexts;
}

List<Map<String, dynamic>> gridItems = [
  {
    'text': 'Debt/Loans',
    'iconPath': ImageConstant.imgTrendingup,
  },
  {
    'text': 'Utilities',
    'iconPath': ImageConstant.imgIcon,
  },
  {
    'text': 'Transport',
    'iconPath': ImageConstant.imgCarBlueA700,
  },
  {
    'text': 'Savings',
    'iconPath': ImageConstant.imgMusicBlueA700,
  },
  {
    'text': 'Housing',
    'iconPath': ImageConstant.imgHome,
  },
  {
    'text': 'Groceries',
    'iconPath': ImageConstant.imgVideocameraBlueA700,
  },
  {
    'text': 'Education',
    'iconPath': ImageConstant.imgCalendar,
  },
  {
    'text': 'Healthcare',
    'iconPath': ImageConstant.imgDownload,
  },
  {
    'text': 'Pet/Child',
    'iconPath': ImageConstant.imgIconBlueA700,
  },
];

Map<int, String> getButtonTextsForGridItem(String gridItemText) {
  switch (gridItemText) {
    case 'Housing':
      return buttonTexts;
    case 'Healthcare':
      return healthcareButtonTexts;
    case 'Utilities':
      return utilitiesButtonTexts;
    case 'Transport':
      return transportationButtonTexts;
    case 'Debt/Loans':
      return debtLoansCategories;
    case 'Savings':
      return savingsCategories;
    case 'Groceries':
      return groceriesCategories;
    case 'Education':
      return educationCategories;
    case 'Pet/Child':
      return petChildCategories;
    // Add more cases for other grid items if needed.
    default:
      return {}; // Return an empty map if no match is found.
  }
}

class ButtonListStateEdit extends ChangeNotifier {
  Map<String, List<String>> selectedCategories = {};
  String? currentParentCategory;
  final filteredCategories = ValueNotifier<List<String>>([]);

  void setCurrentParentCategory(String category) {
    currentParentCategory = category;
    notifyListeners();
  }

  void toggleButton(BuildContext context, int index, String buttonText) {
    if (currentParentCategory == null) return;

    selectedCategories.putIfAbsent(currentParentCategory!, () => []);
    if (selectedCategories[currentParentCategory!]!.contains(buttonText)) {
      selectedCategories[currentParentCategory!]!.remove(buttonText);
    } else {
      // Check if the total number of selected categories is less than 30
      int totalSelectedCategories = 0;
      bool isAlreadySelected = false;
      selectedCategories.forEach((key, value) {
        totalSelectedCategories += value.length;
        if (value.contains(buttonText)) {
          isAlreadySelected = true;
        }
      });

      if (isAlreadySelected) return;

      if (totalSelectedCategories < 30) {
        selectedCategories[currentParentCategory!]!.add(buttonText);
      } else {
        // Show an error message or an alert to the user
        final snackBar = SnackBar(
          content: Text(
            'You can only select up to 30 categories',
            textAlign: TextAlign.center,
            style: AppStyle.txtHelveticaNowTextBold16WhiteA700.copyWith(
              letterSpacing: getHorizontalSize(0.3),
            ),
          ),
          backgroundColor: ColorConstant.redA700,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    notifyListeners();
  }

  void removeCategory(String parentCategory, String buttonText) {
    if (selectedCategories.containsKey(parentCategory)) {
      selectedCategories[parentCategory]?.remove(buttonText);
      notifyListeners();
    }
  }

  void addCategory(String category) {
    // Use a default parent category or create a new one based on your requirements
    String defaultParentCategory = 'Custom Categories';

    selectedCategories.putIfAbsent(defaultParentCategory, () => []);
    if (!selectedCategories[defaultParentCategory]!.contains(category)) {
      selectedCategories[defaultParentCategory]!.add(category);
    }
    notifyListeners();
  }
}

class CategorySearchNotifierEdit extends StateNotifier<List<String>> {
  CategorySearchNotifierEdit() : super([]);

  void updateFilteredCategories(
    BuildContext context,
    String query,
    Map<int, String> allButtonTexts,
    int selectedCategoriesCount,
  ) {
    List<String> _filteredCategories = [];
    if (query.isNotEmpty) {
      allButtonTexts.forEach((key, value) {
        if (value.toLowerCase().contains(query.toLowerCase())) {
          _filteredCategories.add(value);
        }
      });
    }
    // Calculate the number of categories that can still be added
    int remainingCategories = 30 - selectedCategoriesCount;
    if (remainingCategories < _filteredCategories.length) {
      // Limit the filtered categories based on the number of remaining categories
      _filteredCategories = _filteredCategories.sublist(0, remainingCategories);
    }

    state = _filteredCategories;
  }
}

final categorySearchProvider =
    StateNotifierProvider<CategorySearchNotifierEdit, List<String>>(
        (ref) => CategorySearchNotifierEdit());

final buttonListStateProviderEdit =
    ChangeNotifierProvider<ButtonListStateEdit>((ref) => ButtonListStateEdit());

// ignore_for_file: must_be_immutable
class CategoryNecessaryScreenEdit extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Budget? selectedBudget =
        ModalRoute.of(context)!.settings.arguments as Budget?;

    final searchController = useTextEditingController();

    final filteredCategories = ref.watch(categorySearchProvider);

    final buttonListState = ref.watch(buttonListStateProviderEdit);
    Map<String, List<String>> selectedCategories =
        buttonListState.selectedCategories;
    String? parentCategory = buttonListState.currentParentCategory;
    List<String> selectedButtonTexts =
        parentCategory != null ? selectedCategories[parentCategory] ?? [] : [];
    List<Widget> selectedButtons = [];

    void initializeSelectedButtons(Map<String, double> necessaryExpense) {
      necessaryExpense.forEach((key, value) {
        ref.read(buttonListStateProviderEdit.notifier).addCategory(key);
      });
    }

    void initializeSelectedButtonsDebt(Map<String, double> debtExpense) {
      debtExpense.forEach((key, value) {
        ref.read(buttonListStateProviderEdit.notifier).addCategory(key);
      });
    }

    useEffect(() {
      Future.microtask(() {
        initializeSelectedButtons(selectedBudget?.necessaryExpense ?? {});
        initializeSelectedButtonsDebt(selectedBudget?.debtExpense ?? {});
      });
      return () {}; // Cleanup function
    }, []);

    selectedCategories.forEach((parentCategory, buttonTexts) {
      buttonTexts.forEach((buttonText) {
        selectedButtons.add(
          Padding(
            padding: EdgeInsets.only(left: 2, right: 2),
            child: GestureDetector(
              onTap: () {
                ref
                    .read(buttonListStateProviderEdit.notifier)
                    .removeCategory(parentCategory, buttonText);
              },
              child: Container(
                // width: getHorizontalSize(80),
                padding: getPadding(left: 16, top: 10, right: 16, bottom: 10),
                decoration: AppDecoration.txtOutlineBlueA700.copyWith(
                  borderRadius: BorderRadiusStyle.txtRoundedBorder10,
                ),
                child: Text(
                  buttonText,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppStyle.txtHelveticaNowTextBold12.copyWith(
                    letterSpacing: getHorizontalSize(0.3),
                  ),
                ),
              ),
            ),
          ),
        );
      });
    });

    print('selectedCategories: $selectedCategories');
    // print('selectedButtons: $selectedButtons');

    void _showModalBottomSheet(BuildContext context,
        Map<int, String> buttonTexts, String parentCategory) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                    // color: Colors.grey.withOpacity(0.5),
                    ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.4, // Set the initial height of the modal
                minChildSize: 0.4, // Set the minimum height of the modal
                maxChildSize: 0.6, // Set the maximum height of the modal
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: buttonTexts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final entry = buttonTexts.entries.elementAt(index);
                          return CategoryButtonEdit(
                            index: entry.key,
                            text: entry.value,
                            // selectedCategories:
                            //     buttonListState.selectedCategories,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }

    void showAddCategoryModal(BuildContext context, WidgetRef ref) {
      TextEditingController customCategoryController = TextEditingController();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          void submitForm() async {
            final customCategory = customCategoryController.text;
            if (customCategory.isNotEmpty) {
              ref
                  .read(buttonListStateProviderEdit.notifier)
                  .addCategory(customCategory);
            }
          }

          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.7,
                maxChildSize: 0.8,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(16),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        onSubmitted: (_) => submitForm(),
                                        controller: customCategoryController,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          labelText: "Custom Category",
                                          labelStyle: AppStyle
                                              .txtHelveticaNowTextBold14
                                              .copyWith(
                                            color: ColorConstant.blueGray300,
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          hintText:
                                              "Enter a custom category name...",
                                          hintStyle: AppStyle
                                              .txtManropeSemiBold14
                                              .copyWith(
                                                  color:
                                                      ColorConstant.blueGray300,
                                                  letterSpacing: 0.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadiusStyle
                                                .txtRoundedBorder10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    CustomButton(
                                      onTap: () {
                                        submitForm();
                                        Navigator.pop(context);
                                      },
                                      alignment: Alignment.bottomCenter,
                                      height: getVerticalSize(56),
                                      text: "Save",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        resizeToAvoidBottomInset: false,
        body: Container(
          height: size.height,
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Transform(
                        transform: Matrix4.identity()..scale(1.0, 1.0, 1.0),
                        alignment: Alignment.center,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgTopographic7,
                          height: MediaQuery.of(context).size.height *
                              1, // Set the height to 50% of the screen height
                          width: MediaQuery.of(context)
                              .size
                              .width, // Set the width to the full screen width
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 24, top: 16, right: 24),
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomAppBar(
                              height: getVerticalSize(70),
                              leadingWidth: 25,
                              leading: AppbarImage(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                height: getSize(24),
                                width: getSize(24),
                                svgPath: ImageConstant.imgArrowleft,
                                margin: getMargin(bottom: 1),
                              ),
                              centerTitle: true,
                              title: AppbarTitle(text: "Necessary Categories"),
                              actions: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          showAddCategoryModal(context, ref),
                                      child: Container(
                                        width: 70,
                                        child: SvgPicture.asset(
                                          ImageConstant.imgPlus,
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
                                                'Please read the instructions below',
                                                textAlign: TextAlign.center,
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold16,
                                              ),
                                              content: Text(
                                                " In this step, you'll be able to add necessary categories to your budget. Follow the instructions below:\n\n"
                                                "1. Browse through the available categories or use the search bar to find specific ones that match your needs.\n"
                                                "2. Tap on a category to add it to your chosen categories list. You can always tap again to remove it if needed.\n"
                                                "3. Once you've added all the necessary categories, press the 'Next' button to move on to adding discretionary categories.\n\n"
                                                "Remember, these necessary categories represent your essential expenses, such as rent, utilities, and groceries. Adding them accurately will help you create a realistic budget and better manage your finances.",
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
                                        child: SvgPicture.asset(
                                          ImageConstant.imgQuestion,
                                          height: 24,
                                          width: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            CustomSearchView(
                              focusNode: FocusNode(),
                              controller: searchController,
                              hintText: "Search...",
                              margin: getMargin(top: 14),
                              prefix: Container(
                                  margin: getMargin(
                                      left: 16, top: 18, right: 12, bottom: 18),
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgSearch)),
                              prefixConstraints: BoxConstraints(
                                maxHeight: getVerticalSize(56),
                              ),
                              onChanged: (query) {
                                ref
                                    .read(categorySearchProvider.notifier)
                                    .updateFilteredCategories(
                                        context,
                                        query,
                                        mergeAllButtonTexts(),
                                        selectedButtons.length);
                              },
                            ),
                            Visibility(
                              visible: filteredCategories.isNotEmpty,
                              child: SingleChildScrollView(
                                child: Container(
                                  height: 100,
                                  child: GridView.builder(
                                    padding: getPadding(
                                        left: 8, right: 8, top: 5, bottom: 5),
                                    shrinkWrap: true,
                                    itemCount: filteredCategories.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          2, // Set the number of columns you want
                                      mainAxisSpacing:
                                          8.0, // Set the spacing between rows
                                      crossAxisSpacing:
                                          8.0, // Set the spacing between columns
                                      childAspectRatio:
                                          5.0, // Set the aspect ratio of the grid items
                                    ),
                                    itemBuilder: (context, index) {
                                      final buttonListState = ref
                                          .watch(buttonListStateProviderEdit);
                                      final selectedButtons = buttonListState
                                          .selectedCategories.values
                                          .expand((element) => element)
                                          .toList();
                                      // print(
                                      //     'selectedButtons: $selectedButtons');
                                      final isSelected = selectedButtons
                                          .contains(filteredCategories[index]);

                                      return GestureDetector(
                                        onTap: () {
                                          if (selectedButtons.length < 30) {
                                            ref
                                                .read(
                                                    buttonListStateProviderEdit
                                                        .notifier)
                                                .addCategory(
                                                    filteredCategories[index]);
                                          } else {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'You can only select up to 30 categories',
                                                textAlign: TextAlign.center,
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold16WhiteA700
                                                    .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.3),
                                                ),
                                              ),
                                              backgroundColor:
                                                  ColorConstant.redA700,
                                              duration: Duration(seconds: 2),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                        child: CategoryButtonEdit(
                                          index: index,
                                          text: filteredCategories[index],
                                          isFromSearchResults: true,
                                          // selectedCategories: buttonListState
                                          // .selectedCategories,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: getPadding(top: 18),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Chosen Categories",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtHelveticaNowTextBold16
                                        .copyWith(
                                      letterSpacing: getHorizontalSize(0.4),
                                    ),
                                  ),
                                  Text(
                                    "${selectedButtons.length}/30",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: AppStyle.txtHelveticaNowTextBold16
                                        .copyWith(
                                      letterSpacing: getHorizontalSize(0.4),
                                      color: ColorConstant.blueA700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                top: 21,
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: getVerticalSize(105),
                                ),
                                child: SingleChildScrollView(
                                  child: Container(
                                    width: double.maxFinite,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child: Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: selectedButtons,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: getPadding(top: 16),
                                child: Text("Budget Category Sectors",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtHelveticaNowTextBold16
                                        .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.4)))),
                            Padding(
                                padding: getPadding(top: 15, right: 8),
                                child: Row(children: [
                                  CustomButton(
                                      height: getVerticalSize(28),
                                      width: getHorizontalSize(158),
                                      text: "Necessary Exps.",
                                      shape: ButtonShape.RoundedBorder6,
                                      padding: ButtonPadding.PaddingT3,
                                      fontStyle:
                                          ButtonFontStyle.ManropeSemiBold12,
                                      prefixWidget: Container(
                                          margin: getMargin(right: 8),
                                          child: CustomImageView(
                                              svgPath: ImageConstant.imgCar))),
                                  Padding(
                                      padding: getPadding(
                                          left: 16, top: 7, bottom: 3),
                                      child: Text("Discretionary Exps. ",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeSemiBold12
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  CustomImageView(
                                      svgPath: ImageConstant.imgCart,
                                      height: getSize(22),
                                      width: getSize(22),
                                      margin:
                                          getMargin(left: 8, top: 3, bottom: 3))
                                ])),
                            Expanded(
                              child: Padding(
                                padding: getPadding(top: 10),
                                child: SingleChildScrollView(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: getVerticalSize(109),
                                      crossAxisCount: 3,
                                      mainAxisSpacing: getHorizontalSize(16),
                                      crossAxisSpacing: getHorizontalSize(16),
                                    ),
                                    itemCount: gridItems.length,
                                    itemBuilder: (context, index) {
                                      return GridtrendingupItemWidget(
                                        text: gridItems[index]['text'],
                                        iconPath: gridItems[index]['iconPath'],
                                        onTap: () {
                                          final buttonTexts =
                                              getButtonTextsForGridItem(
                                                  gridItems[index]['text']);
                                          String parentCategory =
                                              gridItems[index]['text'];
                                          ref
                                              .read(buttonListStateProviderEdit
                                                  .notifier)
                                              .setCurrentParentCategory(
                                                  parentCategory);
                                          _showModalBottomSheet(context,
                                              buttonTexts, parentCategory);
                                          print(
                                              '${gridItems[index]['text']} tapped');
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: getMargin(left: 3),
                padding: getPadding(left: 21, top: 10, right: 21, bottom: 12),
                decoration: AppDecoration.outlineBluegray5000c,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomImageView(
                      svgPath: ImageConstant.imgCarousel2,
                      margin: getMargin(bottom: 10),
                    ),
                    CustomButton(
                      height: getVerticalSize(56),
                      text: "Next",
                      onTap: () async {
                        final Map<String, double> debtLoanCategories = {
                          "Mortgage": 0,
                          "Car Loan": 0,
                          "Student Loan": 0,
                          "Personal Loan": 0,
                          "Payday Loan": 0,
                          "Business Loan": 0,
                          "Medical Debt": 0,
                          "Home Equity Loan": 0,
                          "Consolidation Loan": 0,
                          "Credit Card Debt": 0,
                          "General Debt": 0,
                          "Other Loans #1": 0,
                          "Other Loans #2": 0,
                        };

                        final Map<String, double> savingCategories = {
                          "Emergency Fund": 0,
                          "Retirement Savings": 0,
                          "Investments": 0,
                          "Education Savings": 0,
                          "Vacation Fund": 0,
                          "Down Payment": 0,
                          "Home Improvement Fund": 0,
                          "Home Equity Loan": 0,
                          "Debt Payoff": 0,
                          "Wedding Fund": 0,
                          "Vehicle Savings": 0,
                          "General Savings": 0,
                          "surplus": 0,
                          "Savings": 0,
                        };

                        Map<String, double> allCategoriesWithAmount = {
                          for (String parentCategory in selectedCategories.keys)
                            for (String categoryName
                                in selectedCategories[parentCategory]!)
                              categoryName: 0,
                        };

                        Map<String, double> necessaryCategoriesWithAmount = {
                          for (String parentCategory in selectedCategories.keys)
                            for (String categoryName
                                in selectedCategories[parentCategory]!)
                              if (!debtLoanCategories.containsKey(categoryName))
                                categoryName: 0,
                        };

                        Map<String, double> extractedDebtLoanCategories = {
                          for (String key in allCategoriesWithAmount.keys)
                            if (debtLoanCategories.containsKey(key))
                              key: allCategoriesWithAmount[key]!,
                        };

                        print(allCategoriesWithAmount);
                        print(necessaryCategoriesWithAmount);
                        print(extractedDebtLoanCategories);

                        final budgetState =
                            ref.watch(budgetStateProvider.notifier);
                        final generateSalaryController =
                            ref.watch(generateSalaryProvider.notifier);
                        final String? budgetId =
                            generateSalaryController.state.budgetId;

                        await budgetState.saveBudgetNecessaryInfo(
                          budgetId: budgetId,
                          necessaryExpense: necessaryCategoriesWithAmount,
                        );

                        await budgetState.saveBudgetDebtInfo(
                          budgetId: budgetId,
                          debtExpense: extractedDebtLoanCategories,
                        );

                        if (budgetState.state.status == BudgetStatus.success &&
                            allCategoriesWithAmount.isNotEmpty) {
                          // Show SnackBar with success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Information saved successfully!',
                                textAlign: TextAlign.center,
                                style: AppStyle
                                    .txtHelveticaNowTextBold16WhiteA700
                                    .copyWith(
                                  letterSpacing: getHorizontalSize(0.3),
                                ),
                              ),
                              backgroundColor: ColorConstant.blue900,
                            ),
                          );
                          Navigator.pushNamed(
                              context, '/category_discretionary_screen',
                              arguments: {
                                'necessaryCategoriesWithAmount':
                                    necessaryCategoriesWithAmount,
                                'extractedDebtLoanCategories':
                                    extractedDebtLoanCategories,
                              });
                        } else if (budgetState.state.status ==
                            BudgetStatus.failure) {
                          // Show SnackBar with failure message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Something went wrong! Please try again later.',
                                textAlign: TextAlign.center,
                                style: AppStyle
                                    .txtHelveticaNowTextBold16WhiteA700
                                    .copyWith(
                                  letterSpacing: getHorizontalSize(0.3),
                                ),
                              ),
                              backgroundColor: ColorConstant.redA700,
                            ),
                          );
                        } else if (allCategoriesWithAmount.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select at least one category.',
                                textAlign: TextAlign.center,
                                style: AppStyle
                                    .txtHelveticaNowTextBold16WhiteA700
                                    .copyWith(
                                  letterSpacing: getHorizontalSize(0.3),
                                ),
                              ),
                              backgroundColor: ColorConstant.amber600,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onTapArrowleft1(BuildContext context) {
    Navigator.pop(context);
  }

  onTapNext(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.categoryDiscretionaryScreen);
  }
}
