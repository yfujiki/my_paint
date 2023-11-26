import 'package:flutter/material.dart';

import 'drawing_point.dart';
import 'my_custom_painter.dart';

class DrawingArea extends StatefulWidget {
  const DrawingArea({super.key});

  @override
  DrawingAreaState createState() => DrawingAreaState();
}

class DrawingAreaState extends State<DrawingArea> {
  List<DrawingPoint?> points = [];
  Paint paint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          points.add(DrawingPoint(
              position: renderBox.globalToLocal(details.globalPosition),
              paint: paint));
        });
      },
      onPanEnd: (details) {
        setState(() {
          points.add(null);
        });
      },
      child: CustomPaint(
        painter: MyCustomPainter(points: points),
        child: Container(),
      ),
    );
  }
}
