// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' hide TextStyle;

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
      points.map((e) => _getLocalPosition(e, size)).toList(),
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
            center: Offset(_getLocalPosition(point, size).dx, size.height),
            width: horizontalHitZone,
            height: size.height);
        if (rect.contains(touchOffset!)) {
          //print(point);
          potentialHitTargets.add(point);
        }
      }

      //with all potential targets created we're looking for the closes one to touch
      if (potentialHitTargets.length == 1) {
        //print("hit ${potentialHitTargets[0]}");
        canvas.drawLine(
          Offset(size.width * _getLocalPosPercents(potentialHitTargets[0]).dx,
              size.height * (_getLocalPosPercents(potentialHitTargets[0]).dy)),
          Offset(size.width * _getLocalPosPercents(potentialHitTargets[0]).dx,
              size.height),
          paint,
        );
        canvas.drawPoints(
          PointMode.points,
          [
            Offset(size.width * _getLocalPosPercents(potentialHitTargets[0]).dx,
                size.height * (_getLocalPosPercents(potentialHitTargets[0]).dy))
          ],
          activePointPaint,
        );
        _drawParagraph(potentialHitTargets[0], size, canvas, paint);
      } else if (potentialHitTargets.length > 1) {
        Offset closestHorizontallyPoint = potentialHitTargets[0];

        for (Offset point in potentialHitTargets) {
          // if ((_getLocalPosition(closestHorizontallyPoint, size).dx -
          //             touchOffset!.dx)
          //         .abs() <
          //     ((_getLocalPosition(point, size).dx - touchOffset!.dx).abs()))
          //   closestHorizontallyPoint = point;

          if (max(_getLocalPosition(closestHorizontallyPoint, size).dx,
                      touchOffset!.dx) -
                  min(_getLocalPosition(closestHorizontallyPoint, size).dx,
                      touchOffset!.dx) >
              max(_getLocalPosition(point, size).dx, touchOffset!.dx) -
                  min(_getLocalPosition(point, size).dx, touchOffset!.dx))
            closestHorizontallyPoint = point;

          // if ((_getLocalPosition(closestHorizontallyPoint, size).dx -
          //             touchOffset!.dx)
          //         .abs() <
          //     ((_getLocalPosition(point, size).dx - touchOffset!.dx).abs()))
          //   closestHorizontallyPoint = point;
        }
        //print("hit $closestHorizontallyPoint");
        canvas.drawLine(
          Offset(
              size.width * _getLocalPosPercents(closestHorizontallyPoint).dx,
              size.height *
                  (_getLocalPosPercents(closestHorizontallyPoint).dy)),
          Offset(
            size.width * _getLocalPosPercents(closestHorizontallyPoint).dx,
            size.height,
          ),
          paint,
        );
        canvas.drawPoints(
          PointMode.points,
          [
            Offset(
                size.width * _getLocalPosPercents(closestHorizontallyPoint).dx,
                size.height *
                    (_getLocalPosPercents(closestHorizontallyPoint).dy))
          ],
          activePointPaint,
        );
        _drawParagraph(closestHorizontallyPoint, size, canvas, paint);
      }
    }
  }

  Paragraph _getParagraph(Offset point, double width) {
    final ParagraphStyle paragraphStyle =
        ParagraphStyle(textAlign: TextAlign.center);
    final TextStyle textStyle = TextStyle(color: Colors.white);
    final ParagraphBuilder paragraphBuilder = ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText("${point.dx}, ${point.dy}");
    return paragraphBuilder.build()..layout(ParagraphConstraints(width: width));
  }

  void _drawParagraph(Offset point, Size size, Canvas canvas, Paint paint) {
    Offset pointLocalPos = _getLocalPosition(point, size);
    Paragraph paragraph = _getParagraph(point, 100.0);
    late Rect textBackground;
    // Rect.fromPoints(
    //   pointLocalPos.translate(5.0, -10),
    //   Offset(
    //     paragraph.width + pointLocalPos.translate(5.0, -10).dx,
    //     pointLocalPos.translate(5.0, -10).dy + (paragraph.height * 1.5),
    //   ),
    // ).shift(
    //   Offset(0, -paragraph.height),
    // );

    late RRect textBg;

    if (touchOffset!.dx >= size.width / 2.0) {
      textBackground = Rect.fromPoints(
        pointLocalPos.translate(-5.0, -10),
        Offset(
          pointLocalPos.translate(-5.0, -10).dx - paragraph.width,
          pointLocalPos.translate(-5.0, -10).dy + (paragraph.height * 1.5),
        ),
      ).shift(
        Offset(0, -paragraph.height),
      );
      textBg = RRect.fromRectAndCorners(
        textBackground,
        topLeft: const Radius.circular(10.0),
        topRight: const Radius.circular(10.0),
        bottomLeft: const Radius.circular(10.0),
      );
      //print("more than half of graph");
    } else {
      textBackground = Rect.fromPoints(
        pointLocalPos.translate(5.0, -10),
        Offset(
          paragraph.width + pointLocalPos.translate(5.0, -10).dx,
          pointLocalPos.translate(5.0, -10).dy + (paragraph.height * 1.5),
        ),
      ).shift(
        Offset(0, -paragraph.height),
      );
      textBg = RRect.fromRectAndCorners(
        textBackground,
        topLeft: const Radius.circular(10.0),
        topRight: const Radius.circular(10.0),
        bottomRight: const Radius.circular(10.0),
      );
    }

    // canvas.drawRRect(
    //   RRect.fromRectAndRadius(textBackground, const Radius.circular(10.0)),
    //   paint,
    // );
    canvas.drawRRect(textBg, paint);
    canvas.drawParagraph(
      paragraph,
      textBackground.topLeft
          .translate(0.0, (textBackground.height - paragraph.height) / 2.0),
    );
  }

  @override
  bool shouldRepaint(SingleLinearGraphPainter oldDelegate) =>
      touchOffset != null || touchOffset != oldDelegate.touchOffset;

  // @override
  // bool shouldRebuildSemantics(SingleLinearGraphPainter oldDelegate) => false;
}
