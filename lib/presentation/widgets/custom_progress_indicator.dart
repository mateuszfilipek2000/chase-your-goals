// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print, library_prefixes

import 'package:flutter/material.dart';
import 'dart:math' as Math;

class CustomProgressIndicator extends StatefulWidget {
  const CustomProgressIndicator(
      {Key? key, this.color = Colors.blue, this.width = 70.0})
      : super(key: key);

  final Color color;
  final double width;

  @override
  _CustomProgressIndicatorState createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController animController;

  @override
  void initState() {
    super.initState();
    animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed)
              animController.reverse();
            else if (status == AnimationStatus.dismissed)
              animController.forward();
          })
          ..addListener(() {
            setState(() {});
          });
    animController.forward();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: AspectRatio(
        aspectRatio: 1.75,
        child: CustomPaint(
          painter:
              _ProgressIndicatorPainter(animController.value, StrokeCap.round),
        ),
      ),
    );
  }
}

class _ProgressIndicatorPainter extends CustomPainter {
  const _ProgressIndicatorPainter(this.animationValue, this.strokeCap);

  final StrokeCap strokeCap;

  final double animationValue;
  final double singleIndicationWitdhMultiplier = 0.15;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = size.width * singleIndicationWitdhMultiplier
      ..strokeCap = strokeCap;

    double strokeHeight = 0.0;

    if (strokeCap != StrokeCap.butt)
      strokeHeight = size.width * singleIndicationWitdhMultiplier / 2.0;

    for (double i = singleIndicationWitdhMultiplier / 2.0;
        i <= 1.0 - singleIndicationWitdhMultiplier / 2.0;
        i += singleIndicationWitdhMultiplier +
            (1.0 - (singleIndicationWitdhMultiplier * 5)) / 4) {
      double halfHeight = size.height / 2.0;

      double cosValue(double i) =>
          (Math.cos((i * Math.pi) + (animationValue * Math.pi * 2.0)).abs() /
              2.0) +
          0.5;

      canvas.drawLine(
        Offset(
          size.width * i,
          (size.height - halfHeight) -
              ((cosValue(i) * size.height) / 2.0) +
              strokeHeight,
        ),
        Offset(
          size.width * i,
          (size.height - halfHeight) +
              ((cosValue(i) * size.height) / 2.0) -
              strokeHeight,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
