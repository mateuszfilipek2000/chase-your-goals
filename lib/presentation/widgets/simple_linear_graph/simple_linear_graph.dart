// ignore_for_file: curly_braces_in_flow_control_structures, library_prefixes

// import 'dart:ui';

import 'dart:ui';
import 'package:chase_your_goals/presentation/widgets/simple_linear_graph/axis_painter.dart';
import 'package:chase_your_goals/presentation/widgets/simple_linear_graph/linear_graph_painter.dart';
import 'package:flutter/material.dart' hide TextStyle;
import 'dart:math' as Math;

///if you want to have the area beneth the graph line coloured then pass this colour
class SimpleLinearGraph extends StatefulWidget {
  const SimpleLinearGraph({
    Key? key,
    required this.graphPoints,
    this.graphColors,
    this.maxX,
    this.maxY,
    this.labelX,
    this.labelY,
    this.minX,
    this.minY,
  }) : super(key: key);

  final List<List<Offset>> graphPoints;
  final List<Color>? graphColors;
  final double? maxY;
  final double? maxX;
  final double? minY;
  final double? minX;
  final String? labelX;
  final String? labelY;

  @override
  State<SimpleLinearGraph> createState() => _SimpleLinearGraphState();
}

class _SimpleLinearGraphState extends State<SimpleLinearGraph> {
  double _maxY = 0.0;
  double _maxX = 0.0;
  late double _minY;
  late double _minX;

  // ignore: avoid_init_to_null
  Offset? touchOffset = null;

  @override
  void initState() {
    _minY = widget.graphPoints[0][0].dy;
    _minX = widget.graphPoints[0][0].dx;

    //sorting each offset list by the value of x in each offset
    for (List<Offset> offsets in widget.graphPoints) {
      offsets.sort((a, b) => a.dx.compareTo(b.dx));
    }

    //if maxX value is null then every available offset is checked to find max value
    if (widget.maxX == null) {
      for (List<Offset> points in widget.graphPoints) {
        for (Offset point in points) {
          _maxX = Math.max(_maxX, point.dx);
        }
      }
    } else
      _maxX = widget.maxX!;

    //if minY value is null then every available offset is checked to find lowest value
    if (widget.minY == null) {
      for (List<Offset> points in widget.graphPoints) {
        for (Offset point in points) {
          _minY = Math.min(_minY, point.dy);
        }
      }
    } else
      _minY = widget.minY!;

    //if minX value is null then every available offset is checked to find lowest value
    if (widget.minX == null) {
      for (List<Offset> points in widget.graphPoints) {
        for (Offset point in points) {
          _minX = Math.min(_minX, point.dx);
        }
      }
    } else
      _minX = widget.minX!;

    //if maxY value is null then every available offset is checked to find max value
    if (widget.maxY == null) {
      for (List<Offset> points in widget.graphPoints) {
        for (Offset point in points) {
          _maxY = Math.max(_maxY, point.dy);
        }
      }
    } else
      _maxY = widget.maxY!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220.0,
      height: 110.0,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 210.0,
          height: 100.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CustomPaint(
                painter: GraphAxisPainter(
                  _minY,
                  _maxY,
                  axisWidth: 20.0,
                  verticalDividers: 10,
                  horizontalDividers: 10,
                ),
              ),
              for (int i = 0; i < widget.graphPoints.length; i++)
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 190.0,
                    height: 100.0,
                    child: GestureDetector(
                      onPanStart: (DragStartDetails details) =>
                          setState(() => touchOffset = details.localPosition),
                      onPanUpdate: (DragUpdateDetails details) =>
                          setState(() => touchOffset = details.localPosition),
                      onPanEnd: (_) => setState(() => touchOffset = null),
                      child: CustomPaint(
                        painter: SingleLinearGraphPainter(
                          widget.graphPoints[i],
                          null,
                          // maxX: _maxX + (0.1 * _minX),
                          // maxY: _maxY + (0.1 * _maxY),
                          // minX: _minX - (0.1 * _minX),
                          // minY: _minY - (0.1 * _maxY),
                          maxX: _maxX,
                          maxY: _maxY,
                          minX: _minX,
                          minY: _minY,
                          touchOffset: touchOffset,
                        ),
                      ),
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
