import 'dart:ui' hide TextStyle;

import 'package:flutter/material.dart';

class GraphAxisPainter extends CustomPainter {
  const GraphAxisPainter(
    this.verticalAxisMin,
    this.verticalAxisMax, {
    //required this.axisWidth,
    required this.horizontalDividers,
    required this.verticalDividers,
    required this.pointLabels,
  });

  final double verticalAxisMin;
  final double verticalAxisMax;

  final int verticalDividers;
  final int horizontalDividers;
  final List<String> pointLabels;

  //final double axisWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Paint axisPaint = Paint()
    //   ..color = Colors.black
    //   ..strokeWidth = 2.0
    //   ..style = PaintingStyle.stroke
    //   ..strokeCap = StrokeCap.butt;

    // Paint rectPaint = Paint()
    //   ..color = Colors.orange
    //   ..style = PaintingStyle.fill;

    Paint verticalLinesPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    double reducedHeight = size.height;

    // canvas.drawRect(
    //     Rect.fromPoints(Offset(0, size.height - axisWidth / 2.0),
    //         Offset(axisWidth, size.height)),
    //     rectPaint);

    for (var i = verticalDividers; i >= 0; i--) {
      //drawing background lines
      canvas.drawLine(
          Offset(0, reducedHeight / verticalDividers * i),
          Offset(size.width, reducedHeight / verticalDividers * i),
          verticalLinesPaint);

      //drawing vertical labels
      if (i == 0 || i == verticalDividers / 2) {
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: ((verticalAxisMax) /
                    verticalDividers *
                    (verticalDividers - i).abs())
                .toInt()
                .toString(),
            style: const TextStyle(color: Colors.black, fontSize: 13),
          ),
          textAlign: TextAlign.start,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            (-textPainter.width - 15.0),
            (reducedHeight / verticalDividers * i) - (textPainter.height / 2.0),
          ),
        );
      }
    }

    for (int i = 0; i < pointLabels.length; i++) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: pointLabels[i],
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          ((size.width / (pointLabels.length - 1) * i) -
              (textPainter.width / 2.0)),
          (size.height + 5.0),
        ),
      );
    }

    // for (var i = verticalDividers; i >= 0; i--) {
    //   if (i == 0 || i == verticalDividers || i == verticalDividers / 2) {
    //     final TextPainter textPainter = TextPainter(
    //       text: TextSpan(
    //         text: ((verticalAxisMax) /
    //                 verticalDividers *
    //                 (verticalDividers - i).abs())
    //             .toInt()
    //             .toString(),
    //         style: const TextStyle(color: Colors.black, fontSize: 10),
    //       ),
    //       textAlign: TextAlign.start,
    //       textDirection: TextDirection.ltr,
    //     );
    //     textPainter.layout();
    //     textPainter.paint(
    //       canvas,
    //       Offset(
    //           (textPainter.width),
    //           (reducedHeight / verticalDividers * i) -
    //               (textPainter.height / 2.0)),
    //     );
    //   } else {
    //     // canvas.drawLine(
    //     //     Offset(0, reducedHeight / verticalDividers * i),
    //     //     Offset(axisWidth / 2.0, reducedHeight / verticalDividers * i),
    //     //     axisPaint);
    //   }
    // }
  }

  // Paragraph _getParagraph(String value) {
  //   final ParagraphStyle paragraphStyle =
  //       ParagraphStyle(textAlign: TextAlign.right);
  //   final TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 10);
  //   final ParagraphBuilder paragraphBuilder = ParagraphBuilder(paragraphStyle)
  //     ..pushStyle(textStyle)
  //     ..addText(value);
  //   return paragraphBuilder.build()
  //     ..layout(ParagraphConstraints(width: axisWidth));
  // }

  @override
  bool shouldRepaint(GraphAxisPainter oldDelegate) => false;

  // @override
  // bool shouldRebuildSemantics(GraphAxisPainter oldDelegate) => false;

}
