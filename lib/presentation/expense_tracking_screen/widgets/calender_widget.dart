import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/theme/app_style.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:table_calendar/table_calendar.dart';

import 'expenses_lists_widget.dart';

final calendarProvider =
    StateNotifierProvider<CalendarController, CalendarState>(
  (ref) => CalendarController(),
);

class CalendarController extends StateNotifier<CalendarState> {
  CalendarController()
      : super(CalendarState(
          focusedDay: DateTime.now(),
          selectedDay: null,
          calendarFormat: CalendarFormat.week, // Add this line
        ));

  void updateFocusedDay(DateTime day) {
    state = state.copyWith(focusedDay: day);
  }

  void updateSelectedDay(DateTime? day) {
    state = state.copyWith(selectedDay: day);
  }

  // Add this method to CalendarController
  void updateCalendarFormat(CalendarFormat format) {
    state = state.copyWith(calendarFormat: format);
  }

  void setSelectedDay(DateTime day) {
    Future.microtask(() {
      state = state.copyWith(selectedDay: day);
    });
  }
}

@immutable
class CalendarState {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat; // Add this line

  CalendarState(
      {required this.focusedDay,
      this.selectedDay,
      required this.calendarFormat});

  CalendarState copyWith(
      {DateTime? focusedDay,
      DateTime? selectedDay,
      CalendarFormat? calendarFormat}) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      calendarFormat: calendarFormat ?? this.calendarFormat, // Add this line
    );
  }
}

final selectedBudgetProvider = StateProvider<Budget?>((ref) => null);

class CalendarWidget extends HookConsumerWidget {
  final Budget? budget;
  final List<Map<String, dynamic>> actualExpenses;
  final VoidCallback onLoad;

  CalendarWidget({
    required this.budget,
    required this.actualExpenses,
    required this.onLoad,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      onLoad();

      // Schedule the setSelectedDay method to be called after the frame is built
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ref.read(calendarProvider.notifier).setSelectedDay(DateTime.now());
      });

      return () {}; // Clean-up function
    }, []);

    useEffect(() {
      // Set the current date as the selected day when the page is loaded
      ref.read(calendarProvider.notifier).setSelectedDay(DateTime.now());
      return () {}; // Clean-up function
    }, []);
    final calendarController = ref.watch(calendarProvider.notifier);
    final calendarState = ref.watch(calendarProvider);
    final selectedDate = calendarState.selectedDay;

    // Get the list of actual expenses from the passed Budget object
    // final List<Map<String, dynamic>> actualExpenses =
    //     budget?.actualExpenses ?? [];
    // print('budget Calender: ${budget.toString()}');
    print('actualExpenses: $actualExpenses');

    // Filter the actual expenses based on the selected date
    final List<Map<String, dynamic>> selectedDateExpenses =
        actualExpenses.where((expense) {
      final expenseDate = DateTime.parse(expense['date'] as String);
      return expenseDate.year == selectedDate?.year &&
          expenseDate.month == selectedDate?.month &&
          expenseDate.day == selectedDate?.day;
    }).toList();

    final List<Map<String, dynamic>> reversedSelectedDateExpenses =
        selectedDateExpenses.reversed.toList();

    int countExpensesForDate(
        DateTime date, List<Map<String, dynamic>> expenses) {
      return expenses.where((expense) {
        final expenseDate = DateTime.parse(expense['date'] as String);
        return expenseDate.year == date.year &&
            expenseDate.month == date.month &&
            expenseDate.day == date.day;
      }).length;
    }

    Widget customDayBuilder(
      BuildContext context,
      DateTime date,
      DateTime focusedDate,
      List<Map<String, dynamic>> expenses,
    ) {
      final expensesCount = countExpensesForDate(date, expenses);

      return Container(
        width: 40,
        decoration: BoxDecoration(
          color: expensesCount > 0
              ? Color(0xFF1A237E)
              : null, // Set the background color if there are expenses
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: AppStyle.txtHelveticaNowTextBold14.copyWith(
                      color: expensesCount > 0 ? Colors.white : null,
                    ),
                  ),
                ],
              ),
              if (expensesCount > 0)
                Positioned(
                  bottom: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final monthScrollController = ScrollController(
      initialScrollOffset: (calendarState.focusedDay.month - 1) *
              MediaQuery.of(context).size.width /
              5 -
          MediaQuery.of(context).size.width / 5,
    );

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: getPadding(left: 12, bottom: 12),
              child: Container(
                height: getVerticalSize(45.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: getPadding(bottom: 4),
                      child: Text(
                        DateFormat('EEEE,  ').format(
                            calendarState.selectedDay ?? DateTime.now()),
                        style: AppStyle.txtManropeRegular18Bluegray500.copyWith(
                          color: ColorConstant.blueGray500,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat('MMMM')
                          .format(calendarState.selectedDay ?? DateTime.now()),
                      style: AppStyle.txtHelveticaNowTextBold32.copyWith(
                        color: ColorConstant.blueA700,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: DateFormat(' dd').format(
                              calendarState.selectedDay ?? DateTime.now(),
                            ),
                            style: AppStyle.txtHelveticaNowTextBold40.copyWith(
                              color: ColorConstant.blueA700,
                            ),
                          ),
                          TextSpan(
                            text: _daySuffix(
                              (calendarState.selectedDay ?? DateTime.now()).day,
                            ),
                            style: AppStyle.txtHelveticaNowTextBold14.copyWith(
                              color: ColorConstant.blueA700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 50,
          child: ListView.builder(
            controller: monthScrollController,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = DateTime(DateTime.now().year, index + 1, 1);
              final monthFormat = DateFormat("MMMM").format(month);
              final isCurrentMonth =
                  month.month == calendarState.focusedDay.month;
              final double itemWidth = MediaQuery.of(context).size.width / 5;

              return GestureDetector(
                onTap: () {
                  calendarController
                      .updateFocusedDay(DateTime(month.year, month.month, 1));

                  monthScrollController.animateTo(
                    index * itemWidth,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                  child: Text(
                    monthFormat,
                    style: TextStyle(
                      color: isCurrentMonth ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppStyle.txtManropeBold10.fontFamily,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: TableCalendar(
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, focusedDate) {
                return customDayBuilder(
                    context, date, focusedDate, actualExpenses);
              },
            ),
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: calendarState.focusedDay,
            calendarFormat: calendarState.calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            selectedDayPredicate: (day) {
              return isSameDay(calendarState.selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              calendarController.updateSelectedDay(selectedDay);
              calendarController.updateFocusedDay(focusedDay);
            },
            onPageChanged: (focusedDay) {
              calendarController.updateFocusedDay(focusedDay);
            },
            headerVisible: false,
            calendarStyle: CalendarStyle(
              canMarkersOverflow: true,
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green.shade600,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Color(0xFF1A237E),
                shape: BoxShape.circle,
              ),
              todayTextStyle: AppStyle.txtHelveticaNowTextBold14
                  .copyWith(color: ColorConstant.whiteA700),
              selectedTextStyle: AppStyle.txtHelveticaNowTextBold14
                  .copyWith(color: ColorConstant.whiteA700),
              defaultTextStyle: AppStyle.txtHelveticaNowTextBold14.copyWith(
                color: ColorConstant.black900,
              ),
              outsideTextStyle: AppStyle.txtHelveticaNowTextBold14.copyWith(
                color: ColorConstant.blueGray300,
              ),
              weekendTextStyle: AppStyle.txtHelveticaNowTextBold14.copyWith(
                color: ColorConstant.black900,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: AppStyle.txtHelveticaNowTextBold14
                  .copyWith(color: ColorConstant.black900),
              weekendStyle: AppStyle.txtHelveticaNowTextBold14
                  .copyWith(color: ColorConstant.black900),
              dowTextFormatter: (date, locale) {
                return DateFormat('EE', locale).format(date)[0];
              },
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (calendarState.calendarFormat == CalendarFormat.month) {
              calendarController.updateCalendarFormat(CalendarFormat.week);
            } else {
              calendarController.updateCalendarFormat(CalendarFormat.month);
            }
          },
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              calendarController.updateCalendarFormat(CalendarFormat.month);
            } else if (details.primaryVelocity! < 0) {
              calendarController.updateCalendarFormat(CalendarFormat.week);
            }
          },
          child: Container(
            width: 40,
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[400],
            ),
            margin: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
        SizedBox(
          height: getVerticalSize(0),
        ),
        StatefulBuilder(builder: (context, StateSetter setState) {
          void _onDismissed(int index) {
            setState(() {
              reversedSelectedDateExpenses.removeAt(index);
            });
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: ColorConstant.redA700,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Clear Expenses',
                                style: AppStyle.txtHelveticaNowTextBold18
                                    .copyWith(letterSpacing: 0.2),
                              ),
                              content: Text(
                                'Are you sure you want to clear all expenses for the Week?',
                                style: AppStyle.txtManropeRegular14
                                    .copyWith(letterSpacing: 0.2),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancel',
                                      style: AppStyle.txtHelveticaNowTextBold14
                                          .copyWith(letterSpacing: 0.2)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Clear',
                                      style: AppStyle.txtHelveticaNowTextBold14
                                          .copyWith(
                                              letterSpacing: 0.2,
                                              color: ColorConstant.redA700)),
                                  onPressed: () async {
                                    String budgetId = budget!.budgetId;
                                    print('budgetId: $budgetId');
                                    print(selectedDate);
                                    await ref
                                        .read(budgetStateProvider.notifier)
                                        .deleteWeeklyExpenses(
                                            budgetId, selectedDate!, ref);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: getPadding(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0), // Adjust padding here
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomImageView(
                              width: 20,
                              height: 20,
                              svgPath: ImageConstant.imgTrashNew,
                              color: ColorConstant.redA700,
                            ),
                            SizedBox(
                                width:
                                    4), // Adjust the space between the icon and text
                            Text(
                              'Exps. Week',
                              style:
                                  AppStyle.txtHelveticaNowTextBold12.copyWith(
                                color: ColorConstant.redA700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: ColorConstant.redA700,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Clear Expenses',
                                style: AppStyle.txtHelveticaNowTextBold18
                                    .copyWith(letterSpacing: 0.2),
                              ),
                              content: Text(
                                'Are you sure you want to clear all expenses for the Month?',
                                style: AppStyle.txtManropeRegular14
                                    .copyWith(letterSpacing: 0.2),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancel',
                                      style: AppStyle.txtHelveticaNowTextBold14
                                          .copyWith(letterSpacing: 0.2)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Clear',
                                      style: AppStyle.txtHelveticaNowTextBold14
                                          .copyWith(
                                              letterSpacing: 0.2,
                                              color: ColorConstant.redA700)),
                                  onPressed: () async {
                                    String budgetId = budget!.budgetId;
                                    print('budgetId: $budgetId');
                                    print(selectedDate);
                                    await ref
                                        .read(budgetStateProvider.notifier)
                                        .deleteMonthlyExpenses(
                                            budgetId, selectedDate!, ref);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: getPadding(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0), // Adjust padding here
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomImageView(
                              width: 20,
                              height: 20,
                              svgPath: ImageConstant.imgTrashNew,
                              color: ColorConstant.redA700,
                            ),
                            SizedBox(
                                width:
                                    4), // Adjust the space between the icon and text
                            Text(
                              'Exps. Month',
                              style:
                                  AppStyle.txtHelveticaNowTextBold12.copyWith(
                                color: ColorConstant.redA700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getVerticalSize(8),
              ),
              Consumer(builder: (context, ref, child) {
                return Padding(
                  padding: getPadding(left: 15, right: 15),
                  child: reversedSelectedDateExpenses.isEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(12)),
                                  depth: 0.1,
                                  intensity: 1,
                                  surfaceIntensity: 0.5,
                                  lightSource: LightSource.top,
                                  color: ColorConstant.gray50,
                                ),
                                child: Container(
                                  height: getVerticalSize(95),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.gray100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          "Press the plus (+) button to add an Expense",
                                          style: AppStyle.txtManropeBold12
                                              .copyWith(
                                            color: ColorConstant.blueGray500,
                                            letterSpacing: getHorizontalSize(1),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: getVerticalSize(16),
                            );
                          },
                          itemCount: reversedSelectedDateExpenses.length,
                          itemBuilder: (context, index) {
                            int actualExpensesIndex = actualExpenses
                                .indexOf(reversedSelectedDateExpenses[index]);
                            return Dismissible(
                              key: UniqueKey(),
                              background: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: getVerticalSize(50),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              ColorConstant.redA700
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            stops: [
                                              0.15,
                                              1.0
                                            ], // first color stops at 70%, second at 100%
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // SizedBox(width: 25),
                                            Padding(
                                              padding: getPadding(right: 16),
                                              child: CustomImageView(
                                                svgPath:
                                                    ImageConstant.imgTrashNew,
                                                height: getSize(24),
                                                width: getSize(24),
                                                color: ColorConstant.whiteA700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                _onDismissed(index);
                                ref
                                    .read(budgetStateProvider.notifier)
                                    .deleteExpense(budget!.budgetId,
                                        actualExpensesIndex, ref);
                              },
                              child: ExpenseListWidget(
                                selectedDate: selectedDate!,
                                budget: budget,
                                expenseData:
                                    reversedSelectedDateExpenses[index],
                              ),
                            );
                          },
                        ),
                );
              }),
            ],
          );
        }),
      ],
    );
  }
}

String _daySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
