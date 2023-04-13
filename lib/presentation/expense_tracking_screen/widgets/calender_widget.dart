import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/theme/app_style.dart';
import 'package:table_calendar/table_calendar.dart';

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

class CalendarWidget extends ConsumerWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarController = ref.watch(calendarProvider.notifier);
    final calendarState = ref.watch(calendarProvider);

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
