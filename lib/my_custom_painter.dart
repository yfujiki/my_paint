import 'package:flutter/material.dart';
import 'drawing_point.dart';

class MyCustomPainter extends CustomPainter {
  List<DrawingPoint?> points;

  MyCustomPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    DrawingPoint? lastPoint;
    for (var point in points) {
      if (point != null && lastPoint != null) {
        canvas.drawLine(lastPoint.position, point.position, point.paint);
      }
      lastPoint = point;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
