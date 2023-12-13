// drawing_utilities.dart

import 'package:flutter/material.dart';

class DrawingUtilities {
  static void drawDevice(Canvas canvas, Paint paint, double x, double y, double width, double height) {
    canvas.drawRect(
        Rect.fromCenter(center: Offset(x, y), width: width, height: height),
        paint);
  }

  static void drawXInsideBox(Canvas canvas, Paint paint, double x, double y, double width, double height) {
    canvas.drawLine(Offset(x - width / 2, y - height / 2),
        Offset(x + width / 2, y + height / 2), paint);
    canvas.drawLine(Offset(x + width / 2, y - height / 2),
        Offset(x - width / 2, y + height / 2), paint);
  }
}
