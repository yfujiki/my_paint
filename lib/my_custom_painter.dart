import 'package:flutter/material.dart';
import 'drawing_point.dart';

class MyCustomPainter extends CustomPainter {
  List<DrawingPoint> points;

  MyCustomPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in points) {
      canvas.drawCircle(point.position, 5.0, point.paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
