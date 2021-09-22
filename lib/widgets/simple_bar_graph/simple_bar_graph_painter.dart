// // ignore_for_file: curly_braces_in_flow_control_structures

// import 'dart:math';
// import 'dart:ui' hide TextStyle;

// import 'package:flutter/material.dart';

// //TODO ADD INITIAL ANIMATION
// class SimpleBarGraphPainter extends CustomPainter {
//   SimpleBarGraphPainter(
//     this.points,
//     this.color, {
//     required this.maxY,
//     this.touchOffset,
//     this.initialAnimationValue,
//   });
//   final List<Offset> points;
//   final Color? color;
//   final double maxY;
//   double? initialAnimationValue;
//   Offset? touchOffset;


//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color =
//           color != null ? color!.withOpacity(0.5) : Colors.blue.withOpacity(0.5)
//       ..strokeWidth = 5.0
//       ..style = PaintingStyle.fill;

//     Paint pointPaint = Paint()
//       ..color = color ?? Colors.blue
//       ..strokeWidth = 10.0
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     Paint activePointPaint = Paint()
//       ..color = color == null
//           ? Colors.red
//           : color != Colors.red
//               ? Colors.red
//               : Colors.blue
//       ..strokeWidth = 10.0
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     Path path = Path();
//     path.moveTo(0, size.height);
//     for (var i = 0; i < points.length; i++) {
//       Offset localPosPercents = _getLocalPosPercents(points[i]);
//       path.lineTo(
//           localPosPercents.dx * size.width, localPosPercents.dy * size.height);
//     }
//     path.lineTo(size.width, size.height);
//     canvas.drawPath(path, paint);

//     canvas.drawPoints(
//       PointMode.points,
//       points.map((e) => _getLocalPosition(e, size)).toList(),
//       pointPaint,
//     );

//     //if touch offset != null then we're looking up for the closest point to the touch position
//     if (touchOffset != null) {
//       double horizontalHitZone = 0.15 * size.width;
//       List<Offset> potentialHitTargets = [];

//       //first of all we're checking for all potential hit targets
//       for (Offset point in points) {
//         Rect rect = Rect.fromCenter(
//             center: Offset(_getLocalPosition(point, size).dx, size.height),
//             width: horizontalHitZone,
//             height: size.height);
//         if (rect.contains(touchOffset!)) {
//           potentialHitTargets.add(point);
//         }
//       }

//       //with all potential targets created we're looking for the closes one to touch
//       if (potentialHitTargets.length == 1) {
//         canvas.drawLine(
//           Offset(size.width * _getLocalPosPercents(potentialHitTargets[0]).dx,
//               size.height * (_getLocalPosPercents(potentialHitTargets[0]).dy)),
//           Offset(size.width * _getLocalPosPercents(potentialHitTargets[0]).dx,
//               size.height),
//           paint,
//         );
//         canvas.drawPoints(
//           PointMode.points,
//           [
//             Offset(size.width * _getLocalPosPercents(potentialHitTargets[0]).dx,
//                 size.height * (_getLocalPosPercents(potentialHitTargets[0]).dy))
//           ],
//           activePointPaint,
//         );
//         _drawParagraph(potentialHitTargets[0], size, canvas, paint);
//       } else if (potentialHitTargets.length > 1) {
//         Offset closestHorizontallyPoint = potentialHitTargets[0];

//         for (Offset point in potentialHitTargets) {
//           if (max(_getLocalPosition(closestHorizontallyPoint, size).dx,
//                       touchOffset!.dx) -
//                   min(_getLocalPosition(closestHorizontallyPoint, size).dx,
//                       touchOffset!.dx) >
//               max(_getLocalPosition(point, size).dx, touchOffset!.dx) -
//                   min(_getLocalPosition(point, size).dx, touchOffset!.dx))
//             closestHorizontallyPoint = point;
//         }
//         canvas.drawLine(
//           Offset(
//               size.width * _getLocalPosPercents(closestHorizontallyPoint).dx,
//               size.height *
//                   (_getLocalPosPercents(closestHorizontallyPoint).dy)),
//           Offset(
//             size.width * _getLocalPosPercents(closestHorizontallyPoint).dx,
//             size.height,
//           ),
//           paint,
//         );
//         canvas.drawPoints(
//           PointMode.points,
//           [
//             Offset(
//                 size.width * _getLocalPosPercents(closestHorizontallyPoint).dx,
//                 size.height *
//                     (_getLocalPosPercents(closestHorizontallyPoint).dy))
//           ],
//           activePointPaint,
//         );
//         _drawParagraph(closestHorizontallyPoint, size, canvas, paint);
//       }
//     }
//   }

//   TextPainter _getIndicatorText(Offset point) {
//     final TextPainter textPainter = TextPainter(
//       text: TextSpan(
//         text: point.dy.toInt().toString(),
//         style: const TextStyle(color: Colors.white, fontSize: 15),
//       ),
//       textAlign: TextAlign.start,
//       textDirection: TextDirection.ltr,
//     );
//     textPainter.layout();
//     return textPainter;
//   }

//   void _drawParagraph(Offset point, Size size, Canvas canvas, Paint paint) {
//     Offset pointLocalPos = _getLocalPosition(point, size);
//     TextPainter textPainter = _getIndicatorText(point);
//     late Rect textBackground;

//     late RRect textBg;

//     if (touchOffset!.dx >= size.width / 2.0) {
//       textBackground = Rect.fromPoints(
//         pointLocalPos.translate(-5.0, -10),
//         Offset(
//           pointLocalPos.translate(-5.0, -10).dx - (textPainter.width * 2.0),
//           pointLocalPos.translate(-5.0, -10).dy + (textPainter.height * 1.5),
//         ),
//       ).shift(
//         Offset(0, -textPainter.height),
//       );
//       textBg = RRect.fromRectAndCorners(
//         textBackground,
//         topLeft: const Radius.circular(10.0),
//         topRight: const Radius.circular(10.0),
//         bottomLeft: const Radius.circular(10.0),
//       );
//       //print("more than half of graph");
//     } else {
//       textBackground = Rect.fromPoints(
//         pointLocalPos.translate(5.0, -10),
//         Offset(
//           (textPainter.width * 2.0) + pointLocalPos.translate(5.0, -10).dx,
//           pointLocalPos.translate(5.0, -10).dy + (textPainter.height * 1.5),
//         ),
//       ).shift(
//         Offset(0, -textPainter.height),
//       );
//       textBg = RRect.fromRectAndCorners(
//         textBackground,
//         topLeft: const Radius.circular(10.0),
//         topRight: const Radius.circular(10.0),
//         bottomRight: const Radius.circular(10.0),
//       );
//     }

//     canvas.drawRRect(textBg, paint);

//     textPainter.paint(
//       canvas,
//       textBackground.center
//           .translate(-(textPainter.width / 2.0), (-textPainter.height) / 2.0),
//     );
//   }

//   @override
//   bool shouldRepaint(SimpleBarGraphPainter oldDelegate) =>
//       touchOffset != null ||
//       touchOffset != oldDelegate.touchOffset ||
//       (oldDelegate.initialAnimationValue != initialAnimationValue &&
//           initialAnimationValue != null);

//   // @override
//   // bool shouldRebuildSemantics(SimpleBarGraphPainter oldDelegate) => false;
// }
