import 'package:chase_your_goals/presentation/widgets/custom_progress_indicator.dart';
import 'package:chase_your_goals/presentation/widgets/simple_linear_graph/simple_linear_graph.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SimpleLinearGraph(
          graphPoints: graphPoints,
          maxX: 30,
          maxY: 110,
          minX: 5,
          minY: 40,
        ),
      ),
    );
  }
}

List<List<Offset>> graphPoints = [
  [
    const Offset(10, 100),
    const Offset(20, 50),
    const Offset(15, 70),
  ],
];
