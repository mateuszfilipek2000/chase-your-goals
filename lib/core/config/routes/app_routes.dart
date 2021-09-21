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
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
