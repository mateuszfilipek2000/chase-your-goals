import 'package:chase_your_goals/screens/details/view/details_view.dart';
import 'package:chase_your_goals/screens/timer/view/stopwatch_view.dart';
import 'package:chase_your_goals/screens/timer/view/timer_view.dart';
import 'package:chase_your_goals/screens/about/view/about_view.dart';
import 'package:chase_your_goals/screens/calendar/view/calendar_view.dart';
import 'package:chase_your_goals/screens/task_adding/view/task_adding_view.dart';
import 'package:chase_your_goals/screens/tasks/view/tasks_view.dart';
import 'package:chase_your_goals/screens/home/view/home_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/tasks':
        return MaterialPageRoute(builder: (_) => const TasksPage());
      case '/task_adding':
        return MaterialPageRoute(
          builder: (_) => const TaskAddingPage(),
          fullscreenDialog: true,
        );
      case '/calendar':
        return MaterialPageRoute(builder: (_) => const CalendarPage());
      case '/about':
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case '/timer':
        return MaterialPageRoute(builder: (_) => const TimerPage());
      case '/stopwatch':
        Map<String, int> args = routeSettings.arguments as Map<String, int>;
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => StopwatchView(
            hours: args["hours"]!,
            minutes: args["minutes"]!,
            seconds: args["seconds"]!,
          ),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          fullscreenDialog: true,
        );
      case '/details': 
        return MaterialPageRoute(builder: (_) => const DetailsPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
