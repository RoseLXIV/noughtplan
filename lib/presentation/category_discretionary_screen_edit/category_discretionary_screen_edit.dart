import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/providers/first_time_provider.dart';
import 'package:noughtplan/presentation/category_discretionary_screen/widgets/category_button_discretionary.dart';
import 'package:noughtplan/presentation/category_discretionary_screen_edit/widgets/category_button_discretionary_edit.dart';
// import 'package:noughtplan/presentation/category_necessary_screen/category_necessary_screen.dart';
import 'package:noughtplan/presentation/category_necessary_screen/widgets/category_button.dart';

import '../category_discretionary_screen/widgets/gridicon_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_floating_button.dart';
import 'package:noughtplan/widgets/custom_search_view.dart';

final Map<int, String> buttonTexts = {
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

Map<int, String> mergeAllButtonTexts() {
  final allButtonTexts = <int, String>{};

  int offset = 0;
  List<Map<int, String>> allMaps = [
    buttonTexts,
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
    'text': 'Personal Spending',
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

Map<int, String> getButtonTextsForGridItem(String gridItemText) {
  switch (gridItemText) {
    case 'Entertainment':
      return buttonTexts;
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
    case 'Personal Spending':
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

class ButtonListStateDiscretionaryEdit extends ChangeNotifier {
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

  void clearSelectedCategories() {
    selectedCategories.clear();
    notifyListeners();
  }
}

class CategorySearchNotifierDiscretionaryEdit
    extends StateNotifier<List<String>> {
  CategorySearchNotifierDiscretionaryEdit() : super([]);

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

final categorySearchProviderDiscretionaryEdit = StateNotifierProvider<
    CategorySearchNotifierDiscretionaryEdit,
    List<String>>((ref) => CategorySearchNotifierDiscretionaryEdit());

final buttonListStateProviderDiscretionaryEdit =
    ChangeNotifierProvider<ButtonListStateDiscretionaryEdit>(
        (ref) => ButtonListStateDiscretionaryEdit());

// ignore_for_file: must_be_immutable
class CategoryDiscretionaryScreenEdit extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _animationController =
        useAnimationController(duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);

    final firstTime = ref.watch(firstTimeProvider);
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Budget selectedBudget = args['selectedBudget'];

    print('selectedBudget: $selectedBudget');
    final searchController = useTextEditingController();

    final filteredCategories =
        ref.watch(categorySearchProviderDiscretionaryEdit);

    final buttonListState = ref.watch(buttonListStateProviderDiscretionaryEdit);
    Map<String, List<String>> selectedCategories =
        buttonListState.selectedCategories;
    String? parentCategory = buttonListState.currentParentCategory;
    List<String> selectedButtonTexts =
        parentCategory != null ? selectedCategories[parentCategory] ?? [] : [];
    List<Widget> selectedButtons = [];

    void initializeSelectedButtons(Map<String, double> discretionaryExpense) {
      discretionaryExpense.forEach((key, value) {
        ref
            .read(buttonListStateProviderDiscretionaryEdit.notifier)
            .addCategory(key);
      });
    }

    useEffect(() {
      Future.microtask(() {
        ref
            .read(buttonListStateProviderDiscretionaryEdit.notifier)
            .clearSelectedCategories();
        initializeSelectedButtons(selectedBudget.discretionaryExpense ?? {});
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
                    .read(buttonListStateProviderDiscretionaryEdit.notifier)
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
                  .read(buttonListStateProviderDiscretionaryEdit.notifier)
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
                initialChildSize: 0.65,
                minChildSize: 0.65,
                maxChildSize: 0.8,
                builder:
                    (BuildContext context, ScrollController scrollController) {
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
                            controller: scrollController,
                            child: Column(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    onSubmitted: (_) => submitForm(),
                                    controller: customCategoryController,
                                    textAlign: TextAlign.center,
                                    style: AppStyle.txtManropeRegular16
                                        .copyWith(
                                            color: ColorConstant.blueGray800),
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
                                      hintStyle: AppStyle.txtManropeSemiBold14
                                          .copyWith(
                                              color: ColorConstant.blueGray300,
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
                        transform: Matrix4.identity()..scale(1.0, -1.0, 1.0),
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
                              height: getVerticalSize(80),
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
                              title:
                                  AppbarTitle(text: "Discretionary Categories"),
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
                                                'Editing Discretionary Categories',
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
                                                                "Editing discretionary categories for your budget is a straightforward process. Here's how:\n\n"),
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
                                                                '2. Add or Remove Category:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' Tap any category to add it to your list. If you want to remove it, simply tap again.\n\n'),
                                                        TextSpan(
                                                            text:
                                                                '3. Modify Custom Category:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' To modify a custom category, tap on the "+" icon, edit the category name in the text field, and press "Save". Note that custom categories containing the words "Debt" or "Loan" will not be considered as discretionary expenses.\n\n'),
                                                        TextSpan(
                                                            text: '4. Proceed:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                " Once you've made all the desired adjustments, hit the \'Next\' button to review your budget.\n\n"),
                                                        TextSpan(
                                                            text:
                                                                "Remember, discretionary categories represent non-essential expenses, such as entertainment, dining out, and hobbies. Accurately editing these will help you maintain a realistic budget and better manage your finances. If a category remains unchanged, the old value will automatically be used."),
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
                                    .read(
                                        categorySearchProviderDiscretionaryEdit
                                            .notifier)
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
                                      final buttonListState = ref.watch(
                                          buttonListStateProviderDiscretionaryEdit);
                                      final selectedButtons = buttonListState
                                          .selectedCategories.values
                                          .expand((element) => element)
                                          .toList();
                                      final isSelected = selectedButtons
                                          .contains(filteredCategories[index]);

                                      return GestureDetector(
                                        onTap: () {
                                          if (selectedButtons.length < 30) {
                                            ref
                                                .read(
                                                    buttonListStateProviderDiscretionaryEdit
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
                                        child: CategoryButtonDiscretionaryEdit(
                                          index: index,
                                          text: filteredCategories[index],
                                          isFromSearchResults: true,
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
                                      color: selectedButtons.length == 30
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
                              padding: getPadding(top: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                      height: getVerticalSize(28),
                                      width: getHorizontalSize(143),
                                      text: "Necessary Exps.",
                                      variant: ButtonVariant.FillWhiteA700,
                                      shape: ButtonShape.RoundedBorder6,
                                      padding: ButtonPadding.PaddingT3,
                                      fontStyle: ButtonFontStyle
                                          .ManropeSemiBold12Bluegray300,
                                      prefixWidget: Container(
                                          margin: getMargin(right: 8),
                                          child: CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgVolume))),
                                  CustomButton(
                                    height: getVerticalSize(28),
                                    width: getHorizontalSize(175),
                                    text: "Discretionary Exps.",
                                    shape: ButtonShape.RoundedBorder6,
                                    padding: ButtonPadding.PaddingT3_1,
                                    fontStyle:
                                        ButtonFontStyle.ManropeSemiBold12,
                                    suffixWidget: Container(
                                      margin: getMargin(left: 8),
                                      child: CustomImageView(
                                          svgPath:
                                              ImageConstant.imgCartWhiteA700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                      mainAxisSpacing: getHorizontalSize(8),
                                      crossAxisSpacing: getHorizontalSize(8),
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
                                              .read(
                                                  buttonListStateProviderDiscretionaryEdit
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
                      svgPath: ImageConstant.imgCarousel3,
                      margin: getMargin(bottom: 10),
                    ),
                    CustomButton(
                      height: getVerticalSize(56),
                      text: "Next",
                      onTap: () async {
                        final Map<String, dynamic> args =
                            ModalRoute.of(context)!.settings.arguments
                                as Map<String, dynamic>;

                        final Map<String, double>
                            necessaryCategoriesWithAmount =
                            args['necessaryCategoriesWithAmount']
                                as Map<String, double>;

                        final Map<String, double> extractedDebtLoanCategories =
                            args['extractedDebtLoanCategories']
                                as Map<String, double>;

                        Map<String, double> allCategoriesWithAmount = {
                          for (String parentCategory in selectedCategories.keys)
                            for (String categoryName
                                in selectedCategories[parentCategory]!)
                              categoryName: 0,
                        };

                        final Map<String, double> discretionaryExpense =
                            selectedBudget.discretionaryExpense ?? {};

                        allCategoriesWithAmount.updateAll((key, value) {
                          return discretionaryExpense.containsKey(key)
                              ? discretionaryExpense[key]!
                              : value;
                        });

                        print('All Discretionary $allCategoriesWithAmount');

                        final budgetState =
                            ref.watch(budgetStateProvider.notifier);
                        final generateSalaryController =
                            ref.watch(generateSalaryProvider.notifier);
                        final String? budgetId = selectedBudget.budgetId;

                        await budgetState.saveBudgetDiscretionaryInfo(
                          budgetId: budgetId,
                          discretionaryExpense: allCategoriesWithAmount,
                        );

                        if (budgetState.state.status == BudgetStatus.success) {
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
                            context,
                            '/allocate_funds_screen_edit',
                            arguments: {
                              'necessaryCategoriesWithAmount':
                                  necessaryCategoriesWithAmount,
                              'extractedDebtLoanCategories':
                                  extractedDebtLoanCategories,
                              'discretionaryCategoriesWithAmount':
                                  allCategoriesWithAmount,
                              'selectedBudget': selectedBudget
                            },
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

  onTapArrowleft2(BuildContext context) {
    Navigator.pop(context);
  }
}

void _showModalBottomSheet(
    BuildContext context, Map<int, String> buttonTexts, String parentCategory) {
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
            builder: (BuildContext context, ScrollController scrollController) {
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
                              padding: EdgeInsets.zero,
                              itemCount: buttonTexts.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 1.7,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                final entry =
                                    buttonTexts.entries.elementAt(index);
                                return CategoryButtonDiscretionaryEdit(
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
