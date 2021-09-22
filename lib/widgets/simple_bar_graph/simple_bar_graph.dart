// // ignore_for_file: curly_braces_in_flow_control_structures, library_prefixes

// // import 'dart:ui';

// import 'dart:ui';
// import 'package:flutter/material.dart' hide TextStyle;
// import 'dart:math' as Math;

// ///if you want to have the area beneth the graph line coloured then pass this colour
// class SimpleBarGraph extends StatefulWidget {
//   const SimpleBarGraph(
//       {Key? key,
//       required this.width,
//       required this.height,
//       required this.values,
//       this.maxY,
//       this.labelX,
//       this.labelY,
//       this.padding = 30.0})
//       : super(key: key);

//   final double height;
//   final double width;
//   final List<double> values;
//   final double? maxY;
//   final String? labelX;
//   final String? labelY;
//   final double padding;

//   @override
//   State<SimpleBarGraph> createState() => _SimpleLinearGraphState();
// }

// class _SimpleLinearGraphState extends State<SimpleBarGraph>
//     with SingleTickerProviderStateMixin {
//   late double _maxY;
//   late double _minY;
//   late double _minX;

//   // ignore: avoid_init_to_null
//   Offset? touchOffset = null;

//   late AnimationController animationController;
//   late Animation<double> animation;

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     for (double value in widget.values) _maxY = Math.max(_maxY, value);

//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     )..addListener(() => setState(() {}));
//     animation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: animationController, curve: Curves.easeIn),
//     );

//     super.initState();

//     animationController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: widget.width,
//       height: widget.height,
//       child: Center(
//         child: SizedBox(
//           width: widget.width - widget.padding,
//           height: widget.height - widget.padding,
//           child: Stack(
//             fit: StackFit.expand,
//             children: <Widget>[
//               CustomPaint(
//                 painter: GraphAxisPainter(
//                   _maxY,
//                   verticalDividers: 10,
//                   horizontalDividers: 10,
//                   pointLabels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
//                 ),
//               ),
//               GestureDetector(
//                 onPanStart: (DragStartDetails details) =>
//                     setState(() => touchOffset = details.localPosition),
//                 onPanUpdate: (DragUpdateDetails details) =>
//                     setState(() => touchOffset = details.localPosition),
//                 onPanEnd: (_) => setState(() => touchOffset = null),
//                 child: CustomPaint(
//                   painter: SingleLinearGraphPainter(
//                     widget.graphPoints,
//                     null,
//                     // maxX: _maxX + (0.1 * _minX),
//                     // maxY: _maxY + (0.1 * _maxY),
//                     // minX: _minX - (0.1 * _minX),
//                     // minY: _minY - (0.1 * _maxY),
//                     maxX: _maxX,
//                     maxY: _maxY,
//                     minX: _minX,
//                     minY: _minY,
//                     initialAnimationValue: animation.value,

//                     touchOffset: touchOffset,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
