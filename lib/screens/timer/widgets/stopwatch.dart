import 'package:chase_your_goals/screens/timer/widgets/stopwatch_painter.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class StopwatchWidget extends StatefulWidget {
  const StopwatchWidget({
    Key? key,
    this.radius = 100.0,
    required this.startStopwatch,
    this.pause,
    this.onEnd,
    this.resume,
  }) : super(key: key);

  final double radius;
  final Function(Duration duration) startStopwatch;
  final Function? onEnd;
  final Function? pause;
  final Function? resume;

  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController stopwatchController;
  late Animation<double> stopwatchAnimation;

  @override
  void initState() {
    stopwatchController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() => setState(() {}));

    stopwatchAnimation =
        Tween<double>(begin: 0.0, end: 100.0).animate(stopwatchController);
    super.initState();

    stopwatchController.forward();
  }

  @override
  void dispose() {
    stopwatchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        height: widget.radius,
        width: widget.radius,
        child: CustomPaint(
          painter: StopwatchPainter(stopwatchAnimation.value),
        ),
      ),
    );
  }
}
