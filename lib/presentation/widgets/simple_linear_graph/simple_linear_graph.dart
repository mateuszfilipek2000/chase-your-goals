// ignore_for_file: curly_braces_in_flow_control_structures, library_prefixes

import 'dart:ui';

import 'package:chase_your_goals/data/models/linear_function.dart';
import 'package:flutter/material.dart';
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Colors.red),
      ),
      child: SizedBox(
        width: 200.0,
        height: 100.0,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            for (int i = 0; i < widget.graphPoints.length; i++)
              GestureDetector(
                onPanStart: (DragStartDetails details) {
                  setState(() {
                    touchOffset = details.localPosition;
                  });
                },
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    touchOffset = details.localPosition;
                  });
                },
                onPanEnd: (_) {
                  setState(() {
                    touchOffset = null;
                  });
                },
                child: CustomPaint(
                  painter: SingleLinearGraphPainter(
                    widget.graphPoints[i],
                    null,
                    maxX: _maxX,
                    maxY: _maxY,
                    minX: _minX,
                    minY: _minY,
                    touchOffset: touchOffset,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SingleLinearGraphPainter extends CustomPainter {
  SingleLinearGraphPainter(
    this.points,
    this.color, {
    required this.maxX,
    required this.maxY,
    required this.minX,
    required this.minY,
    this.touchOffset,
  });
  final List<Offset> points;
  final Color? color;
  final double maxY;
  final double maxX;
  final double minY;
  final double minX;
  Offset? touchOffset;

  ///translates the percentage
  Offset _getLocalPosPercents(Offset point) {
    return Offset((point.dx - minX) / (maxX - minX),
        (1 - (point.dy - minY) / (maxY - minY)).abs());
  }

  Offset _getLocalPosition(Offset point, Size size) {
    Offset localPosPercents = _getLocalPosPercents(point);
    return Offset(
        localPosPercents.dx * size.width, localPosPercents.dy * size.height);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color =
          color != null ? color!.withOpacity(0.6) : Colors.blue.withOpacity(0.6)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.fill;

    Paint pointPaint = Paint()
      ..color = color ?? Colors.blue
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint activePointPaint = Paint()
      ..color = color == null
          ? Colors.red
          : color != Colors.red
              ? Colors.red
              : Colors.blue
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    path.moveTo(0, size.height);
    for (var i = 0; i < points.length; i++) {
      Offset localPosPercents = _getLocalPosPercents(points[i]);
      path.lineTo(
          localPosPercents.dx * size.width, localPosPercents.dy * size.height);
    }
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, paint);

    canvas.drawPoints(
      PointMode.points,
      points
          .map((e) => Offset(size.width * _getLocalPosPercents(e).dx,
              size.height * (_getLocalPosPercents(e).dy)))
          .toList(),
      pointPaint,
    );

    //if touch offset != null then we're looking up for the closest point to the touch position
    if (touchOffset != null) {
      //print(touchOffset);
      double horizontalHitZone = 0.15 * size.width;
      List<Offset> potentialHitTargets = [];

      //first of all we're checking for all potential hit targets
      for (Offset point in points) {
        Rect rect = Rect.fromCenter(
            center: Offset(point.dx, size.height),
            width: horizontalHitZone,
            height: size.height);
        if (rect.contains(touchOffset!)) {
          print(point);
          potentialHitTargets.add(point);
        }
      }

      //with all potential targets created we're looking for the closes one to touch
      if (potentialHitTargets.length == 1) {
        print("hit ${potentialHitTargets[0]}");
        canvas.drawPoints(
            PointMode.points,
            [
              Offset(
                  size.width * _getLocalPosPercents(potentialHitTargets[0]).dx,
                  size.height *
                      (_getLocalPosPercents(potentialHitTargets[0]).dy))
            ],
            activePointPaint);
      } else if (potentialHitTargets.length > 1) {
        Offset closestHorizontallyPoint = potentialHitTargets[0];

        for (Offset point in potentialHitTargets) {
          if ((closestHorizontallyPoint.dx - touchOffset!.dx).abs() <
              (point.dx - touchOffset!.dx).abs())
            closestHorizontallyPoint = point;
        }
        print("hit $closestHorizontallyPoint");
        canvas.drawPoints(
            PointMode.points,
            [
              Offset(
                  size.width *
                      _getLocalPosPercents(closestHorizontallyPoint).dx,
                  size.height *
                      (_getLocalPosPercents(closestHorizontallyPoint).dy))
            ],
            activePointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(SingleLinearGraphPainter oldDelegate) =>
      touchOffset != null || touchOffset != oldDelegate.touchOffset;

  // @override
  // bool shouldRebuildSemantics(SingleLinearGraphPainter oldDelegate) => false;
}
