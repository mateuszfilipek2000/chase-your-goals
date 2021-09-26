import 'package:flutter/rendering.dart';

class LinearFunction {
  const LinearFunction(this.a, this.b);
  final double a;
  final double b;

  factory LinearFunction.fromTwoPoints(Offset p1, Offset p2) {
    double _a;
    double _b;
    try {
      if (p2.dx - p1.dx == 0.0) throw ("Dividing by double zero");
      _a = (p2.dy - p1.dy) / (p2.dx - p1.dx);
      _b = ((p2.dx * p1.dy) - (p1.dx * p2.dy)) / (p2.dx - p1.dx);
    } catch (e) {
      // print("Dividing by zero");
      // print(e == "Dividing by double zero");
      return const LinearFunction(0, 0);
    }
    return LinearFunction(_a, _b);
  }

  double getY(double x) => a * x + b;
}
