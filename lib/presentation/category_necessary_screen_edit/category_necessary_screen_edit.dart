import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/auth/backend/authenticator.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_necessary_categories_storage.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/providers/first_time_provider.dart';
import 'package:noughtplan/presentation/budget_creation_page_view_edit/budget_creation_page_view_edit.dart';
import 'package:noughtplan/presentation/category_discretionary_screen_edit/category_discretionary_screen_edit.dart';
import 'package:noughtplan/presentation/category_necessary_screen_edit/widgets/category_button.dart';
import 'package:noughtplan/widgets/custom_text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  8: 'Life Insurance',
  9: 'General Healthcare Costs',
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
    petChildCategories,
    entertainmentButtonTexts,
    subscriptionButtonTexts,
    personalCareButtonTexts,
    clothingButtonTexts,
    restaurantButtonTexts,
    technologyButtonTexts,
    personalSpendingButtonTexts,
    otherButtonTexts,
    givingButtonTexts,
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

final Map<int, String> entertainmentButtonTexts = {
  0: 'Movies',
  1: 'Music',
  2: 'Video Games',
  3: 'Concerts',
  4: 'Theater',
  5: 'Museums',
  6: 'Sports Events',
  7: 'Theme Parks',
  8: 'Books',
  9: 'Hobbies',
  10: 'Outdoor Activities',
  11: 'Fitness Classes',
  12: 'General Entertainment Costs',
};

final Map<int, String> subscriptionButtonTexts = {
  0: 'Streaming Services',
  1: 'Magazines',
  2: 'Newspapers',
  3: 'Music Services',
  4: 'Gym Memberships',
  5: 'Online Courses',
  6: 'Software Services',
  7: 'App Subscriptions',
  8: 'Cloud Storage',
  9: 'General Subscriptions Costs',
};

final Map<int, String> personalCareButtonTexts = {
  0: 'Hair Care',
  1: 'Skin Care',
  2: 'Makeup',
  3: 'Spa Services',
  4: 'Massages',
  5: 'Dental Care',
  6: 'Eye Care',
  7: 'Grooming',
  8: 'Fitness',
  9: 'General Personal Care Costs',
};

final Map<int, String> clothingButtonTexts = {
  0: 'Shirts',
  1: 'Pants',
  2: 'Dresses',
  3: 'Suits',
  4: 'Shoes',
  5: 'Accessories',
  6: 'Outerwear',
  7: 'Sportswear',
  8: 'Underwear',
  9: 'General Clothing Costs',
};

final Map<int, String> restaurantButtonTexts = {
  0: 'Fast Food',
  1: 'Casual Dining',
  2: 'Fine Dining',
  3: 'Cafes',
  4: 'Bars',
  5: 'Buffets',
  6: 'Delivery Services',
  7: 'Food Trucks',
  8: 'Takeout',
  9: 'General Restaurant Costs',
};

final Map<int, String> technologyButtonTexts = {
  0: 'Smartphones',
  1: 'Laptops',
  2: 'Tablets',
  3: 'Gaming Consoles',
  4: 'Wearables',
  5: 'Smart Home Devices',
  6: 'Audio Equipment',
  7: 'Cameras',
  8: 'Accessories',
  9: 'General Technology Costs',
};

final Map<int, String> personalSpendingButtonTexts = {
  0: 'Hobbies',
  1: 'Sports',
  2: 'Vacations',
  3: 'Gifts',
  4: 'Events',
  5: 'Memberships',
  6: 'Courses',
  7: 'Recreation',
  8: 'Collectibles',
  9: 'General Personal Spending',
};

final Map<int, String> otherButtonTexts = {
  0: 'Legal Fees',
  1: 'Taxes',
  2: 'Fines',
  3: 'Miscellaneous',
};

final Map<int, String> givingButtonTexts = {
  0: 'Charitable Donations',
  1: 'Gifts',
  2: 'Supporting Friends & Family',
  3: 'Community Projects',
  4: 'Fundraisers',
  5: 'Sponsorships',
  6: 'Volunteering',
  7: 'Tithing',
  8: 'Crowdfunding',
};

// Map<int, String> mergeAllButtonTexts() {
//   final allButtonTexts = <int, String>{};

//   int offset = 0;
//   List<Map<int, String>> allMaps = [

//     entertainmentbuttonTexts,
//     subscriptionButtonTexts,
//     personalCareButtonTexts,
//     clothingButtonTexts,
//     restaurantButtonTexts,
//     technologyButtonTexts,
//     personalSpendingButtonTexts,
//     otherButtonTexts,
//     givingButtonTexts,
//   ];

//   for (final map in allMaps) {
//     map.forEach((key, value) => allButtonTexts[key + offset] = value);
//     offset += map.length;
//   }

//   return allButtonTexts;
// }

List<Map<String, dynamic>> gridItemsDiscretionary = [
  {
    'text': 'Entertainment',
    'iconPath': ImageConstant.imgEntertainment,
  },
  {
    'text': 'Subscriptions',
    'iconPath': ImageConstant.imgSend,
  },
  {
    'text': 'Personal Care',
    'iconPath': ImageConstant.imgLocation,
  },
  {
    'text': 'Clothing',
    'iconPath': ImageConstant.imgBag,
  },
  {
    'text': 'Restaurants',
    'iconPath': ImageConstant.imgTrophyBlueA700,
  },
  {
    'text': 'Technology',
    'iconPath': ImageConstant.imgTrash,
  },
  {
    'text': 'Spending',
    'iconPath': ImageConstant.imgVideocameraBlueA70048x48,
  },
  {
    'text': 'Other',
    'iconPath': ImageConstant.imgPlus,
  },
  {
    'text': 'Giving',
    'iconPath': ImageConstant.imgVideocamera48x48,
  },
];

Map<int, String> getButtonTextsForGridItemDiscretionary(String gridItemText) {
  switch (gridItemText) {
    case 'Entertainment':
      return entertainmentButtonTexts;
    case 'Subscriptions':
      return subscriptionButtonTexts;
    case 'Personal Care':
      return personalCareButtonTexts;
    case 'Clothing':
      return clothingButtonTexts;
    case 'Restaurants':
      return restaurantButtonTexts;
    case 'Technology':
      return technologyButtonTexts;
    case 'Spending':
      return personalSpendingButtonTexts;
    case 'Other':
      return otherButtonTexts;
    case 'Giving':
      return givingButtonTexts;
    // Add more cases for other grid items if needed.
    default:
      return {}; // Return an empty map if no match is found.
  }
}

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

  Future<void> toggleButton(
      BuildContext context, int index, String buttonText) async {
    if (currentParentCategory == null) return;

    selectedCategories.putIfAbsent(currentParentCategory!, () => []);
    if (selectedCategories[currentParentCategory!]!.contains(buttonText)) {
      selectedCategories[currentParentCategory!]!.remove(buttonText);
    } else {
      // Check if the total number of selected categories is less than 45
      int totalSelectedCategories = 0;
      bool isAlreadySelected = false;
      selectedCategories.forEach((key, value) {
        totalSelectedCategories += value.length;
        if (value.contains(buttonText)) {
          isAlreadySelected = true;
        }
      });

      if (isAlreadySelected) return;

      if (totalSelectedCategories < 45) {
        selectedCategories[currentParentCategory!]!.add(buttonText);
        print('currentParentCategory: $currentParentCategory');
        print('buttonText: $buttonText');
        final prefs = await SharedPreferences.getInstance();
        List<String>? modalCategories = prefs.getStringList('modalCategories');
        if (modalCategories == null) {
          modalCategories = [];
        }
        modalCategories.add(buttonText);
        await prefs.setStringList('modalCategories', modalCategories);
      } else {
        // Show an error message or an alert to the user
        final snackBar = SnackBar(
          content: Text(
            'You can only select up to 45 categories',
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

  Future<void> removeCategory(String parentCategory, String buttonText) async {
    if (selectedCategories.containsKey(parentCategory)) {
      selectedCategories[parentCategory]?.remove(buttonText);
      final prefs = await SharedPreferences.getInstance();
      List<String>? categoryList = prefs.getStringList(parentCategory);
      List<String>? modalCategories = prefs.getStringList('modalCategories');
      List<String>? searchCategories = prefs.getStringList('searchCategories');
      if (categoryList != null) {
        categoryList.remove(buttonText);
        await prefs.setStringList(parentCategory, categoryList);
      }
      if (modalCategories != null) {
        modalCategories.remove(buttonText);
        await prefs.setStringList('modalCategories', modalCategories);
      }
      if (searchCategories != null) {
        searchCategories.remove(buttonText);
        await prefs.setStringList('searchCategories', searchCategories);
      }
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

  void addNecessaryCategory(String category) {
    // Use a default parent category or create a new one based on your requirements
    String defaultParentCategory = 'necessaryCategories';

    selectedCategories.putIfAbsent(defaultParentCategory, () => []);
    if (!selectedCategories[defaultParentCategory]!.contains(category)) {
      selectedCategories[defaultParentCategory]!.add(category);
    }
    notifyListeners();
  }

  void addDiscretionaryCategory(String category) {
    // Use a default parent category or create a new one based on your requirements
    String defaultParentCategory = 'discretionaryCategories';

    selectedCategories.putIfAbsent(defaultParentCategory, () => []);
    if (!selectedCategories[defaultParentCategory]!.contains(category)) {
      selectedCategories[defaultParentCategory]!.add(category);
    }
    notifyListeners();
  }

  void addDebtCategory(String category) {
    // Use a default parent category or create a new one based on your requirements
    String defaultParentCategory = 'debtCategories';

    selectedCategories.putIfAbsent(defaultParentCategory, () => []);
    if (!selectedCategories[defaultParentCategory]!.contains(category)) {
      selectedCategories[defaultParentCategory]!.add(category);
    }
    notifyListeners();
  }

  void clearSelectedCategories() {
    selectedCategories.clear();
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
    int remainingCategories = 45 - selectedCategoriesCount;
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

final isDiscretionaryExpsSelectedProvider =
    StateNotifierProvider<DiscretionaryExpsSelectedNotifier, bool>(
  (ref) => DiscretionaryExpsSelectedNotifier(),
);

class DiscretionaryExpsSelectedNotifier extends StateNotifier<bool> {
  DiscretionaryExpsSelectedNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

// ignore_for_file: must_be_immutable
class CategoryNecessaryScreenEdit extends HookConsumerWidget {
  final Budget selectedBudget;

  CategoryNecessaryScreenEdit({required this.selectedBudget});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDiscretionaryExpsSelected =
        ref.watch(isDiscretionaryExpsSelectedProvider);

    final _animationController =
        useAnimationController(duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);

    final firstTime = ref.watch(firstTimeProvider);
    // final Budget selectedBudget =
    //     ModalRoute.of(context)!.settings.arguments as Budget;

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
        if (key != 'Surplus') {
          ref.read(buttonListStateProviderEdit.notifier).addCategory(key);
        }
      });
    }

    void initializeSelectedButtonsDebt(Map<String, double> debtExpense) {
      debtExpense.forEach((key, value) {
        ref.read(buttonListStateProviderEdit.notifier).addCategory(key);
      });
    }

    void initializeSelectedButtonsDiscretionary(
        Map<String, double> discretionaryExpense) {
      discretionaryExpense.forEach((key, value) {
        ref.read(buttonListStateProviderEdit.notifier).addCategory(key);
      });
    }

    useEffect(() {
      Future.microtask(() async {
        final prefs = await SharedPreferences.getInstance();
        final necessaryCategories =
            prefs.getStringList('necessaryCategories') ?? [];
        final debtCategories = prefs.getStringList('debtCategories') ?? [];
        final discretionaryCategories =
            prefs.getStringList('discretionaryCategories') ?? [];
        final modalCategories = prefs.getStringList('modalCategories') ?? [];
        final searchCategories = prefs.getStringList('searchCategories') ?? [];

        ref
            .read(buttonListStateProviderEdit.notifier)
            .clearSelectedCategories();
        initializeSelectedButtons(selectedBudget.necessaryExpense ?? {});
        initializeSelectedButtonsDebt(selectedBudget.debtExpense ?? {});
        initializeSelectedButtonsDiscretionary(
            selectedBudget.discretionaryExpense ?? {});

        for (final category in necessaryCategories) {
          ref
              .read(buttonListStateProviderEdit.notifier)
              .addNecessaryCategory(category);
        }

        for (final category in debtCategories) {
          ref
              .read(buttonListStateProviderEdit.notifier)
              .addDebtCategory(category);
        }

        for (final category in discretionaryCategories) {
          ref
              .read(buttonListStateProviderEdit.notifier)
              .addDiscretionaryCategory(category);
        }
        for (final category in modalCategories) {
          ref.read(buttonListStateProviderEdit.notifier).addCategory(category);
        }
        for (final category in searchCategories) {
          ref.read(buttonListStateProviderEdit.notifier).addCategory(category);
        }

        // print('selectedBudget $selectedBudget');
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
                initialChildSize: 0.42, // Set the initial height of the modal
                minChildSize: 0.42, // Set the minimum height of the modal
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
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.grey[400],
                            ),
                            padding: getPadding(top: 50),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(16),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 200),
                                child: GridView.builder(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: buttonTexts.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 1.7,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final entry =
                                        buttonTexts.entries.elementAt(index);
                                    return CategoryButtonEdit(
                                      index: entry.key,
                                      text: entry.value,
                                      // selectedCategories:
                                      //     buttonListState.selectedCategories,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
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

    void _showModalBottomSheetDiscretionary(BuildContext context,
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
                initialChildSize: 0.42, // Set the initial height of the modal
                minChildSize: 0.42, // Set the minimum height of the modal
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
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.grey[400],
                            ),
                            padding: getPadding(top: 50),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(16),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 200),
                                child: GridView.builder(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: buttonTexts.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 1.2,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final entry =
                                        buttonTexts.entries.elementAt(index);
                                    return CategoryButtonEdit(
                                      index: entry.key,
                                      text: entry.value,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
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
      String? categoryType;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          void submitForm() async {
            final customCategory = customCategoryController.text;
            if (customCategory.isNotEmpty && categoryType != null) {
              final prefs = await SharedPreferences.getInstance();

              if (categoryType == 'Necessary') {
                ref
                    .read(buttonListStateProviderEdit.notifier)
                    .addNecessaryCategory(customCategory);
                final necessaryCategories =
                    prefs.getStringList('necessaryCategories') ?? [];
                necessaryCategories.add(customCategory);
                await prefs.setStringList(
                    'necessaryCategories', necessaryCategories);
                Navigator.of(context).pop();
              } else if (categoryType == 'Discretionary') {
                ref
                    .read(buttonListStateProviderEdit.notifier)
                    .addDiscretionaryCategory(customCategory);
                final discretionaryCategories =
                    prefs.getStringList('discretionaryCategories') ?? [];
                discretionaryCategories.add(customCategory);
                await prefs.setStringList(
                    'discretionaryCategories', discretionaryCategories);
                Navigator.of(context).pop();
              } else if (categoryType == 'Debt') {
                ref
                    .read(buttonListStateProviderEdit.notifier)
                    .addDebtCategory(customCategory);
                final debtCategories =
                    prefs.getStringList('debtCategories') ?? [];
                debtCategories.add(customCategory);
                await prefs.setStringList('debtCategories', debtCategories);
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop();
              }
            }
          }

          final generateSalaryState = ref.watch(generateSalaryProvider);

          final generateSalaryController =
              ref.watch(generateSalaryProvider.notifier);

          final budgetId = generateSalaryController.state.budgetId;

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Container(),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.85,
                    minChildSize: 0.85,
                    maxChildSize: 0.9,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32),
                                ),
                                color: Colors.white,
                              ),
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                controller: scrollController,
                                child: Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.grey[400],
                                      ),
                                      // margin: EdgeInsets.symmetric(vertical: 8),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: getPadding(bottom: 8),
                                            child: Text(
                                              'Add Custom Category',
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold32
                                                  .copyWith(
                                                color: ColorConstant.black900,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Choose the category type and enter the category name to add a custom category.',
                                            style: AppStyle.txtManropeSemiBold12
                                                .copyWith(
                                              color: ColorConstant.blueGray500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(
                                        top: 8,
                                        left: 24,
                                        right: 24,
                                        bottom: 16,
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(),
                                        hint: Text(
                                          "Custom Category Type",
                                          style: AppStyle
                                              .txtHelveticaNowTextBold14
                                              .copyWith(
                                            color: ColorConstant.blueGray300,
                                          ),
                                        ),
                                        value: categoryType,
                                        items: <String>[
                                          'Debt',
                                          'Necessary',
                                          'Discretionary',
                                          // 'Custom Goal'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold16
                                                  .copyWith(
                                                color: ColorConstant.black900,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            categoryType = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        onSubmitted: (_) => submitForm(),
                                        controller: customCategoryController,
                                        textAlign: TextAlign.center,
                                        style: AppStyle.txtManropeRegular16
                                            .copyWith(
                                                color:
                                                    ColorConstant.blueGray800),
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
                      );
                    },
                  ),
                ],
              );
            },
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
                          imagePath: ImageConstant.budgetTopo,
                          height: MediaQuery.of(context).size.height *
                              0.7, // Set the height to 50% of the screen height
                          width: MediaQuery.of(context)
                              .size
                              .width, // Set the width to the full screen width
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 24, top: 16, right: 24),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomAppBar(
                                height: getVerticalSize(70),
                                leadingWidth: 25,
                                leading: CustomImageView(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  height: getSize(24),
                                  width: getSize(24),
                                  svgPath: ImageConstant.imgArrowleft,
                                  margin: getMargin(bottom: 1),
                                ),
                                centerTitle: true,
                                title: Padding(
                                  padding: getPadding(right: 32),
                                  child: AppbarTitle(text: "Categories"),
                                ),
                                actions: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/home_page_screen');
                                    },
                                    child: Container(
                                      // width: 70,
                                      child: SvgPicture.asset(
                                        ImageConstant.imgHome2,
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                  ),
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
                                                  'Editing Your Necessary Categories',
                                                  textAlign: TextAlign.center,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold16,
                                                ),
                                                content: SingleChildScrollView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  child: Container(
                                                    child: RichText(
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        style: AppStyle
                                                            .txtManropeRegular14
                                                            .copyWith(
                                                                color: ColorConstant
                                                                    .blueGray800),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "Editing necessary categories for your budget is straightforward. Here's how:\n\n"),
                                                          TextSpan(
                                                              text:
                                                                  '1. Browse and Search:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          TextSpan(
                                                              text:
                                                                  ' Review the available categories or use the search bar to find the ones you wish to modify.\n\n'),
                                                          TextSpan(
                                                              text:
                                                                  '2. Modify Custom Category:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          TextSpan(
                                                              text:
                                                                  ' Need to adjust a unique expense in your categories? Press the plus (+) button at the top to update your own custom category. The same applies to your debts, loans, and savings. Simply locate the "savings", "loan", or "debt" in the category name, and make the necessary changes.\n\n'),
                                                          TextSpan(
                                                              text:
                                                                  '3. Select and Deselect:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          TextSpan(
                                                              text:
                                                                  ' Tap any category to edit it. Made an error? No problem, simply tap again to remove it. You can also deselect a category from the Chosen Category section if you no longer need it.\n\n'),
                                                          TextSpan(
                                                              text:
                                                                  '4. Proceed:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          TextSpan(
                                                              text:
                                                                  " Once you've made all the necessary adjustments, hit the \'Next\' button to proceed to discretionary categories.\n\n"),
                                                          TextSpan(
                                                              text:
                                                                  "Remember, necessary categories represent essential expenses such as rent, utilities, groceries, debts, and savings. By updating them accurately, you're ensuring a realistic budget and effective financial management. If a category remains unchanged, the old value will automatically be used."),
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
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    boxShape: NeumorphicBoxShape
                                                        .circle(),
                                                    depth: 0.9,
                                                    intensity: 8,
                                                    surfaceIntensity: 0.7,
                                                    shadowLightColor:
                                                        Colors.white,
                                                    lightSource:
                                                        LightSource.top,
                                                    color: firstTime
                                                        ? ColorConstant.blueA700
                                                        : Colors.white,
                                                  ),
                                                  child: SvgPicture.asset(
                                                    ImageConstant.imgQuestion,
                                                    height: 24,
                                                    width: 24,
                                                    color: firstTime
                                                        ? ColorConstant
                                                            .whiteA700
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
                                                        -5 *
                                                            _animationController
                                                                .value),
                                                    child: Padding(
                                                      padding:
                                                          getPadding(top: 16),
                                                      child: SvgPicture.asset(
                                                        ImageConstant
                                                            .imgArrowUp, // path to your arrow SVG image
                                                        height: 24,
                                                        width: 24,
                                                        color: ColorConstant
                                                            .blueA700,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
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
                                prefix: Container(
                                    margin: getMargin(
                                        left: 16,
                                        top: 18,
                                        right: 12,
                                        bottom: 18),
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
                                  physics: BouncingScrollPhysics(),
                                  child: Container(
                                    height: 150,
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
                                            3.0, // Set the aspect ratio of the grid items
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
                                        final isSelected =
                                            selectedButtons.contains(
                                                filteredCategories[index]);

                                        return GestureDetector(
                                          onTap: () async {
                                            if (selectedButtons.length < 45) {
                                              ref
                                                  .read(
                                                      buttonListStateProviderEdit
                                                          .notifier)
                                                  .addCategory(
                                                      filteredCategories[
                                                          index]);
                                            } else {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                  'You can only select up to 45 categories',
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
                                      "${selectedButtons.length}/45",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: AppStyle.txtHelveticaNowTextBold16
                                          .copyWith(
                                        letterSpacing: getHorizontalSize(0.4),
                                        color: selectedButtons.length == 45
                                            ? Colors.red
                                            : ColorConstant.blueA700,
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
                                    physics: BouncingScrollPhysics(),
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
                                child: Text(
                                  "Budget Category Sectors",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtHelveticaNowTextBold16
                                      .copyWith(
                                    letterSpacing: getHorizontalSize(0.4),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: getPadding(top: 15, right: 8),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => ref
                                          .read(
                                              isDiscretionaryExpsSelectedProvider
                                                  .notifier)
                                          .toggle(),
                                      child: Container(
                                        height: getVerticalSize(40),
                                        width: getHorizontalSize(158),
                                        decoration: BoxDecoration(
                                          color: !isDiscretionaryExpsSelected
                                              ? ColorConstant.blueA700
                                              : ColorConstant.whiteA700,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomImageView(
                                              svgPath: ImageConstant.imgCar,
                                              height: getSize(22),
                                              width: getSize(22),
                                              color:
                                                  !isDiscretionaryExpsSelected
                                                      ? ColorConstant.whiteA700
                                                      : ColorConstant.blueA700,
                                            ),
                                            Text(
                                              "Necessary Exps.",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeSemiBold12
                                                  .copyWith(
                                                color:
                                                    !isDiscretionaryExpsSelected
                                                        ? ColorConstant
                                                            .whiteA700
                                                        : ColorConstant
                                                            .blueA700,
                                                letterSpacing:
                                                    getHorizontalSize(0.2),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () => ref
                                          .read(
                                              isDiscretionaryExpsSelectedProvider
                                                  .notifier)
                                          .toggle(),
                                      child: Container(
                                        height: getVerticalSize(40),
                                        width: getHorizontalSize(158),
                                        decoration: BoxDecoration(
                                          color: isDiscretionaryExpsSelected
                                              ? ColorConstant.blueA700
                                              : ColorConstant.whiteA700,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Discretionary Exps. ",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeSemiBold12
                                                  .copyWith(
                                                color:
                                                    isDiscretionaryExpsSelected
                                                        ? ColorConstant
                                                            .whiteA700
                                                        : ColorConstant
                                                            .blueA700,
                                                letterSpacing:
                                                    getHorizontalSize(0.2),
                                              ),
                                            ),
                                            CustomImageView(
                                              svgPath: ImageConstant.imgCart,
                                              height: getSize(22),
                                              width: getSize(22),
                                              color: isDiscretionaryExpsSelected
                                                  ? ColorConstant.whiteA700
                                                  : ColorConstant.blueA700,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: isDiscretionaryExpsSelected,
                                child: Expanded(
                                  child: Padding(
                                    padding: getPadding(top: 10),
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: getVerticalSize(105),
                                          crossAxisCount: 3,
                                          mainAxisSpacing: getHorizontalSize(8),
                                          crossAxisSpacing:
                                              getHorizontalSize(8),
                                        ),
                                        itemCount:
                                            gridItemsDiscretionary.length,
                                        itemBuilder: (context, index) {
                                          return GridtrendingupItemWidget(
                                            text: gridItemsDiscretionary[index]
                                                ['text'],
                                            iconPath:
                                                gridItemsDiscretionary[index]
                                                    ['iconPath'],
                                            onTap: () {
                                              final buttonTextsDiscretionary =
                                                  getButtonTextsForGridItemDiscretionary(
                                                      gridItemsDiscretionary[
                                                          index]['text']);
                                              String
                                                  parentCategoryDiscretionary =
                                                  gridItemsDiscretionary[index]
                                                      ['text'];
                                              ref
                                                  .read(
                                                      buttonListStateProviderDiscretionaryEdit
                                                          .notifier)
                                                  .setCurrentParentCategory(
                                                      parentCategoryDiscretionary);
                                              _showModalBottomSheetDiscretionary(
                                                  context,
                                                  buttonTextsDiscretionary,
                                                  parentCategoryDiscretionary);
                                              print(
                                                  '${gridItemsDiscretionary[index]['text']} tapped');
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !isDiscretionaryExpsSelected,
                                child: Expanded(
                                  child: Padding(
                                    padding: getPadding(top: 10, bottom: 10),
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: getVerticalSize(109),
                                          crossAxisCount: 3,
                                          mainAxisSpacing: getHorizontalSize(8),
                                          crossAxisSpacing:
                                              getHorizontalSize(8),
                                        ),
                                        itemCount: gridItems.length,
                                        itemBuilder: (context, index) {
                                          return GridtrendingupItemWidget(
                                            text: gridItems[index]['text'],
                                            iconPath: gridItems[index]
                                                ['iconPath'],
                                            onTap: () {
                                              final buttonTexts =
                                                  getButtonTextsForGridItem(
                                                      gridItems[index]['text']);
                                              String parentCategory =
                                                  gridItems[index]['text'];
                                              ref
                                                  .read(
                                                      buttonListStateProviderEdit
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              KeyboardVisibilityBuilder(builder: (context, visible) {
                return Visibility(
                  visible: !visible,
                  child: Container(
                    margin: getMargin(left: 3),
                    padding:
                        getPadding(left: 21, top: 6, right: 21, bottom: 12),
                    decoration: AppDecoration.outlineBluegray5000c,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: getPadding(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomImageView(
                                svgPath: ImageConstant.imgAlertcircle,
                                height: getSize(16),
                                width: getSize(16),
                                color: ColorConstant.amber600,
                              ),
                              Padding(
                                padding: getPadding(left: 6),
                                child: Text(
                                    'Remember to save your information!',
                                    style: AppStyle.txtManropeSemiBold12
                                        .copyWith(
                                            color: ColorConstant.amber600)),
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          height: getVerticalSize(56),
                          text: "Save & Continue",
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

                            List<Map<int, String>> discretionaryCategories = [
                              entertainmentButtonTexts,
                              subscriptionButtonTexts,
                              personalCareButtonTexts,
                              clothingButtonTexts,
                              restaurantButtonTexts,
                              technologyButtonTexts,
                              personalSpendingButtonTexts,
                              otherButtonTexts,
                              givingButtonTexts,
                            ];

                            List<Map<int, String>> necessaryCategories = [
                              buttonTexts,
                              healthcareButtonTexts,
                              utilitiesButtonTexts,
                              transportationButtonTexts,
                              savingsCategories,
                              groceriesCategories,
                              educationCategories,
                              petChildCategories,
                            ];

                            bool isDebtOrLoanCategory(String categoryName) {
                              final lowercaseCategoryName =
                                  categoryName.toLowerCase();
                              return lowercaseCategoryName.contains("debt") ||
                                  lowercaseCategoryName.contains("loan");
                            }

                            Map<String, double> allCategoriesWithAmount = {
                              for (String parentCategory
                                  in selectedCategories.keys)
                                for (String categoryName
                                    in selectedCategories[parentCategory]!)
                                  categoryName: 0,
                            };

                            Map<String, double> allCategoriesWithParent = {
                              for (String parentCategory
                                  in selectedCategories.keys)
                                for (String categoryName
                                    in selectedCategories[parentCategory]!)
                                  '$parentCategory - $categoryName': 0,
                            };

                            final Map<String, double> necessaryExpense =
                                selectedBudget.necessaryExpense ?? {};
                            final Map<String, double> debtExpense =
                                selectedBudget.debtExpense ?? {};
                            final Map<String, double> discretionaryExpense =
                                selectedBudget.discretionaryExpense ?? {};

                            print('debtExpense: $debtExpense');

                            Map<String, double> necessaryCategoriesWithAmount =
                                {
                              for (String categoryName in necessaryExpense.keys)
                                // if (necessaryCategories.any((category) =>
                                //     category.values.contains(categoryName)))
                                categoryName: necessaryExpense[categoryName]!,
                            };

                            Map<String, double> extractedDebtLoanCategories = {
                              for (String key in debtExpense.keys)
                                // if (debtLoanCategories.containsKey(key) ||
                                //     isDebtOrLoanCategory(key))
                                key: debtExpense[key]!,
                            };

                            Map<String, double>
                                discretionaryCategoriesWithAmount = {
                              for (String categoryName
                                  in discretionaryExpense.keys)
                                // if (discretionaryCategories.any((category) =>
                                //     category.values.contains(categoryName)))
                                categoryName:
                                    discretionaryExpense[categoryName]!,
                            };

                            allCategoriesWithParent.forEach((key, value) {
                              if (key.startsWith('necessaryCategories')) {
                                String categoryName = key
                                    .substring('necessaryCategories - '.length);
                                necessaryCategoriesWithAmount[categoryName] =
                                    value;
                              } else if (key
                                  .startsWith('discretionaryCategories')) {
                                String categoryName = key.substring(
                                    'discretionaryCategories - '.length);
                                discretionaryCategoriesWithAmount[
                                    categoryName] = value;
                              } else if (key.startsWith('debtCategories')) {
                                String categoryName =
                                    key.substring('debtCategories - '.length);
                                extractedDebtLoanCategories[categoryName] =
                                    value;
                              }
                            });

                            // Find odd categories in allCategoriesWithAmount and add them to the appropriate maps
                            allCategoriesWithAmount.forEach((categoryName, _) {
                              if (!necessaryCategoriesWithAmount
                                      .containsKey(categoryName) &&
                                  !extractedDebtLoanCategories
                                      .containsKey(categoryName) &&
                                  !discretionaryCategoriesWithAmount
                                      .containsKey(categoryName)) {
                                // Check which list the odd category belongs to
                                bool isNecessaryCategory =
                                    necessaryCategories.any((category) =>
                                        category.values.contains(categoryName));
                                bool isDebtLoanCategory = debtLoanCategories
                                    .containsKey(categoryName);
                                bool isDiscretionaryCategory =
                                    discretionaryCategories.any((category) =>
                                        category.values.contains(categoryName));

                                if (isNecessaryCategory) {
                                  necessaryCategoriesWithAmount[categoryName] =
                                      0;
                                } else if (isDebtLoanCategory) {
                                  extractedDebtLoanCategories[categoryName] = 0;
                                } else if (isDiscretionaryCategory) {
                                  discretionaryCategoriesWithAmount[
                                      categoryName] = 0;
                                }
                              }
                            });
// Update necessaryCategoriesWithAmount with values from necessaryExpense
                            necessaryCategoriesWithAmount
                                .updateAll((key, value) {
                              return necessaryExpense.containsKey(key)
                                  ? necessaryExpense[key]!
                                  : value;
                            });

// Update extractedDebtLoanCategories with values from debtExpense
                            extractedDebtLoanCategories.updateAll((key, value) {
                              return debtExpense.containsKey(key)
                                  ? debtExpense[key]!
                                  : value;
                            });

// Update discretionaryCategoriesWithAmount with values from discretionaryExpense
                            discretionaryCategoriesWithAmount
                                .updateAll((key, value) {
                              return discretionaryExpense.containsKey(key)
                                  ? discretionaryExpense[key]!
                                  : value;
                            });
                            print('All Categories: $allCategoriesWithAmount');
                            // print('All Categories with Parent:');
                            // allCategoriesWithParent.forEach((key, value) {
                            //   print('$key: $value');
                            // });

                            // Remove the categories that are not in allCategoriesWithAmount

                            necessaryCategoriesWithAmount.removeWhere(
                                (key, value) =>
                                    !allCategoriesWithAmount.containsKey(key));
                            extractedDebtLoanCategories.removeWhere(
                                (key, value) =>
                                    !allCategoriesWithAmount.containsKey(key));
                            discretionaryCategoriesWithAmount.removeWhere(
                                (key, value) =>
                                    !allCategoriesWithAmount.containsKey(key));

                            print(
                                'All Necessary Amounts: $necessaryCategoriesWithAmount');
                            print(
                                'All Debt Amounts: $extractedDebtLoanCategories');
                            print(
                                'All Discretionary Amounts: $discretionaryCategoriesWithAmount');

                            final budgetState =
                                ref.watch(budgetStateProvider.notifier);
                            // final generateSalaryController =
                            //     ref.watch(generateSalaryProvider.notifier);
                            final budgetId = selectedBudget.budgetId;

                            if (budgetState.state.status ==
                                    BudgetStatus.success &&
                                allCategoriesWithAmount.isNotEmpty) {
                              await budgetState.saveBudgetNecessaryInfo(
                                budgetId: budgetId,
                                necessaryExpense: necessaryCategoriesWithAmount,
                              );

                              await budgetState.saveBudgetDebtInfo(
                                budgetId: budgetId,
                                debtExpense: extractedDebtLoanCategories,
                              );

                              await budgetState.saveBudgetDiscretionaryInfo(
                                budgetId: budgetId,
                                discretionaryExpense:
                                    discretionaryCategoriesWithAmount,
                              );
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove('necessaryCategories');
                              prefs.remove('debtCategories');
                              prefs.remove('discretionaryCategories');
                              prefs.remove('modalCategories');
                              prefs.remove('searchCategories');
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BudgetCreationPageViewEdit(
                                    initialIndex: 2,
                                    selectedBudget: selectedBudget,
                                  ),
                                  settings: RouteSettings(
                                    name: '/budget_creation_page_view',
                                    arguments: {
                                      'budgetId': budgetId,
                                      'necessaryCategoriesWithAmount':
                                          necessaryCategoriesWithAmount,
                                      'extractedDebtLoanCategories':
                                          extractedDebtLoanCategories,
                                      'discretionaryCategoriesWithAmount':
                                          discretionaryCategoriesWithAmount,
                                    },
                                  ),
                                ),
                              );
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
                );
              }),
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
