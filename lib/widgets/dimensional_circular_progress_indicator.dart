import 'dart:ui';

import 'package:chase_your_goals/data/models/linear_function.dart';
import 'package:flutter/material.dart';

class DimensionalCircularProgressIndicator extends StatefulWidget {
  const DimensionalCircularProgressIndicator({
    Key? key,
    this.height = 20.0,
    this.width = 50.0,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  _DimensionalCircularProgressIndicatorState createState() =>
      _DimensionalCircularProgressIndicatorState();
}

class _DimensionalCircularProgressIndicatorState
    extends State<DimensionalCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..repeat()
      ..addListener(
        () => setState(() {}),
      );

    // scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
    //   CurvedAnimation(
    //     parent: animationController,
    //     curve: Curves.easeInOut,
    //   ),
    // );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: ProgressPainter(
          animationController.value,
          Theme.of(context).primaryColor,
          //scaleAnimation.value,
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  ProgressPainter(this.animationControllerValue, this.pointColor);

  //double scaleAnimationValue;
  double animationControllerValue;

  final LinearFunction firstPointMovement = const LinearFunction(1.25, -0.25);
  final LinearFunction secondPointMovement = const LinearFunction(1.25, 0.25);

  final LinearFunction firstPointScale = const LinearFunction(2.5, -0.5);
  final LinearFunction lastPointScale = const LinearFunction(-2.5, 1.5);

  final Color pointColor;

  final Curve scaleCurve = Curves.easeIn;

  @override
  void paint(Canvas canvas, Size size) {
    //double intervalBetweenFixedWidth = (1 / 3) - 0.25;

    final double pointSize = size.width / 4.0;

    Paint pointPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = pointSize
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    late Offset firstPointOffset;
    late Offset secondPointOffset;

    //the points that are appearing/disappearing
    late Offset firstScalingPointOffset = Offset(0, size.height / 2.0);
    late Offset lastScalingPointOffset = Offset(size.width, size.height / 2.0);

    if (animationControllerValue >= 0.2 && animationControllerValue <= 0.6) {
      //first point moves from 0 to 0.5 width, second point moves from 0.5 to 1 width
      // print(
      //   firstPointMovement.getY(animationControllerValue),
      // );
      firstPointOffset = Offset(
          firstPointMovement.getY(animationControllerValue) * size.width,
          size.height / 2.0);
      secondPointOffset = Offset(
          secondPointMovement.getY(animationControllerValue) * size.width,
          size.height / 2.0);

      //while first and second point are changing positions,
      //new first point appears, and the 'old' last point disappears

      Paint firstScalingPointPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = scaleCurve
                .transform(firstPointScale.getY(animationControllerValue)) *
            pointSize
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      Paint lastScalingPointPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = scaleCurve
                .transform(lastPointScale.getY(animationControllerValue)) *
            pointSize
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPoints(
        PointMode.points,
        [
          firstScalingPointOffset,
        ],
        firstScalingPointPaint,
      );

      canvas.drawPoints(
        PointMode.points,
        [
          lastScalingPointOffset,
        ],
        lastScalingPointPaint,
      );
    } else if (animationControllerValue < 0.2) {
      //first point is at 0 width, second point is at 0.5 width
      firstPointOffset = Offset(0, size.height / 2.0);
      secondPointOffset = Offset(0.5 * size.width, size.height / 2.0);

      canvas.drawPoints(
        PointMode.points,
        [
          lastScalingPointOffset,
        ],
        pointPaint,
      );
    } else {
      //first point is at 0.5 width, second point is at 1 width
      firstPointOffset = Offset(0.5 * size.width, size.height / 2.0);
      secondPointOffset = Offset(size.width, size.height / 2.0);

      canvas.drawPoints(
        PointMode.points,
        [
          firstScalingPointOffset,
        ],
        pointPaint,
      );
    }

    canvas.drawPoints(
      PointMode.points,
      [
        firstPointOffset,
        secondPointOffset,
      ],
      pointPaint,
    );
  }

  @override
  bool shouldRepaint(ProgressPainter oldDelegate) =>
      //scaleAnimationValue != oldDelegate.scaleAnimationValue ||
      animationControllerValue != oldDelegate.animationControllerValue;

  @override
  bool shouldRebuildSemantics(ProgressPainter oldDelegate) => false;
}
