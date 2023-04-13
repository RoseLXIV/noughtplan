import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/widgets/custom_button_form.dart';

import 'widgets/calender_widget.dart';

class ExpenseModalController extends StateNotifier<bool> {
  ExpenseModalController() : super(false);

  void openModal() => state = true;
  void closeModal() => state = false;
}

final expenseModalProvider =
    StateNotifierProvider<ExpenseModalController, bool>((ref) {
  return ExpenseModalController();
});

class ExpenseTrackingScreen extends ConsumerWidget {
  const ExpenseTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ModalRoute.of(context)?.settings.arguments as Budget?;
    print(budget);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        body: Container(
          height: getVerticalSize(
            812,
          ),
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Transform(
                  transform: Matrix4.identity()..scale(1.0, 1.0, 0.1),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgTopographic7,
                    height: MediaQuery.of(context).size.height *
                        1, // Set the height to 50% of the screen height
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set the width to the full screen width
                    // alignment: Alignment.,
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgGroup183001,
                      height: getVerticalSize(
                        53,
                      ),
                      width: getHorizontalSize(
                        161,
                      ),
                      alignment: Alignment.topLeft,
                      margin: getMargin(
                        left: 17,
                        top: 25,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: getPadding(
                          right: 17,
                          top: 38,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Please read the instructions below',
                                    textAlign: TextAlign.center,
                                    style: AppStyle.txtHelveticaNowTextBold16,
                                  ),
                                  content: Text(
                                    "In this step, you'll be able to add discretionary categories to your budget. Follow the instructions below:\n\n"
                                    "1. Browse through the available categories or use the search bar to find specific ones that match your interests and lifestyle.\n"
                                    "2. Tap on a category to add it to your chosen categories list. You can always tap again to remove it if needed.\n"
                                    "3. Once you've added all the discretionary categories you want, press the 'Next' button to move on to reviewing your budget.\n\n"
                                    "Remember, these discretionary categories represent your non-essential expenses, such as entertainment, hobbies, and dining out. Adding them thoughtfully will help you create a balanced budget, allowing for personal enjoyment while still managing your finances effectively.",
                                    textAlign: TextAlign.center,
                                    style: AppStyle.txtManropeRegular14,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 7),
                            child: SvgPicture.asset(
                              ImageConstant.imgQuestion,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: getPadding(top: 95, left: 12, right: 12),
                  child: CalendarWidget(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: NeumorphicFloatingActionButton(
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(60)),
            depth: 0.5,
            // intensity: 9,
            surfaceIntensity: 0.8,
            lightSource: LightSource.top,
            color: ColorConstant.lightBlueA200,
          ),

          onPressed: () => _showAddExpenseModal(context, budget, ref),

          child: Icon(
            Icons.add_rounded,
            color: ColorConstant.whiteA700,
            size: getSize(42),
          ),
          // backgroundColor: ColorConstant.lightBlueA200,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<void> _showAddExpenseModal(
      BuildContext context, Budget? budget, WidgetRef ref) async {
    final necessaryCategories = budget?.necessaryExpense ?? {};
    final discretionaryCategories = budget?.discretionaryExpense ?? {};
    final debtCategories = budget?.debtExpense ?? {};
    DateTime? selectedDate = ref.watch(calendarProvider).selectedDay;

    List<String> allCategories = [
      ...necessaryCategories.keys,
      ...discretionaryCategories.keys,
      ...debtCategories.keys,
    ];

    String? selectedCategory;
    TextEditingController amountController = TextEditingController();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Container(
                        // color: Colors.grey.withOpacity(0.5),
                        ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.63,
                    minChildSize: 0.63,
                    maxChildSize: 1,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        padding: EdgeInsets.only(
                            top: 8, left: 32, right: 32, bottom: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: getPadding(top: 32),
                                        child: Text(
                                          'Add Expense',
                                          style: AppStyle
                                              .txtHelveticaNowTextBold32
                                              .copyWith(
                                            color: ColorConstant.black900,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: getPadding(
                                          top: 3,
                                        ),
                                        child: Text(
                                          'Track your spending by entering each expense into the appropriate category.',
                                          style: AppStyle.txtManropeSemiBold12
                                              .copyWith(
                                            color: ColorConstant.blueGray500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    initialValue: DateFormat('EEEE, MMMM dd, y')
                                        .format(selectedDate ?? DateTime.now()),
                                    readOnly: false,
                                    decoration: InputDecoration(
                                      labelText: 'Date',
                                      labelStyle: AppStyle
                                          .txtHelveticaNowTextBold14
                                          .copyWith(
                                        color: ColorConstant.blueGray300,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: AppStyle.txtHelveticaNowTextBold18
                                        .copyWith(
                                      color: ColorConstant.black900,
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate:
                                            selectedDate ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                      );
                                      if (pickedDate != null &&
                                          pickedDate != selectedDate) {
                                        setState(() {
                                          selectedDate = pickedDate;
                                        });
                                      }
                                    },
                                    enabled: false,
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: ColorConstant
                                          .gray50, // Background color
                                    ),
                                    child: DropdownSearch<String>(
                                      mode: Mode.BOTTOM_SHEET,
                                      showSearchBox: true,
                                      selectedItem: selectedCategory,
                                      dropdownBuilder: (context, selectedItem) {
                                        return Text(
                                          selectedItem ?? "Select a category",
                                          style: selectedItem == null
                                              ? AppStyle
                                                  .txtHelveticaNowTextBold18
                                                  .copyWith(
                                                  color: ColorConstant
                                                      .blueGray300, // Your desired color for "Select a category"
                                                )
                                              : AppStyle
                                                  .txtHelveticaNowTextBold18
                                                  .copyWith(
                                                  color: ColorConstant.black900,
                                                ),
                                        );
                                      },
                                      items: allCategories,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedCategory = newValue;
                                        });
                                      },
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Category",
                                        labelStyle: AppStyle
                                            .txtHelveticaNowTextBold14
                                            .copyWith(
                                          color: ColorConstant.blueGray300,
                                        ),
                                        fillColor: Colors.transparent,
                                        filled: true,
                                        border: InputBorder.none,
                                      ),
                                      popupItemBuilder:
                                          (context, item, isSelected) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item,
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold18
                                                    .copyWith(
                                                  color: ColorConstant.black900,
                                                ),
                                              ),
                                              Divider(
                                                color:
                                                    ColorConstant.blueGray100,
                                                thickness: 0.5,
                                                indent: 10,
                                                endIndent: 10,
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: ColorConstant
                                          .gray50, // Background color
                                    ),
                                    child: TextField(
                                      controller: amountController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        ThousandsFormatter(),
                                      ],
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                        labelText: 'Amount',
                                        labelStyle: AppStyle
                                            .txtHelveticaNowTextBold14
                                            .copyWith(
                                          color: ColorConstant.blueGray300,
                                        ),
                                        fillColor: Colors.transparent,
                                        filled: true,
                                        prefixText: '\$ ',
                                        prefixStyle: AppStyle
                                            .txtHelveticaNowTextBold40
                                            .copyWith(
                                          color: ColorConstant.blue90001,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        border: InputBorder.none,
                                      ),
                                      style: AppStyle.txtHelveticaNowTextBold40
                                          .copyWith(
                                        color: ColorConstant.blue90001,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Neumorphic(
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(12)),
                                      depth: 0.5,
                                      // intensity: 9,
                                      surfaceIntensity: 0.8,
                                      lightSource: LightSource.top,
                                    ),
                                    child: CustomButtonForm(
                                      onTap: () {
                                        // TODO: Save the selected category, entered amount, and selected date to your data
                                        Navigator.pop(context);
                                      },
                                      alignment: Alignment.bottomCenter,
                                      height: getVerticalSize(56),
                                      text: "Save",
                                      enabled: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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

      // enforce max length
      if (value.length > maxLength) {
        value = value.substring(0, maxLength);
      }

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
