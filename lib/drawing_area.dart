import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'drawing_point.dart';
import 'my_custom_painter.dart';

class DrawingArea extends StatefulWidget {
  const DrawingArea({super.key});

  @override
  DrawingAreaState createState() => DrawingAreaState();
}

class DrawingAreaState extends State<DrawingArea> {
  final GlobalKey _globalKey = GlobalKey();
  List<DrawingPoint?> points = [];
  Paint paint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          key: _globalKey,
          child: GestureDetector(
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
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                points.clear();
              });
            },
            child: const Icon(Icons.clear),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: FloatingActionButton(
            onPressed: () {
              saveToImage();
            },
            child: const Icon(Icons.save),
          ),
        ),
      ],
    );
  }

  Future<void> saveToImage() async {
    RenderRepaintBoundary? boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;
    final image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData == null) return;
    Uint8List pngBytes = byteData.buffer.asUint8List();
    await saveImage(pngBytes);
  }

  Future<void> saveImage(Uint8List pngBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/my_image.png').create();
    await imagePath.writeAsBytes(pngBytes);
  }
}
