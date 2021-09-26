import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chase_your_goals/data/extensions/date_helpers.dart';

class SimpleCalendar extends StatefulWidget {
  const SimpleCalendar({
    Key? key,
    //required this.height,
    required this.width,
  }) : super(key: key);

  //final double height;
  final double width;

  @override
  _SimpleCalendarState createState() => _SimpleCalendarState();
}

class _SimpleCalendarState extends State<SimpleCalendar> {
  late DateTime selectedMonth;

  List<int> currentMonthIndexes = [];
  int currentDayIndex = 0;

  List<CalendarDay> days = [];

  @override
  void initState() {
    selectedMonth = DateTime.now();
    prepareCalendar();
    super.initState();
  }

  void prepareCalendar() {
    days.clear();

    DateTime firstDayOfCurrentMonth =
        DateTime(selectedMonth.year, selectedMonth.month, 1);

    currentDayIndex = firstDayOfCurrentMonth.weekday - 1;

    for (var i = max(
            getMonthLength(selectedMonth.previousMonth) - 6,
            selectedMonth.firstDayOfMonth
                .subtract(
                    Duration(days: selectedMonth.firstDayOfMonth.weekday - 1))
                .day);
        i <= getMonthLength(selectedMonth.previousMonth);
        i++) {
      days.add(CalendarDay(i, isActive: false));
    }

    for (var i = 1; i <= getMonthLength(selectedMonth); i++) {
      days.add(CalendarDay(i, isActive: true));
    }

    for (var i = 1; days.length <= 42; i++) {
      days.add(CalendarDay(i, isActive: false));
    }
  }

  int getMonthLength(DateTime now) {
    int monthLength = 0;

    // DateTime currentMonth = DateTime(now.year, now.month, 1);

    // while (currentMonth.month == now.month) {
    //   monthLength++;
    //   currentMonth = currentMonth.add(const Duration(days: 1));
    // }
    monthLength = DateTime(now.year, now.month + 1, 0).day;
    return monthLength;
  }

  int max(a, b) => a > b ? a : b;

  int min(a, b) => a < b ? a : b;

  void changeMonth({bool forward = true}) {
    if (forward) {
      selectedMonth = selectedMonth.nextMonth;
    } else {
      selectedMonth = selectedMonth.previousMonth;
    }
    prepareCalendar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: widget.height,
      height: (widget.width / 1.17) + 50.0 + 10.0,
      width: widget.width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      onPressed: () {
                        print("month - 1");

                        changeMonth(forward: false);
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          englishMonths[selectedMonth.month]!,
                          style: Theme.of(context).textTheme.headline6,
                          key: UniqueKey(),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: () {
                        print("month + 1");

                        changeMonth(forward: true);
                      },
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: AspectRatio(
                key: UniqueKey(),
                aspectRatio: 7 / 6,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: GridView.count(
                    dragStartBehavior: DragStartBehavior.start,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 7,
                    children: days.map(
                      (day) {
                        if (!day.isActive) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor,
                            ),
                            child: Center(
                              child: Text(
                                day.dayNumber.toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          );
                        } else {
                          return Material(
                            color: Theme.of(context).colorScheme.surface,
                            child: InkWell(
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  day.dayNumber.toString(),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarDay {
  const CalendarDay(
    this.dayNumber, {
    required this.isActive,
    this.numberOfEvents = 0,
  });

  final int dayNumber;
  final bool isActive;
  final int numberOfEvents;
}

//TODO INTERNATIONALIZATION
Map<int, String> englishMonths = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December",
};
