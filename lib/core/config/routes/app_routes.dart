import 'package:chase_your_goals/screens/calendar/view/calendar_view.dart';
import 'package:chase_your_goals/screens/task_adding/view/task_adding_view.dart';
import 'package:chase_your_goals/screens/tasks/view/tasks_view.dart';
import 'package:chase_your_goals/screens/about/view/about_view.dart';
import 'package:chase_your_goals/screens/home/view/home_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/about':
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case '/tasks':
        return MaterialPageRoute(builder: (_) => const TasksPage());
      case '/task_adding':
        return MaterialPageRoute(
          builder: (_) => const TaskAddingPage(),
          fullscreenDialog: true,
        );
      case '/calendar': 
        return MaterialPageRoute(builder: (_) => const CalendarPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
