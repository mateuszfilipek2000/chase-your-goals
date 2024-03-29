import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chase_your_goals/data/extensions/date_helpers.dart';
import 'dart:math' as math;

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

class _SimpleCalendarState extends State<SimpleCalendar>
    with SingleTickerProviderStateMixin {
  late DateTime selectedMonth;

  List<int> currentMonthIndexes = [];
  int currentDayIndex = 0;

  List<CalendarDay> days = [];

  final GlobalKey _calendarKey = GlobalKey();

  OverlayEntry? overlayEntry;
  int? overlayButtonIndex;

  late AnimationController overlayController;
  late Animation<double> overlayOpacityAnimation;

  @override
  void initState() {
    overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    overlayOpacityAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(parent: overlayController, curve: Curves.easeIn),
    );

    selectedMonth = DateTime.now();
    prepareCalendar();
    super.initState();
  }

  @override
  void dispose() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
    overlayController.dispose();
    super.dispose();
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
      days.add(CalendarDay(i, isActive: false, events: []));
    }

    for (var i = 1; i <= getMonthLength(selectedMonth); i++) {
      days.add(
        CalendarDay(
          i,
          isActive: true,
          events: dummyEvents[math.Random().nextInt(dummyEvents.length)],
        ),
      );
    }

    for (var i = 1; days.length <= 42; i++) {
      days.add(CalendarDay(i, isActive: false, events: []));
    }
  }

  int getMonthLength(DateTime now) => DateTime(now.year, now.month + 1, 0).day;

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

  void showOverlay(int index) async {
    //checking if there's existing overlay, if it exists then it's removed
    if (overlayEntry != null) {
      TickerFuture reverse = overlayController.reverse();
      await reverse;
      if (overlayEntry != null) overlayEntry?.remove();
      overlayEntry = null;
    }

    double overlayWidth = 150.0;
    double overlayHeight = 200.0;

    final RenderBox renderBox =
        _calendarKey.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size;

    final Offset offset = renderBox.localToGlobal(Offset.zero);

    final Offset bottomLeftCorner = Offset(offset.dx, offset.dy + size.height);
    final double buttonWidth = widget.width / 7.0;
    final double calendarAreaHeight = buttonWidth * 6.0;

    if (overlayButtonIndex == null || overlayButtonIndex != index) {
      overlayController.forward();
      overlayButtonIndex = index;
      //calendar has 42 buttons, 6 rows, each row contains 7 buttons
      //getting offset (left top corner) of pressed button
      final Offset buttonOffset = Offset(
        (index % 7) * buttonWidth,
        (buttonWidth * (index / 7).floor()),
      ).translate(
          bottomLeftCorner.dx, bottomLeftCorner.dy - calendarAreaHeight);

      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: ((index % 7) * buttonWidth <= size.width / 2.0)
              ? buttonOffset.dx + buttonWidth
              : buttonOffset.dx - overlayWidth,
          top: (buttonWidth * (index / 7).ceil()) >= size.height / 2.0
              ? buttonOffset.dy - overlayHeight
              : buttonOffset.dy,
          child: FadeTransition(
            opacity: overlayOpacityAnimation,
            child: SizedBox(
              height: overlayHeight,
              width: overlayWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  //border: Border.all(width: 1.0, color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    children: days[index]
                        .events
                        .map(
                          (event) => TextButton(
                            onPressed: () {},
                            //padding: const EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                event,
                                style: Theme.of(context).textTheme.caption,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context)?.insert(overlayEntry!);
    } else {
      overlayButtonIndex = null;
    }
  }

  void hideOverlay() async {
    if (overlayEntry != null) {
      TickerFuture reverse = overlayController.reverse();
      await reverse;
      if (overlayEntry != null) overlayEntry?.remove();
      overlayEntry = null;
      overlayButtonIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _calendarKey,
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
                        hideOverlay();
                        changeMonth(forward: false);
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          englishMonths[selectedMonth.month]! +
                              " ${selectedMonth.year}",
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
                        hideOverlay();
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
                    children: days
                        .asMap()
                        .map(
                          (int index, CalendarDay day) {
                            if (!day.isActive) {
                              return MapEntry<int, Widget>(
                                index,
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).disabledColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      day.dayNumber.toString(),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return MapEntry<int, Widget>(
                                index,
                                Material(
                                  color: Theme.of(context).colorScheme.surface,
                                  child: InkWell(
                                    onTap: () {
                                      if (day.numberOfEvents != 0) {
                                        showOverlay(index);
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (day.numberOfEvents != 0)
                                          ClipOval(
                                            child: Container(
                                              height: widget.width / 10,
                                              width: widget.width / 10,
                                              color: day.numberOfEvents == 1
                                                  ? Colors.blue[300]
                                                  : day.numberOfEvents <= 3
                                                      ? Colors.blue[700]
                                                      : Colors.red,
                                            ),
                                          ),
                                        Text(
                                          day.dayNumber.toString(),
                                          style: day.numberOfEvents == 0
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        )
                        .values
                        .toList(),
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
    required this.events,
  });

  final int dayNumber;
  final bool isActive;
  // final int numberOfEvents;
  final List<String> events;
  int get numberOfEvents => events.length;
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

List<String> _dummyEvents = [
  "Find blue flower with red thorns",
  "This would be so much easier if I wasn't colorblind",
  "Are we there yet?",
  "Well it’s no wonder you don’t have any friends.",
  "Because that’s what friends do, they FORGIVE EACH OTHER.",
  "This’ll be fun. We’ll stay up late, swapping manly stories, and in the morning… I’m making waffles.",
];

List<List<String>> dummyEvents = [
  [],
  _dummyEvents,
  [],
  _dummyEvents.getRange(0, 2).toList(),
  _dummyEvents.getRange(1, 4).toList(),
  _dummyEvents.getRange(2, 3).toList(),
];
