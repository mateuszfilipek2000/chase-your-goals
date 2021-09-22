// ignore_for_file: curly_braces_in_flow_control_structures, library_prefixes

// import 'dart:ui';

import 'dart:ui';
import 'package:chase_your_goals/widgets/simple_linear_graph/axis_painter.dart';
import 'package:chase_your_goals/widgets/simple_linear_graph/linear_graph_painter.dart';
import 'package:flutter/material.dart' hide TextStyle;
import 'dart:math' as Math;

///if you want to have the area beneth the graph line coloured then pass this colour
class SimpleLinearGraph extends StatefulWidget {
  const SimpleLinearGraph(
      {Key? key,
      // required this.width,
      // required this.height,
      required this.graphPoints,
      this.graphColors,
      // this.maxX,
      this.maxY,
      this.labelX,
      this.labelY,
      // this.minX,
      this.minY,
      this.padding = 30.0})
      : super(key: key);

  // final double height;
  // final double width;
  final List<Offset> graphPoints;
  final List<Color>? graphColors;
  final double? maxY;
  final double? maxX = null;
  final double? minY;
  final double? minX = null;
  final String? labelX;
  final String? labelY;
  final double padding;

  @override
  State<SimpleLinearGraph> createState() => _SimpleLinearGraphState();
}

class _SimpleLinearGraphState extends State<SimpleLinearGraph>
    with SingleTickerProviderStateMixin {
  double _maxY = 0.0;
  double _maxX = 0.0;
  late double _minY;
  late double _minX;

  // ignore: avoid_init_to_null
  Offset? touchOffset = null;

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() => setState(() {}));
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    _minY = widget.graphPoints[0].dy;
    _minX = widget.graphPoints[0].dx;

    //sorting each offset list by the value of x in each offset
    // for (List<Offset> offsets in widget.graphPoints) {
    //   offsets.sort((a, b) => a.dx.compareTo(b.dx));
    // }
    widget.graphPoints.sort((a, b) => a.dx.compareTo(b.dx));

    //if maxX value is null then every available offset is checked to find max value
    if (widget.maxX == null) {
      for (Offset point in widget.graphPoints) {
        _maxX = Math.max(_maxX, point.dx);
      }
    } else
      _maxX = widget.maxX!;

    //if minY value is null then every available offset is checked to find lowest value
    if (widget.minY == null) {
      for (Offset point in widget.graphPoints) {
        _minY = Math.min(_minY, point.dy);
      }
    } else
      _minY = widget.minY!;

    //if minX value is null then every available offset is checked to find lowest value
    if (widget.minX == null) {
      for (Offset point in widget.graphPoints) {
        _minX = Math.min(_minX, point.dx);
      }
    } else
      _minX = widget.minX!;

    //if maxY value is null then every available offset is checked to find max value
    if (widget.maxY == null) {
      for (Offset point in widget.graphPoints) {
        _maxY = Math.max(_maxY, point.dy);
      }
    } else
      _maxY = widget.maxY!;

    super.initState();

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: SizedBox(
          width: constraints.maxWidth - widget.padding,
          height: constraints.maxHeight - widget.padding,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CustomPaint(
                painter: GraphAxisPainter(
                  _minY,
                  _maxY,
                  //axisWidth: widget.width * 0.05,
                  verticalDividers: 10,
                  horizontalDividers: 10,
                  pointLabels: [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun'
                  ],
                ),
              ),
              GestureDetector(
                onPanStart: (DragStartDetails details) =>
                    setState(() => touchOffset = details.localPosition),
                onPanUpdate: (DragUpdateDetails details) =>
                    setState(() => touchOffset = details.localPosition),
                onPanEnd: (_) => setState(() => touchOffset = null),
                child: CustomPaint(
                  painter: SingleLinearGraphPainter(
                    widget.graphPoints,
                    null,
                    // maxX: _maxX + (0.1 * _minX),
                    // maxY: _maxY + (0.1 * _maxY),
                    // minX: _minX - (0.1 * _minX),
                    // minY: _minY - (0.1 * _maxY),
                    maxX: _maxX,
                    maxY: _maxY,
                    minX: _minX,
                    minY: _minY,
                    initialAnimationValue: animation.value,

                    touchOffset: touchOffset,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
