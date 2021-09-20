import 'dart:ui' hide TextStyle;

import 'package:flutter/material.dart';

class GraphAxisPainter extends CustomPainter {
  const GraphAxisPainter(
    this.verticalAxisMin,
    this.verticalAxisMax, {
    required this.axisWidth,
    required this.horizontalDividers,
    required this.verticalDividers,
  });

  final double verticalAxisMin;
  final double verticalAxisMax;

  final int verticalDividers;
  final int horizontalDividers;

  final double axisWidth;

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
      canvas.drawLine(
          Offset(axisWidth, reducedHeight / verticalDividers * i),
          Offset(size.width, reducedHeight / verticalDividers * i),
          verticalLinesPaint);
    }

    for (var i = verticalDividers; i >= 0; i--) {
      if (i == 0 || i == verticalDividers || i == verticalDividers / 2) {
        // canvas.drawLine(Offset(0, reducedHeight / verticalDividers * i),
        //     Offset(axisWidth, reducedHeight / verticalDividers * i), axisPaint);

        // Paragraph _p = _getParagraph(
        //   ((verticalAxisMax) / verticalDividers * (verticalDividers - i).abs())
        //       .toInt()
        //       .toString(),
        // );

        // canvas.drawParagraph(
        //   _p,
        //   Offset(0, (reducedHeight / verticalDividers * i) - (_p.height / 2.0)),
        // );
        //final TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 10);
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: ((verticalAxisMax) /
                    verticalDividers *
                    (verticalDividers - i).abs())
                .toInt()
                .toString(),
            style: const TextStyle(color: Colors.black, fontSize: 10),
          ),
          textAlign: TextAlign.start,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
              (axisWidth - textPainter.width),
              (reducedHeight / verticalDividers * i) -
                  (textPainter.height / 2.0)),
        );
      } else {
        // canvas.drawLine(
        //     Offset(0, reducedHeight / verticalDividers * i),
        //     Offset(axisWidth / 2.0, reducedHeight / verticalDividers * i),
        //     axisPaint);
      }
    }
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
