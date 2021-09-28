import 'package:chase_your_goals/core/constants/constants.dart';
import 'package:chase_your_goals/data/extensions/date_helpers.dart';
import 'package:chase_your_goals/data/models/task.dart';
import 'package:chase_your_goals/data/models/task_status.dart';
import 'package:chase_your_goals/screens/about/view/about_view.dart';
import 'package:chase_your_goals/screens/calendar/view/calendar_view.dart';
import 'package:chase_your_goals/screens/home/widgets/custom_bottom_navbar.dart';
import 'package:chase_your_goals/screens/tasks/view/tasks_view.dart';
import 'package:chase_your_goals/screens/timer/view/timer_view.dart';
import 'package:chase_your_goals/widgets/custom_progress_indicator.dart';
import 'package:chase_your_goals/widgets/section.dart';
import 'package:chase_your_goals/widgets/simple_linear_graph/simple_linear_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chase_your_goals/screens/home/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: CustomBottomNavbar(
        onPageChanged: (int i) => pageController.animateToPage(
          i,
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceInOut,
        ),
        buttonTexts: const ["Home", "Tasks", "Calendar", "Focus", "About"],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Section(
                isFirst: true,
                isChart: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Your activity this week so far",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: size.height * 1 / 4,
                      child: SimpleLinearGraph(
                        graphPoints: graphPoints,
                        // minX: 0,
                        // maxX: 8,
                        maxY: 115,
                        minY: 0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Section(
                  sectionTitle: "Upcoming activities",
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      shrinkWrap: true,
                      //TODO ADD TASKS
                      itemCount: dummyTasks.length,
                      itemBuilder: (context, index) {
                        return Material(
                          elevation: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              tileColor: Theme.of(context).cardColor,
                              onTap: () => print(index),
                              title: Text(
                                dummyTasks[index].title,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              isThreeLine:
                                  dummyTasks[index].description != null,
                              subtitle: dummyTasks[index].description == null
                                  ? null
                                  : Text(
                                      dummyTasks[index].description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                              trailing: dummyTasks[index].dateDue == null
                                  ? null
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.alarm,
                                        ),
                                        Text(
                                          dummyTasks[index]
                                              .dateDue!
                                              .getDashedDate(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TasksPage(),
          const CalendarPage(),
          const TimerPage(),
          const AboutPage(),
        ],
      ),
    );
  }
}

List<Offset> graphPoints = [
  const Offset(1, 100),
  const Offset(2, 60),
  const Offset(3, 50),
  const Offset(4, 30),
  const Offset(5, 50),
  const Offset(6, 70),
  const Offset(7, 70),
];

List<Task> dummyTasks = [
  Task(
    "Make a to-do app!",
    "Oh I can't wait for it to happen, I'll finally be able to keep track of my tasks!",
    DateTime.parse("2021-09-10"),
    DateTime.parse("2021-10-07"),
    Status.inProgress,
    [],
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    Status.inProgress,
    [],
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    Status.inProgress,
    [],
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    Status.inProgress,
    [],
  ),
];
