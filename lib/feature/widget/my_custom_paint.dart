import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {
  Rect? rawBoundingBox;
  Size? size;

  MyCustomPainter({@required this.rawBoundingBox, this.size});

  @override
  void paint(Canvas canvas, Size size) {
    var offset = const Rect.fromLTRB(300, 100, 300, 100);
    var faceBoundingBox = Rect.fromLTRB(
        getEdge(rawBoundingBox!.left) - offset.left,
        rawBoundingBox!.top - offset.top,
        getEdge(rawBoundingBox!.right) - offset.right,
        rawBoundingBox!.bottom - offset.bottom);

    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawRect(faceBoundingBox, paint);
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return true;
  }

  double getEdge(value) {
    if (value > size!.width) {
      return size!.width - (value - size!.width);
    } else if (value < size!.width) {
      return size!.width + (size!.width - value);
    } else {
      return size!.width;
    }
  }
}
