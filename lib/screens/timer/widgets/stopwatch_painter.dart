import 'package:flutter/material.dart';
import 'dart:math' as math;

class StopwatchPainter extends CustomPainter {
  StopwatchPainter(
    this.progressPercent, {
    this.color = Colors.blue,
    this.thickness = 10.0,
  });
  double progressPercent;
  final Color color;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    Paint progressPaint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2.0, size.height / 2.0);

    canvas.drawArc(
      Rect.fromCenter(center: center, width: size.width, height: size.width),
      -math.pi / 2.0,
      2 * math.pi * (progressPercent / 100.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(StopwatchPainter oldDelegate) =>
      oldDelegate.progressPercent != progressPercent;

  @override
  bool shouldRebuildSemantics(StopwatchPainter oldDelegate) => false;
}
